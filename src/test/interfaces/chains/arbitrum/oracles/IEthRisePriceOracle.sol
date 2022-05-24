pragma solidity ^0.8.10;

interface EthRisePriceOracle {
    function ETHRISE() external view returns (address);

    function USDC() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);

    function rVault() external view returns (address);
}
