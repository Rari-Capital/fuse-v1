pragma solidity ^0.8.10;

interface MStableLiquidator {
    function IMBTC() external view returns (address);

    function IMUSD() external view returns (address);

    function MBTC() external view returns (address);

    function MUSD() external view returns (address);

    function redeem(
        address inputToken,
        uint256 inputAmount,
        bytes memory strategyData
    ) external returns (address outputToken, uint256 outputAmount);
}
