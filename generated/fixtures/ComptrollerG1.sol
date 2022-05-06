pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IComptrollerG1 {
    event Failure(uint256 error, uint256 info, uint256 detail);
    event MarketEntered(address cToken, address account);
    event MarketExited(address cToken, address account);
    event MarketListed(address cToken);
    event NewCloseFactor(
        uint256 oldCloseFactorMantissa,
        uint256 newCloseFactorMantissa
    );
    event NewCollateralFactor(
        address cToken,
        uint256 oldCollateralFactorMantissa,
        uint256 newCollateralFactorMantissa
    );
    event NewLiquidationIncentive(
        uint256 oldLiquidationIncentiveMantissa,
        uint256 newLiquidationIncentiveMantissa
    );
    event NewMaxAssets(uint256 oldMaxAssets, uint256 newMaxAssets);
    event NewPriceOracle(address oldPriceOracle, address newPriceOracle);

    function _afterNonReentrant() external;

    function _become(
        address unitroller,
        address _oracle,
        uint256 _closeFactorMantissa,
        uint256 _maxAssets,
        bool reinitializing
    ) external;

    function _beforeNonReentrant() external;

    function _setCloseFactor(uint256 newCloseFactorMantissa)
        external
        returns (uint256);

    function _setCollateralFactor(
        address cToken,
        uint256 newCollateralFactorMantissa
    ) external returns (uint256);

    function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa)
        external
        returns (uint256);

    function _setMaxAssets(uint256 newMaxAssets) external returns (uint256);

    function _setPriceOracle(address newOracle) external returns (uint256);

    function _supportMarket(address cToken) external returns (uint256);

    function accountAssets(address, uint256) external view returns (address);

    function admin() external view returns (address);

    function adminHasRights() external view returns (bool);

    function borrowAllowed(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external returns (uint256);

    function borrowVerify(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external;

    function borrowWithinLimits(address cToken, uint256 accountBorrowsNew)
        external
        returns (uint256);

    function checkMembership(address account, address cToken)
        external
        view
        returns (bool);

    function closeFactorMantissa() external view returns (uint256);

    function comptrollerImplementation() external view returns (address);

    function enterMarkets(address[] memory cTokens)
        external
        returns (uint256[] memory);

    function exitMarket(address cTokenAddress) external returns (uint256);

    function fuseAdminHasRights() external view returns (bool);

    function getAccountLiquidity(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function getAssetsIn(address account)
        external
        view
        returns (address[] memory);

    function isComptroller() external view returns (bool);

    function liquidateBorrowAllowed(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount,
        uint256 seizeTokens
    ) external;

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint256 repayAmount
    ) external view returns (uint256, uint256);

    function liquidationIncentiveMantissa() external view returns (uint256);

    function markets(address)
        external
        view
        returns (bool isListed, uint256 collateralFactorMantissa);

    function mintAllowed(
        address cToken,
        address minter,
        uint256 mintAmount
    ) external returns (uint256);

    function mintVerify(
        address cToken,
        address minter,
        uint256 mintAmount,
        uint256 mintTokens
    ) external;

    function mintWithinLimits(
        address cToken,
        uint256 exchangeRateMantissa,
        uint256 accountTokens,
        uint256 mintAmount
    ) external returns (uint256);

    function oracle() external view returns (address);

    function pendingAdmin() external view returns (address);

    function pendingComptrollerImplementation() external view returns (address);

    function redeemAllowed(
        address cToken,
        address redeemer,
        uint256 redeemTokens
    ) external returns (uint256);

    function redeemVerify(
        address cToken,
        address redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    ) external;

    function repayBorrowAllowed(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function repayBorrowVerify(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 borrowerIndex
    ) external;

    function seizeAllowed(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeVerify(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function transferAllowed(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external returns (uint256);

    function transferVerify(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external;
}

abstract contract FComptrollerG1 is Test {
    address ComptrollerG1 = deployCode("ComptrollerG1.sol:ComptrollerG1");
}
