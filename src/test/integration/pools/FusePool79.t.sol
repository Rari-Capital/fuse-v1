pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

// External interfaces
import {IICHIVault} from "../../interfaces/external/ichi/IICHIVault.sol";

// Interfaces
import {ICErc20} from "../../interfaces/core/ICErc20.sol";
import {IUnitroller} from "../../interfaces/core/IUnitroller.sol";
import {IIFuseFeeDistributor} from "../../interfaces/core/IIFuseFeeDistributor.sol";
import {IComptroller} from "../../interfaces/core/IComptroller.sol";

// Pool 79: Fox and Frens
// https://app.rari.capital/token/0x779f9bad1f4b1ef5198ad9361dbf3791f9e0d596 (token)

contract FusePool79 is Test {
    address user = 0xB290f2F3FAd4E540D0550985951Cdad2711ac34A;

    IUnitroller internal constant pool =
        IUnitroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    IIFuseFeeDistributor internal constant fuseAdmin =
        IIFuseFeeDistributor(0x90A48D5CF7343B08dA12E067680B4C6dbfE551Be);

    IComptroller internal constant comptroller =
        IComptroller(0x613Ea1dC49E83eAd05db49DcFcF57b22Fb5510bD);

    // oneFOX token: https://etherscan.io/token/0x03352d267951e96c6f7235037c5dfd2ab1466232
    ERC20 internal constant oneFoxToken =
        ERC20(0x03352D267951E96c6F7235037C5DFD2AB1466232);

    // FOX token: https://etherscan.io/address/0xc770eefad204b5180df6a14ee197d99d808ee52d
    ERC20 internal constant foxToken =
        ERC20(0xc770EEfAd204B5180dF6a14Ee197D99d808ee52d);

    // ICHIVault oneFOX-FOX: https://etherscan.io/address/0x779F9BAd1f4B1Ef5198AD9361DBf3791F9e0D596
    // https://angel.ichi.org/
    IICHIVault internal constant ICHIVault =
        IICHIVault(0x779F9BAd1f4B1Ef5198AD9361DBf3791F9e0D596);

    // Fox and Frens ICHI Vault (fICHI_Vault_LP-79): https://etherscan.io/address/0x3639c603e9A4698CADb813aceC4cEa2D1a83eC18
    ICErc20 cICHIVault = ICErc20(0x3639c603e9A4698CADb813aceC4cEa2D1a83eC18);

    function setUp() public {
        vm.label(address(pool), "pool");
        vm.label(address(fuseAdmin), "fuseAdmin");
        vm.label(address(comptroller), "comptroller");
        vm.label(address(oneFoxToken), "oneFoxToken");
        vm.label(address(foxToken), "foxToken");
        vm.label(address(ICHIVault), "ICHIVault");
    }

    function testPool79() public {
        vm.startPrank(user);

        deal(address(oneFoxToken), user, 100e18);

        assertEq(oneFoxToken.balanceOf(user), 100e18);

        oneFoxToken.approve(address(ICHIVault), type(uint256).max);

        // TODO: investigate why ICHIVault only allows token0, not token1
        uint256 ICHIVaultShares = ICHIVault.deposit(100e18, 0, user);
        require(ICHIVaultShares > 0, "Should receive shares");

        ICHIVault.approve(address(cICHIVault), type(uint256).max);

        deal(address(cICHIVault), user, 100e18);
        uint256 cICHIVaultShares = cICHIVault.mint(100e18);

        // TODO: this currently fails
        require(cICHIVaultShares > 0, "mint failed");
    }
}
