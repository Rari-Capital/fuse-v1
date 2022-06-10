// Common ways of scripted interacting with the Fuse-SDK

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

  console.log(
    await fuse.getBorrowableAssetsByComptroller(
      "0x88F7c23EA6C4C404dA463Bc9aE03b012B32DEf9e"
    )
  );
};

main().catch((error) => {
  throw error;
});
