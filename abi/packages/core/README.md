# Typechain Fuse Core Contracts

This is package contains an ethers interface of all core contracts in the fuse-v1 repository.

For more information, visit the [repository](https://github.com/Rari-Capital/fuse-v1).
## Usage

```js
import { RewardsDistributorDelegate__factory } from '@fuse-v1/core'

const contract = RewardsDistributorDelegate__factory.connect(contractAddress, web3Provider)
```