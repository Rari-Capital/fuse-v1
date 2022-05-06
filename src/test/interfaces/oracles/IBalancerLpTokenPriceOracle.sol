pragma solidity ^0.8.10;

interface IBalancerLpTokenPriceOracle {
    function BONE() external view returns (uint256);

    function BPOW_PRECISION() external view returns (uint256);

    function EXIT_FEE() external view returns (uint256);

    function INIT_POOL_SUPPLY() external view returns (uint256);

    function MAX_BOUND_TOKENS() external view returns (uint256);

    function MAX_BPOW_BASE() external view returns (uint256);

    function MAX_FEE() external view returns (uint256);

    function MAX_IN_RATIO() external view returns (uint256);

    function MAX_OUT_RATIO() external view returns (uint256);

    function MAX_TOTAL_WEIGHT() external view returns (uint256);

    function MAX_WEIGHT() external view returns (uint256);

    function MIN_BALANCE() external view returns (uint256);

    function MIN_BOUND_TOKENS() external view returns (uint256);

    function MIN_BPOW_BASE() external view returns (uint256);

    function MIN_FEE() external view returns (uint256);

    function MIN_WEIGHT() external view returns (uint256);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
