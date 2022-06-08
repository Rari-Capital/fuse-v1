// Common ways of scripted interacting with the Fuse-SDK

// Vendor
import Joi from "joi";
import { providers } from "ethers";

// Utilities
import { logger } from "../scripts/utilities/logger";
import { validateEnvConfig } from "../scripts/utilities/validateConfig";

// Fuse
import { Fuse } from "./Fuse";

// Validate values from .env file

const main = async () => {
  const { CHAIN_ID, ETH_RPC_URL } = validateEnvConfig(
    "../.env",
    Joi.object({
      CHAIN_ID: Joi.number().default(1),
      ETH_RPC_URL: Joi.string().default(""),
    })
  );

  const provider = new providers.JsonRpcProvider(ETH_RPC_URL);
  const fuse = new Fuse(provider, CHAIN_ID);

  console.log(fuse);

  //   var pools = await fuse.contracts.FusePoolDirectory.methods
  //     .getPublicPoolsByVerification(true)
  //     .call();

  //   var poolsList = pools[0];

  //   for (let i = 0; i < poolsList.length; i++) {
  //     var comptroller = new fuse.web3.eth.Contract(
  //       JSON.parse(
  //         fuse.compoundContracts["contracts/Comptroller.sol:Comptroller"].abi
  //       ),
  //       (
  //         await fuse.contracts.FusePoolDirectory.methods
  //           .pools(poolsList[i])
  //           .call()
  //       ).comptroller
  //     );

  //     console.log("pool number ", poolsList[i]);
  //     console.log(await comptroller.methods.comptrollerImplementation().call());
  //   }
};

main().catch((error) => {
  throw error;
});
