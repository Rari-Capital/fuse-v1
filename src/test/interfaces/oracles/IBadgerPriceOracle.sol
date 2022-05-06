pragma solidity ^0.8.10;

interface IBadgerPriceOracle {
    function BADGER_ETH_FEED() external view returns (address);

    function BBADGER() external view returns (address);

    function BDIGG() external view returns (address);

    function BTC_ETH_FEED() external view returns (address);

    function DIGG_BTC_FEED() external view returns (address);

    function IBBTC() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
