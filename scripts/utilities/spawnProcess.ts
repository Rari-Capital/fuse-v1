// Native
import { exec } from "child_process";

export const spawnProcess = (command: string) => {
  return new Promise((resolve, reject) => {
    exec(command, (error: any, stdout: string, stderr: string) => {
      if (error) {
        reject(error);
      }

      resolve(stdout ? stdout : stderr);
    });
  });
};
