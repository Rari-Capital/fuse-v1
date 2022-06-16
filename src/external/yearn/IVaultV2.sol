// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.6.12;

interface IVaultV2 {
    function pricePerShare() external view returns (uint256);

    function token() external view returns (address);

    function decimals() external view returns (uint8);

    function deposit(uint256 _amount) external returns (uint256);

    function withdraw(uint256 maxShares) external returns (uint256);
}
