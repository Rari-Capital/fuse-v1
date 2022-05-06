pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IReservoir {
    function drip() external returns (uint256);

    function dripRate() external view returns (uint256);

    function dripStart() external view returns (uint256);

    function dripped() external view returns (uint256);

    function target() external view returns (address);

    function token() external view returns (address);
}

abstract contract FReservoir is Test {
    address Reservoir = deployCode("Reservoir.sol:Reservoir");
}
