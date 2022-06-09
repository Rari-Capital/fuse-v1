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

  public getComptroller = async (address: string) => {
    return new Contract(address, this.abis.ComptrollerABI, this.provider);
  };

  // Comptroller

  public getAllMarketsByComptroller = async (comptrollerAddress: string) => {
    const comptroller = await this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getAllMarkets();
  };

  public getAllBorrowersByComptroller = async (comptrollerAddress: string) => {
    const comptroller = await this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getAllBorrowers();
  };

  public getWhitelistByComptroller = async (comptrollerAddress: string) => {
    const comptroller = await this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getWhitelist();
  };

  public getRewardsDistributorsByComptroller = async (
    comptrollerAddress: string
  ) => {
    const comptroller = await this.getComptroller(comptrollerAddress);

    return await comptroller.functions.getRewardsDistributors();
  };

  // FuseFeeDistributor

  // public

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
        const comptroller = await this.getComptroller(poolDescription[2]);

        return {
          poolIndex,
          comptroller,
          implementation:
            await comptroller.functions.comptrollerImplementation(),
        };
      })
    );
  };
}
