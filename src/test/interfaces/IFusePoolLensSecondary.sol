pragma solidity ^0.8.10;

interface IFusePoolLensSecondary {
    function directory() external view returns (address);

    function getMaxBorrow(address account, address cTokenModify)
        external
        returns (uint256);

    function getMaxRedeem(address account, address cTokenModify)
        external
        returns (uint256);

    function getPoolOwnership(address comptroller)
        external
        view
        returns (
            address,
            bool,
            bool,
            FusePoolLensSecondary.CTokenOwnership[] memory
        );

    function getRewardSpeedsByPool(address comptroller)
        external
        view
        returns (
            address[] memory,
            address[] memory,
            address[] memory,
            uint256[][] memory,
            uint256[][] memory
        );

    function getRewardSpeedsByPools(address[] calldata comptrollers)
        external
        view
        returns (
            address[][] memory,
            address[][] memory,
            address[][] memory,
            uint256[][][] memory,
            uint256[][][] memory
        );

    function getRewardsDistributorsBySupplier(address supplier)
        external
        view
        returns (
            uint256[] memory,
            address[] memory,
            address[][] memory
        );

    function getUnclaimedRewardsByDistributors(
        address holder,
        address[] calldata distributors
    )
        external
        returns (
            address[] memory,
            uint256[] memory,
            address[][] memory,
            uint256[2][][] memory,
            uint256[] memory
        );

    function initialize(address _directory) external;
}

interface FusePoolLensSecondary {
    struct CTokenOwnership {
        address cToken;
        address admin;
        bool adminHasRights;
        bool fuseAdminHasRights;
    }
}
