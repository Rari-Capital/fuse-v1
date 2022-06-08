// Vendor
import { providers, Contract } from "ethers";

// Utilities
import { ChainID, isSupportedChainId } from "./utilities";

// Contracts
import { getContracts } from "./contracts";

export class Fuse {
  provider: providers.JsonRpcProvider;
  abis: {
    [key: string]: any;
  };
  contracts: {
    [key: string]: Contract;
  };

  constructor(provider: providers.JsonRpcProvider, chainId: ChainID) {
    if (!isSupportedChainId(chainId)) {
      throw new Error(`Unsupported chainid: ${chainId}`);
    }

    this.provider = provider;
    const { abis, contracts } = getContracts(provider, chainId);
    this.abis = abis;
    this.contracts = contracts;
  }

  public getAllPools = async () => {
    const [poolList, poolDescriptions] =
      await this.contracts.FusePoolDirectory.functions.getPublicPoolsByVerification(
        true
      );

    return {
      poolList,
      poolDescriptions,
    };
  };

  public getComptroller = async (address: string) => {
    return new Contract(address, this.abis.ComptrollerABI, this.provider);
  };

  public getComptrollersOfAllPools = async () => {
    const { poolDescriptions } = await this.getAllPools();

    return Promise.all(
      poolDescriptions.map(async (poolDescription: any, poolIndex: number) => {
        const comptroller = await this.getComptroller(poolDescription[2]);

        return [
          poolIndex,
          await comptroller.functions.comptrollerImplementation(),
        ];
      })
    );
  };
}
