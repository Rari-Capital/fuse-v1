# Fuse V1

An attempt at porting Fuse V1 to a modern Foundry based stack

## Assumptions

- Compound master branch is safe and audited
- Our changes to the fork
- We should attempt to keep the diff as minimal as possible and don't change files you don't have to

## Changelog

- Ported foundry-rs/forge-std to 0.5.17 (fairly untested) and moved into src/test/utilities
