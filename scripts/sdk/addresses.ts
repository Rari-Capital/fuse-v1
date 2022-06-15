// SDK
import FUSE_ARBITRUM from "../../lib/RariSDK/src/Fuse/addresses/arbitrum";
import FUSE_ARBITRUM_RINKEBY from "../../lib/RariSDK/src/Fuse/addresses/arbitrumRinkeby";
import FUSE_MAINNET from "../../lib/RariSDK/src/Fuse/addresses/mainnet";

// Utilities
import { ChainID } from "../utilities/network";

export const FUSE_ADDRESSES: any = {
  [ChainID.ARBITRUM]: FUSE_ARBITRUM,
  [ChainID.ARBITRUM_RINKEBY]: FUSE_ARBITRUM_RINKEBY,
  [ChainID.ETHEREUM]: FUSE_MAINNET,
};

export const getAddresses = (chainId: ChainID) => FUSE_ADDRESSES[chainId];
