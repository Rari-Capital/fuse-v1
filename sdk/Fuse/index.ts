// Vendor
import { providers, Contract } from "ethers";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/networks";

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
    return new Contract(this.abis.ComptrollerABI, address);
  };

  public getAllComptrollers = async () => {
    const { poolList } = await this.getAllPools();

    console.log(poolList.length);

    return "";
  };
}
