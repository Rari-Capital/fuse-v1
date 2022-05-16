pragma solidity ^0.8.10;

interface PriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function isPriceOracle() external view returns (bool);
}
