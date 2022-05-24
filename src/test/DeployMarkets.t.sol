pragma solidity ^0.8.10;

// Vendor
import "forge-std/Test.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {Auth, Authority} from "solmate/auth/Auth.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {FuseFlywheelDynamicRewards} from "fuse-flywheel/rewards/FuseFlywheelDynamicRewards.sol";
import {FuseFlywheelLensRouter, CToken as ICToken} from "fuse-flywheel/FuseFlywheelLensRouter.sol";
import "fuse-flywheel/FuseFlywheelCore.sol";

// Test utilities
import {Constants} from "./helpers/Constants.sol";

// Interfaces
import {CErc20} from "./interfaces/core/ICErc20.sol";
import {CToken} from "./interfaces/core/ICToken.sol";
import {WhitePaperInterestRateModel} from "./interfaces/core/IWhitePaperInterestRateModel.sol";
import {Unitroller} from "./interfaces/core/IUnitroller.sol";
import {Comptroller} from "./interfaces/core/IComptroller.sol";
import {CErc20Delegate} from "./interfaces/core/ICErc20Delegate.sol";
import {CErc20PluginDelegate} from "./interfaces/core/ICErc20PluginDelegate.sol";
import {CErc20PluginRewardsDelegate} from "./interfaces/core/ICErc20PluginRewardsDelegate.sol";
import {CErc20Delegator} from "./interfaces/core/ICErc20Delegator.sol";
import {RewardsDistributorDelegate} from "./interfaces/core/IRewardsDistributorDelegate.sol";
import {RewardsDistributorDelegator} from "./interfaces/core/IRewardsDistributorDelegator.sol";
import {ComptrollerInterface} from "./interfaces/core/IComptrollerInterface.sol";
import {InterestRateModel} from "./interfaces/core/IInterestRateModel.sol";
import {FuseFeeDistributor} from "./interfaces/IFuseFeeDistributor.sol";
import {FusePoolDirectory} from "./interfaces/IFusePoolDirectory.sol";

// Mocks
import {MockPriceOracle} from "./interfaces/oracles/IMockPriceOracle.sol";
import {MockERC4626} from "./mocks/MockERC4626.sol";
import {MockERC4626Dynamic} from "./mocks/MockERC4626Dynamic.sol";

// Artifacts
string constant WhitePaperInterestRateModelArtifact = "./artifacts/WhitePaperInterestRateModel.sol/WhitePaperInterestRateModel.json";
string constant UnitrollerArtifact = "./artifacts/Unitroller.sol/Unitroller.json";
string constant ComptrollerArtifact = "./artifacts/Comptroller.sol/Comptroller.json";
string constant CErc20DelegateArtifact = "./artifacts/CErc20Delegate.sol/CErc20Delegate.json";
string constant CErc20PluginDelegateArtifact = "./artifacts/CErc20PluginDelegate.sol/CErc20PluginDelegate.json";
string constant CErc20PluginRewardsDelegateArtifact = "./artifacts/CErc20PluginRewardsDelegate.sol/CErc20PluginRewardsDelegate.json";
string constant CErc20DelegatorArtifact = "./artifacts/CErc20Delegator.sol/CErc20Delegator.json";
string constant RewardsDistributorDelegateArtifact = "./artifacts/RewardsDistributorDelegate.sol/RewardsDistributorDelegate.json";
string constant RewardsDistributorDelegatorArtifact = "./artifacts/RewardsDistributorDelegator.sol/RewardsDistributorDelegator.json";
string constant ComptrollerInterfaceArtifact = "./artifacts/ComptrollerInterface.sol/ComptrollerInterface.json";
string constant InterestRateModelArtifact = "./artifacts/InterestRateModel.sol/InterestRateModel.json";
string constant FuseFeeDistributorArtifact = "./artifacts/FuseFeeDistributor.sol/FuseFeeDistributor.json";
string constant FusePoolDirectoryArtifact = "./artifacts/FusePoolDirectory.sol/FusePoolDirectory.json";
string constant MockPriceOracleArtifact = "./artifacts/MockPriceOracle.sol/MockPriceOracle.json";

