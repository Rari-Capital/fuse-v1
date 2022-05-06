pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IMaximillion {
    function cEther() external view returns (address);

    function repayBehalf(address borrower) external payable;

    function repayBehalfExplicit(address borrower, address cEther_)
        external
        payable;
}

abstract contract FMaximillion is Test {
    address Maximillion = deployCode("Maximillion.sol:Maximillion");
}
