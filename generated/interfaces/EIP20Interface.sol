pragma solidity ^0.8.10;

interface Interface {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function approve(address spender, uint256 amount)
        external
        returns (bool success);

    function balanceOf(address owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address dst, uint256 amount)
        external
        returns (bool success);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool success);
}
