pragma solidity ^0.8.10;

interface IMStablePriceOracle {
    function IMBTC() external view returns (address);

    function IMUSD() external view returns (address);

    function MBTC() external view returns (address);

    function MUSD() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
