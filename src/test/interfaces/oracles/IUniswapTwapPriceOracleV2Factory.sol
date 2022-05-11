pragma solidity ^0.8.10;

interface IUniswapTwapPriceOracleV2Factory {
    function WETH() external view returns (address);

    function deploy(address uniswapV2Factory, address baseToken)
        external
        returns (address);

    function logic() external view returns (address);

    function oracles(address, address) external view returns (address);

    function rootOracle() external view returns (address);
}
