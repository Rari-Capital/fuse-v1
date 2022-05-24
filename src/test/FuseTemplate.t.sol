pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";

// Interfaces
import {Comptroller} from "./interfaces/core/IComptroller.sol";
import {FuseFeeDistributor} from "./interfaces/IFuseFeeDistributor.sol";
import {FusePoolDirectory} from "./interfaces/IFusePoolDirectory.sol";
import {Unitroller} from "./interfaces/core/IUnitroller.sol";

// Mocks
import {MockPriceOracle} from "./interfaces/mocks/IMockPriceOracle.sol";

// Artifacts
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";

// Fixtures
import {FuseFixture} from "./fixtures/FuseFixture.sol";

contract FuseTemplateTest is FuseFixture {
    Comptroller internal comptroller;
    FusePoolDirectory internal fusePoolDirectory;

    address[] internal emptyAddresses;

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(fuseAdminAddress);

        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );

        fusePoolDirectory = FusePoolDirectory(
            deployCode(FusePoolDirectoryArtifact)
        );

        fusePoolDirectory.initialize(false, emptyAddresses);

        (, address unitrollerAddress) = fusePoolDirectory.deployPool(
            "TestPool",
            comptrollerAddress,
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
