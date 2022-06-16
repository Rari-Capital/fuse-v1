// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

interface IUniswapV3Twap {
    function price(address underlying) external view returns (uint256);
}
