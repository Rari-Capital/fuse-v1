pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// Interfaces
import {ICErc20} from "../../interfaces/core/ICErc20.sol";
import {IUnitroller} from "../../interfaces/core/IUnitroller.sol";
import {IIFuseFeeDistributor} from "../../interfaces/core/IIFuseFeeDistributor.sol";
import {IComptroller} from "../../interfaces/core/IComptroller.sol";

// Pool 79: Fox and Frens
// https://etherscan.io/address/0x41c7B863FdDa5eb7CF8D8f748B136d10d7AEC631 (pool)

contract FusePool79 is Test {
    address user = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;

    IUnitroller internal constant pool =
        IUnitroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    IIFuseFeeDistributor internal constant fuseAdmin =
        IIFuseFeeDistributor(0x90A48D5CF7343B08dA12E067680B4C6dbfE551Be);

    IComptroller internal constant comptroller =
        IComptroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    // Uniswap V3 oneFOX-FOX: https://etherscan.io/address/0x202a4a99ab3833528e2dda446730e95cb004093e#readContract
    address internal constant oneFoxFoxLpToken =
        0x202a4a99aB3833528e2ddA446730E95CB004093E;

    // oneFOX token: https://etherscan.io/token/0x03352d267951e96c6f7235037c5dfd2ab1466232
    ERC20 internal constant oneFoxToken =
        ERC20(0x03352D267951E96c6F7235037C5DFD2AB1466232);

    function setUp() public {
        vm.label(address(pool), "pool");
        vm.label(address(fuseAdmin), "fuseAdmin");
        vm.label(address(comptroller), "comptroller");
        vm.label(address(oneFoxFoxLpToken), "oneFoxFoxLpToken");
        vm.label(address(oneFoxToken), "oneFoxToken");
    }

    function testPool79() public {
        vm.startPrank(user);

        deal(address(oneFoxToken), user, 1e18);

        console2.log(oneFoxToken.balanceOf(address(user)));

        assertTrue(true);
    }
}
