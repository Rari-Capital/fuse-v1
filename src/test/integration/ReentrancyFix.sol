pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Interfaces
import {ICEtherDelegate} from "../interfaces/core/ICEtherDelegate.sol";
import {ICEtherDelegator} from "../interfaces/core/ICEtherDelegator.sol";

// Utilities
import {ErrorHandling} from "../utilities/ErrorHandling.sol";

contract ReentrancyFix is Test {
    // Tetranode's Flavor of the Month Ethereum Network Token
    // ICEtherDelegator CEtherDelegator =
    //     ICEtherDelegator(0xbB025D470162CC5eA24daF7d4566064EE7f5F111);

    // ICEtherDelegate CEtherDelegate =
    //     ICEtherDelegate(address(CEtherDelegator.implementation()));

    address exploiter = 0x6162759eDAd730152F0dF8115c698a42E666157F;

    function setUp() public {}

    function testShouldAllowReentrancyWithOldCEtherDelegate() public {
        vm.startPrank(exploiter);

        ErrorHandling.functionCall(
            address(0x32075bAd9050d4767018084F0Cb87b3182D36C45),
            "0x34930754000000000000000000000000c54172e34046c1653d1920d40333dd358c7a1af4000000000000000000000000bb025d470162cc5ea24daf7d4566064ee7f5f1110000000000000000000000006b175474e89094c44da98b954eedeac495271d0f0000000000000000000000000000000000000000004a723dc6b40b8a9a00000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000003000000000000000000000000d8553552f8868c1ef160eedf031cf0bcf96869450000000000000000000000007e9ce3caa9910cc048590801e64174957ed41d43000000000000000000000000647a36d421183a0a9fa62717a64b664a24e469c7",
            "CALL_FAIL"
        );
    }

//     function testShouldDisallowReentrancyWithUpgradedCEtherDelegate() public {
//         // Deploy new CEtherDelegate (using deployCode)
//         // Get pool 8 admin
//         // Impersonate pool 8 admin
//         // Get FuseFeeDistributor owner
//         // Impersonate FuseFeeDistributor owner
//         // Call FuseFeeDistributor._editCEtherDelegateWhitelist
//         // Call CEther._setImplementationSafe

//         // Impersonate exploiter
//         vm.startPrank(exploiter);

//         // Exploit should revert
//         vm.expectRevert();

//         ErrorHandling._functionCall(
//             address(0x32075bAd9050d4767018084F0Cb87b3182D36C45),
//             "0x34930754000000000000000000000000c54172e34046c1653d1920d40333dd358c7a1af4000000000000000000000000bb025d470162cc5ea24daf7d4566064ee7f5f1110000000000000000000000006b175474e89094c44da98b954eedeac495271d0f0000000000000000000000000000000000000000004a723dc6b40b8a9a00000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000003000000000000000000000000d8553552f8868c1ef160eedf031cf0bcf96869450000000000000000000000007e9ce3caa9910cc048590801e64174957ed41d43000000000000000000000000647a36d421183a0a9fa62717a64b664a24e469c7",
//             "CALL_FAIL"
//         );
//     }
// }

// https://github.com/foundry-rs/forge-std/issues/22
