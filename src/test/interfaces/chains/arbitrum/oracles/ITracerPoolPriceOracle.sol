pragma solidity ^0.8.10;

interface TracerPoolPriceOracle {
    event NewAdmin(address oldAdmin, address newAdmin);

    function addPool(address pool, address settlementToken) external;

    function admin() external view returns (address);

    function changeAdmin(address newAdmin) external;

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
