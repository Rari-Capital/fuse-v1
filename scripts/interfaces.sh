#!/usr/bin/env bash

shopt -s extglob

# Run from root

# rm -rf generated/abi
rm -rf generated/interfaces

# mkdir -p generated/abi
mkdir -p generated/interfaces

for f in src/core/*.sol; do
    name=${f//+(*\/|.*)}

    forge inspect ${name} abi > generated/abi/${name}.json
    cast interface generated/abi/${name}.json > generated/interfaces/I${name}.sol
    sed -i "s/interface Interface/interface I${name}/g" generated/interfaces/I${name}.sol
done;

make lint-fix