contract DeployMarketsTest is Test {
    MockERC20 internal underlyingToken;
    MockERC20 internal rewardToken;

    WhitePaperInterestRateModel internal interestModel;
    Comptroller internal comptroller;

    CErc20Delegate internal cErc20Delegate;
    CErc20PluginDelegate internal cErc20PluginDelegate;
    CErc20PluginRewardsDelegate internal cErc20PluginRewardsDelegate;

    MockERC4626 internal mockERC4626;
    MockERC4626Dynamic internal mockERC4626Dynamic;

    CErc20 internal cErc20;
    FuseFeeDistributor internal fuseAdmin;
    FusePoolDirectory internal fusePoolDirectory;

    FuseFlywheelCore internal flywheel;
    FuseFlywheelDynamicRewards internal rewards;

    ERC20 internal marketKey;

    address internal user = address(this);

    uint256 internal depositAmount = 1 ether;

    address[] internal markets;
    address[] internal emptyAddresses;
    address[] internal newUnitroller;
    bool[] internal falseBoolArray;
    bool[] internal trueBoolArray;
    address[] internal newImplementation;
    bool[] internal t;
    bool[] internal f;
    address[] internal oldCErC20Implementations;
    address[] internal newCErc20Implementations;
    FuseFlywheelCore[] internal flywheelsToClaim;

    function setUp() public {
        vm.startPrank(Constants.fuseAdminAddress);

        underlyingToken = new MockERC20("UnderlyingToken", "UT", 18);
        rewardToken = new MockERC20("RewardToken", "RT", 18);
        interestModel = WhitePaperInterestRateModel(
            deployCode(
                WhitePaperInterestRateModelArtifact,
                abi.encode(1e18, 1e18)
            )
        );
        fuseAdmin = FuseFeeDistributor(Constants.fuseAdminAddress);
        fusePoolDirectory = FusePoolDirectory(
            deployCode(FusePoolDirectoryArtifact)
        );
        fusePoolDirectory.initialize(false, emptyAddresses);

        underlyingToken.mint(address(this), 100e18);

        MockPriceOracle priceOracle = MockPriceOracle(
            deployCode(MockPriceOracleArtifact, abi.encode(10))
        );
        emptyAddresses.push(address(0));

        Comptroller tempComptroller = Comptroller(
            deployCode(
                ComptrollerArtifact,
                abi.encode(payable(address(fuseAdmin)))
            )
        );
        newUnitroller.push(address(tempComptroller));
        trueBoolArray.push(true);
        falseBoolArray.push(false);

        vm.stopPrank();
        vm.startPrank(Constants.multisigAddress);

        fuseAdmin._editComptrollerImplementationWhitelist(
            emptyAddresses,
            newUnitroller,
            trueBoolArray
        );

        vm.stopPrank();
        vm.startPrank(Constants.fuseAdminAddress);

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

        cErc20PluginDelegate = CErc20PluginDelegate(
            deployCode(CErc20PluginDelegateArtifact)
        );
        cErc20PluginRewardsDelegate = CErc20PluginRewardsDelegate(
            deployCode(CErc20PluginRewardsDelegateArtifact)
        );
        cErc20Delegate = CErc20Delegate(deployCode(CErc20DelegateArtifact));

        for (uint256 i = 0; i < 7; i++) {
            t.push(true);
            f.push(false);
        }

        oldCErC20Implementations.push(address(0));
        oldCErC20Implementations.push(address(0));
        oldCErC20Implementations.push(address(0));
        oldCErC20Implementations.push(address(cErc20Delegate));
        oldCErC20Implementations.push(address(cErc20Delegate));
        oldCErC20Implementations.push(address(cErc20PluginDelegate));
        oldCErC20Implementations.push(address(cErc20PluginRewardsDelegate));

        newCErc20Implementations.push(address(cErc20Delegate));
        newCErc20Implementations.push(address(cErc20PluginDelegate));
        newCErc20Implementations.push(address(cErc20PluginRewardsDelegate));
        newCErc20Implementations.push(address(cErc20PluginDelegate));
        newCErc20Implementations.push(address(cErc20PluginRewardsDelegate));
        newCErc20Implementations.push(address(cErc20PluginDelegate));
        newCErc20Implementations.push(address(cErc20PluginRewardsDelegate));

        fuseAdmin._editCErc20DelegateWhitelist(
            oldCErC20Implementations,
            newCErc20Implementations,
            f,
            t
        );

        vm.stopPrank();
    }

    function testDeployCErc20Delegate() public {
        vm.roll(1);
        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                ComptrollerInterface(address(comptroller)),
                payable(address(fuseAdmin)),
                InterestRateModel(address(interestModel)),
                "cUnderlyingToken",
                "CUT",
                address(cErc20Delegate),
                "",
                uint256(1),
                uint256(0)
            ),
            0.9e18
        );

        address[] memory allMarkets = comptroller.getAllMarkets();
        CErc20Delegate cToken = CErc20Delegate(
            address(allMarkets[allMarkets.length - 1])
        );
        assertEq(cToken.name(), "cUnderlyingToken");
        underlyingToken.approve(address(cToken), 1e36);
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        comptroller.enterMarkets(cTokens);
        vm.roll(1);
        cToken.mint(10e18);
        assertEq(cToken.totalSupply(), 10e18 * 5);
        assertEq(underlyingToken.balanceOf(address(cToken)), 10e18);
        vm.roll(1);

        cToken.borrow(1000);
        assertEq(cToken.totalBorrows(), 1000);
        assertEq(
            underlyingToken.balanceOf(address(this)),
            100e18 - 10e18 + 1000
        );
    }

    function testDeployCErc20PluginDelegate() public {
        mockERC4626 = new MockERC4626(ERC20(address(underlyingToken)));

        vm.roll(1);
        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                ComptrollerInterface(address(comptroller)),
                payable(address(fuseAdmin)),
                InterestRateModel(address(interestModel)),
                "cUnderlyingToken",
                "CUT",
                address(cErc20Delegate),
                abi.encode(address(mockERC4626)),
                uint256(1),
                uint256(0)
            ),
            0.9e18
        );

        address[] memory allMarkets = comptroller.getAllMarkets();
        CErc20PluginDelegate cToken = CErc20PluginDelegate(
            address(allMarkets[allMarkets.length - 1])
        );

        cToken._setImplementationSafe(
            address(cErc20PluginDelegate),
            false,
            abi.encode(address(mockERC4626))
        );
        assertEq(address(cToken.plugin()), address(mockERC4626));

        underlyingToken.approve(address(cToken), 1e36);
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        comptroller.enterMarkets(cTokens);
        vm.roll(1);

        cToken.mint(10e18);
        assertEq(cToken.totalSupply(), 10e18 * 5);
        assertEq(mockERC4626.balanceOf(address(cToken)), 10e18);
        assertEq(underlyingToken.balanceOf(address(mockERC4626)), 10e18);
        vm.roll(1);

        cToken.borrow(1000);
        assertEq(cToken.totalBorrows(), 1000);
        assertEq(underlyingToken.balanceOf(address(mockERC4626)), 10e18 - 1000);
        assertEq(mockERC4626.balanceOf(address(cToken)), 10e18 - 1000);
        assertEq(
            underlyingToken.balanceOf(address(this)),
            100e18 - 10e18 + 1000
        );
    }

    function testDeployCErc20PluginRewardsDelegate() public {
        flywheel = new FuseFlywheelCore(
            underlyingToken,
            IFlywheelRewards(address(0)),
            IFlywheelBooster(address(0)),
            address(this),
            Authority(address(0))
        );
        rewards = new FuseFlywheelDynamicRewards(flywheel, 1);
        flywheel.setFlywheelRewards(rewards);

        mockERC4626Dynamic = new MockERC4626Dynamic(
            ERC20(address(underlyingToken)),
            FlywheelCore(address(flywheel))
        );

        marketKey = ERC20(address(mockERC4626Dynamic));
        flywheel.addStrategyForRewards(marketKey);

        vm.roll(1);
        comptroller._deployMarket(
            false,
            abi.encode(
                address(underlyingToken),
                ComptrollerInterface(address(comptroller)),
                payable(address(fuseAdmin)),
                InterestRateModel(address(interestModel)),
                "cUnderlyingToken",
                "CUT",
                address(cErc20Delegate),
                abi.encode(
                    address(mockERC4626Dynamic),
                    address(flywheel),
                    address(underlyingToken)
                ),
                uint256(1),
                uint256(0)
            ),
            0.9e18
        );

        address[] memory allMarkets = comptroller.getAllMarkets();
        CErc20PluginRewardsDelegate cToken = CErc20PluginRewardsDelegate(
            address(allMarkets[allMarkets.length - 1])
        );

        cToken._setImplementationSafe(
            address(cErc20PluginRewardsDelegate),
            false,
            abi.encode(
                address(mockERC4626Dynamic),
                address(flywheel),
                address(underlyingToken)
            )
        );
        assertEq(address(cToken.plugin()), address(mockERC4626Dynamic));
        assertEq(
            underlyingToken.allowance(address(cToken), address(flywheel)),
            type(uint256).max
        );

        underlyingToken.approve(address(cToken), 1e36);
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        comptroller.enterMarkets(cTokens);
        vm.roll(1);

        cToken.mint(10000000);
        assertEq(cToken.totalSupply(), 10000000 * 5);
        assertEq(mockERC4626Dynamic.balanceOf(address(cToken)), 10000000);
        assertEq(
            underlyingToken.balanceOf(address(mockERC4626Dynamic)),
            10000000
        );
        vm.roll(1);

        cToken.borrow(1000);
        assertEq(cToken.totalBorrows(), 1000);
        assertEq(
            underlyingToken.balanceOf(address(mockERC4626Dynamic)),
            10000000 - 1000
        );
        assertEq(
            mockERC4626Dynamic.balanceOf(address(cToken)),
            10000000 - 1000
        );
        assertEq(
            underlyingToken.balanceOf(address(this)),
            100e18 - 10000000 + 1000
        );
    }
}
