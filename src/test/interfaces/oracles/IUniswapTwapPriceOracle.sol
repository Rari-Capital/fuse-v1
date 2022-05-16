pragma solidity ^0.8.10;

interface UniswapTwapPriceOracle {
    function WETH() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function rootOracle() external view returns (address);

    function uniswapV2Factory() external view returns (address);
}
