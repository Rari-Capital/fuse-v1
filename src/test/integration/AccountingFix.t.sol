pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

// Interfaces
import {ICEtherDelegate} from "../interfaces/core/ICEtherDelegate.sol";
import {ICEtherDelegateTempExploitAccounting} from "../interfaces/core/ICEtherDelegateTempExploitAccounting.sol";
import {IComptroller} from "../interfaces/core/IComptroller.sol";
import {IFuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";

contract AccountingFix is Test {
    using FixedPointMathLib for uint256;

    ICEtherDelegateTempExploitAccounting
        internal cEtherDelegateTempExploitAccounting;

    ICEtherDelegate internal cEtherDelegate;

    uint256 internal account1UnderlyingSupplyBalanceInitial;
    uint256 internal account1UnderlyingBorrowBalanceInitial;
    uint256 internal account2UnderlyingSupplyBalanceInitial;
    uint256 internal account2UnderlyingBorrowBalanceInitial;

    uint256 internal account1UnderlyingSupplyBalanceFinal;
    uint256 internal account1UnderlyingBorrowBalanceFinal;
    uint256 internal account2UnderlyingSupplyBalanceFinal;
    uint256 internal account2UnderlyingBorrowBalanceFinal;

    function setUp() public {}

    function testShouldMergeAttackersSupplyAndBorrowBalances() public {
        // Deploy new CEtherDelegateTempExploitAccounting
        cEtherDelegateTempExploitAccounting = ICEtherDelegateTempExploitAccounting(
            deployCode(
                "CEtherDelegateTempExploitAccounting.sol:CEtherDelegateTempExploitAccounting"
            )
        );

        // Deploy new CEtherDelegate
        cEtherDelegate = ICEtherDelegate(
            deployCode("CEtherDelegate.sol:CEtherDelegate")
        );

        // Get pool 8 admin
        IComptroller comptroller = IComptroller(
            0xc54172e34046c1653d1920d40333Dd358c7a1aF4
        );
        address comptrollerAdmin = comptroller.admin();
        vm.label(address(comptrollerAdmin), "comptrollerAdmin");

        // Impersonate admin of pool 8
        vm.startPrank(comptrollerAdmin);

        // Get FuseFeeDistributor owner
        IFuseFeeDistributor fuseFeeDistributor = IFuseFeeDistributor(
            address(0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85)
        );
        vm.label(address(fuseFeeDistributor), "fuseFeeDistributor");

        address fuseFeeDistributorOwner = fuseFeeDistributor.owner();
        vm.label(address(fuseFeeDistributorOwner), "fuseFeeDistributorOwner");

        // Impersonate FuseFeeDistributor owner
        vm.stopPrank();
        vm.startPrank(fuseFeeDistributorOwner);

        // Call FuseFeeDistributor._editCEtherDelegateWhitelist
        address[] memory oldImplementations = new address[](2);
        oldImplementations[0] = 0xd77E28A1b9a9cFe1fc2EEE70E391C05d25853cbF;
        oldImplementations[1] = address(cEtherDelegateTempExploitAccounting);

        address[] memory newImplementations = new address[](2);
        newImplementations[0] = address(cEtherDelegateTempExploitAccounting);
        newImplementations[1] = address(cEtherDelegate);

        bool[] memory allowResign = new bool[](2);
        allowResign[0] = false;
        allowResign[1] = false;

        bool[] memory statuses = new bool[](2);
        statuses[0] = true;
        statuses[1] = true;

        fuseFeeDistributor._editCEtherDelegateWhitelist(
            oldImplementations,
            newImplementations,
            allowResign,
            statuses
        );

        // Get attacker's initial balancess
        ICEtherDelegate cEther = ICEtherDelegate(
            0xbB025D470162CC5eA24daF7d4566064EE7f5F111
        );

        uint256 exchangeRateStored = cEther.exchangeRateStored();
        uint256 account1SupplySharesInitial = cEther.balanceOf(
            0x32075bAd9050d4767018084F0Cb87b3182D36C45
        );
        account1UnderlyingSupplyBalanceInitial = account1SupplySharesInitial
            .mulDivDown(exchangeRateStored, 10**18);
        account1UnderlyingBorrowBalanceInitial = cEther.borrowBalanceStored(
            0x32075bAd9050d4767018084F0Cb87b3182D36C45
        );
        account2UnderlyingSupplyBalanceInitial = cEther
            .balanceOf(0x3686657208883d016971c7395eDaeD73c107383E)
            .mulDivDown(exchangeRateStored, 10**18);
        account2UnderlyingBorrowBalanceInitial = cEther.borrowBalanceStored(
            0x3686657208883d016971c7395eDaeD73c107383E
        );

        assertGt(account1UnderlyingSupplyBalanceInitial, 0);
        assertEq(account1UnderlyingBorrowBalanceInitial, 0);
        assertEq(account2UnderlyingSupplyBalanceInitial, 0);
        assertGt(account2UnderlyingBorrowBalanceInitial, 0);

        uint256 totalSupplyInitial = cEther.totalSupply();
        uint256 totalBorrowsInitial = cEther.totalBorrows();

        // Impersonate ComptrollerAdmin (required for upgrading implementation)
        vm.stopPrank();
        vm.startPrank(comptrollerAdmin);

        // Call CEther._setImplementationSafe for temp impl
        address[] memory secondaryExploiterAddress = new address[](1);
        secondaryExploiterAddress[
            0
        ] = 0x3686657208883d016971c7395eDaeD73c107383E;

        cEther._setImplementationSafe(
            address(cEtherDelegateTempExploitAccounting),
            false,
            bytes(abi.encode(secondaryExploiterAddress))
        );

        // Call CEther._setImplementationSafe for final impl
        cEther._setImplementationSafe(
            address(cEtherDelegate),
            false,
            bytes("0x")
        );

        // Double-check attacker's balances
        // TODO: shouldn't this also mulDivDown using 10**18?
        account1UnderlyingSupplyBalanceFinal = cEther
            .balanceOf(0x32075bAd9050d4767018084F0Cb87b3182D36C45)
            .mulDivDown(exchangeRateStored, 10**18);
        account1UnderlyingBorrowBalanceFinal = cEther.borrowBalanceStored(
            0x32075bAd9050d4767018084F0Cb87b3182D36C45
        );
        account2UnderlyingSupplyBalanceFinal = cEther
            .balanceOf(0x3686657208883d016971c7395eDaeD73c107383E)
            .mulDivDown(exchangeRateStored, 10**18);
        account2UnderlyingBorrowBalanceFinal = cEther.borrowBalanceStored(
            0x3686657208883d016971c7395eDaeD73c107383E
        );

        assertEq(account1UnderlyingSupplyBalanceFinal, 0);
        assertEq(
            account1UnderlyingBorrowBalanceFinal,
            account2UnderlyingBorrowBalanceInitial -
                account1UnderlyingSupplyBalanceInitial
        );
        assertEq(account2UnderlyingSupplyBalanceFinal, 0);
        assertEq(account2UnderlyingBorrowBalanceFinal, 0);

        uint256 totalSupplyFinal = cEther.totalSupply();
        uint256 totalBorrowsFinal = cEther.totalBorrows();

        assertEq(
            totalSupplyFinal,
            totalSupplyInitial - account1SupplySharesInitial
        );
        assertEq(
            totalBorrowsFinal,
            totalBorrowsInitial - account1UnderlyingSupplyBalanceInitial
        );
    }
}
