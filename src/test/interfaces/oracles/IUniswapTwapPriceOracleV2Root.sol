pragma solidity ^0.8.10;

interface IUniswapTwapPriceOracleV2Root {
    function MIN_TWAP_TIME() external view returns (uint256);

    function OBSERVATION_BUFFER() external view returns (uint8);

    function WETH() external view returns (address);

    function observationCount(address) external view returns (uint256);

    function observations(address, uint256)
        external
        view
        returns (
            uint32 timestamp,
            uint256 price0Cumulative,
            uint256 price1Cumulative
        );

    function pairsFor(
        address[] memory tokenA,
        address[] memory tokenB,
        address factory
    ) external view returns (address[] memory);

    function price(
        address underlying,
        address baseToken,
        address factory
    ) external view returns (uint256);

    function update(address pair) external;

    function update(address[] memory pairs) external;

    function workable(
        address[] memory pairs,
        address[] memory baseTokens,
        uint256[] memory minPeriods,
        uint256[] memory deviationThresholds
    ) external view returns (bool[] memory);
}
