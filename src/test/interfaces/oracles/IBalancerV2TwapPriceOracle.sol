pragma solidity ^0.8.10;

interface BalancerV2TwapPriceOracle {
    function TWAP_PERIOD() external view returns (uint256);

    function WETH() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
