// Native
import { createHash } from "crypto";
import { createReadStream } from "fs";

export const createHashFromFile = (filePath: string) =>
  new Promise((resolve) => {
    const hash = createHash("sha256");

    createReadStream(filePath)
      .on("data", (data) => hash.update(data))
      .on("end", () =>
        resolve({
          [`${}`]: hash.digest("hex"),
        })
      );
  });
