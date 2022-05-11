pragma solidity ^0.8.10;

interface IFixedEurPriceOracle {
    function ETH_USD_PRICE_FEED() external view returns (address);

    function EUR_USD_PRICE_FEED() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
