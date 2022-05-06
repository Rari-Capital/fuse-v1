pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Interfaces
import {IIFuseFeeDistributor} from "../interfaces/IIFuseFeeDistributor.sol";
import {IComptrollerInterface} from "../interfaces/IComptrollerInterface.sol";
import {ICEther} from "../interfaces/ICEther.sol";
import {IInterestRateModel} from "../interfaces/IInterestRateModel.sol";

contract CEtherTest is Test {
    IIFuseFeeDistributor internal constant fuseAdmin =
        IIFuseFeeDistributor(0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85);

    IComptrollerInterface public comptrollerInterface;

    ICEther public cEther;

    IInterestRateModel public interestRateModel;

    function setUp() public {
        comptrollerInterface = IComptrollerInterface(
            deployCode("ComptrollerInterface.sol:ComptrollerInterface")
        );

        vm.label(address(comptrollerInterface), "ComptrollerInterface");

        interestRateModel = IInterestRateModel(
            deployCode("InterestRateModel.sol:InterestRateModel")
        );

        vm.label(address(interestRateModel), "InterestRateModel");

        cEther = ICEther(deployCode("CEther.sol:CEther"));

        vm.label(address(cEther), "CEther");

        vm.startPrank(address(fuseAdmin));
    }

    function testExample() public {
        // cEther.initialize(
        //     address(comptrollerInterface),
        //     address(interestRateModel),
        //     "cEther",
        //     "cETH",
        //     0,
        //     0
        // );

        assertTrue(true);
    }
}
