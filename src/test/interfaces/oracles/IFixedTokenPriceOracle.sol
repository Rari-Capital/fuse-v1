pragma solidity ^0.8.10;

interface IFixedTokenPriceOracle {
    function baseToken() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
