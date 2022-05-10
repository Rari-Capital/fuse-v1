pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Interfaces
import {ICErc20} from "../../interfaces/core/ICErc20.sol";
import {IUnitroller} from "../../interfaces/core/IUnitroller.sol";
import {IIFuseFeeDistributor} from "../../interfaces/core/IIFuseFeeDistributor.sol";
import {IComptroller} from "../../interfaces/core/IComptroller.sol";

// Fox and Frens
// https://etherscan.io/address/0x41c7B863FdDa5eb7CF8D8f748B136d10d7AEC631 (pool)

contract FusePool79Test is Test {
    address alice = address(1);

    IUnitroller internal constant pool =
        IUnitroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    IIFuseFeeDistributor internal constant fuseAdmin =
        IIFuseFeeDistributor(0x90A48D5CF7343B08dA12E067680B4C6dbfE551Be);

    IComptroller internal constant comptroller =
        IComptroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    // Uniswap V3 oneFox-FOX: https://etherscan.io/address/0x202a4a99ab3833528e2dda446730e95cb004093e#readContract
    address internal constant oneFoxFoxLp =
        0x202a4a99aB3833528e2ddA446730E95CB004093E;

    function setUp() public {
        vm.label(address(pool), "pool");
        vm.label(address(fuseAdmin), "fuseAdmin");
        vm.label(address(comptroller), "comptroller");
    }

    function testPool79() public {
        vm.startPrank(alice);

        deal(oneFoxFoxLp, alice, 100e18);
    }
}
