pragma solidity ^0.8.10;

interface TemplePriceOracle {
    function TEMPLE() external view returns (address);

    function TREASURY() external view returns (address);

    function baseToken() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
