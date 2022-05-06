pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IEIP20NonStandardInterface {
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

    function totalSupply() external view returns (uint256);

    function transfer(address dst, uint256 amount) external;

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external;
}

abstract contract FEIP20NonStandardInterface is Test {
    IEIP20NonStandardInterface public EIP20NonStandardInterface =
        IEIP20NonStandardInterface(
            deployCode(
                "EIP20NonStandardInterface.sol:EIP20NonStandardInterface"
            )
        );
}
