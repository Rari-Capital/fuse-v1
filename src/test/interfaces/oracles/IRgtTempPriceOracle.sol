pragma solidity ^0.8.10;

interface RgtTempPriceOracle {
    function EXCHANGE_RATE() external view returns (uint256);

    function RGT() external view returns (address);

    function TRIBE() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
