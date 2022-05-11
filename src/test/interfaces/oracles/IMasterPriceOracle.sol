pragma solidity ^0.8.10;

interface IMasterPriceOracle {
    event NewAdmin(address oldAdmin, address newAdmin);
    event NewDefaultOracle(address oldOracle, address newOracle);
    event NewOracle(address underlying, address oldOracle, address newOracle);

    function add(address[] memory underlyings, address[] memory _oracles)
        external;

    function admin() external view returns (address);

    function canAdminOverwrite() external view returns (bool);

    function changeAdmin(address newAdmin) external;

    function defaultOracle() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function initialize(
        address[] memory underlyings,
        address[] memory _oracles,
        address _defaultOracle,
        address _admin,
        bool _canAdminOverwrite
    ) external;

    function oracles(address) external view returns (address);

    function price(address underlying) external view returns (uint256);

    function setDefaultOracle(address newOracle) external;
}
