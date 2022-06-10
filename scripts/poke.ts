// Common ways of scripted interacting with the Fuse-SDK

// Vendor
import { ArgumentParser } from "argparse";
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

interface ICLIArgs {
  flags: any[];
}

const createParserArguments = (): ICLIArgs => {
  const parser = new ArgumentParser({ add_help: true });

  parser.add_argument("-f", "--flags", {
    nargs: "*",
  });

  return parser.parse_args();
};

const main = async () => {
  const parsedArgs = createParserArguments();
  const provider = new providers.JsonRpcProvider(RPC_URLS[CHAIN_ID]);
  const fuse = new Fuse(provider, CHAIN_ID);

  // npm run scripts:poke -- -f
  if (parsedArgs.flags) {
    // [function name, arguments]
    const [command, a, b, c] = parsedArgs.flags;

    switch (command) {
      // npm run scripts:poke -- -f getComptrollersOfPublicPoolsByVerification
      case "getComptrollersOfPublicPoolsByVerification":
        console.log(await fuse.getComptrollersOfPublicPoolsByVerification());
        break;

      // npm run scripts:poke -- -f getBorrowableAssetsByIndex 8
      case "getBorrowableAssetsByIndex":
        console.log(await fuse.getBorrowableAssetsByIndex(a));
        break;

      // npm run scripts:poke -- -f getBorrowableAssetsByComptroller 0xc54172e34046c1653d1920d40333Dd358c7a1aF4
      case "getBorrowableAssetsByComptroller":
        console.log(await fuse.getBorrowableAssetsByComptroller(a));
        break;

      default:
        console.log("Did not find matching function to call with args");
        break;
    }

    return;
  }

  console.log("Scratchpad");
};

main().catch((error) => {
  throw error;
});
