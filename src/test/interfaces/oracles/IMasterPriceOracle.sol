pragma solidity ^0.8.10;

interface IMasterPriceOracle {
    event NewAdmin(address oldAdmin, address newAdmin);

    function add(address[] memory underlyings, address[] memory _oracles)
        external;

    function admin() external view returns (address);

    function canAdminOverwrite() external view returns (bool);

    function changeAdmin(address newAdmin) external;

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function oracles(address) external view returns (address);

    function price(address underlying) external view returns (uint256);
}
