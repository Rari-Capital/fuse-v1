# Fuse V1

```
NOTE: WORK IN PROGRESS
```

## Goal

- Port Fuse V1 to a modern Foundry-based development stack
- Establish a 1:1 baseline of the current production deployment of Fuse V1
- Establish a baseline suite of integration tests proving what is running in production is safe, works and configured as expected
- Establish a baseline suite of unit tests proving the diff between `compound-protocol` upstream and our fork is safe and works as expected.

## Action plan

- Import any code relevant to Fuse V1 as it is running in production
- Clean up imported code that is unused or deprecated
- Evaluate whether to import current `Compound Protocol` test suite given its significant tech debt
- Evaluate the current state of `fuse-contracts` test suite given its limited scope
- Focus on `mainnet` integration tests first
- Port unit tests from `Midas Protocol` back to establish a baseline
- Discuss a strategy of how we would go about deploying to Ethereum testnets
- Get a proper CI test environment up and running
- Properly structure and configure the branch structure of the repo

## Repository structure

- `master` is our 1:1 representation of all Fuse V1 contracts running in production
- `development` is our active development branch; all PR's by default target development
- `audit/..` prefixed indicates that it is a prepared branch for auditors
- `feature/..` prefixed indicates that it is a feature we are developing
- `core/..` prefixed indicates that it is a feature related to any core protocol updates we port over from Compound
- `archive/..` prefixed indicates that the branch is archived but would like to be kept around until further notice
- `bug/..` prefixed indicates that it is a bug fix (low priority)
- `hotfix/..` prefixed indicates that it is a hot fix (high priority); hotfixes are branches off of `master` and then merged back into `development` after deployment

## Setup

Copy `.env.template` into `.env` and add your details.

Required:

```
ETH_RPC_URL=
ETHERSCAN_API_KEY=
```

Run `make build` to build and `make test` to test, `make trace` to verbose test.

## Assumptions and recommendations

- Compound master branch is safe and audited
- Our changes to the fork are relatively minimal, we mostly selectively include files or apply minimal modifications to the files
- We should attempt to keep the diff as minimal as possible and don't change files we don't have to
- Quantstamp recommendation: Provide coverage scripts for all diffs. Improve tests for new code. Ensure that testing and coverage instructions are in the documentation

## Scripting

- `interfaces.sh`, generates `abi` and `interface` of all files in `src/core`
