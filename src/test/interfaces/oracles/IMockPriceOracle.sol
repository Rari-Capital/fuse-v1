pragma solidity ^0.8.10;

interface MockPriceOracle {
    function getUnderlyingPrice(address cToken) view external returns (uint256);
    function hasPriceFeed(address underlying) view external returns (bool);
    function maxSecondsBeforePriceIsStale() view external returns (uint256);
    function price(address underlying) view external returns (uint256);
}

