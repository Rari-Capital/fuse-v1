pragma solidity ^0.8.10;

interface BadgerSettLiquidatorEnclave {
    function withdrawAll(address inputToken)
        external
        returns (address outputToken, uint256 outputAmount);
}
