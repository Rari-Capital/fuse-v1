# Fuse V1

Attempt at porting Fuse V1 to a modern Foundry based stack

## Setup

Copy `.env.template` into `.env` and add your details.

Run `make build` to build and `make test` to test, `make trace` to verbose test.

## To do

- Merge in `fuse-contracts` to reduce mental overhead

## Assumptions and recommendations

- Compound master branch is safe and audited
- Our changes to the fork are relatively minimal, we mostly selectively include files or apply minimal modifications to the files
- We should attempt to keep the diff as minimal as possible and don't change files we don't have to

## Fixtures

Scripts to generate abi's, interfaces and the glue layer

## Tips

- Get ABI from Etherscan or `forge inspect CONTRACT abi > abi.json`
- `cast interface abi.json > IFace.sol`
