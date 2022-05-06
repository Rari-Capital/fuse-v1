pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Fixtures
import {ICEther, FCEther} from "../../generated/fixtures/CEther.sol";

contract CEther is FCEther {
    function setUp() public {
        vm.label(address(CEther), "CEther");
    }

    function testExample() public {
        assertTrue(true);
    }
}
