pragma solidity ^0.8.10;

interface ZeroPriceOracle {
    function getUnderlyingPrice(address cToken) view external returns (uint256);
    function price(address underlying) view external returns (uint256);
}

