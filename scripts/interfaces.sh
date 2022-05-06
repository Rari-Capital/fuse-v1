#!/usr/bin/env bash

shopt -s extglob

# Run from root

rm -rf generated/abi
rm -r generated/interfaces

mkdir -p generated/abi
mkdir -p generated/interfaces

for f in src/core/*.sol; do
    name=${f//+(*\/|.*)}

    forge inspect ${name)} abi > generated/abi/${name)}.json
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
    name=${f//+(*\/|.*)}

    cast interface generated/abi/${name}.json > generated/interfaces/${name}.sol
done;

make lint-fix
