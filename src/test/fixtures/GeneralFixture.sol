pragma solidity ^0.8.10;

// Vendor
// Automatically get access to vm, console.log(), console2.log() and many other utilities.
// You don't need to import this again in your test if you inherit FuseFixture.
import "forge-std/Test.sol";

// Interfaces
import {FuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";

abstract contract GeneralFixture is Test {
    address public constant fuseAdminAddress =
        address(0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85);

    address public constant fusePoolDirectoryAddress =
        address(0x835482FE0532f169024d5E9410199369aAD5C77E);

    address public constant comptrollerAddress =
        address(0xE16DB319d9dA7Ce40b666DD2E365a4b8B3C18217);

    address public constant multisigAddress =
        address(0x5eA4A9a7592683bF0Bc187d6Da706c6c4770976F);

    FuseFeeDistributor internal fuseAdmin;

    function setUp() public virtual {
        vm.label(fuseAdminAddress, "fuseAdmin");
        vm.label(fusePoolDirectoryAddress, "fusePoolDirectory");
        vm.label(comptrollerAddress, "comptroller");
        vm.label(multisigAddress, "multisig");

        fuseAdmin = FuseFeeDistributor(fuseAdminAddress);
    }
}
