pragma solidity ^0.8.10;

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
