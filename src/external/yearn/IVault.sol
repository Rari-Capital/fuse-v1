// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IVault {
    function getPricePerFullShare() external view returns (uint256);

    function token() external view returns (address);

    function decimals() external view returns (uint8);

    function deposit(uint256 _amount) external;

    function withdraw(uint256 _shares) external;
}
