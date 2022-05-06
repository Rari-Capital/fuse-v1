pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface ICEtherDelegator {
    function implementation() external view returns (address);
}

abstract contract FCEtherDelegator is Test {
    address CEtherDelegator = deployCode("CEtherDelegator.sol:CEtherDelegator");
}
