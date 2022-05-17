# Fuse V1

```
NOTE: WORK IN PROGRESS
```

Porting Fuse V1 to a modern Foundry based stack

## Action plan

- Get a good understanding of what the overall current test suite looks like
- Import the current `Compound Protocol` test suite and make sure it still runs
- Import the current `fuse-contracts` test suite and make sure it runs
- Focus on `mainnet` integration tests first
- Discuss a strategy of how we would go about deploying to testnets
- Modify the current CI Foundry flow to include the `Compound Protocol` and `fuse-contracts` test suite
- Parallelize the CI flow

## Notices

- Avoid rewriting unit tests in Foundry, focus on low hanging fruit first
-

## Setup

Copy `.env.template` into `.env` and add your details.

Run `make build` to build and `make test` to test, `make trace` to verbose test.

## Assumptions and recommendations

- Compound master branch is safe and audited
- Our changes to the fork are relatively minimal, we mostly selectively include files or apply minimal modifications to the files
- We should attempt to keep the diff as minimal as possible and don't change files we don't have to
- Quantstamp recommendation: Provide coverage scripts for all diffs. Improve tests for new code. Ensure that testing and coverage instructions are in the documentation.

## Scripts

- `interfaces.sh`, generates `abi` and `interface` of all files in `src/core`

## To do

- Request admin for the default branch to branch off of to be `development`
- Request admin access to add security credentials to the repo so that we can do mainnet forking in our CI
- Investigate `src/liquidators/BalancerPoolTokenLiquidator.sol` lint issue (removed the file for now)
- Run automated analyses tools like Slither on our codebase
- Configure Slither as automated step in our CI
