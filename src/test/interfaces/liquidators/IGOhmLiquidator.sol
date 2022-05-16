pragma solidity ^0.8.10;

interface GOhmLiquidator {
    function OLYMPUS_STAKING() external view returns (address);

    function redeem(
        address inputToken,
        uint256 inputAmount,
        bytes memory strategyData
    ) external returns (address outputToken, uint256 outputAmount);
}
