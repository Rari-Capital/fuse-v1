pragma solidity ^0.8.10;

// Interfaces

import {AlphaHomoraV1BankLiquidator} from "../../interfaces/liquidators/IAlphaHomoraV1BankLiquidator.sol";

// Fixtures
import {FuseFixture} from "../../fixtures/FuseFixture.sol";

contract AlphaHomoraV1BankLiquidatorTest is FuseFixture {
    function setUp() public virtual override {
        super.setUp();
    }

    function testExample() public {
        assertTrue(true);
    }
}
