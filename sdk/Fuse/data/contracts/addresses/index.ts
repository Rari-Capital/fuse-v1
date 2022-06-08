// Addresses
import { arbitrum } from "./arbitrum";
import { arbitrumRinkeby } from "./arbitrumRinkeby";
import { mainnet } from "./mainnet";

// Utilities
import { ChainID } from "../../../../utilities/networks";

export const ADDRESSES: any = {
  [ChainID.ARBITRUM]: arbitrum,
  [ChainID.ARBITRUM_RINKEBY]: arbitrumRinkeby,
  [ChainID.ETHEREUM]: mainnet,
};

export const getAddresses = (chainId: ChainID) => ADDRESSES[chainId];
