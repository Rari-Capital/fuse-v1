pragma solidity 0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

// Interfaces
import {ICErc20} from "../interfaces/core/ICErc20.sol";
import {ICToken} from "../interfaces/core/ICToken.sol";
import {IWhitePaperInterestRateModel} from "../interfaces/core/IWhitePaperInterestRateModel.sol";
import {IUnitroller} from "../interfaces/core/IUnitroller.sol";
import {IComptroller} from "../interfaces/core/IComptroller.sol";
import {ICErc20Delegate} from "../interfaces/core/ICErc20Delegate.sol";
import {ICErc20Delegator} from "../interfaces/core/ICErc20Delegator.sol";
import {IRewardsDistributorDelegate} from "../interfaces/core/IRewardsDistributorDelegate.sol";
import {IRewardsDistributorDelegator} from "../interfaces/core/IRewardsDistributorDelegator.sol";
import {IComptrollerInterface} from "../interfaces/core/IComptrollerInterface.sol";
import {IInterestRateModel} from "../interfaces/core/IInterestRateModel.sol";
import {IFuseFeeDistributor} from "../interfaces/IFuseFeeDistributor.sol";
import {IFusePoolDirectory} from "../interfaces/IFusePoolDirectory.sol";

// Mocks
import {IMockPriceOracle} from "../mocks/IMockPriceOracle.sol";

// Reference https://github.com/Midas-Protocol/contracts/blob/development/contracts/test/DeployMarkets.t.sol

contract DeployMarketsTest is Test {
    MockERC20 internal underlyingToken;
    MockERC20 internal rewardToken;

    IWhitePaperInterestRateModel internal interestModel;
    IComptroller internal comptroller;

    ICErc20Delegate internal cErc20Delegate;

    ICErc20 internal cErc20;
    IFuseFeeDistributor internal fuseAdmin;
    IFusePoolDirectory internal fusePoolDirectory;

    address user = address(this);

    uint256 depositAmount = 1 ether;

    address[] internal emptyAddresses;
    address[] internal oldCErc20Implementations;
    address[] internal newCErc20Implementations;

    function setUpBaseContracts() public {
        underlyingToken = new MockERC20("UnderlyingToken", "UT", 18);
        rewardToken = new MockERC20("RewardToken", "RT", 18);
        interestModel = IWhitePaperInterestRateModel(
            deployCode(
                "WhitePaperInterestRateModel.sol:WhitePaperInterestRateModel",
                abi.encode(2343665, 1e18, 1e18)
            )
        );
        fuseAdmin = IFuseFeeDistributor(
            deployCode("FuseFeeDistributor.sol:FuseFeeDistributor")
        );
        fuseAdmin.initialize(1e16);
        fusePoolDirectory = IFusePoolDirectory(
            deployCode("FusePoolDirectory.sol:FusePoolDirectory")
        );
        fusePoolDirectory.initialize(false, emptyAddresses);
    }

    function setUpWhiteList() public {
        cErc20Delegate = ICErc20Delegate(
            deployCode("CErc20Delegate.sol:CErc20Delegate")
        );

        oldCErc20Implementations.push(address(0));

        newCErc20Implementations.push(address(cErc20Delegate));

        bool[] memory allowResign = new bool[](2);
        allowResign[0] = false;
        allowResign[1] = false;

        bool[] memory statuses = new bool[](2);
        statuses[0] = true;
        statuses[1] = true;

        fuseAdmin._editCEtherDelegateWhitelist(
            oldCErc20Implementations,
            newCErc20Implementations,
            allowResign,
            statuses
        );
    }

    function setUpPool() public {
        underlyingToken.mint(address(this), 100e18);

        IMockPriceOracle priceOracle = IMockPriceOracle(
            deployCode("MockPriceOracle.sol:MockPriceOracle", abi.encode(10))
        );

        emptyAddresses.push(address(0));
    }

    function setUp() public {
        setUpBaseContracts();
        setUpPool();
        setUpWhiteList();
        vm.roll(1);
    }
}
