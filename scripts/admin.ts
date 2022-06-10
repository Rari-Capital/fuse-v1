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

// TODO: possibly properly encode / type commands as parser args but I like the flexibility

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

      // npm run scripts:admin -- -f fixBorrowRateTooHigh 0x647A36d421183a0a9Fa62717a64B664a24E469C7
      case "fixBorrowRateTooHigh":
        console.log(await fuse.fixBorrowRateTooHigh(arg1));
        break;

      default:
        console.log("Did not find matching function to call with args");
        break;
    }

    return;
  }

  // ...

  // TODO: Add scripts to generate calldata for common actions given to fuseAdmin.

  // Pause all borrowable tokens for a given pool
  // Perhaps with an Ethers multicall?

  //   console.log(await fuse.pauseAllBorrowableTokensByIndex(8));

  // Fix interest rate too high error

  //   await fuse.fixBorrowRateTooHigh();

  // ...
};

main().catch((error) => {
  throw error;
});
