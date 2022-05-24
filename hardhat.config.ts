// Environment
import dotenv from "dotenv";
dotenv.config();

// Native
import { readFileSync } from "fs";

// Vendor
import * as toml from "toml";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-contract-sizer";
import { HardhatUserConfig, subtask } from "hardhat/config";
import { TASK_COMPILE_SOLIDITY_GET_SOURCE_PATHS } from "hardhat/builtin-tasks/task-names";

// Default values to avoid failures when running Hardhat
const SOLC_DEFAULT = "0.8.10";

const ETH_RPC_URL = process.env.ETH_RPC_URL;
const ARBITRUM_RPC_URL = process.env.ARBITRUM_RPC_URL;
const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL;

// Configure accounts
const accounts = process.env.PRIVATE_KEY
  ? [process.env.PRIVATE_KEY]
  : {
      mnemonic:
        process.env.MNEMONIC ||
        "test test test test test test test test test test test junk",
    };

// Inherit Foundry config
let foundry: { default: { solc: string } };

try {
  foundry = toml.parse(readFileSync("./foundry.toml").toString());
  foundry.default.solc = foundry.default["solc-version"]
    ? foundry.default["solc-version"]
    : SOLC_DEFAULT;
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
        blockNumber: Number(process.env.FORK_BLOCK),
        enabled: process.env.FORKING === "true",
        url: ETH_RPC_URL,
      },
    },
    rinkeby: {
      url: RINKEBY_RPC_URL,
      accounts,
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
    coinmarketcap: process.env.CMC_KEY ?? "",
  },
  etherscan: {
    // API key for Etherscan. https://etherscan.io/
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
