# Fuse V1

```
WORK IN PROGRESS
```

## Branches

- `master` is our 1:1 representation of all Fuse V1 contracts running in production

The `master` branch should always have passing tests.

- `development` is our active development branch; all PR's by default target development

The `development` branch should preferably have passing tests.

- `docs/..` prefixed indicates that it is an update to the documentation and does not introduce new code
- `audit/..` prefixed indicates that it is a prepared branch for auditors
- `feat/..` or `feature/..` prefixed indicates that it is a feature we are developing
- `core/..` prefixed indicates that it is a feature related to any core protocol updates we port over from Compound
- `archive/..` prefixed indicates that the branch is archived but would like to be kept around until further notice. You would update the branch name the moment you decide to archive the branch.
- `bug/..` prefixed indicates that it is a bug fix (low priority)
- `fix/..` prefixed indicates that it is a general fix (low priority)
- `hotfix/..` prefixed indicates that it is a hot fix (high priority); hotfixes are branches off of `master` and then merged back into `development` after deployment

All prefixed branches are merged through PRs (target: `development`), preferably code reviewed and include tests. The CI flow runs on every change in the PR targetting `development`. If you make any changes to the `ABI` make sure you run `make scripts-interfaces` followed by `make lint-fix`.

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

Run `make scripts-interfaces` to automatically (re)generate interfaces and ABIs for any files that have been changed.

Run `make lint-fix` to run the automatic linter across the entire codebase and autofix any issues.

It is recommended you install the following [VSCode extensions](.vscode/extensions.json) if you use VSCode.
