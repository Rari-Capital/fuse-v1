pragma solidity ^0.8.10;

interface BalancerStableLpTokenPriceOracle {
    function DAI() external view returns (address);

    function WBTC() external view returns (address);

    function bbaUSD() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function staBTC() external view returns (address);
}
