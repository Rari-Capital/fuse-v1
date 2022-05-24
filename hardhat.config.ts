// Environment
import dotenv from "dotenv";
dotenv.config();

// Native
import { readFileSync } from "fs";

// Vendor
import Joi from "joi";
import toml from "toml";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-contract-sizer";
import { HardhatUserConfig, subtask } from "hardhat/config";
import { TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS } from "hardhat/builtin-tasks/task-names";

// Validate values from .env file
interface EnvConfigStore {
  FORKING: boolean;
  FORK_BLOCK: number;
  SOLC_DEFAULT: string;
  PRIVATE_KEY: string;
  MNEMONIC: string;
  ETH_RPC_URL: string;
  ARBITRUM_RPC_URL: string;
  CMC_API_KEY: string;
  ETHERSCAN_API_KEY: string;
}

const validateEnvConfig = (): EnvConfigStore => {
  const configSchema = Joi.object({
    SOLC_DEFAULT: Joi.string().default("0.8.10"),
    PRIVATE_KEY: Joi.string(),
    MNEMONIC: Joi.string(),
    FORK_BLOCK: Joi.number(),
    FORKING: Joi.boolean().default(false),
    ETH_RPC_URL: Joi.string().required(),
    ARBITRUM_RPC_URL: Joi.string().default(""),
    CMC_API_KEY: Joi.string().default(""),
    ETHERSCAN_API_KEY: Joi.string(),
  });

  const { error, value: validateEnvConfig } = configSchema.validate(
    dotenv.config().parsed,
    {
      allowUnknown: true,
    }
  );

  if (error) {
    throw new Error(`Config validation error: ${error.message}`);
  }

  return validateEnvConfig;
};

const envConfig = validateEnvConfig();

const {
  FORKING,
  FORK_BLOCK,
  SOLC_DEFAULT,
  PRIVATE_KEY,
  MNEMONIC,
  ETH_RPC_URL,
  ARBITRUM_RPC_URL,
  CMC_API_KEY,
  ETHERSCAN_API_KEY,
} = envConfig;

// Configure accounts
const accounts = PRIVATE_KEY
  ? [PRIVATE_KEY]
  : {
      mnemonic:
        MNEMONIC ||
        "test test test test test test test test test test test junk",
    };

// Inherit Foundry config
let foundry: { default: { solc: string } };

try {
  const foundryFile = toml.parse(readFileSync("./foundry.toml").toString());

  console.log(foundryFile);

  foundry = {
    default: {
      solc: foundryFile.default["solc-version"] || SOLC_DEFAULT,
    },
  };
} catch (error) {
  foundry = {
    default: {
      solc: SOLC_DEFAULT,
    },
  };
}

// Filter out .t.sol test files and regular Solidity files in the test directory
subtask(TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS).setAction(
  async (_, __, runSuper) => {
    const paths = await runSuper();

    return paths.filter(
      (p: string) => !p.endsWith(".t.sol") && !p.includes("test")
    );
  }
);

const config: HardhatUserConfig & {
  contractSizer: {
    alphaSort: boolean;
    disambiguatePaths: boolean;
    runOnCompile: boolean;
  };
  etherscan: {
    apiKey: string;
  };
} = {
  paths: {
    cache: "hh-cache",
    sources: "./src",
    tests: "./test",
  },
  contractSizer: {
    alphaSort: false,
    disambiguatePaths: false,
    runOnCompile: true,
  },
  defaultNetwork: "hardhat",
  networks: {
    localhost: {},
    hardhat: {
      allowUnlimitedContractSize: false,
      chainId: 1337,
      forking: {
        blockNumber: Number(FORK_BLOCK),
        enabled: FORKING === true,
        url: ETH_RPC_URL,
      },
    },
    mainnet: {
      url: ETH_RPC_URL,
      accounts,
    },
    arbitrum: {
      url: ARBITRUM_RPC_URL,
      accounts,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.5.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.10",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 77,
    excludeContracts: ["src/test"],
    // API key for CoinMarketCap. https://pro.coinmarketcap.com/signup
    coinmarketcap: CMC_API_KEY,
  },
  etherscan: {
    // API key for Etherscan. https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  },
};

export default config;
