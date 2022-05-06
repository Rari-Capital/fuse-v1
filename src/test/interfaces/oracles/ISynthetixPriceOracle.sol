pragma solidity ^0.8.10;

interface ISynthetixPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
