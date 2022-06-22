# Typechain Fuse Liquidator Contracts

This is package contains an ethers interface of all liquidator contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).

## Usage

```js
import { UniswapLpTokenLiquidator__factory } from "@fuse-v1/liquidators";

const contract = UniswapLpTokenLiquidator__factory.connect(
  liquidatorAddress,
  web3Provider
);
```
