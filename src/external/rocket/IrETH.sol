// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IrETH {
    function getExchangeRate() external view returns (uint256);
}
