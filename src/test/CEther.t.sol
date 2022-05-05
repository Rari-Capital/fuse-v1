pragma solidity 0.5.17;

// Mocks
import {CEther} from "../core/CEther.sol";

// Test utilities
import {Test} from "./utilities/Test.sol";

contract CEtherTest is Test {
    CEther internal cEther;

    function setUp() public {
        cEther = new CEther();
    }

    function testExample() public {
        assertTrue(cEther.isCEther());
    }
}
