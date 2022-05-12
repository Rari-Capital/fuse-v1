pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// Interfaces
import {ICErc20} from "../interfaces/core/ICErc20.sol";
import {ICToken} from "../interfaces/core/ICToken.sol";
import {IComptroller} from "../interfaces/core/IComptroller.sol";
import {IFuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";

abstract contract WithPool is Test {
    ICErc20 cErc20;
    ICToken cToken;

    IComptroller comptroller;

    IFuseFeeDistributor fuseAdmin;

    constructor() {}

    function setUpBaseContracts() public {}

    function setUpPoolAndMarket() public {}
}
