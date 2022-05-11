pragma solidity ^0.8.10;

interface IUniswapV3TwapPriceOracleV2 {
    function TWAP_PERIOD() external view returns (uint32);

    function WETH() external view returns (address);

    function baseToken() external view returns (address);

    function feeTier() external view returns (uint24);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function initialize(
        address _uniswapV3Factory,
        uint24 _feeTier,
        address _baseToken
    ) external;

    function price(address underlying) external view returns (uint256);

    function uniswapV3Factory() external view returns (address);
}
