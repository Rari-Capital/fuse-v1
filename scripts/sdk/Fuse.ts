// Vendor
import { providers, Contract, BigNumber } from "ethers";
import addresses from "../../lib/RariSDK/src/Fuse/addresses/mainnet";

// Contracts
import { getContracts } from "./contracts";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/network";
import { logger } from "../utilities/logger";
import { promiseAllInBatches } from "../utilities/promiseAllInBatches";

export class Fuse {
  public provider: providers.JsonRpcProvider;
  public abis;
  public contracts;

  constructor(provider: providers.JsonRpcProvider, chainId: ChainID) {
    if (!isSupportedChainId(chainId)) {
      throw new Error(`Unsupported chainid: ${chainId}`);
    }

    const { abis, contracts } = getContracts(provider, chainId);

    this.provider = provider;
    this.abis = abis;
    this.contracts = contracts;
  }

  // Common

  public getComptroller = (address: string) => {
    return new Contract(address, this.abis.ComptrollerABI, this.provider);
  };

  public getCErc20Delegate = (address: string) => {
    return new Contract(address, this.abis.CErc20DelegateABI, this.provider);
  };

  public getCToken = (address: string) => {
    return new Contract(address, this.abis.CTokenABI, this.provider);
  };

  public getAllMarketsByComptroller = async (comptrollerAddress: string) => {
    const comptroller = this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getAllMarkets();
  };

  public getAllBorrowersByComptroller = async (comptrollerAddress: string) => {
    const comptroller = this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getAllBorrowers();
  };

  public getWhitelistByComptroller = async (comptrollerAddress: string) => {
    const comptroller = this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getWhitelist();
  };

  public getRewardsDistributorsByComptroller = async (
    comptrollerAddress: string
  ) => {
    const comptroller = this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getRewardsDistributors();
  };

  public getAllPools = async () => {
    const poolDescriptions =
      await this.contracts.FusePoolDirectory.functions.getAllPools();

    return {
      poolDescriptions,
    };
  };

  public getPoolsByAccount = async (address: string) => {
    const [poolIndexes, poolDescriptions] =
      await this.contracts.FusePoolDirectory.functions.getPoolsByAccount(
        address
      );

    return {
      poolIndexes,
      poolDescriptions,
    };
  };

  public getPublicPools = async () => {
    const poolDescriptions =
      await this.contracts.FusePoolDirectory.functions.getAllPools();

    return {
      poolDescriptions,
    };
  };

  public getPublicPoolsByVerification = async () => {
    const [poolIndexes, poolDescriptions] =
      await this.contracts.FusePoolDirectory.functions.getPublicPoolsByVerification(
        true
      );

    return {
      poolIndexes,
      poolDescriptions,
    };
  };

  // Admin

  public pauseAllBorrowableTokensByIndex = async (index: number) => {
    const { name, comptroller, borrowableAssets } =
      await this.getBorrowableAssetsByIndex(index);

    console.warn(`Pausing all borrowable assets in pool ${index}: ${name}`);
    console.log(`Comptroller address: ${comptroller}`);

    console.log(borrowableAssets);
  };

  public getPoolsWithTooHighBorrowRate = async () => {
    // Maximum borrow rate that can ever be applied (.0005% / block)
    const borrowRateMaxMantissa = BigNumber.from(0.0005e16);

    const { poolDescriptions } = await this.getPublicPoolsByVerification();

    const checkBorrowRate = async (pool: any) => {
      const comptrollerAddress = pool[2];

      const cTokens = (
        await this.getAllMarketsByComptroller(comptrollerAddress)
      ).flat();

      return await Promise.all(
        cTokens.map(async (market: string) => {
          const borrowRate = BigNumber.from(
            (
              await this.getCToken(market).functions.borrowRatePerBlock()
            ).toString()
          );

          if (!borrowRate.gte(borrowRateMaxMantissa)) {
            return false;
          }

          return {
            comptroller: comptrollerAddress,
            market,
          };
        })
      );
    };

    const results = (
      await promiseAllInBatches(checkBorrowRate, poolDescriptions, 3)
    )
      .flat()
      .filter(Boolean);

    return results;
  };

  // [
  //   '0x6d53B483ad27907109a853fBD8aBe58a59f7ad41',
  //   '0x7322B10Db09687fe8889aD8e87f333f95104839F'
  // ]

  // https://ethtx.info/mainnet/0x9166e125841b9ffe29b2bcb4e5e4bd9a1e31ec117834d9c4f1ea2c851c048bf8/

  public getCalldataBorrowRateTooHigh = async (ctokenAddress: string) => {
    const cToken = this.getCErc20Delegate(ctokenAddress);

    // TODO: replace addresses with SDK mainnet addresses
    const calls = [
      cToken.interface.encodeFunctionData("_setImplementationSafe", [
        "0x46f196f21f420e3ea159b706d249046e80f05f7e",
        false,
        0x0,
      ]),
      cToken.interface.encodeFunctionData("_setImplementationSafe", [
        "0x67db14e73c2dce786b5bbbfa4d010deab4bbfcf9",
        false,
        0x0,
      ]),
    ];

    console.log(calls);
  };

  // Poke

  public getComptrollersImplementationOfPublicPoolsByVerification =
    async () => {
      const { poolDescriptions } = await this.getPublicPoolsByVerification();

      return Object.assign(
        {},
        ...Object.values(
          await Promise.all(
            poolDescriptions.map(
              async (poolDescription: any, poolIndex: number) => {
                const comptroller = this.getComptroller(poolDescription[2]);

                return {
                  [poolIndex]: [
                    poolDescription[2],
                    (
                      await comptroller.functions.comptrollerImplementation()
                    )[0],
                  ],
                };
              }
            )
          )
        )
      );
    };

  public getBorrowableAssetsByComptroller = async (
    comptrollerAddress: string
  ) => {
    const comptroller = this.getComptroller(comptrollerAddress);
    const cTokens = await Promise.all(
      (await this.getAllMarketsByComptroller(comptrollerAddress))
        .flat()
        .map((market: string) => this.getCErc20Delegate(market))
    );

    return Object.assign(
      {},
      ...Object.values(
        (
          await Promise.all(
            cTokens.map(async (cToken) => {
              const isBorrowable =
                (
                  await comptroller.functions.borrowGuardianPaused(
                    cToken.address
                  )
                )[0] === false;

              if (isBorrowable) {
                return {
                  [cToken.address]: (await cToken.functions.name())[0],
                };
              }
            })
          )
        ).filter(Boolean)
      ).flat()
    );
  };

  public getBorrowableAssetsByIndex = async (index: number) => {
    const { poolDescriptions } = await this.getPublicPoolsByVerification();

    const [name, , comptroller] = poolDescriptions[index];

    return {
      name,
      comptroller,
      borrowableAssets: await this.getBorrowableAssetsByComptroller(
        comptroller
      ),
    };
  };
}
