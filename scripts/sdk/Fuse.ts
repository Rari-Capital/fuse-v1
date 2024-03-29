// Vendor
import { providers, Contract, BigNumber } from "ethers";

// Contracts
import { getContracts } from "./contracts";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/network";
import { promiseAllBatch } from "../utilities/promiseAllBatch";

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

  // Happens when someone is able to withdraw past 100% utilization rate because of accumulated Fuse fees/reserves
  public getPoolsWithTooHighBorrowRate = async () => {
    // Maximum borrow rate that can ever be applied (.0005% / block)
    const borrowRateMaxMantissa = BigNumber.from(0.0005e16);

    const { poolDescriptions } = await this.getPublicPoolsByVerification();

    const checkBorrowRate = async (pool: any) => {
      const [name, , comptroller] = pool;

      const cTokens = (
        await this.getAllMarketsByComptroller(comptroller)
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
            name,
            comptroller,
            market,
            borrowRate: borrowRate.toString(),
          };
        })
      );
    };

    const results = (
      await promiseAllBatch(checkBorrowRate, poolDescriptions, 3)
    )
      .flat()
      .filter(Boolean);

    return results;
  };

  public getCalldataBorrowRateTooHigh = async (ctokenAddress: string) => {
    const CTOKEN_IRM_FIX_IMPLEMENTATION =
      "0x46f196f21f420e3ea159b706d249046e80f05f7e";

    const CTOKEN_DEFAULT_IMPLEMENTATION =
      "0x67db14e73c2dce786b5bbbfa4d010deab4bbfcf9";

    const cToken = this.getCErc20Delegate(ctokenAddress);

    const targets = [ctokenAddress, ctokenAddress];

    const data = [
      cToken.interface.encodeFunctionData("_setImplementationSafe", [
        CTOKEN_IRM_FIX_IMPLEMENTATION,
        false,
        0x0,
      ]),
      cToken.interface.encodeFunctionData("_setImplementationSafe", [
        CTOKEN_DEFAULT_IMPLEMENTATION,
        false,
        0x0,
      ]),
    ];

    return [targets, data];
  };

  // Poke

  public getAllVerifiedPools = async () => {
    const pools: any = {};
    const { poolDescriptions } = await this.getPublicPoolsByVerification();

    poolDescriptions.forEach((poolDescription: any, poolIndex: number) => {
      pools[poolIndex] = poolDescription[0];
    });

    return pools;
  };

  public getComptrollerImplementationOfVerifiedPools = async () => {
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
                  (await comptroller.functions.comptrollerImplementation())[0],
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
