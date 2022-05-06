pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IRewardsDistributorDelegator {
    event NewImplementation(
        address oldImplementation,
        address newImplementation
    );

    function _setImplementation(address implementation_) external;

    function admin() external view returns (address);

    function implementation() external view returns (address);

    function pendingAdmin() external view returns (address);
}

abstract contract FRewardsDistributorDelegator is Test {
    IRewardsDistributorDelegator public RewardsDistributorDelegator =
        IRewardsDistributorDelegator(
            deployCode(
                "RewardsDistributorDelegator.sol:RewardsDistributorDelegator"
            )
        );
}
