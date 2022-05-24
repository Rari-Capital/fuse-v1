pragma solidity ^0.8.10;

interface MockPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function hasPriceFeed(address underlying) external view returns (bool);

    function maxSecondsBeforePriceIsStale() external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
