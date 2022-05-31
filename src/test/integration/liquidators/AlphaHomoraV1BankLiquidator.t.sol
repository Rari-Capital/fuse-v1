pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// Interfaces
import {CErc20} from "../../interfaces/core/ICErc20.sol";
import {AlphaHomoraV1BankLiquidator} from "../../interfaces/liquidators/IAlphaHomoraV1BankLiquidator.sol";

// Fixtures
import {FuseFixture} from "../../fixtures/FuseFixture.sol";

/// @notice Redeems seized Alpha Homora v1 ibETH (Bank) tokens for ETH for use as a step in a liquidation.
contract AlphaHomoraV1BankLiquidatorTest is Test, FuseFixture {
    AlphaHomoraV1BankLiquidator internal liquidator;

    // General
    address user = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;

    // Alpha Finance Lab: ibETH Token
    // https://etherscan.io/address/67b66c99d3eb37fa76aa3ed1ff33e8e39f0b9c7a
    ERC20 underlyingToken = ERC20(0x67B66C99D3Eb37Fa76Aa3Ed1ff33E8e39F0b9c7A);

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(user);

        deal(address(underlyingToken), user, 10e18);
        assertGe(underlyingToken.balanceOf(user), 10e18);

        liquidator = AlphaHomoraV1BankLiquidator(
            deployCode(
                "artifacts/AlphaHomoraV1BankLiquidator.sol/AlphaHomoraV1BankLiquidator.json"
            )
        );

        // liquidator.redeem(inputToken, inputAmount, strategyData);

        console2.log(address(liquidator));
    }

    function testExample() public {
        assertTrue(true);
    }
}
