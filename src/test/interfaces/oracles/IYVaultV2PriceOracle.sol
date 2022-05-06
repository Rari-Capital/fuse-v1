pragma solidity ^0.8.10;

interface IYVaultV2PriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
