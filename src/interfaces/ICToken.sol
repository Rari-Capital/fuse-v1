pragma solidity ^0.8.10;

interface ICToken {
    event AccrueInterest(
        uint256 cashPrior,
        uint256 interestAccumulated,
        uint256 borrowIndex,
        uint256 totalBorrows
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event Borrow(
        address borrower,
        uint256 borrowAmount,
        uint256 accountBorrows,
        uint256 totalBorrows
    );
    event Failure(uint256 error, uint256 info, uint256 detail);
    event LiquidateBorrow(
        address liquidator,
        address borrower,
        uint256 repayAmount,
        address cTokenCollateral,
        uint256 seizeTokens
    );
    event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
    event NewAdminFee(uint256 oldAdminFeeMantissa, uint256 newAdminFeeMantissa);
    event NewComptroller(address oldComptroller, address newComptroller);
    event NewFuseFee(uint256 oldFuseFeeMantissa, uint256 newFuseFeeMantissa);
    event NewMarketInterestRateModel(
        address oldInterestRateModel,
        address newInterestRateModel
    );
    event NewReserveFactor(
        uint256 oldReserveFactorMantissa,
        uint256 newReserveFactorMantissa
    );
    event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);
    event RepayBorrow(
        address payer,
        address borrower,
        uint256 repayAmount,
        uint256 accountBorrows,
        uint256 totalBorrows
    );
    event ReservesAdded(
        address benefactor,
        uint256 addAmount,
        uint256 newTotalReserves
    );
    event ReservesReduced(
        address admin,
        uint256 reduceAmount,
        uint256 newTotalReserves
    );
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function _reduceReserves(uint256 reduceAmount) external returns (uint256);

    function _setAdminFee(uint256 newAdminFeeMantissa)
        external
        returns (uint256);

    function _setInterestRateModel(address newInterestRateModel)
        external
        returns (uint256);

    function _setNameAndSymbol(string memory _name, string memory _symbol)
        external;

    function _setReserveFactor(uint256 newReserveFactorMantissa)
        external
        returns (uint256);

    function _withdrawAdminFees(uint256 withdrawAmount)
        external
        returns (uint256);

    function _withdrawFuseFees(uint256 withdrawAmount)
        external
        returns (uint256);

    function accrualBlockNumber() external view returns (uint256);

    function accrueInterest() external returns (uint256);

    function adminFeeMantissa() external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address owner) external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function borrowBalanceStored(address account)
        external
        view
        returns (uint256);

    function borrowIndex() external view returns (uint256);

    function borrowRatePerBlock() external view returns (uint256);

    function comptroller() external view returns (address);

    function decimals() external view returns (uint8);

    function exchangeRateCurrent() external returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function fuseFeeMantissa() external view returns (uint256);

    function getAccountSnapshot(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        );

    function getCash() external view returns (uint256);

    function initialize(
        address comptroller_,
        address interestRateModel_,
        uint256 initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 reserveFactorMantissa_,
        uint256 adminFeeMantissa_
    ) external;

    function interestRateModel() external view returns (address);

    function isCEther() external view returns (bool);

    function isCToken() external view returns (bool);

    function name() external view returns (string memory);

    function protocolSeizeShareMantissa() external view returns (uint256);

    function reserveFactorMantissa() external view returns (uint256);

    function seize(
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function symbol() external view returns (string memory);

    function totalAdminFees() external view returns (uint256);

    function totalBorrows() external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function totalFuseFees() external view returns (uint256);

    function totalReserves() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool);
}
