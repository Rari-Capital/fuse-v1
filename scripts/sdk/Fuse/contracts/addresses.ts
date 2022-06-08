// Addresses
import arbitrum from "../../../../lib/RariSDK/src/Fuse/addresses/arbitrum";
import arbitrumRinkeby from "../../../../lib/RariSDK/src/Fuse/addresses/arbitrumRinkeby";
import mainnet from "../../../../lib/RariSDK/src/Fuse/addresses/mainnet";

// Utilities
import { ChainID } from "../../utilities/networks";

export const ADDRESSES: any = {
  [ChainID.ARBITRUM]: arbitrum,
  [ChainID.ARBITRUM_RINKEBY]: arbitrumRinkeby,
  [ChainID.ETHEREUM]: mainnet,
};

export const getAddresses = (chainId: ChainID) => ADDRESSES[chainId];
