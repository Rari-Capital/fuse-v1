# Typechain Fuse Utility Contracts

This is package contains an ethers interface of all utility contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).

## Usage

```js
import { InitializableClones__factory } from "@fuse-v1/utils";

const contract = InitializableClones__factory.connect(
  contractAddress,
  web3Provider
);
```
