pragma solidity ^0.8.10;

interface ChainlinkPriceOracle {
    function BTC_ETH_PRICE_FEED() external view returns (address);

    function ETH_USD_PRICE_FEED() external view returns (address);

    function btcPriceFeeds(address) external view returns (address);

    function ethPriceFeeds(address) external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function hasPriceFeed(address underlying) external view returns (bool);

    function maxSecondsBeforePriceIsStale() external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function usdPriceFeeds(address) external view returns (address);
}
