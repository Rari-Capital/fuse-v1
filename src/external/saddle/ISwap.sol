// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.6.12;

interface ISwap {
    function getVirtualPrice() external view returns (uint256);

    function getToken(uint8) external view returns (address);
}
