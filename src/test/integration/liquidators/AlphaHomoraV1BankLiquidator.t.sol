pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";

// Interfaces

import {AlphaHomoraV1BankLiquidator} from "../../interfaces/liquidators/IAlphaHomoraV1BankLiquidator.sol";

// Fixtures
import {FuseFixture} from "../../fixtures/FuseFixture.sol";

contract AlphaHomoraV1BankLiquidatorTest is Test, FuseFixture {
    AlphaHomoraV1BankLiquidator internal liquidator;

    function setUp() public virtual override {
        super.setUp();

        liquidator = AlphaHomoraV1BankLiquidator(
            deployCode(
                "artifacts/AlphaHomoraV1BankLiquidator.sol/AlphaHomoraV1BankLiquidator.json"
            )
        );

        console2.log(address(liquidator));
    }

    function testExample() public {
        assertTrue(true);
    }
}
