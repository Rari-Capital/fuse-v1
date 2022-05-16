pragma solidity ^0.8.10;

interface ICHIVault {
    event Affiliate(address indexed sender, address affiliate);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event DeployICHIVault(
        address indexed sender,
        address indexed pool,
        bool allowToken0,
        bool allowToken1,
        address owner,
        uint256 twapPeriod
    );
    event Deposit(
        address indexed sender,
        address indexed to,
        uint256 shares,
        uint256 amount0,
        uint256 amount1
    );
    event DepositMax(
        address indexed sender,
        uint256 deposit0Max,
        uint256 deposit1Max
    );
    event Hysteresis(address indexed sender, uint256 hysteresis);
    event MaxTotalSupply(address indexed sender, uint256 maxTotalSupply);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Rebalance(
        int24 tick,
        uint256 totalAmount0,
        uint256 totalAmount1,
        uint256 feeAmount0,
        uint256 feeAmount1,
        uint256 totalSupply
    );
    event SetTwapPeriod(address sender, uint32 newTwapPeriod);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(
        address indexed sender,
        address indexed to,
        uint256 shares,
        uint256 amount0,
        uint256 amount1
    );

    function PRECISION() external view returns (uint256);

    function affiliate() external view returns (address);

    function allowToken0() external view returns (bool);

    function allowToken1() external view returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function baseLower() external view returns (int24);

    function baseUpper() external view returns (int24);

    function currentTick() external view returns (int24 tick);

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function deposit(
        uint256 deposit0,
        uint256 deposit1,
        address to
    ) external returns (uint256 shares);

    function deposit0Max() external view returns (uint256);

    function deposit1Max() external view returns (uint256);

    function fee() external view returns (uint24);

    function getBasePosition()
        external
        view
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    function getLimitPosition()
        external
        view
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    function getTotalAmounts()
        external
        view
        returns (uint256 total0, uint256 total1);

    function hysteresis() external view returns (uint256);

    function ichiVaultFactory() external view returns (address);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function limitLower() external view returns (int24);

    function limitUpper() external view returns (int24);

    function maxTotalSupply() external view returns (uint256);

    function name() external view returns (string memory);

    function owner() external view returns (address);

    function pool() external view returns (address);

    function rebalance(
        int24 _baseLower,
        int24 _baseUpper,
        int24 _limitLower,
        int24 _limitUpper,
        int256 swapQuantity
    ) external;

    function renounceOwnership() external;

    function setAffiliate(address _affiliate) external;

    function setDepositMax(uint256 _deposit0Max, uint256 _deposit1Max) external;

    function setHysteresis(uint256 _hysteresis) external;

    function setMaxTotalSupply(uint256 _maxTotalSupply) external;

    function setTwapPeriod(uint32 newTwapPeriod) external;

    function symbol() external view returns (string memory);

    function tickSpacing() external view returns (int24);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function totalSupply() external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferOwnership(address newOwner) external;

    function twapPeriod() external view returns (uint32);

    function uniswapV3MintCallback(
        uint256 amount0,
        uint256 amount1,
        bytes memory data
    ) external;

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes memory data
    ) external;

    function withdraw(uint256 shares, address to)
        external
        returns (uint256 amount0, uint256 amount1);
}
