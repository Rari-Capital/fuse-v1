pragma solidity ^0.8.10;

interface GAlcxPriceOracle {
    function ALCX() external view returns (address);

    function gALCX() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
