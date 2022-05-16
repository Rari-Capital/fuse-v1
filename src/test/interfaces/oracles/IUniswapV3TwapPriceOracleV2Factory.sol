pragma solidity ^0.8.10;

interface UniswapV3TwapPriceOracleV2Factory {
    function WETH() external view returns (address);

    function deploy(
        address uniswapV3Factory,
        uint24 feeTier,
        address baseToken
    ) external returns (address);

    function logic() external view returns (address);

    function oracles(
        address,
        uint256,
        address
    ) external view returns (address);
}
