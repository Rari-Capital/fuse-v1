pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Fixtures
import {ICEther} from "../../generated/interfaces/CEther.sol";

contract CEther is Test {
    ICEther public cEther;

    function setUp() public {
        cEther = ICEther(deployCode("CEther.sol:CEther"));

        vm.label(address(cEther), "CEther");
    }

    function testExample() public {
        assertTrue(true);
    }
}