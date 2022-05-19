// Native
import { writeFile } from "fs/promises";
import { mkdirSync } from "fs";
import { basename, parse, dirname } from "path";

// Vendor
import glob from "glob";

// Utilities
import { spawnProcess } from "./utilities/spawnProcess";

const IGNORE_LIST = ["test", "external", "interfaces", "chains"];

const main = async () => {
  const ABI = "abi";
  const INTERFACES = "interfaces";

  const PROJECT_ROOT_DIR = `${__dirname}/..`;
  const ABI_DIR = `${PROJECT_ROOT_DIR}/${ABI}`;
  const INTERFACES_DIR = `${PROJECT_ROOT_DIR}/src/test/${INTERFACES}`;

  const FILEPATHS = glob.sync(`${PROJECT_ROOT_DIR}/src/**/*.sol`, {
    nodir: true,
  });

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

    mkdirSync(`${ABI_DIR}/${dirPath}`, { recursive: true });
    mkdirSync(`${INTERFACES_DIR}/${dirPath}`, { recursive: true });

    if (!abiOutputPath || !interfaceOutputPath) {
      continue;
    }

    try {
      const abiOutput = (await spawnProcess(
        `forge inspect ${fileName} abi`
      )) as string;

      // Write ABI
      await writeFile(abiOutputPath, abiOutput);

      const rawInterfaceOutput = (await spawnProcess(
        `cast interface ${abiOutputPath}`
      )) as string;

      // Write Interface
      const interfaceOutput = rawInterfaceOutput.replace(
        "interface Interface",
        `interface ${fileName}`
      );

      await writeFile(interfaceOutputPath, interfaceOutput);
    } catch (error) {
      console.error(error);
      continue;
    }
  }
};

main().catch((error) => {
  throw error;
});
