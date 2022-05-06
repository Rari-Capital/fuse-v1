#!/usr/bin/env bash

shopt -s extglob

# Run from root

rm -rf generated/fixtures
mkdir -p generated/fixtures

for f in generated/interfaces/*.sol; do
    sed "s/interface Interface/interface I${f//+(*\/|.*)}/g" generated/interfaces/${f//+(*\/|.*)}.sol > generated/fixtures/${f//+(*\/|.*)}.sol
    sed -i 1d generated/fixtures/${f//+(*\/|.*)}.sol

    version="^0.8.10"
    interface=$(cat generated/fixtures/${f//+(*\/|.*)}.sol)
    name=${f//+(*\/|.*)}
    cat > generated/fixtures/${f//+(*\/|.*)}.sol <<-EOF
pragma solidity $version;

import {Test} from "forge-std/Test.sol";
$interface

abstract contract F$name is Test {
    address $name = deployCode("$name.sol:$name");
}
EOF
done;

make lint-fix
