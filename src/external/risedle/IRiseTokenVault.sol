// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.6.12;

interface IRiseTokenVault {
    function getNAV(address token) external view returns (uint256);

    function removeSupply(uint256 amount) external;
}
