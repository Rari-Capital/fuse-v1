#!/usr/bin/env bash

shopt -s extglob

# Run from root

rm -rf generated

mkdir -p generated/abi generated/interfaces

for f in src/utils/*.sol; do
    name=${f//+(*\/|.*)}

    forge inspect ${name} abi > generated/abi/${name}.json
    cast interface generated/abi/${name}.json > generated/interfaces/I${name}.sol
    sed -i "s/interface Interface/interface ${name}/g" generated/interfaces/I${name}.sol
done;

make lint-fix
