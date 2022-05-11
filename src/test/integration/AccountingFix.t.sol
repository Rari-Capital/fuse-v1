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

    address account1;
    address account2;
    address account3;
    address fETH;

    function setUp() public {}

    function testShouldMergeAttackersSupplyAndBorrowBalances() public {
        // Deploy new CEtherDelegateTempExploitAccounting
        cEtherDelegateTempExploitAccounting = ICEtherDelegateTempExploitAccounting(
            deployCode(
                "CEtherDelegateTempExploitAccounting.sol:CEtherDelegateTempExploitAccounting"
            )
        );

        account1 = 0x32075bAd9050d4767018084F0Cb87b3182D36C45;
        account2 = 0x6cB8A9c28fc3Eb696550e1f69aFE21fb60986f2d;
        account3 = 0x3686657208883d016971c7395eDaeD73c107383E;

        fETH = 0xbB025D470162CC5eA24daF7d4566064EE7f5F111;

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
        oldImplementations[0] = 0xbDADDC6a1321Ed458b53aB9e51DC0De8dba78D43;
        oldImplementations[1] = address(cEtherDelegateTempExploitAccounting);

        address[] memory newImplementations = new address[](2);
        newImplementations[0] = address(cEtherDelegateTempExploitAccounting);
        newImplementations[1] = 0xbDADDC6a1321Ed458b53aB9e51DC0De8dba78D43;

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
            fETH
        );
        cEther.accrueInterest();

        uint256 exchangeRateStored = cEther.exchangeRateStored();
        uint256 account1SupplySharesInitial = cEther.balanceOf(
            account1
        );
        account1UnderlyingSupplyBalanceInitial = account1SupplySharesInitial
            .mulDivDown(exchangeRateStored, 10**18);
        account1UnderlyingBorrowBalanceInitial = cEther.borrowBalanceStored(
            account1
        );
        account2UnderlyingSupplyBalanceInitial = cEther
            .balanceOf(account2)
            .mulDivDown(exchangeRateStored, 10**18) + cEther
            .balanceOf(account3)
            .mulDivDown(exchangeRateStored, 10**18);
        account2UnderlyingBorrowBalanceInitial = cEther.borrowBalanceStored(
            account2
        ) + cEther.borrowBalanceStored(
            account3);

        assertGt(account1UnderlyingSupplyBalanceInitial, 0);
        assertEq(account1UnderlyingBorrowBalanceInitial, 0);
        assertEq(account2UnderlyingSupplyBalanceInitial, 0);
        assertGt(account2UnderlyingBorrowBalanceInitial, 0);

        uint256 totalSupplyInitial = cEther.totalSupply();
        uint256 totalBorrowsInitial = cEther.totalBorrows();

        // Impersonate ComptrollerAdmin (required for upgrading implementation)
        vm.stopPrank();
        vm.startPrank(address(fuseFeeDistributor));

        address[] memory secondaryExploiterAddress = new address[](2);
        secondaryExploiterAddress[
             0
        ] = account2;
        secondaryExploiterAddress[
             1
        ] = account3;

         cEther._setImplementationSafe(
             address(cEtherDelegateTempExploitAccounting),
             false,
             abi.encode(secondaryExploiterAddress)
        );

        // Call CEther._setImplementationSafe for final impl
        cEther._setImplementationSafe(
             address(0xbDADDC6a1321Ed458b53aB9e51DC0De8dba78D43),
             false,
             new bytes(0)
        );

        // Double-check attacker's balances
        account1UnderlyingSupplyBalanceFinal = cEther
             .balanceOf(account1)
             .mulDivDown(exchangeRateStored, 10**18);
        account1UnderlyingBorrowBalanceFinal = cEther.borrowBalanceStored(
             account1
            );
        account2UnderlyingSupplyBalanceFinal = cEther
             .balanceOf(account2)
             .mulDivDown(exchangeRateStored, 10**18) + cEther
             .balanceOf(account3)
             .mulDivDown(exchangeRateStored, 10**18);
         account2UnderlyingBorrowBalanceFinal = cEther.borrowBalanceStored(
             account2
            ) + cEther.borrowBalanceStored(
            account3);

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
