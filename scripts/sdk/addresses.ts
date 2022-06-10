// SDK
import ARBITRUM from "../../lib/RariSDK/src/Fuse/addresses/arbitrum";
import ARBITRUM_RINKEBY from "../../lib/RariSDK/src/Fuse/addresses/arbitrumRinkeby";
import MAINNET from "../../lib/RariSDK/src/Fuse/addresses/mainnet";

// Utilities
import { ChainID } from "../utilities/network";

export const ADDRESSES: any = {
  [ChainID.ARBITRUM]: ARBITRUM,
  [ChainID.ARBITRUM_RINKEBY]: ARBITRUM_RINKEBY,
  [ChainID.ETHEREUM]: MAINNET,
};

export const getAddresses = (chainId: ChainID) => ADDRESSES[chainId];
