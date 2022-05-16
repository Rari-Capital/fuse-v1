pragma solidity ^0.8.10;

interface ChainlinkPriceOracleV3 {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
