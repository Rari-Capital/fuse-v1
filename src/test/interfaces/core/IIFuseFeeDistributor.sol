pragma solidity ^0.8.10;

interface IFuseFeeDistributor {
    function _callPool(address[] memory targets, bytes[] memory data) external;

    function cErc20DelegateWhitelist(
        address oldImplementation,
        address newImplementation,
        bool allowResign
    ) external view returns (bool);

    function cEtherDelegateWhitelist(
        address oldImplementation,
        address newImplementation,
        bool allowResign
    ) external view returns (bool);

    function comptrollerImplementationWhitelist(
        address oldImplementation,
        address newImplementation
    ) external view returns (bool);

    function deployCErc20(bytes memory constructorData)
        external
        returns (address);

    function deployCEther(bytes memory constructorData)
        external
        returns (address);

    function interestFeeRate() external view returns (uint256);

    function latestCErc20Delegate(address oldImplementation)
        external
        view
        returns (
            address cErc20Delegate,
            bool allowResign,
            bytes memory becomeImplementationData
        );

    function latestCEtherDelegate(address oldImplementation)
        external
        view
        returns (
            address cEtherDelegate,
            bool allowResign,
            bytes memory becomeImplementationData
        );

    function latestComptrollerImplementation(address oldImplementation)
        external
        view
        returns (address);

    function maxSupplyEth() external view returns (uint256);

    function maxUtilizationRate() external view returns (uint256);

    function minBorrowEth() external view returns (uint256);

    function owner() external view returns (address);
}
