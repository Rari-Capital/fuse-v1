// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

interface ICurveMinter {
    function get_virtual_price() external view returns (uint256);

    function lp_price() external view returns (uint256);

    function price_oracle() external view returns (uint256);
}
