pragma solidity 0.8.13;

// // Vendor
// import {Test} from "forge-std/Test.sol";

// // Interfaces
// import {ICEtherDelegate} from "../interfaces/core/ICEtherDelegate.sol";
// import {ICEtherDelegateTempExploitAccounting} from "../interfaces/core/ICEtherDelegateTempExploitAccounting.sol";
// import {IComptroller} from "../interfaces/core/IComptroller.sol";
// import {IFuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";

// contract AccountingFix is Test {
//     ICEtherDelegateTempExploitAccounting
//         internal cEtherDelegateTempExploitAccounting;

//     ICEtherDelegate internal cEtherDelegate;

//     function setUp() public {}

//     function testShouldMergeAttackersSupplyAndBorrowBalances() public {
//         // Deploy new CEtherDelegateTempExploitAccounting
//         cEtherDelegateTempExploitAccounting = ICEtherDelegateTempExploitAccounting(
//             deployCode(
//                 "CEtherDelegateTempExploitAccounting.sol:CEtherDelegateTempExploitAccounting"
//             )
//         );

//         // Deploy new CEtherDelegate
//         cEtherDelegate = ICEtherDelegate(
//             deployCode("CEtherDelegate.sol:CEtherDelegate")
//         );

//         // Get pool 8 admin
//         IComptroller comptroller = IComptroller(
//             0xc54172e34046c1653d1920d40333Dd358c7a1aF4
//         );
//         address comptrollerAdmin = comptroller.admin();
//         vm.label(address(comptrollerAdmin), "comptrollerAdmin");

//         // Impersonate admin of pool 8
//         vm.startPrank(comptrollerAdmin);

//         // Get FuseFeeDistributor owner
//         IFuseFeeDistributor fuseFeeDistributor = IFuseFeeDistributor(
//             address(0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85)
//         );
//         vm.label(address(fuseFeeDistributor), "fuseFeeDistributor");

//         address fuseFeeDistributorOwner = fuseFeeDistributor.owner();
//         vm.label(address(fuseFeeDistributorOwner), "fuseFeeDistributorOwner");

//         // Impersonate FuseFeeDistributor owner
//         vm.stopPrank();
//         vm.startPrank(fuseFeeDistributorOwner);

//         // Call FuseFeeDistributor._editCEtherDelegateWhitelist
//         // fuseFeeDistributor._edit

//         assertTrue(true);
//     }
// }

// // const { ethers } = require("hardhat");
// // const { expect } = require("chai");

// // describe("CEtherDelegateTempExploitAccounting", function () {
// //   it("Should merge the attacker's supply and borrow balances", async function () {
// //     // Enable using 0 gas price
// //     await hre.network.provider.send("hardhat_setNextBlockBaseFeePerGas", ["0x0"]);

// //     // Deploy new CEtherDelegateTempExploitAccounting
// //     const CEtherDelegateTempExploitAccounting = await ethers.getContractFactory("CEtherDelegateTempExploitAccounting");
// //     var cEtherDelegateTempExploitAccounting = await CEtherDelegateTempExploitAccounting.deploy();

// //     // Deploy new CEtherDelegate
// //     const CEtherDelegate = await ethers.getContractFactory("CEtherDelegate");
// //     var cEtherDelegate = await CEtherDelegate.deploy();

// //     // Get pool 8 admin
// //     const Comptroller = await ethers.getContractFactory("Comptroller");
// //     var comptroller = Comptroller.attach("0xc54172e34046c1653d1920d40333dd358c7a1af4");
// //     var comptrollerAdmin = await comptroller.admin();

// //     // Impersonate admin of pool 8
// //     await hre.network.provider.request({
// //         method: "hardhat_impersonateAccount",
// //         params: [comptrollerAdmin],
// //     });

// //     // Get FuseFeeDistributor owner
// //     var ffd = new ethers.Contract("0xa731585ab05fC9f83555cf9Bff8F58ee94e18F85", [{"inputs":[{"internalType":"address[]","name":"oldImplementations","type":"address[]"},{"internalType":"address[]","name":"newImplementations","type":"address[]"},{"internalType":"bool[]","name":"allowResign","type":"bool[]"},{"internalType":"bool[]","name":"statuses","type":"bool[]"}],"name":"_editCEtherDelegateWhitelist","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}], ethers.provider);
// //     var ffdOwner = await ffd.owner();

// //     // Impersonate FuseFeeDistributor owner
// //     await hre.network.provider.request({
// //         method: "hardhat_impersonateAccount",
// //         params: [ffdOwner],
// //     });

// //     // Call FuseFeeDistributor._editCEtherDelegateWhitelist
// //     await ffd.connect(await ethers.getSigner(ffdOwner))._editCEtherDelegateWhitelist(["0xd77e28a1b9a9cfe1fc2eee70e391c05d25853cbf", cEtherDelegateTempExploitAccounting.address], [cEtherDelegateTempExploitAccounting.address, cEtherDelegate.address], [false, false], [true, true], { gasPrice: "0" });

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
