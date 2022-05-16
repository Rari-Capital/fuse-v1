pragma solidity ^0.8.10;

interface SaddleLpTokenPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function poolOf(address) external view returns (address);

    function price(address underlying) external view returns (uint256);

    function registerPool(address lpToken) external;

    function underlyingTokens(address, uint256) external view returns (address);
}
