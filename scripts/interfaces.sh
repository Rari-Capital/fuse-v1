#!/usr/bin/env bash

shopt -s globstar

# Run from root

# rm -rf generated

# mkdir -p generated/abi generated/interfaces

# make build

for FILE in $(find ./src -type f ! -path '*/test*' | egrep '\.(sol)$'); do
    echo $f

    # name=${f//+(*\/|.*)}

    # cast interface out/${name}.sol/${name}.json > generated/interfaces/I${name}.sol
    # sed -i "s/interface Interface/interface ${name}/g" generated/interfaces/I${name}.sol
done;

# make lint-fix

# Goal is to generate ABI and interfaces automatically whilst maintaining the original directory structure

find
