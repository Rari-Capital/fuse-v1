pragma solidity ^0.8.10;

interface FuseSafeLiquidatorArbitrum {
    function redeemCustomCollateral(
        address underlyingCollateral,
        uint256 underlyingCollateralSeized,
        address strategy,
        bytes memory strategyData
    ) external returns (address, uint256);

    function safeLiquidate(
        address borrower,
        address cEther,
        address cErc20Collateral,
        uint256 minOutputAmount,
        address exchangeSeizedTo,
        address uniswapV2Router,
        address[] memory redemptionStrategies,
        bytes[] memory strategyData
    ) external payable returns (uint256);

    function safeLiquidate(
        address borrower,
        uint256 repayAmount,
        address cErc20,
        address cTokenCollateral,
        uint256 minOutputAmount,
        address exchangeSeizedTo,
        address uniswapV2Router,
        address[] memory redemptionStrategies,
        bytes[] memory strategyData
    ) external returns (uint256);

    function safeLiquidateToEthWithFlashLoan(
        address borrower,
        uint256 repayAmount,
        address cEther,
        address cErc20Collateral,
        uint256 minProfitAmount,
        address exchangeProfitTo,
        address uniswapV2RouterForCollateral,
        address[] memory redemptionStrategies,
        bytes[] memory strategyData,
        uint256 ethToCoinbase
    ) external returns (uint256);

    function safeLiquidateToTokensWithFlashLoan(
        address borrower,
        uint256 repayAmount,
        address cErc20,
        address cTokenCollateral,
        uint256 minProfitAmount,
        address exchangeProfitTo,
        address uniswapV2RouterForBorrow,
        address uniswapV2RouterForCollateral,
        address[] memory redemptionStrategies,
        bytes[] memory strategyData,
        uint256 ethToCoinbase
    ) external returns (uint256);

    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes memory data
    ) external;
}
