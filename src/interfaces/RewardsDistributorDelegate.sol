pragma solidity ^0.8.10;

interface IRewardsDistributorDelegate {
    event CompBorrowSpeedUpdated(address indexed cToken, uint256 newSpeed);
    event CompGranted(address recipient, uint256 amount);
    event CompSupplySpeedUpdated(address indexed cToken, uint256 newSpeed);
    event ContributorCompSpeedUpdated(
        address indexed contributor,
        uint256 newSpeed
    );
    event DistributedBorrowerComp(
        address indexed cToken,
        address indexed borrower,
        uint256 compDelta,
        uint256 compBorrowIndex
    );
    event DistributedSupplierComp(
        address indexed cToken,
        address indexed supplier,
        uint256 compDelta,
        uint256 compSupplyIndex
    );
    event NewAdmin(address oldAdmin, address newAdmin);
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    function _acceptAdmin() external;

    function _grantComp(address recipient, uint256 amount) external;

    function _setCompBorrowSpeed(address cToken, uint256 compSpeed) external;

    function _setCompSpeeds(
        address[] memory cTokens,
        uint256[] memory supplySpeeds,
        uint256[] memory borrowSpeeds
    ) external;

    function _setCompSupplySpeed(address cToken, uint256 compSpeed) external;

    function _setContributorCompSpeed(address contributor, uint256 compSpeed)
        external;

    function _setPendingAdmin(address newPendingAdmin) external;

    function admin() external view returns (address);

    function allMarkets(uint256) external view returns (address);

    function claimRewards(address holder, address[] memory cTokens) external;

    function claimRewards(
        address[] memory holders,
        address[] memory cTokens,
        bool borrowers,
        bool suppliers
    ) external;

    function claimRewards(address holder) external;

    function compAccrued(address) external view returns (uint256);

    function compBorrowSpeeds(address) external view returns (uint256);

    function compBorrowState(address)
        external
        view
        returns (uint224 index, uint32 block);

    function compBorrowerIndex(address, address)
        external
        view
        returns (uint256);

    function compContributorSpeeds(address) external view returns (uint256);

    function compInitialIndex() external view returns (uint224);

    function compSupplierIndex(address, address)
        external
        view
        returns (uint256);

    function compSupplySpeeds(address) external view returns (uint256);

    function compSupplyState(address)
        external
        view
        returns (uint224 index, uint32 block);

    function flywheelPreBorrowerAction(address cToken, address borrower)
        external;

    function flywheelPreSupplierAction(address cToken, address supplier)
        external;

    function flywheelPreTransferAction(
        address cToken,
        address src,
        address dst
    ) external;

    function getAllMarkets() external view returns (address[] memory);

    function getBlockNumber() external view returns (uint256);

    function implementation() external view returns (address);

    function initialize(address _rewardToken) external;

    function isRewardsDistributor() external view returns (bool);

    function lastContributorBlock(address) external view returns (uint256);

    function pendingAdmin() external view returns (address);

    function rewardToken() external view returns (address);

    function updateContributorRewards(address contributor) external;
}
