// Native
import { createHash } from "crypto";
import { readFile, writeFile } from "fs/promises";
import { mkdirSync, createReadStream } from "fs";
import { basename, parse, dirname } from "path";

// Vendor
import glob from "glob";
import { differenceWith, isEqual } from "lodash";

// Utilities
import { spawnProcess } from "./utilities/spawnProcess";
import { createHashFromFile } from "./utilities/createFileHash";

const main = async () => {
  const ABI = "tabi";
  const INTERFACES = "tinterfaces";

  const IGNORE_LIST = [
    // Directories
    "test",
    "external",
    "interfaces",
    // Files
    // "chains/arbitrum/FusePoolDirectoryArbitrum.sol",
    // "core/ComptrollerStorage.sol",
    // "core/CTokenInterfaces.sol",
    // "core/ErrorReporter.sol",
    // "core/RewardsDistributorStorage.sol",
    // "src/FusePoolLens.sol",
    // "src/FusePoolLensSecondary.sol",
    // "src/FuseSafeLiquidator.sol",
  ];

  const PROJECT_ROOT_DIR = `${__dirname}/..`;
  const ABI_DIR = `${PROJECT_ROOT_DIR}/${ABI}`;
  const INTERFACES_DIR = `${PROJECT_ROOT_DIR}/src/test/${INTERFACES}`;
  const SCRIPTS_DIR = `${PROJECT_ROOT_DIR}/scripts`;

  const FILEPATHS = glob
    .sync(`${PROJECT_ROOT_DIR}/src/**/*.sol`, {
      nodir: true,
    })
    .filter(
      (filePath) =>
        !IGNORE_LIST.map((item) => filePath.includes(item)).includes(true)
    );

  const PREVIOUS_HASHES = JSON.parse(
    await readFile(`${SCRIPTS_DIR}/hashes.json`, "utf-8")
  );

  const NEW_HASHES = Object.assign(
    {},
    ...(await Promise.all(
      FILEPATHS.map((filePath) => createHashFromFile(filePath))
    ))
  );

  const DIFF_HASHES = Object.entries({
    ...PREVIOUS_HASHES,
    ...NEW_HASHES,
  }).reduce((acc, [key, value]) => {
    if (
      !Object.values(PREVIOUS_HASHES).includes(value) ||
      !Object.values(NEW_HASHES).includes(value)
    )
      (acc as any)[key] = value;

    return acc;
  }, {});

  // Filter filepaths down to diff hashes
  const DIFF_HASHES_PATHS = Object.keys(DIFF_HASHES).map(
    (item) => console.log(item)

    // Find a match
  );

  console.log(DIFF_HASHES_PATHS);

  // TODO: investigate if we can run the generator on just the files that were diffed
  // TODO: investigate if there are ways we could generate these from compiled artifacts far more quickly
  // TODO: currently the generator stumbles on subsequent calls whenever an invalid ABI is generated (i.e. FusePoolDirectoryArbitrum.sol:18:51)
  // TODO: replace so we can parallelize the execution with limitations

  for (const filePath of FILEPATHS) {
    if (IGNORE_LIST.map((item) => filePath.includes(item)).includes(true)) {
      continue;
    }

    //   const fileName = parse(basename(filePath)).name;

    //   const abiOutputPath = `${ABI_DIR}/${filePath
    //     .split("/src/")
    //     .pop()
    //     ?.replace(".sol", ".json")}`;

    //   const interfaceOutputPath = `${INTERFACES_DIR}/${filePath
    //     .split("/src/")
    //     .pop()}`;

    //   const dirPath = dirname(filePath.split("/src/")[1]);

    //   if (!abiOutputPath || !interfaceOutputPath) {
    //     continue;
    //   }

    //   try {
    //     const abiOutput = (await spawnProcess(
    //       `forge inspect ${fileName} abi`
    //     ).catch((error) => {
    //       console.warn(error);
    //       return "";
    //     })) as string;

    //     if (!abiOutput) {
    //       console.warn(`Failed to generate ABI for ${filePath}, skipping...`);
    //       continue;
    //     }

    //     // Write ABI
    //     mkdirSync(`${ABI_DIR}/${dirPath}`, { recursive: true });

    //     await writeFile(abiOutputPath, abiOutput);

    //     const rawInterfaceOutput = (await spawnProcess(
    //       `cast interface ${abiOutputPath}`
    //     ).catch((error) => {
    //       console.warn(error);
    //       return "";
    //     })) as string;

    //     if (!rawInterfaceOutput) {
    //       console.warn(
    //         `Failed to generate interface for ${filePath}, skipping...`
    //       );
    //       continue;
    //     }

    //     // Write Interface
    //     mkdirSync(`${INTERFACES_DIR}/${dirPath}`, { recursive: true });

    //     const interfaceOutput = rawInterfaceOutput.replace(
    //       "interface Interface",
    //       `interface ${fileName}`
    //     );

    //     await writeFile(interfaceOutputPath, interfaceOutput);

    //     console.log(`Succesfully generated ABI and interface for ${filePath}`);
    //   } catch (error) {
    //     console.error(error);
    //     continue;
    //   }
  }

  // await writeFile(
  //   `${SCRIPTS_DIR}/hashes.json`,
  //   JSON.stringify(NEW_HASHES, null, 2)
  // );
};

main().catch((error) => {
  throw error;
});
