// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "../external/compound/ICEther.sol";

import "../external/aave/IWETH.sol";

import "./IRedemptionStrategy.sol";

/**
 * @title CEtherLiquidator
 * @notice Redeems seized Compound/Cream/Fuse CEther cTokens for underlying ETH for use as a step in a liquidation.
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 */
contract CEtherLiquidator is IRedemptionStrategy {
    /**
     * @dev WETH contract object.
     */
    IWETH private constant WETH =
        IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    /**
     * @notice Redeems custom collateral `token` for an underlying token.
     * @param inputToken The input wrapped token to be redeemed for an underlying token.
     * @param inputAmount The amount of the input wrapped token to be redeemed for an underlying token.
     * @param strategyData The ABI-encoded data to be used in the redemption strategy logic.
     * @return outputToken The underlying ERC20 token outputted.
     * @return outputAmount The quantity of underlying tokens outputted.
     */
    function redeem(
        IERC20Upgradeable inputToken,
        uint256 inputAmount,
        bytes memory strategyData
    )
        external
        override
        returns (IERC20Upgradeable outputToken, uint256 outputAmount)
    {
        // Redeem cEther for underlying ETH (and store output as new collateral)
        CEther cEther = CEther(address(inputToken));
        uint256 redeemResult = cEther.redeem(inputAmount);
        require(
            redeemResult == 0,
            "Error calling redeeming seized cEther: error code not equal to 0"
        );
        outputToken = IERC20Upgradeable(address(0));
        outputAmount = address(this).balance;

        // Convert to WETH because `FuseSafeLiquidator.repayTokenFlashLoan` only supports tokens (not ETH) as output from redemptions (reverts on line 24 because `underlyingCollateral` is the zero address)
        WETH.deposit{value: outputAmount}();
        return (IERC20Upgradeable(address(WETH)), outputAmount);
    }
}
