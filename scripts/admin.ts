// Vendor
import Joi from "joi";
import { providers } from "ethers";

// Utilities
import { validateEnvConfig } from "./utilities/validateConfig";

// SDK
import { Fuse } from "./sdk/Fuse";
import { ChainID } from "./utilities/network";

// Validate values from .env file
const { CHAIN_ID, ETH_RPC_URL, ARBITRUM_RPC_URL, ARBITRUM_RINKEBY_RPC_URL } =
  validateEnvConfig(
    ".env",
    Joi.object({
      CHAIN_ID: Joi.number().default(1),
      ETH_RPC_URL: Joi.string().default(""),
      ARBITRUM_RPC_URL: Joi.string().default(""),
      ARBITRUM_RINKEBY_RPC_URL: Joi.string().default(""),
    })
  );

const RPC_URLS: any = {
  [ChainID.ARBITRUM]: ARBITRUM_RPC_URL,
  [ChainID.ARBITRUM_RINKEBY]: ARBITRUM_RINKEBY_RPC_URL,
  [ChainID.ETHEREUM]: ETH_RPC_URL,
};

const main = async () => {
  const provider = new providers.JsonRpcProvider(RPC_URLS[CHAIN_ID]);
  const fuse = new Fuse(provider, CHAIN_ID);

  console.log(fuse);

  // TODO: Add scripts to generate calldata for common actions given to fuseAdmin.
  // Particularly, pause all borrowable tokens on a given pool, fix "interest rate too high error" and maybe some more

  // ...
};

main().catch((error) => {
  throw error;
});
