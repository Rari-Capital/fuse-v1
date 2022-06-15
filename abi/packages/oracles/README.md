# Typechain Fuse Oracle Contracts

This is package contains an ethers interface of all oracle contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).
## Usage

```js
import { PriceOracle__factory } from '@fuse-v1/oracles'

const contract = PriceOracle__factory.connect(oracleAddress, web3Provider)
```