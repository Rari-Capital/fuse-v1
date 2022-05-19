// Native
import { exec } from "child_process";
import { writeFile } from "fs/promises";
import { mkdirSync, write } from "fs";
import { basename, parse, dirname } from "path";

// Vendor
import glob from "glob";

const spawnProcess = (command: string) => {
  return new Promise((resolve, reject) => {
    exec(command, (error: any, stdout: string, stderr: string) => {
      if (error) {
        reject(error);
      }

      resolve(stdout ? stdout : stderr);
    });
  });
};

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
    if (
      filePath.includes("test") ||
      filePath.includes("external") ||
      filePath.includes("interfaces")
    ) {
      return;
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
      return;
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
    }
  }
};

main().catch((error) => {
  throw error;
});
