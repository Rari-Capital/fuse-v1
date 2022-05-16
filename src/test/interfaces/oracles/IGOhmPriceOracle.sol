pragma solidity ^0.8.10;

interface GOhmPriceOracle {
    function GOHM() external view returns (address);

    function OHM() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
