pragma solidity ^0.8.10;

interface Interface {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function isPriceOracle() external view returns (bool);
}
