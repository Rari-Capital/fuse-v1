# Typechain Fuse Arbitrum Contracts

This is package contains an ethers interface of all arbitrum contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).

## Usage

```js
import { FuseSafeLiquidatorArbitrum__factory } from "@fuse-v1/arbitrum";

const contract = FuseSafeLiquidatorArbitrum__factory.connect(
  contractAddress,
  web3Provider
);
```
