# Fuse V1

A naive attempt at porting Fuse V1 to a modern Foundry based stack

## To do

- Merge in `fuse-contracts` to reduce mental overhead

## Assumptions and recommendations

- Compound master branch is safe and audited
- Our changes to the fork are relatively minimal, we mostly selectively include files or apply minimal modifications to the files.
- We should attempt to keep the diff as minimal as possible and don't change files you don't have to

## Changelog

- Ported foundry-rs/forge-std to 0.5.17 (fairly untested) and moved into src/test/utilities
