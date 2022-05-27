// Vendor
import Joi from "joi";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-contract-sizer";
import { HardhatUserConfig, subtask } from "hardhat/config";
import { TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS } from "hardhat/builtin-tasks/task-names";

// Utilities
import { validateEnvConfig } from "./scripts/utilities/validateConfig";

// Validate values from .env file
const {
  FORKING,
  FORK_BLOCK,
  PRIVATE_KEY,
  ETH_RPC_URL,
  ARBITRUM_RPC_URL,
  CMC_API_KEY,
  ETHERSCAN_API_KEY,
} = validateEnvConfig(
  Joi.object({
    PRIVATE_KEY: Joi.string().default("1".repeat(64)),
    FORK_BLOCK: Joi.number(),
    FORKING: Joi.boolean(),
    ETH_RPC_URL: Joi.string().default(""),
    ARBITRUM_RPC_URL: Joi.string().default(""),
    CMC_API_KEY: Joi.string(),
    ETHERSCAN_API_KEY: Joi.string(),
  })
);

// Filter out .t.sol test files and regular Solidity files in the test directory
subtask(TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS).setAction(
  async (_, __, runSuper) => {
    const paths = await runSuper();

    return paths.filter(
      (p: string) => !p.endsWith(".t.sol") && !p.includes("test")
    );
  }
);

// Accounts
const accounts = [PRIVATE_KEY];

// Network settings
const settings = {
  optimizer: {
    enabled: true,
    runs: 200,
  },
};

const config: HardhatUserConfig & {
  contractSizer: {
    alphaSort: boolean;
    disambiguatePaths: boolean;
    runOnCompile: boolean;
  };
  etherscan: {
    apiKey: string;
  };
  typechain: { outDir: string; target: string };
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
        settings,
      },
      {
        version: "0.6.12",
        settings,
      },
      {
        version: "0.8.10",
        settings,
      },
    ],
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 77,
    excludeContracts: ["src/test"],
    // API key for CoinMarketCap: https://pro.coinmarketcap.com/signup
    coinmarketcap: CMC_API_KEY,
  },
  etherscan: {
    // API key for Etherscan: https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  },
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
};

export default config;
