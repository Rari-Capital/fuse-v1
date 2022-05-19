// Native
import { writeFile } from "fs/promises";
import { mkdirSync } from "fs";
import { basename, parse, dirname } from "path";

// Vendor
import glob from "glob";

// Utilities
import { spawnProcess } from "./utilities/spawnProcess";

const IGNORE_LIST = ["test", "external", "interfaces"];

const main = async () => {
  const ABI = "tabi";
  const INTERFACES = "tinterfaces";

  const PROJECT_ROOT_DIR = `${__dirname}/..`;
  const ABI_DIR = `${PROJECT_ROOT_DIR}/${ABI}`;
  const INTERFACES_DIR = `${PROJECT_ROOT_DIR}/src/test/${INTERFACES}`;

  const FILEPATHS = glob.sync(`${PROJECT_ROOT_DIR}/src/**/*.sol`, {
    nodir: true,
  });

  // TODO: investigate if there are ways we could generate these from compiled artifacts far more quickly
  // TODO: currently the generator stumbles on subsequent calls whenever an invalid ABI is generated (i.e. FusePoolDirectoryArbitrum.sol:18:51)
  // TODO: replace so we can parallelize the execution with limitations

  for (const filePath of FILEPATHS) {
    if (IGNORE_LIST.map((item) => filePath.includes(item)).includes(true)) {
      continue;
    }

    const fileName = parse(basename(filePath)).name;

    const abiOutputPath = `${ABI_DIR}/${filePath
      .split("/src/")
      .pop()
      ?.replace(".sol", ".json")}`;

    const interfaceOutputPath = `${INTERFACES_DIR}/${filePath
      .split("/src/")
      .pop()}`;

    const dirPath = dirname(filePath.split("/src/")[1]);

    if (!abiOutputPath || !interfaceOutputPath) {
      continue;
    }

    try {
      const abiOutput = (await spawnProcess(
        `forge inspect ${fileName} abi`
      ).catch(() => {
        return "";
      })) as string;

      if (!abiOutput) {
        console.warn(`Failed to generate ABI for ${filePath}, skipping...`);
        continue;
      }

      // Write ABI
      mkdirSync(`${ABI_DIR}/${dirPath}`, { recursive: true });

      await writeFile(abiOutputPath, abiOutput);

      const rawInterfaceOutput = (await spawnProcess(
        `cast interface ${abiOutputPath}`
      ).catch(() => {
        return "";
      })) as string;

      if (!rawInterfaceOutput) {
        console.warn(
          `Failed to generate interface for ${filePath}, skipping...`
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

      console.log(`Succesfully generated ABI and interface for ${filePath}`);
    } catch (error) {
      console.error(error);
      continue;
    }
  }
};

main().catch((error) => {
  throw error;
});
