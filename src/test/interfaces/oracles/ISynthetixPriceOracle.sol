pragma solidity ^0.8.10;

interface SynthetixPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
