# Fuse V1

```
WORK IN PROGRESS
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

The `master` branch should always have passing tests.

- `development` is our active development branch; all PR's by default target development

The `development` branch should preferably have passing tests.

- `audit/..` prefixed indicates that it is a prepared branch for auditors
- `feat/..` or `feature/..` prefixed indicates that it is a feature we are developing
- `core/..` prefixed indicates that it is a feature related to any core protocol updates we port over from Compound
- `archive/..` prefixed indicates that the branch is archived but would like to be kept around until further notice. You would update the branch name the moment you decide to archive the branch.
- `bug/..` prefixed indicates that it is a bug fix (low priority)
- `hotfix/..` prefixed indicates that it is a hot fix (high priority); hotfixes are branches off of `master` and then merged back into `development` after deployment

All prefixed branches are merged through PRs (target: `development`), preferably code reviewed and include tests. The CI flow runs on every change in the PR targetting `development`. If you make any changes to the `ABI` make sure you run the `interfaces.sh` script.

Work in progress PR titles are prefixed by `WIP: `.

## CI

The CI is configured using Github workflows and can be found [here](https://github.com/Rari-Capital/fuse-v1/blob/development/.github/workflows/ci.yml).

It includes an automated linter setup using `Prettier` and `Solhint` and a `Forge` test runner.

## Setup

Copy `.env.template` into `.env` and add your details.

Required:

```
ETH_RPC_URL=
ETHERSCAN_API_KEY=
```

Run `make` to install all the dependencies.

Run `make build` to build and `make test` to test, `make trace` to verbose test.

It is recommended you install the following [VSCode extensions](.vscode/extensions.json) if you use VSCode.

## Assumptions and recommendations

- Compound master branch is safe and audited
- Our changes to the fork are relatively minimal, we mostly selectively include files or apply minimal modifications to the files
- We should attempt to keep the diff as minimal as possible and don't change files we don't have to
- Quantstamp recommendation: Provide coverage scripts for all diffs. Improve tests for new code. Ensure that testing and coverage instructions are in the documentation

## Scripting

- `interfaces.sh`, generates `abi` and `interface` of all files in `src/core`

In the future I would like to upgrade the script to TypeScript and automatically skip any files that do not have to be updated.
