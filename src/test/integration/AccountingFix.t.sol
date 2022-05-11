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
        uint256 exchangeRateStored = cEtherDelegate.exchangeRateStored();
        uint256 account1SupplySharesInitial = cEtherDelegate.balanceOf(
            0x32075bAd9050d4767018084F0Cb87b3182D36C45
        );
        uint256 account1UnderlyingSupplyBalanceInitial = account1SupplySharesInitial
                .mulDivDown(exchangeRateStored, 10**18);
        uint256 account1UnderlyingBorrowBalanceInitial = cEtherDelegate
            .borrowBalanceStored(0x32075bAd9050d4767018084F0Cb87b3182D36C45);
        uint256 account2UnderlyingSupplyBalanceInitial = cEtherDelegate
            .balanceOf(0x3686657208883d016971c7395eDaeD73c107383E)
            .mulDivDown(exchangeRateStored, 10**18);
        uint256 account2UnderlyingBorrowBalanceInitial = cEtherDelegate
            .borrowBalanceStored(0x3686657208883d016971c7395eDaeD73c107383E);

        assertGt(account1UnderlyingSupplyBalanceInitial, 0);
        assertEq(account1UnderlyingBorrowBalanceInitial, 0);
        assertEq(account2UnderlyingSupplyBalanceInitial, 0);
        assertGt(account2UnderlyingBorrowBalanceInitial, 0);

        assertTrue(true);
    }
}

// // const { ethers } = require("hardhat");
// // const { expect } = require("chai");

// // describe("CEtherDelegateTempExploitAccounting", function () {

// //     // Get attacker's initial balances
// //     var cEther = CEtherDelegate.attach("0xbB025D470162CC5eA24daF7d4566064EE7f5F111");
// //     var exchangeRateStored = await cEther.exchangeRateStored();
// //     var account1SupplySharesInitial = await cEther.balanceOf("0x32075bAd9050d4767018084F0Cb87b3182D36C45");
// //     var account1UnderlyingSupplyBalanceInitial = account1SupplySharesInitial.mul(exchangeRateStored).div(ethers.utils.parseEther("1"));
// //     var account1UnderlyingBorrowBalanceInitial = await cEther.borrowBalanceStored("0x32075bAd9050d4767018084F0Cb87b3182D36C45");
// //     var account2UnderlyingSupplyBalanceInitial = (await cEther.balanceOf("0x3686657208883d016971c7395edaed73c107383e")).mul(exchangeRateStored).div(ethers.utils.parseEther("1"));
// //     var account2UnderlyingBorrowBalanceInitial = await cEther.borrowBalanceStored("0x3686657208883d016971c7395edaed73c107383e");
// //     expect(account1UnderlyingSupplyBalanceInitial).to.be.above(0);
// //     expect(account1UnderlyingBorrowBalanceInitial).to.equal(0);
// //     expect(account2UnderlyingSupplyBalanceInitial).to.equal(0);
// //     expect(account2UnderlyingBorrowBalanceInitial).to.be.above(0);
// //     var totalSupplyInitial = await cEther.totalSupply();
// //     var totalBorrowsInitial = await cEther.totalBorrows();

// //     // Call CEther._setImplementationSafe for temp impl
// //     var secondaryExploiterAddresses = ["0x3686657208883d016971c7395edaed73c107383e"];
// //     var becomeImplData = ethers.utils.defaultAbiCoder.encode(["address[]"], [secondaryExploiterAddresses]);
// //     await cEther.connect(await ethers.getSigner(comptrollerAdmin))._setImplementationSafe(cEtherDelegateTempExploitAccounting.address, false, becomeImplData, { gasPrice: "0" });

// //     // Call CEther._setImplementationSafe for final impl
// //     await cEther.connect(await ethers.getSigner(comptrollerAdmin))._setImplementationSafe(cEtherDelegate.address, false, "0x", { gasPrice: "0" });

// //     // Double-check attacker's balances
// //     var account1UnderlyingSupplyBalanceFinal = (await cEther.balanceOf("0x32075bAd9050d4767018084F0Cb87b3182D36C45")).mul(exchangeRateStored);
// //     var account1UnderlyingBorrowBalanceFinal = await cEther.borrowBalanceStored("0x32075bAd9050d4767018084F0Cb87b3182D36C45");
// //     var account2UnderlyingSupplyBalanceFinal = (await cEther.balanceOf("0x3686657208883d016971c7395edaed73c107383e")).mul(exchangeRateStored);
// //     var account2UnderlyingBorrowBalanceFinal = await cEther.borrowBalanceStored("0x3686657208883d016971c7395edaed73c107383e");
// //     expect(account1UnderlyingSupplyBalanceFinal).to.equal(0);
// //     expect(account1UnderlyingBorrowBalanceFinal).to.equal(account2UnderlyingBorrowBalanceInitial.sub(account1UnderlyingSupplyBalanceInitial));
// //     expect(account2UnderlyingSupplyBalanceFinal).to.equal(0);
// //     expect(account2UnderlyingBorrowBalanceFinal).to.equal(0);
// //     var totalSupplyFinal = await cEther.totalSupply();
// //     var totalBorrowsFinal = await cEther.totalBorrows();
// //     expect(totalSupplyFinal).to.equal(totalSupplyInitial.sub(account1SupplySharesInitial));
// //     expect(totalBorrowsFinal).to.equal(totalBorrowsInitial.sub(account1UnderlyingSupplyBalanceInitial));
// //   });
// // });
