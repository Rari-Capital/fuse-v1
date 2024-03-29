// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "../external/compound/IPriceOracle.sol";
import "../external/compound/ICToken.sol";
import "../external/compound/ICErc20.sol";

import "./BasePriceOracle.sol";
import "./UniswapTwapPriceOracleV2Root.sol";

/**
 * @title UniswapTwapPriceOracleV2
 * @notice Stores cumulative prices and returns TWAPs for assets on Uniswap V2 pairs.
 * @dev Implements `PriceOracle` and `BasePriceOracle`.
 * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
 */
contract UniswapTwapPriceOracleV2 is
    Initializable,
    PriceOracle,
    BasePriceOracle
{
    using SafeMathUpgradeable for uint256;

    /**
     * @dev WETH token contract address.
     */
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /**
     * @dev UniswapTwapPriceOracleV2Root contract address.
     */
    UniswapTwapPriceOracleV2Root public rootOracle;

    /**
     * @dev UniswapV2Factory contract address.
     */
    address public uniswapV2Factory;

    /**
     * @dev The token on which to base TWAPs (its price must be available via `msg.sender`).
     */
    address public baseToken;

    /**
     * @dev Constructor that sets the UniswapTwapPriceOracleV2Root, UniswapV2Factory, and base token.
     */
    function initialize(
        address _rootOracle,
        address _uniswapV2Factory,
        address _baseToken
    ) external initializer {
        require(
            _rootOracle != address(0),
            "UniswapTwapPriceOracleV2Root not defined."
        );
        require(
            _uniswapV2Factory != address(0),
            "UniswapV2Factory not defined."
        );
        rootOracle = UniswapTwapPriceOracleV2Root(_rootOracle);
        uniswapV2Factory = _uniswapV2Factory;
        baseToken = _baseToken == address(0) ? address(WETH) : _baseToken;
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
        // Return 1e18 for ETH
        if (cToken.isCEther()) return 1e18;

        // Get underlying ERC20 token address
        address underlying = CErc20(address(cToken)).underlying();

        // Get price, format, and return
        uint256 baseUnit = 10**uint256(ERC20Upgradeable(underlying).decimals());
        return _price(underlying).mul(1e18).div(baseUnit);
    }

    /**
     * @dev Internal function returning the price in ETH of `underlying`.
     */
    function _price(address underlying) internal view returns (uint256) {
        // Return 1e18 for WETH
        if (underlying == WETH) return 1e18;

        // Return root oracle ERC20/ETH TWAP
        uint256 twap = rootOracle.price(
            underlying,
            baseToken,
            uniswapV2Factory
        );
        return
            baseToken == address(WETH)
                ? twap
                : twap.mul(BasePriceOracle(msg.sender).price(baseToken)).div(
                    10**uint256(ERC20Upgradeable(baseToken).decimals())
                );
    }

    /**
     * @dev Returns the price in ETH of `underlying` (implements `BasePriceOracle`).
     */
    function price(address underlying)
        external
        view
        override
        returns (uint256)
    {
        return _price(underlying);
    }
}
