// Vendor
import { providers, Contract } from "ethers";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/networks";

// Data
import { ADDRESSES } from "./data/addresses";
import {
  FUSE_CONTRACTS,
  CORE_CONTRACTS,
  ORACLE_CONTRACTS,
} from "./data/contracts";

export class Fuse {
  provider: providers.JsonRpcProvider;
  contracts: {
    [key: string]: Contract;
  };

  addresses: any;

  constructor(provider: providers.JsonRpcProvider, chainId: ChainID) {
    if (!isSupportedChainId(chainId)) {
      throw new Error(`Unsupported chainid: ${chainId}`);
    }

    this.provider = provider;
    this.addresses = ADDRESSES[chainId];

    console.log(this.addresses);

    this.contracts = {
      FusePoolDirectory: new Contract(
        this.addresses.FUSE_POOL_DIRECTORY_CONTRACT_ADDRESS,
        FUSE_CONTRACTS.FusePoolDirectoryABI,
        this.provider
      ),
      FusePoolLens: new Contract(
        this.addresses.FUSE_POOL_LENS_CONTRACT_ADDRESS,
        FUSE_CONTRACTS.FusePoolLensABI,
        this.provider
      ),
      FusePoolLensSecondary: new Contract(
        this.addresses.FUSE_POOL_LENS_SECONDARY_CONTRACT_ADDRESS,
        FUSE_CONTRACTS.FusePoolLensSecondaryABI,
        this.provider
      ),
      FuseSafeLiquidator: new Contract(
        this.addresses.FUSE_SAFE_LIQUIDATOR_CONTRACT_ADDRESS,
        FUSE_CONTRACTS.FuseSafeLiquidatorABI,
        this.provider
      ),
      FuseFeeDistributor: new Contract(
        this.addresses.FUSE_FEE_DISTRIBUTOR_CONTRACT_ADDRESS,
        FUSE_CONTRACTS.FuseFeeDistributorABI,
        this.provider
      ),
    };
  }
}
