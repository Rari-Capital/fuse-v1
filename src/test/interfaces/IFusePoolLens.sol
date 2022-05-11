pragma solidity ^0.8.10;

interface IFusePoolLens {
    function directory() external view returns (address);

    function getPoolAssetsWithData(address comptroller)
        external
        returns (FusePoolLens.FusePoolAsset[] memory);

    function getPoolSummary(address comptroller)
        external
        returns (
            uint256,
            uint256,
            address[] memory,
            string[] memory,
            bool
        );

    function getPoolUserSummary(address comptroller, address account)
        external
        returns (uint256, uint256);

    function getPoolUsersWithData(
        address[] calldata comptrollers,
        uint256 maxHealth
    )
        external
        returns (
            FusePoolLens.FusePoolUser[][] memory,
            uint256[] memory,
            uint256[] memory,
            bool[] memory
        );

    function getPoolUsersWithData(address comptroller, uint256 maxHealth)
        external
        returns (
            FusePoolLens.FusePoolUser[] memory,
            uint256,
            uint256
        );

    function getPoolsByAccountWithData(address account)
        external
        returns (
            uint256[] memory,
            FusePoolDirectory.FusePool[] memory,
            FusePoolLens.FusePoolData[] memory,
            bool[] memory
        );

    function getPoolsBySupplier(address account)
        external
        view
        returns (uint256[] memory, FusePoolDirectory.FusePool[] memory);

    function getPoolsBySupplierWithData(address account)
        external
        returns (
            uint256[] memory,
            FusePoolDirectory.FusePool[] memory,
            FusePoolLens.FusePoolData[] memory,
            bool[] memory
        );

    function getPublicPoolUsersWithData(uint256 maxHealth)
        external
        returns (
            address[] memory,
            FusePoolLens.FusePoolUser[][] memory,
            uint256[] memory,
            uint256[] memory,
            bool[] memory
        );

    function getPublicPoolsByVerificationWithData(bool whitelistedAdmin)
        external
        returns (
            uint256[] memory,
            FusePoolDirectory.FusePool[] memory,
            FusePoolLens.FusePoolData[] memory,
            bool[] memory
        );

    function getPublicPoolsWithData()
        external
        returns (
            uint256[] memory,
            FusePoolDirectory.FusePool[] memory,
            FusePoolLens.FusePoolData[] memory,
            bool[] memory
        );

    function getUserSummary(address account)
        external
        returns (
            uint256,
            uint256,
            bool
        );

    function getWhitelistedPoolsByAccount(address account)
        external
        view
        returns (uint256[] memory, FusePoolDirectory.FusePool[] memory);

    function getWhitelistedPoolsByAccountWithData(address account)
        external
        returns (
            uint256[] memory,
            FusePoolDirectory.FusePool[] memory,
            FusePoolLens.FusePoolData[] memory,
            bool[] memory
        );

    function initialize(address _directory) external;
}

interface FusePoolLens {
    struct FusePoolAsset {
        address cToken;
        address underlyingToken;
        string underlyingName;
        string underlyingSymbol;
        uint256 underlyingDecimals;
        uint256 underlyingBalance;
        uint256 supplyRatePerBlock;
        uint256 borrowRatePerBlock;
        uint256 totalSupply;
        uint256 totalBorrow;
        uint256 supplyBalance;
        uint256 borrowBalance;
        uint256 liquidity;
        bool membership;
        uint256 exchangeRate;
        uint256 underlyingPrice;
        address oracle;
        uint256 collateralFactor;
        uint256 reserveFactor;
        uint256 adminFee;
        uint256 fuseFee;
        bool borrowGuardianPaused;
    }

    struct FusePoolUser {
        address account;
        uint256 totalBorrow;
        uint256 totalCollateral;
        uint256 health;
        FusePoolAsset[] assets;
    }

    struct FusePoolData {
        uint256 totalSupply;
        uint256 totalBorrow;
        address[] underlyingTokens;
        string[] underlyingSymbols;
        bool whitelistedAdmin;
    }
}

interface FusePoolDirectory {
    struct FusePool {
        string name;
        address creator;
        address comptroller;
        uint256 blockPosted;
        uint256 timestampPosted;
    }
}
