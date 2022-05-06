pragma solidity ^0.8.10;

interface IKeep3rV2PriceOracle {
    function MIN_TWAP_TIME() external view returns (uint256);

    function WETH_ADDRESS() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function keep3rV2OracleFactory() external view returns (address);

    function price(address underlying) external view returns (uint256);

    function uniswapV2Factory() external view returns (address);
}
