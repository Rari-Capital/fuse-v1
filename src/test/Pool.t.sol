pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

// Test utilities
import {Constants} from "./helpers/Constants.sol";

// Interfaces
import {CErc20} from "./interfaces/core/ICErc20.sol";
import {CToken} from "./interfaces/core/ICToken.sol";
import {CErc20Delegate} from "./interfaces/core/ICErc20Delegate.sol";
import {Comptroller} from "./interfaces/core/IComptroller.sol";
import {FuseFeeDistributor} from "./interfaces/IFuseFeeDistributor.sol";
import {FusePoolDirectory} from "./interfaces/IFusePoolDirectory.sol";
import {Unitroller} from "./interfaces/core/IUnitroller.sol";
import {InterestRateModel} from "./interfaces/core/IInterestRateModel.sol";
import {WhitePaperInterestRateModel} from "./interfaces/core/IWhitePaperInterestRateModel.sol";
import {MockPriceOracle} from "./interfaces/oracles/IMockPriceOracle.sol";

// Artifacts
string constant ComptrollerArtifact = "./artifacts/Comptroller.sol/Comptroller.json";
string constant CErc20DelegateArtifact = "./artifacts/CErc20Delegate.sol/CErc20Delegate.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";
string constant WhitePaperInterestRateModelArtifact = "./artifacts/WhitePaperInterestRateModel.sol/WhitePaperInterestRateModel.json";

contract PoolTest is Test {
    MockERC20 internal underlyingToken;
    CErc20 internal cErc20;
    CToken internal cToken;
    CErc20Delegate internal cErc20Delegate;

    Comptroller internal comptroller;
    WhitePaperInterestRateModel internal interestModel;
    FusePoolDirectory internal fusePoolDirectory;

    address[] internal markets;

    function setUp() public {
        vm.startPrank(Constants.fuseAdminAddress);

        fusePoolDirectory = FusePoolDirectory(
            Constants.fusePoolDirectoryAddress
        );

        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );

        (uint256 index, address unitrollerAddress) = fusePoolDirectory
            .deployPool(
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

    function testEnterMarkets() public {
        interestModel = WhitePaperInterestRateModel(
            deployCode(
                WhitePaperInterestRateModelArtifact,
                abi.encode(1e18, 1e18)
            )
        );

        cErc20Delegate = CErc20Delegate(deployCode(CErc20DelegateArtifact));

        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                Comptroller(comptroller),
                payable(Constants.fuseAdminAddress),
                InterestRateModel(address(interestModel)),
                "CUnderlyingToken",
                "CUT",
                address(cErc20Delegate),
                "",
                uint256(1),
                uint256(0)
            ),
            0.9e18
        );

        uint256 amount = 1 ether;
        underlyingToken = new MockERC20("UnderlyingToken", "UT", 18);
        underlyingToken.mint(address(this), amount);
        underlyingToken.approve(address(cErc20), amount);

        assertEq(comptroller.enterMarkets(markets)[0], 0);

        cErc20.mint(amount);
    }

    // function testExitMarket() public {}
}
