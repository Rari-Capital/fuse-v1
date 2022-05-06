pragma solidity ^0.8.10;

interface IRecursivePriceOracle {
    function COMPOUND_COMPTROLLER() external view returns (address);

    function CREAM_COMPTROLLER() external view returns (address);

    function ETH_USD_PRICE_FEED() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
