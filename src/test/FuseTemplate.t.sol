pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";

// Test utilities
import {Constants} from "./helpers/Constants.sol";

// Interfaces
import {Comptroller} from "./interfaces/core/IComptroller.sol";
import {FuseFeeDistributor} from "./interfaces/IFuseFeeDistributor.sol";
import {FusePoolDirectory} from "./interfaces/IFusePoolDirectory.sol";
import {Unitroller} from "./interfaces/core/IUnitroller.sol";

// Mocks
import {MockPriceOracle} from "./interfaces/oracles/IMockPriceOracle.sol";

// Artifacts
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";

abstract contract FuseFixture is Test {
    FuseFeeDistributor internal fuseAdmin;

    function setUp() public virtual {
        vm.label(Constants.fuseAdminAddress, "fuseAdmin");
        vm.label(Constants.fusePoolDirectoryAddress, "fusePoolDirectory");
        vm.label(Constants.comptrollerAddress, "comptroller");
        vm.label(Constants.multisigAddress, "multisig");

        fuseAdmin = FuseFeeDistributor(Constants.fuseAdminAddress);
    }
}

contract FuseTemplateTest is FuseFixture {
    Comptroller internal comptroller;
    FusePoolDirectory internal fusePoolDirectory;

    address[] internal emptyAddresses;

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(Constants.fuseAdminAddress);

        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );

        fusePoolDirectory = FusePoolDirectory(
            deployCode(FusePoolDirectoryArtifact)
        );

        fusePoolDirectory.initialize(false, emptyAddresses);

        (, address unitrollerAddress) = fusePoolDirectory.deployPool(
            "TestPool",
            Constants.comptrollerAddress,
            false,
            0.1e18,
            1.1e18,
            address(priceOracle)
        );

        Unitroller(payable(unitrollerAddress))._acceptAdmin();
        comptroller = Comptroller(unitrollerAddress);
    }

    function testExample() public {
        assertTrue(true);
    }
}
