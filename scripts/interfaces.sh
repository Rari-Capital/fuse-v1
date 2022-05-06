#!/usr/bin/env bash

shopt -s extglob

# Run from root

rm -rf generated/abi
rm -r generated/interfaces

mkdir -p generated/abi
mkdir -p generated/interfaces

for f in src/core/*.sol; do
    forge inspect ${f//+(*\/|.*)} abi > generated/abi/${f//+(*\/|.*)}.json
done;

# Clean up
# TODO: implement some sort of filter

rm -rf generated/abi/CarefulMath.json
rm -rf generated/abi/ComptrollerStorage.json
rm -rf generated/abi/CTokenInterfaces.json
rm -rf generated/abi/ErrorReporter.json
rm -rf generated/abi/Exponential.json
rm -rf generated/abi/ExponentialNoError.json
rm -rf generated/abi/RewardsDistributorStorage.json
rm -rf generated/abi/SafeMath.json

for f in generated/abi/*.json; do
    cast interface generated/abi/${f//+(*\/|.*)}.json > generated/interfaces/${f//+(*\/|.*)}.sol
done;

make lint-fix
