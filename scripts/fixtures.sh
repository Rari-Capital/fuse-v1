#!/usr/bin/env bash

shopt -s extglob

# Run from root

rm -rf generated/fixtures
mkdir -p generated/fixtures

for f in generated/interfaces/*.sol; do
    name=${f//+(*\/|.*)}

    sed "s/interface Interface/interface I${name}/g" generated/interfaces/${name}.sol > generated/fixtures/${name}.sol
    sed -i 1d generated/fixtures/${name}.sol

    version="^0.8.10"
    interface=$(cat generated/fixtures/${name}.sol)
    cat > generated/fixtures/${name}.sol <<-EOF
pragma solidity $version;

import {Test} from "forge-std/Test.sol";
$interface

abstract contract F$name is Test {
    I$name public $name = I$name(deployCode("$name.sol:$name"));
}
EOF
done;

make lint-fix
