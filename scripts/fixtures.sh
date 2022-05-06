#!/usr/bin/env bash

shopt -s extglob

# Run from root

# Expected to fail:
#
# - ComptrollerStorage
# - CTokenInterfaces
# - ErrorReporter
# - RewardsDistributorStorage

for f in src/core/*.sol; do
    forge inspect ${f//+(*\/|.*)} abi > generated/abi/${f//+(*\/|.*)}.json
    cast interface generated/abi/${f//+(*\/|.*)}.json > generated/interfaces/${f//+(*\/|.*)}.sol
done;

# Run make lint-fix after
