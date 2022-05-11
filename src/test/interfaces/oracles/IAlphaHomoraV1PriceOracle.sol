pragma solidity ^0.8.10;

interface IAlphaHomoraV1PriceOracle {
    function IBETH() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);
}
