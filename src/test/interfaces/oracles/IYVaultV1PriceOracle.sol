pragma solidity ^0.8.10;

interface IYVaultV1PriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
