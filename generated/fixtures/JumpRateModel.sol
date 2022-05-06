pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IJumpRateModel {
    event NewInterestParams(
        uint256 baseRatePerBlock,
        uint256 multiplierPerBlock,
        uint256 jumpMultiplierPerBlock,
        uint256 kink
    );

    function baseRatePerBlock() external view returns (uint256);

    function blocksPerYear() external view returns (uint256);

    function getBorrowRate(
        uint256 cash,
        uint256 borrows,
        uint256 reserves
    ) external view returns (uint256);

    function getSupplyRate(
        uint256 cash,
        uint256 borrows,
        uint256 reserves,
        uint256 reserveFactorMantissa
    ) external view returns (uint256);

    function isInterestRateModel() external view returns (bool);

    function jumpMultiplierPerBlock() external view returns (uint256);

    function kink() external view returns (uint256);

    function multiplierPerBlock() external view returns (uint256);

    function utilizationRate(
        uint256 cash,
        uint256 borrows,
        uint256 reserves
    ) external pure returns (uint256);
}

abstract contract FJumpRateModel is Test {
    address JumpRateModel = deployCode("JumpRateModel.sol:JumpRateModel");
}
