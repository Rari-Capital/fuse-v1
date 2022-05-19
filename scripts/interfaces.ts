// Native
import { readFile } from "fs/promises";
import { existsSync } from "fs";
import { resolve, basename, parse } from "path";

// Vendor
import glob from "glob";

const main = async () => {
  const PROJECT_ROOT_DIR = `${__dirname}/..`;
  const OUTPUT_DIR = `${PROJECT_ROOT_DIR}/out/`;

  if (!existsSync(OUTPUT_DIR)) {
    console.error("Make sure to run 'make build' prior to running this script");
    return;
  }

  glob
    .sync(`${PROJECT_ROOT_DIR}/src/**/*.sol`, { nodir: true })
    .map(async (filename) => {
      if (
        filename.includes("test") ||
        filename.includes("external") ||
        filename.includes("interfaces")
      ) {
        return;
      }

      try {
        const file = resolve(
          `${OUTPUT_DIR}/${basename(filename)}/${
            parse(basename(filename)).name
          }.json`
        );
        const fileData = await readFile(file, "utf-8");

        console.log(fileData);
      } catch (error) {
        console.error(error);
      }
    });
};

main().catch((error) => {
  throw error;
});
