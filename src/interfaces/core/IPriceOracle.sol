pragma solidity ^0.8.10;

interface IPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function isPriceOracle() external view returns (bool);
}
