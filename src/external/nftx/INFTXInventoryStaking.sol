// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface INFTXInventoryStaking {
    function xTokenShareValue(uint256 vaultId) external view returns (uint256);

    function withdraw(uint256 vaultId, uint256 _share) external;
}
