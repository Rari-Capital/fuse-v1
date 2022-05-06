pragma solidity ^0.8.10;

interface IHarvestPriceOracle {
    function FARM() external view returns (address);

    function IFARM() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
