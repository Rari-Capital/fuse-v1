pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface ICErc20Delegator {
    function implementation() external view returns (address);
}

abstract contract FCErc20Delegator is Test {
    ICErc20Delegator public CErc20Delegator =
        ICErc20Delegator(deployCode("CErc20Delegator.sol:CErc20Delegator"));
}
