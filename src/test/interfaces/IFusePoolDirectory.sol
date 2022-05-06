pragma solidity ^0.8.10;

interface IFusePoolDirectory {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event PoolRegistered(uint256 index, FusePoolDirectory.FusePool pool);

    function _setDeployerWhitelistEnforcement(bool _enforceDeployerWhitelist)
        external;

    function _whitelistDeployers(address[] calldata deployers) external;

    function bookmarkPool(address comptroller) external;

    function deployPool(
        string calldata name,
        address implementation,
        bool enforceWhitelist,
        uint256 closeFactor,
        uint256 maxAssets,
        uint256 liquidationIncentive,
        address priceOracle
    ) external returns (uint256, address);

    function deployerWhitelist(address) external view returns (bool);

    function enforceDeployerWhitelist() external view returns (bool);

    function getAllPools()
        external
        view
        returns (FusePoolDirectory.FusePool[] memory);

    function getBookmarks(address account)
        external
        view
        returns (address[] memory);

    function getPoolsByAccount(address account)
        external
        view
        returns (uint256[] memory, FusePoolDirectory.FusePool[] memory);

    function getPublicPools()
        external
        view
        returns (uint256[] memory, FusePoolDirectory.FusePool[] memory);

    function initialize(
        bool _enforceDeployerWhitelist,
        address[] calldata _deployerWhitelist
    ) external;

    function owner() external view returns (address);

    function poolExists(address) external view returns (bool);

    function pools(uint256)
        external
        view
        returns (
            string memory name,
            address creator,
            address comptroller,
            uint256 blockPosted,
            uint256 timestampPosted
        );

    function registerPool(string calldata name, address comptroller)
        external
        returns (uint256);

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;
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
