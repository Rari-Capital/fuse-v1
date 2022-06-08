// Vendor
import { providers, Contract } from "ethers";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/networks";

// Data
import { getContracts } from "./data/contracts";

export class Fuse {
  provider: providers.JsonRpcProvider;
  contracts: {
    [key: string]: Contract;
  };

  constructor(provider: providers.JsonRpcProvider, chainId: ChainID) {
    if (!isSupportedChainId(chainId)) {
      throw new Error(`Unsupported chainid: ${chainId}`);
    }

    this.provider = provider;
    this.contracts = getContracts(provider, chainId);
  }

  public getPools = async () => {
    const [poolList, poolDescriptions] =
      await this.contracts.FusePoolDirectory.functions.getPublicPoolsByVerification(
        true
      );

    return {
      poolList,
      poolDescriptions,
    };
  };
}
