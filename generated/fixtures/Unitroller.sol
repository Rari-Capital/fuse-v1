pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IUnitroller {
    event AdminRightsToggled(bool hasRights);
    event Failure(uint256 error, uint256 info, uint256 detail);
    event FuseAdminRightsToggled(bool hasRights);
    event NewAdmin(address oldAdmin, address newAdmin);
    event NewImplementation(
        address oldImplementation,
        address newImplementation
    );
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
    event NewPendingImplementation(
        address oldPendingImplementation,
        address newPendingImplementation
    );

    function _acceptAdmin() external returns (uint256);

    function _acceptImplementation() external returns (uint256);

    function _setPendingAdmin(address newPendingAdmin)
        external
        returns (uint256);

    function _setPendingImplementation(address newPendingImplementation)
        external
        returns (uint256);

    function _toggleAdminRights(bool hasRights) external returns (uint256);

    function _toggleFuseAdminRights(bool hasRights) external returns (uint256);

    function admin() external view returns (address);

    function adminHasRights() external view returns (bool);

    function comptrollerImplementation() external view returns (address);

    function fuseAdminHasRights() external view returns (bool);

    function pendingAdmin() external view returns (address);

    function pendingComptrollerImplementation() external view returns (address);
}

abstract contract FUnitroller is Test {
    address Unitroller = deployCode("Unitroller.sol:Unitroller");
}
