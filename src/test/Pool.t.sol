pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {Auth, Authority} from "solmate/auth/Auth.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

// Test utilities
import {Constants} from "./helpers/Constants.sol";

// Interfaces
import {CErc20} from "./interfaces/core/ICErc20.sol";
import {CToken} from "./interfaces/core/ICToken.sol";
import {WhitePaperInterestRateModel} from "./interfaces/core/IWhitePaperInterestRateModel.sol";
import {Unitroller} from "./interfaces/core/IUnitroller.sol";
import {Comptroller} from "./interfaces/core/IComptroller.sol";
import {CErc20Delegate} from "./interfaces/core/ICErc20Delegate.sol";
import {CErc20Delegator} from "./interfaces/core/ICErc20Delegator.sol";
import {RewardsDistributorDelegate} from "./interfaces/core/IRewardsDistributorDelegate.sol";
import {RewardsDistributorDelegator} from "./interfaces/core/IRewardsDistributorDelegator.sol";
import {ComptrollerInterface} from "./interfaces/core/IComptrollerInterface.sol";
import {InterestRateModel} from "./interfaces/core/IInterestRateModel.sol";
import {FuseFeeDistributor} from "./interfaces/IFuseFeeDistributor.sol";
import {FusePoolDirectory} from "./interfaces/IFusePoolDirectory.sol";
import {MockPriceOracle} from "./interfaces/oracles/IMockPriceOracle.sol";

// Artifacts
string constant WhitePaperInterestRateModelArtifact = "./artifacts/WhitePaperInterestRateModel.sol/WhitePaperInterestRateModel.json";
string constant ComptrollerArtifact = "./artifacts/Comptroller.sol/Comptroller.json";
string constant CErc20DelegateArtifact = "./artifacts/CErc20Delegate.sol/CErc20Delegate.json";
string constant FuseFeeDistributorArtifact = "./artifacts/FuseFeeDistributor.sol/FuseFeeDistributor.json";
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";

// How does one spin up a new permissioned pool

contract PoolTest is Test {
    MockERC20 internal underlyingToken;
    CErc20 internal cErc20;
    CToken internal cToken;
    CErc20Delegate internal cErc20Delegate;

    Comptroller internal comptroller;
    WhitePaperInterestRateModel internal interestModel;

    FuseFeeDistributor internal fuseAdmin;
    FusePoolDirectory internal fusePoolDirectory;

    address[] internal emptyAddresses;

    // function testDeployPool() public {
    //     // Create Unitroller

    //     comptroller = Comptroller(0x814b02C1ebc9164972D888495927fe1697F0Fb4c);
    //     address comptrollerAdmin = comptroller.admin();
    //     vm.label(address(comptrollerAdmin), "comptrollerAdmin");

    //     vm.startPrank(comptrollerAdmin);

    //     console2.log(comptrollerAdmin);

    //     // Get FuseFeeDistributor owner
    //     fuseAdmin = FuseFeeDistributor(address(Constants.fuseAdminAddress));
    //     vm.label(address(fuseAdmin), "fuseAdmin");

    //     address fuseFeeDistributorOwner = fuseAdmin.owner();
    //     vm.label(address(fuseFeeDistributorOwner), "fuseAdminOwner");

    //     // Impersonate FuseFeeDistributor owner
    //     vm.stopPrank();
    //     vm.startPrank(fuseFeeDistributorOwner);

    //     // Necessary for editing whitelist

    //     console2.log(fuseFeeDistributorOwner);

    //     vm.stopPrank();
    //     // vm.startPrank(fuseAdmin);
    // }

    function testPool() public {
        vm.startPrank(Constants.fuseAdminAddress);

        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );

        fusePoolDirectory = FusePoolDirectory(
            deployCode(FusePoolDirectoryArtifact)
        );
        fusePoolDirectory.initialize(false, emptyAddresses);

        // Comptroller tempComptroller = Comptroller(
        //     deployCode(ComptrollerArtifact)
        // );

        Comptroller tempComptroller = Comptroller(Constants.comptrollerAddress);

        (, address comptrollerAddress) = fusePoolDirectory.deployPool(
            "TestPool",
            address(tempComptroller),
            false,
            0.1e18,
            1.1e18,
            address(priceOracle)
        );

        Unitroller(payable(comptrollerAddress))._acceptAdmin();
        comptroller = Comptroller(comptrollerAddress);

        vm.stopPrank();
    }
}
