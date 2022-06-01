pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// Interfaces
import {FuseFeeDistributor} from "../../interfaces/IFuseFeeDistributor.sol";
import {Comptroller} from "../../interfaces/core/IComptroller.sol";
import {CErc20} from "../../interfaces/core/ICErc20.sol";
import {CEther} from "../../interfaces/core/ICEther.sol";
import {CEtherLiquidator} from "../../interfaces/liquidators/ICEtherLiquidator.sol";

// Fixtures
import {FuseFixture} from "../../fixtures/FuseFixture.sol";

// Pool 8 is a special case, uses a custom FuseAdmin
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
    Comptroller internal poolComptroller;
    FuseFeeDistributor internal poolFuseAdmin;
    CEtherLiquidator internal liquidator;

    // General
    address userAddress = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;

    function setUp() public virtual override {
        super.setUp();

        CEther cf6ETH = CEther(0xF6551C22276b9Bf62FaD09f6bD6Cad0264b89789);
        CErc20 cf6FEI = CErc20(0x185Ab80A77D362447415a5B347D7CD86ecaCC87C);

        vm.startPrank(userAddress);

        vm.deal(userAddress, 1 << 128);
        assertGe(userAddress.balance, 1 << 128);

        cf6ETH.mint{value: 10 ether}();
        uint256 cf6ETHBalance = cf6ETH.balanceOf(userAddress);
        assertGt(cf6ETHBalance, 0);

        liquidator = CEtherLiquidator(
            deployCode("artifacts/CEtherLiquidator.sol/CEtherLiquidator.json")
        );

        cf6FEI.borrow(100e18);

        liquidator.redeem(address(cf6ETH), cf6ETHBalance, "");

        console2.log(address(liquidator));
    }

    function testExample() public {
        assertTrue(true);
    }
}
