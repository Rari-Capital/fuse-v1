pragma solidity ^0.8.10;

interface IWSSquidPriceOracle {
    function SQUID() external view returns (address);

    function SSQUID() external view returns (address);

    function WSSQUID() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
