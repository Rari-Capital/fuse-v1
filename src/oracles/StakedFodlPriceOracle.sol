// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "../external/compound/IPriceOracle.sol";
import "../external/compound/ICErc20.sol";

import "../external/fodl/FodlStake.sol";

import "./BasePriceOracle.sol";

/**
 * @title StakedFodlPriceOracle
 * @notice Returns prices for staked FODL (xFODL).
 * @dev Implements `PriceOracle` and `BasePriceOracle`.
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 */
contract StakedFodlPriceOracle is PriceOracle, BasePriceOracle {
    using SafeMathUpgradeable for uint256;

    /**
     * @notice Fetches the token/ETH price, with 18 decimals of precision.
     * @param underlying The underlying token address for which to get the price.
     * @return Price denominated in ETH (scaled by 1e18)
     */
    function price(address underlying)
        external
        view
        override
        returns (uint256)
    {
        return _price(underlying);
    }

    /**
     * @notice Returns the price in ETH of the token underlying `cToken`.
     * @dev Implements the `PriceOracle` interface for Fuse pools (and Compound v2).
     * @return Price in ETH of the token underlying `cToken`, scaled by `10 ** (36 - underlyingDecimals)`.
     */
    function getUnderlyingPrice(CToken cToken)
        external
        view
        override
        returns (uint256)
    {
        address underlying = CErc20(address(cToken)).underlying();
        // Comptroller needs prices to be scaled by 1e(36 - decimals)
        // Since `_price` returns prices scaled by 18 decimals, we must scale them by 1e(36 - 18 - decimals)
        return
            _price(underlying).mul(1e18).div(
                10**uint256(ERC20Upgradeable(underlying).decimals())
            );
    }

    /**
     * @notice Fetches the token/ETH price, with 18 decimals of precision.
     */
    function _price(address token) internal view returns (uint256) {
        FodlStake stakedFodl = FodlStake(token);
        IERC20Upgradeable fodl = stakedFodl.fodlToken();
        uint256 fodlEthPrice = BasePriceOracle(msg.sender).price(address(fodl));
        return
            fodl.balanceOf(token).mul(fodlEthPrice).div(
                stakedFodl.totalSupply()
            );
    }
}
