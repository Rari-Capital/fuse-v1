pragma solidity ^0.8.10;

interface IFuseFeeDistributor {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function _callPool(address[] memory targets, bytes[] memory data) external;

    function _callPool(address[] memory targets, bytes memory data) external;

    function _setInterestFeeRate(uint256 _interestFeeRate) external;

    function _setPoolLimits(
        uint256 _minBorrowEth,
        uint256 _maxSupplyEth,
        uint256 _maxUtilizationRate
    ) external;

    function _withdrawAssets(address erc20Contract) external;

    function initialize(uint256 _interestFeeRate) external;

    function interestFeeRate() external view returns (uint256);

    function maxSupplyEth() external view returns (uint256);

    function maxUtilizationRate() external view returns (uint256);

    function minBorrowEth() external view returns (uint256);

    function owner() external view returns (address);

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;
}
