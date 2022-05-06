pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Interfaces
import {ICEther} from "../interfaces/ICEther.sol";
import {IComptrollerInterface} from "../interfaces/IComptrollerInterface.sol";
import {IInterestRateModel} from "../interfaces/IInterestRateModel.sol";

contract CEtherTest is Test {
    IComptrollerInterface public comptrollerInterface;
    IInterestRateModel public interestRateModel;
    ICEther public cEther;

    function setUp() public {
        comptrollerInterface = IComptrollerInterface(
            deployCode("ComptrollerInterface.sol:ComptrollerInterface")
        );
        interestRateModel = IInterestRateModel(
            deployCode("InterestRateModel.sol:InterestRateModel")
        );
        cEther = ICEther(deployCode("CEther.sol:CEther"));

        vm.label(address(cEther), "CEther");
    }

    function testExample() public {
        assertTrue(true);
    }
}
