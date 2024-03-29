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

const createParserArguments = (): {
  flags: any[];
} => {
  const parser = new ArgumentParser({ add_help: true });

  // Accept any args after -f, or --flags
  parser.add_argument("-f", "--flags", {
    nargs: "*",
  });

  return parser.parse_args();
};

const main = async () => {
  const parsedArgs = createParserArguments();
  const provider = new providers.JsonRpcProvider(RPC_URLS[CHAIN_ID]);
  const fuse = new Fuse(provider, CHAIN_ID);

  // npm run scripts:admin -- -f command arg1 arg2 arg3
  if (parsedArgs.flags) {
    // [function name, arg1, arg2, arg3, etc..]
    const [command, arg1, arg2, arg3] = parsedArgs.flags;

    switch (command) {
      // npm run scripts:admin -- -f getPoolsWithTooHighBorrowRate
      case "getPoolsWithTooHighBorrowRate":
        console.log(await fuse.getPoolsWithTooHighBorrowRate());
        break;

      // npm run scripts:admin -- -f getCalldataBorrowRateTooHigh 0x647A36d421183a0a9Fa62717a64B664a24E469C7
      case "getCalldataBorrowRateTooHigh":
        console.log(await fuse.getCalldataBorrowRateTooHigh(arg1));
        break;

      default:
        console.log("Did not find matching function to call with args");
        break;
    }

    return;
  }

  console.log("Scratchpad");

  // ...
};

main().catch((error) => {
  throw error;
});
