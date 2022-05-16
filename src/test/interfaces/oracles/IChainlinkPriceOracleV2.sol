pragma solidity ^0.8.10;

interface ChainlinkPriceOracleV2 {
    event NewAdmin(address oldAdmin, address newAdmin);

    function BTC_ETH_PRICE_FEED() external view returns (address);

    function ETH_USD_PRICE_FEED() external view returns (address);

    function admin() external view returns (address);

    function canAdminOverwrite() external view returns (bool);

    function changeAdmin(address newAdmin) external;

    function feedBaseCurrencies(address) external view returns (uint8);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function priceFeeds(address) external view returns (address);

    function setPriceFeeds(
        address[] memory underlyings,
        address[] memory feeds,
        uint8 baseCurrency
    ) external;
}
