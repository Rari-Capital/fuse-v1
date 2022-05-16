pragma solidity ^0.8.10;

interface GFloorPriceOracle {
    function Floor() external view returns (address);

    function gFloor() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
