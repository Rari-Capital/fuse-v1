pragma solidity ^0.8.10;

interface IPreferredPriceOracle {
    function chainlinkOracleV2() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function masterOracle() external view returns (address);

    function price(address underlying) external view returns (uint256);

    function tertiaryOracle() external view returns (address);
}
