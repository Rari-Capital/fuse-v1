// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;

import "./ICToken.sol";

/**
 * @title Compound's CErc20 Contract
 * @notice CTokens which wrap an EIP-20 underlying
 * @author Compound
 */
interface CErc20 is CToken {
    function underlying() external view returns (address);

    function liquidateBorrow(
        address borrower,
        uint256 repayAmount,
        CToken cTokenCollateral
    ) external returns (uint256);
}
