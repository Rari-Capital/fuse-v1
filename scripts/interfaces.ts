// Native
import { createHash } from "crypto";
import { readFile, writeFile } from "fs/promises";
import { createReadStream, mkdirSync } from "fs";
import { basename, parse, dirname } from "path";

// Vendor
import glob from "glob";

// Utilities
import { logger } from "./utilities/logger";
import { spawnProcess } from "./utilities/spawnProcess";

// TODO: investigate if there are ways we could generate these from compiled artifacts far more quickly
// TODO: currently the generator stumbles on subsequent calls whenever an invalid ABI is generated (i.e. FusePoolDirectoryArbitrum.sol:18:51)
// TODO: replace so we can parallelize the execution with limitations

const main = async () => {
  const IGNORE_LIST = [
    // Directories
    "test",
    "external",
    "interfaces",
    // Files
    "chains/arbitrum/FusePoolDirectoryArbitrum.sol",
    "core/ComptrollerStorage.sol",
    "core/CTokenInterfaces.sol",
    "core/ErrorReporter.sol",
    "core/RewardsDistributorStorage.sol",
    "src/FusePoolDirectory",
    "src/FusePoolLens.sol",
    "src/FusePoolLensSecondary.sol",
    "src/FuseSafeLiquidator.sol",
  ];

  const PROJECT_ROOT_DIR = `${__dirname}/..`;
  const ABI_DIR = `${PROJECT_ROOT_DIR}/abi`;
  const INTERFACES_DIR = `${PROJECT_ROOT_DIR}/src/test/interfaces`;
  const SCRIPTS_DIR = `${PROJECT_ROOT_DIR}/scripts`;

  // Get path inside of src
  const trimPath = (filePath: string) => {
    return filePath.split("/src/").pop();
  };

  // Create hash of file
  const createFileHash = (filePath: string) =>
    new Promise((resolve) => {
      const hash = createHash("sha256");

      createReadStream(filePath)
        .on("data", (data) => hash.update(data))
        .on("end", () =>
          resolve({
            [`${trimPath(filePath)}`]: hash.digest("hex"),
          })
        );
    });

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
      FILEPATHS.map((filePath) => createFileHash(filePath))
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
  const DIFF_HASHES_PATHS = Object.keys(DIFF_HASHES)
    .map((item) =>
      FILEPATHS.filter((filePath) => filePath.includes(`/${item}`))
    )
    .flat();

  if (DIFF_HASHES_PATHS.length === 0) {
    logger.info("No changes found, exiting...");
    return;
  } else {
    logger.info(`Re-creating ABI and Interfaces for [${DIFF_HASHES_PATHS}]`);
  }

  for (const filePath of DIFF_HASHES_PATHS) {
    if (IGNORE_LIST.map((item) => filePath.includes(item)).includes(true)) {
      continue;
    }

    const fileName = parse(basename(filePath)).name;

    const abiOutputPath = `${ABI_DIR}/${trimPath(filePath)?.replace(
      ".sol",
      ".json"
    )}`;

    const interfaceOutputPath = `${INTERFACES_DIR}/${trimPath(
      filePath
    )?.replace(fileName, `I${fileName}`)}`;

    const dirPath = dirname(filePath.split("/src/")[1]);

    if (!abiOutputPath || !interfaceOutputPath) {
      continue;
    }

    try {
      const abiOutput = (await spawnProcess(
        `forge inspect ${fileName} abi`
      ).catch((error) => {
        logger.warn(error);
        return "";
      })) as string;

      if (!abiOutput) {
        logger.warn(
          `Failed to generate ABI for [${trimPath(filePath)}], skipping...`
        );
        continue;
      }

      // Write ABI
      mkdirSync(`${ABI_DIR}/${dirPath}`, { recursive: true });

      await writeFile(abiOutputPath, abiOutput);

      const rawInterfaceOutput = (await spawnProcess(
        `cast interface ${abiOutputPath}`
      ).catch((error) => {
        logger.warn(error);
        return "";
      })) as string;

      if (!rawInterfaceOutput) {
        logger.warn(
          `Failed to generate interface for [${trimPath(
            filePath
          )}], skipping...`
        );
        continue;
      }

      // Write Interface
      mkdirSync(`${INTERFACES_DIR}/${dirPath}`, { recursive: true });

      const interfaceOutput = rawInterfaceOutput.replace(
        "interface Interface",
        `interface ${fileName}`
      );

      await writeFile(interfaceOutputPath, interfaceOutput);

      logger.info(
        `Succesfully generated ABI and interface for [${trimPath(filePath)}]`
      );
    } catch (error) {
      logger.error(error);
      continue;
    }
  }

  await writeFile(
    `${SCRIPTS_DIR}/hashes.json`,
    JSON.stringify(NEW_HASHES, null, 2)
  );

  logger.info(`Succesfully updated hashes with [${DIFF_HASHES_PATHS}]`);
};

main().catch((error) => {
  throw error;
});
