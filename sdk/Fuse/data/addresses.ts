// Addresses
import { arbitrum } from "./addresses/arbitrum";
import { arbitrumRinkeby } from "./addresses/arbitrumRinkeby";
import { mainnet } from "./addresses/mainnet";

// Utilities
import { ChainID } from "../../utilities/networks";

export const ADDRESSES: any = {
  [ChainID.ARBITRUM]: arbitrum,
  [ChainID.ARBITRUM_RINKEBY]: arbitrumRinkeby,
  [ChainID.ETHEREUM]: mainnet,
};
