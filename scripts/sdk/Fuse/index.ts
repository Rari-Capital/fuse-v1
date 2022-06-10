// Vendor
import { providers, Contract } from "ethers";

// Utilities
import { ChainID, isSupportedChainId } from "../../utilities/network";

// Contracts
import { getContracts } from "./contracts";

export class Fuse {
  public provider: providers.JsonRpcProvider;
  public abis;
  public contracts;

  constructor(provider: providers.JsonRpcProvider, chainId: ChainID) {
    if (!isSupportedChainId(chainId)) {
      throw new Error(`Unsupported chainid: ${chainId}`);
    }

    this.provider = provider;
    const { abis, contracts } = getContracts(provider, chainId);
    this.abis = abis;
    this.contracts = contracts;
  }

  // General

  public getComptroller = (address: string) => {
    return new Contract(address, this.abis.ComptrollerABI, this.provider);
  };

  public getCErc20Delegator = (address: string) => {
    return new Contract(address, this.abis.CErc20DelegatorABI, this.provider);
  };

  public getCErc20Delegate = (address: string) => {
    return new Contract(address, this.abis.CErc20DelegateABI, this.provider);
  };

  // Comptroller

  // i would also add a function that takes in a comptroller and returns the list of ctokens that are borrowable assets

  // i don't think these will be needed much but i would also like to add a few scripts to generate calldata for common actions given to fuseAdmin. Particularly, pause all borrowable tokens on a given pool, fix "interest rate too high error" and maybe some more

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

  // FusePoolDirectory

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

  // Custom

  public getComptrollersOfPublicPoolsByVerification = async () => {
    const { poolDescriptions } = await this.getPublicPoolsByVerification();

    return Promise.all(
      poolDescriptions.map(async (poolDescription: any, poolIndex: number) => {
        const comptroller = this.getComptroller(poolDescription[2]);

        return {
          poolIndex,
          comptroller,
          implementation:
            await comptroller.functions.comptrollerImplementation(),
        };
      })
    );
  };

  public getBorrowableAssetsByComptroller = async (
    comptrollerAddress: string
  ) => {
    const comptroller = this.getComptroller(comptrollerAddress);

    const cTokens = await Promise.all(
      (
        await this.getAllMarketsByComptroller(comptrollerAddress)
      )[0].map((market: string) => this.getCErc20Delegate(market))
    );

    return (
      await Promise.all(
        cTokens.map(async (cToken) => {
          const isBorrowable =
            (
              await comptroller.functions.borrowGuardianPaused(cToken.address)
            )[0] === false;

          if (isBorrowable) {
            return {
              name: await cToken.functions.name(),
              address: cToken.address,
            };
          }
        })
      )
    ).filter(Boolean);
  };
}
