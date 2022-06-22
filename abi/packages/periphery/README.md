# Typechain Fuse Periphery Contracts

This is package contains an ethers interface of all periphery contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).

## Usage

```js
import { FusePoolDirectory__factory } from "@fuse-v1/periphery";

const contract = FusePoolDirectory__factory.connect(
  contractAddress,
  web3Provider
);
```
