pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {Auth, Authority} from "solmate/auth/Auth.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

// Interfaces
import {CErc20} from "../interfaces/core/ICErc20.sol";
import {CToken} from "../interfaces/core/ICToken.sol";
import {WhitePaperInterestRateModel} from "../interfaces/core/IWhitePaperInterestRateModel.sol";
import {Unitroller} from "../interfaces/core/IUnitroller.sol";
import {Comptroller} from "../interfaces/core/IComptroller.sol";
import {CErc20Delegate} from "../interfaces/core/ICErc20Delegate.sol";
import {ComptrollerInterface} from "../interfaces/core/IComptrollerInterface.sol";
import {InterestRateModel} from "../interfaces/core/IInterestRateModel.sol";
import {FusePoolDirectory} from "../interfaces/IFusePoolDirectory.sol";
import {MockPriceOracle} from "../interfaces/oracles/IMockPriceOracle.sol";

// Artifacts
string constant CErc20DelegateArtifact = "./artifacts/CErc20Delegate.sol/CErc20Delegate.json";
string constant ComptrollerArtifact = "./artifacts/Comptroller.sol/Comptroller.json";
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant WhitePaperInterestRateModelArtifact = "./artifacts/WhitePaperInterestRateModel.sol/WhitePaperInterestRateModel.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";

// Fixtures
import {FuseFixture} from "./FuseFixture.sol";

contract PoolFixture is FuseFixture {
    MockERC20 internal underlyingToken;
    CErc20 internal cErc20;
    CToken internal cToken;
    CErc20Delegate internal cErc20Delegate;

    Comptroller internal comptroller;
    WhitePaperInterestRateModel internal interestModel;

    FusePoolDirectory internal fusePoolDirectory;

    address[] internal markets;
    address[] internal emptyAddresses;
    address[] internal newUnitroller;
    bool[] internal falseBoolArray;
    bool[] internal trueBoolArray;
    address[] internal newImplementation;

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(fuseAdminAddress);

        setUpBaseContracts();
        setUpPoolAndMarket();

        vm.stopPrank();
    }

    function setUpBaseContracts() public {
        underlyingToken = new MockERC20("UnderlyingToken", "UT", 18);
        interestModel = WhitePaperInterestRateModel(
            deployCode(
                WhitePaperInterestRateModelArtifact,
                abi.encode(1e18, 1e18)
            )
        );
        fusePoolDirectory = FusePoolDirectory(
            deployCode(FusePoolDirectoryArtifact)
        );
        fusePoolDirectory.initialize(false, emptyAddresses);
        cErc20Delegate = CErc20Delegate(deployCode(CErc20DelegateArtifact));
    }

    function setUpPoolAndMarket() public {
        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );

        emptyAddresses.push(address(0));

        Comptroller tempComptroller = Comptroller(
            deployCode(ComptrollerArtifact)
        );
        newUnitroller.push(address(comptroller));
        trueBoolArray.push(true);
        falseBoolArray.push(false);

        vm.stopPrank();
        vm.startPrank(multisigAddress);

        fuseAdmin._editComptrollerImplementationWhitelist(
            emptyAddresses,
            newUnitroller,
            trueBoolArray
        );

        vm.stopPrank();
        vm.startPrank(fuseAdminAddress);

        (, address unitrollerAddress) = fusePoolDirectory.deployPool(
            "TestPool",
            address(tempComptroller),
            false,
            0.1e18,
            1.1e18,
            address(priceOracle)
        );

        Unitroller(payable(unitrollerAddress))._acceptAdmin();
        comptroller = Comptroller(unitrollerAddress);

        newImplementation.push(address(cErc20Delegate));

        vm.stopPrank();
        vm.startPrank(multisigAddress);

        fuseAdmin._editCErc20DelegateWhitelist(
            emptyAddresses,
            newImplementation,
            falseBoolArray,
            trueBoolArray
        );

        vm.stopPrank();
        vm.startPrank(fuseAdminAddress);

        vm.roll(1);
        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                ComptrollerInterface(comptrollerAddress),
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

        address[] memory allMarkets = comptroller.getAllMarkets();
        cErc20 = CErc20(address(allMarkets[allMarkets.length - 1]));
        cToken = CToken(address(cErc20));
        markets = [address(cErc20)];
    }
}
