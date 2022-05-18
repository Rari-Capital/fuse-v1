pragma solidity ^0.8.10;

interface IERC4626 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event Deposit(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdraw(address indexed from, address indexed to, uint256 value);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function approve(address spender, uint256 amount)
        external
        returns (bool success);

    function asset() external view returns (address);

    function assetsOf(address user) external view returns (uint256 amount);

    function balanceOf(address owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8);

    function deposit(uint256 amount, address to)
        external
        returns (uint256 shares);

    function exchangeRate() external view returns (uint256);

    function maxDeposit(address to) external view returns (uint256 amount);

    function maxMint(address to) external view returns (uint256 shares);

    function maxRedeem(address from) external view returns (uint256 shares);

    function maxWithdraw(address from) external view returns (uint256 amount);

    function mint(uint256 shares, address to) external returns (uint256 amount);

    function name() external view returns (string memory);

    function previewDeposit(uint256 amount)
        external
        view
        returns (uint256 shares);

    function previewMint(uint256 shares) external view returns (uint256 amount);

    function previewRedeem(uint256 shares)
        external
        view
        returns (uint256 amount);

    function previewWithdraw(uint256 amount)
        external
        view
        returns (uint256 shares);

    function redeem(
        uint256 shares,
        address to,
        address from
    ) external returns (uint256 amount);

    function symbol() external view returns (string memory);

    function totalAssets() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address dst, uint256 amount)
        external
        returns (bool success);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool success);

    function withdraw(
        uint256 amount,
        address to,
        address from
    ) external returns (uint256 shares);
}
