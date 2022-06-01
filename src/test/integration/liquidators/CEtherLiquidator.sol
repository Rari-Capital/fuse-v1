pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// Interfaces
import {CErc20} from "../../interfaces/core/ICErc20.sol";
import {CEtherLiquidator} from "../../interfaces/liquidators/ICEtherLiquidator.sol";

// Fixtures
import {FuseFixture} from "../../fixtures/FuseFixture.sol";

// Pool 8
// Pool 6
// Pool 18
// Pool 127
// Pool 156
// Pool 7
// Pool 79
// Pool 144
// Pool 27
// Pool 146

// https://etherscan.io/address/0xF6551C22276b9Bf62FaD09f6bD6Cad0264b89789

/// @notice Redeems seized Compound/Cream/Fuse CEther cTokens for underlying ETH for use as a step in a liquidation.
contract CEtherLiquidatorTest is Test, FuseFixture {
    CEtherLiquidator internal liquidator;

    // General
    address user = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;

    // Token
    ERC20 underlyingToken = ERC20(0x67B66C99D3Eb37Fa76Aa3Ed1ff33E8e39F0b9c7A);

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(user);

        deal(address(underlyingToken), user, 100e18);
        assertGe(underlyingToken.balanceOf(user), 100e18);

        // Unpause pool

        // Deposit into pool 8

        CErc20 cETH8f = CErc20(0xbB025D470162CC5eA24daF7d4566064EE7f5F111);
        require(cETH8f.mint(100e18) == 0, "mint failed");

        liquidator = CEtherLiquidator(
            deployCode("artifacts/CEtherLiquidator.sol/CEtherLiquidator.json")
        );

        // liquidator.redeem(inputToken, inputAmount, strategyData);

        //

        console2.log(address(liquidator));
    }

    function testExample() public {
        assertTrue(true);
    }
}
