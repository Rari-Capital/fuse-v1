pragma solidity ^0.8.10;

// Vendor
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

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

// Mocks
import {MockPriceOracle} from "./interfaces/mocks/IMockPriceOracle.sol";

// Artifacts
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";
string constant ComptrollerArtifact = "./artifacts/Comptroller.sol/Comptroller.json";
string constant CErc20DelegateArtifact = "./artifacts/CErc20Delegate.sol/CErc20Delegate.json";
string constant WhitePaperInterestRateModelArtifact = "./artifacts/WhitePaperInterestRateModel.sol/WhitePaperInterestRateModel.json";

// Fixtures
import {FuseFixture} from "./fixtures/FuseFixture.sol";

contract FuseTemplateTest is FuseFixture {
    MockERC20 internal underlyingToken;
    CErc20 internal cErc20;
    CToken internal cToken;
    CErc20Delegate internal cErc20Delegate;
    WhitePaperInterestRateModel internal interestModel;

    Comptroller internal comptroller;
    FusePoolDirectory internal fusePoolDirectory;

    address[] internal emptyAddresses;
    address[] internal markets;
    address[] internal oldCErc20Implementations;
    address[] internal newCErc20Implementations;
    bool[] internal trueArray;
    bool[] internal falseArray;

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

    function testEnterMarkets() public {
        interestModel = WhitePaperInterestRateModel(
            deployCode(
                WhitePaperInterestRateModelArtifact,
                abi.encode(1e18, 1e18)
            )
        );

        cErc20Delegate = CErc20Delegate(deployCode(CErc20DelegateArtifact));

        trueArray.push(true);
        falseArray.push(false);
        oldCErc20Implementations.push(address(0));
        newCErc20Implementations.push(address(cErc20Delegate));

        vm.stopPrank();
        vm.startPrank(multisigAddress);

        fuseAdmin._editCErc20DelegateWhitelist(
            oldCErc20Implementations,
            newCErc20Implementations,
            trueArray,
            falseArray
        );

        vm.stopPrank();
        vm.startPrank(fuseAdminAddress);

        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                Comptroller(comptroller),
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
}
