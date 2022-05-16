pragma solidity ^0.8.10;

interface Keep3rPriceOracle {
    function MAX_TWAP_TIME() external view returns (uint256);

    function MIN_TWAP_TIME() external view returns (uint256);

    function WETH_ADDRESS() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function rootOracle() external view returns (address);

    function uniswapV2Factory() external view returns (address);
}
