// Vendor
import { Contract, providers } from "ethers";

// Fuse
import { getAddresses } from "./addresses";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/network";

// ABI Core
import BaseJumpRateModelV2ABI from "../../abi/core/BaseJumpRateModelV2.json";
import CarefulMathABI from "../../abi/core/CarefulMath.json";
import CDaiDelegateABI from "../../abi/core/CDaiDelegate.json";
import CErc20ABI from "../../abi/core/CErc20.json";
import CErc20DelegateABI from "../../abi/core/CErc20Delegate.json";
import CErc20DelegatorABI from "../../abi/core/CErc20Delegator.json";
import CErc20PluginDelegateABI from "../../abi/core/CErc20PluginDelegate.json";
import CErc20PluginRewardsDelegateABI from "../../abi/core/CErc20PluginRewardsDelegate.json";
import CErc20RewardsDelegateABI from "../../abi/core/CErc20RewardsDelegate.json";
import CEtherABI from "../../abi/core/CEther.json";
import CEtherDelegateABI from "../../abi/core/CEtherDelegate.json";
import CEtherDelegatorABI from "../../abi/core/CEtherDelegator.json";
import ComptrollerABI from "../../abi/core/Comptroller.json";
import ComptrollerG1ABI from "../../abi/core/ComptrollerG1.json";
import ComptrollerInterfaceABI from "../../abi/core/ComptrollerInterface.json";
// import ComptrollerStorageABI from "../../../abi/core/ComptrollerStorage.json";
import CTokenABI from "../../abi/core/CToken.json";
// import CTokenInterfacesABI from "../../../abi/core/CTokenInterfaces.json";
import DAIInterestRateModelV2ABI from "../../abi/core/DAIInterestRateModelV2.json";
import EIP20InterfaceABI from "../../abi/core/EIP20Interface.json";
import EIP20NonStandardInterfaceABI from "../../abi/core/EIP20NonStandardInterface.json";
// import ErrorReporterABI from "../../../abi/core/ErrorReporter.json";
import ExponentialABI from "../../abi/core/Exponential.json";
import ExponentialNoErrorABI from "../../abi/core/ExponentialNoError.json";
import IERC4626ABI from "../../abi/core/IERC4626.json";
import IFuseFeeDistributorABI from "../../abi/core/IFuseFeeDistributor.json";
import InterestRateModelABI from "../../abi/core/InterestRateModel.json";
import JumpRateModelABI from "../../abi/core/JumpRateModel.json";
import JumpRateModelV2ABI from "../../abi/core/JumpRateModelV2.json";
import MaximillionABI from "../../abi/core/Maximillion.json";
import PriceOracleABI from "../../abi/core/PriceOracle.json";
import ReactiveJumpRateModelV2ABI from "../../abi/core/ReactiveJumpRateModelV2.json";
import ReservoirABI from "../../abi/core/Reservoir.json";
import RewardsDistributorDelegateABI from "../../abi/core/RewardsDistributorDelegate.json";
import RewardsDistributorDelegatorABI from "../../abi/core/RewardsDistributorDelegator.json";
// import RewardsDistributorStorageABI from "../../../abi/core/RewardsDistributorStorage.json";
import SafeMathABI from "../../abi/core/SafeMath.json";
import SimplePriceOracleABI from "../../abi/core/SimplePriceOracle.json";
import TimelockABI from "../../abi/core/Timelock.json";
import UnitrollerABI from "../../abi/core/Unitroller.json";
import WhitePaperInterestRateModelABI from "../../abi/core/WhitePaperInterestRateModel.json";

// ABI Liquidators
import AlphaHomoraV1BankLiquidatorABI from "../../abi/liquidators/AlphaHomoraV1BankLiquidator.json";
import AlphaHomoraV2SafeBoxETHLiquidatorABI from "../../abi/liquidators/AlphaHomoraV2SafeBoxETHLiquidator.json";
import AlphaHomoraV2SafeBoxLiquidatorABI from "../../abi/liquidators/AlphaHomoraV2SafeBoxLiquidator.json";
import BadgerSettLiquidatorABI from "../../abi/liquidators/BadgerSettLiquidator.json";
import BadgerSettLiquidatorEnclaveABI from "../../abi/liquidators/BadgerSettLiquidatorEnclave.json";
import CErc20LiquidatorABI from "../../abi/liquidators/CErc20Liquidator.json";
import CEtherLiquidatorABI from "../../abi/liquidators/CEtherLiquidator.json";
import CurveLiquidityGaugeV2LiquidatorABI from "../../abi/liquidators/CurveLiquidityGaugeV2Liquidator.json";
import CurveLpTokenLiquidatorABI from "../../abi/liquidators/CurveLpTokenLiquidator.json";
// import CurveMetapoolLpTokenLiquidatorABI from "../../../abi/liquidators/CurveMetapoolLpTokenLiquidator.json";
import CurveSwapLiquidatorABI from "../../abi/liquidators/CurveSwapLiquidator.json";
import CurveTriCryptoLpTokenLiquidatorABI from "../../abi/liquidators/CurveTriCryptoLpTokenLiquidator.json";
import CustomLiquidatorABI from "../../abi/liquidators/CustomLiquidator.json";
import DolaStabilizerLiquidatorABI from "../../abi/liquidators/DolaStabilizerLiquidator.json";
import ETHMAXYLiquidatorABI from "../../abi/liquidators/ETHMAXYLiquidator.json";
import EthRiseLiquidatorABI from "../../abi/liquidators/EthRiseLiquidator.json";
import GelatoGUniLiquidatorABI from "../../abi/liquidators/GelatoGUniLiquidator.json";
import GFloorLiquidatorABI from "../../abi/liquidators/GFloorLiquidator.json";
import GOhmLiquidatorABI from "../../abi/liquidators/GOhmLiquidator.json";
import HarvestLiquidatorABI from "../../abi/liquidators/HarvestLiquidator.json";
import IRedemptionStrategyABI from "../../abi/liquidators/IRedemptionStrategy.json";
import MStableLiquidatorABI from "../../abi/liquidators/MStableLiquidator.json";
import PoolTogetherLiquidatorABI from "../../abi/liquidators/PoolTogetherLiquidator.json";
import SOhmLiquidatorABI from "../../abi/liquidators/SOhmLiquidator.json";
import StakedFodlLiquidatorABI from "../../abi/liquidators/StakedFodlLiquidator.json";
import StakedSdtLiquidatorABI from "../../abi/liquidators/StakedSdtLiquidator.json";
import StakedSpellLiquidatorABI from "../../abi/liquidators/StakedSpellLiquidator.json";
import SushiBarLiquidatorABI from "../../abi/liquidators/SushiBarLiquidator.json";
import SynthetixSynthLiquidatorABI from "../../abi/liquidators/SynthetixSynthLiquidator.json";
import UniswapLpTokenLiquidatorABI from "../../abi/liquidators/UniswapLpTokenLiquidator.json";
import UniswapV1LiquidatorABI from "../../abi/liquidators/UniswapV1Liquidator.json";
import UniswapV2LiquidatorABI from "../../abi/liquidators/UniswapV2Liquidator.json";
import UniswapV3LiquidatorABI from "../../abi/liquidators/UniswapV3Liquidator.json";
import WSTEthLiquidatorABI from "../../abi/liquidators/WSTEthLiquidator.json";
import XVaultLiquidatorABI from "../../abi/liquidators/XVaultLiquidator.json";
import YearnYVaultV1LiquidatorABI from "../../abi/liquidators/YearnYVaultV1Liquidator.json";
import YearnYVaultV2LiquidatorABI from "../../abi/liquidators/YearnYVaultV2Liquidator.json";

// ABI Oracles
import AlphaHomoraV1PriceOracleABI from "../../abi/oracles/AlphaHomoraV1PriceOracle.json";
import AlphaHomoraV2PriceOracleABI from "../../abi/oracles/AlphaHomoraV2PriceOracle.json";
import BadgerPriceOracleABI from "../../abi/oracles/BadgerPriceOracle.json";
import BalancerLpTokenPriceOracleABI from "../../abi/oracles/BalancerLpTokenPriceOracle.json";
import BalancerStableLpTokenPriceOracleABI from "../../abi/oracles/BalancerStableLpTokenPriceOracle.json";
import BalancerV2TwapPriceOracleABI from "../../abi/oracles/BalancerV2TwapPriceOracle.json";
import BasePriceOracleABI from "../../abi/oracles/BasePriceOracle.json";
import ChainlinkPriceOracleABI from "../../abi/oracles/ChainlinkPriceOracle.json";
import ChainlinkPriceOracleV2ABI from "../../abi/oracles/ChainlinkPriceOracleV2.json";
import ChainlinkPriceOracleV3ABI from "../../abi/oracles/ChainlinkPriceOracleV3.json";
import CurveFactoryLpTokenPriceOracleABI from "../../abi/oracles/CurveFactoryLpTokenPriceOracle.json";
import CurveLiquidityGaugeV2PriceOracleABI from "../../abi/oracles/CurveLiquidityGaugeV2PriceOracle.json";
import CurveLpTokenPriceOracleABI from "../../abi/oracles/CurveLpTokenPriceOracle.json";
import CurveTriCryptoLpTokenPriceOracleABI from "../../abi/oracles/CurveTriCryptoLpTokenPriceOracle.json";
import CvxFXSPriceOracleABI from "../../abi/oracles/CvxFXSPriceOracle.json";
import ETHMAXYPriceOracleABI from "../../abi/oracles/ETHMAXYPriceOracle.json";
import FixedEthPriceOracleABI from "../../abi/oracles/FixedEthPriceOracle.json";
import FixedEurPriceOracleABI from "../../abi/oracles/FixedEurPriceOracle.json";
import FixedTokenPriceOracleABI from "../../abi/oracles/FixedTokenPriceOracle.json";
import FixedUsdPriceOracleABI from "../../abi/oracles/FixedUsdPriceOracle.json";
import GAlcxPriceOracleABI from "../../abi/oracles/GAlcxPriceOracle.json";
import GelatoGUniPriceOracleABI from "../../abi/oracles/GelatoGUniPriceOracle.json";
import GFloorPriceOracleABI from "../../abi/oracles/GFloorPriceOracle.json";
import GOhmPriceOracleABI from "../../abi/oracles/GOhmPriceOracle.json";
import HarvestPriceOracleABI from "../../abi/oracles/HarvestPriceOracle.json";
import Keep3rPriceOracleABI from "../../abi/oracles/Keep3rPriceOracle.json";
import Keep3rV2PriceOracleABI from "../../abi/oracles/Keep3rV2PriceOracle.json";
import MasterPriceOracleABI from "../../abi/oracles/MasterPriceOracle.json";
import MockPriceOracleABI from "../../abi/oracles/MockPriceOracle.json";
import MStablePriceOracleABI from "../../abi/oracles/MStablePriceOracle.json";
import PreferredPriceOracleABI from "../../abi/oracles/PreferredPriceOracle.json";
import RecursivePriceOracleABI from "../../abi/oracles/RecursivePriceOracle.json";
import REthPriceOracleABI from "../../abi/oracles/REthPriceOracle.json";
import RgtTempPriceOracleABI from "../../abi/oracles/RgtTempPriceOracle.json";
import SaddleLpTokenPriceOracleABI from "../../abi/oracles/SaddleLpTokenPriceOracle.json";
import StakedFodlPriceOracleABI from "../../abi/oracles/StakedFodlPriceOracle.json";
import StakedSdtPriceOracleABI from "../../abi/oracles/StakedSdtPriceOracle.json";
import StakedSpellPriceOracleABI from "../../abi/oracles/StakedSpellPriceOracle.json";
import SushiBarPriceOracleABI from "../../abi/oracles/SushiBarPriceOracle.json";
import SynthetixPriceOracleABI from "../../abi/oracles/SynthetixPriceOracle.json";
import TemplePriceOracleABI from "../../abi/oracles/TemplePriceOracle.json";
import TokemakPoolTAssetPriceOracleABI from "../../abi/oracles/TokemakPoolTAssetPriceOracle.json";
import UniswapLpTokenPriceOracleABI from "../../abi/oracles/UniswapLpTokenPriceOracle.json";
import UniswapTwapPriceOracleABI from "../../abi/oracles/UniswapTwapPriceOracle.json";
import UniswapTwapPriceOracleRootABI from "../../abi/oracles/UniswapTwapPriceOracleRoot.json";
import UniswapTwapPriceOracleV2ABI from "../../abi/oracles/UniswapTwapPriceOracleV2.json";
import UniswapTwapPriceOracleV2FactoryABI from "../../abi/oracles/UniswapTwapPriceOracleV2Factory.json";
import UniswapTwapPriceOracleV2RootABI from "../../abi/oracles/UniswapTwapPriceOracleV2Root.json";
import UniswapV3TwapPriceOracleABI from "../../abi/oracles/UniswapV3TwapPriceOracle.json";
import UniswapV3TwapPriceOracleV2ABI from "../../abi/oracles/UniswapV3TwapPriceOracleV2.json";
import UniswapV3TwapPriceOracleV2FactoryABI from "../../abi/oracles/UniswapV3TwapPriceOracleV2Factory.json";
import VoltPriceOracleABI from "../../abi/oracles/VoltPriceOracle.json";
import WSSquidPriceOracleABI from "../../abi/oracles/WSSquidPriceOracle.json";
import WSTEthPriceOracleABI from "../../abi/oracles/WSTEthPriceOracle.json";
import WXBtrflyPriceOracleABI from "../../abi/oracles/WXBtrflyPriceOracle.json";
import XVaultPriceOracleABI from "../../abi/oracles/XVaultPriceOracle.json";
import YVaultV1PriceOracleABI from "../../abi/oracles/YVaultV1PriceOracle.json";
import YVaultV2PriceOracleABI from "../../abi/oracles/YVaultV2PriceOracle.json";
import ZeroPriceOracleABI from "../../abi/oracles/ZeroPriceOracle.json";

// ABI Fuse
import FuseFeeDistributorABI from "../../abi/FuseFeeDistributor.json";
import FusePoolDirectoryABI from "../../abi/FusePoolDirectory.json";
import FusePoolLensABI from "../../abi/FusePoolLens.json";
import FusePoolLensSecondaryABI from "../../abi/FusePoolLensSecondary.json";
import FuseSafeLiquidatorABI from "../../abi/FuseSafeLiquidator.json";

export const getContracts = (
  provider: providers.JsonRpcProvider,
  chainId: ChainID
) => {
  if (!isSupportedChainId(chainId)) {
    throw new Error(`Unsupported chainid: ${chainId}`);
  }

  const abis = {
    // Core abis
    BaseJumpRateModelV2ABI,
    CarefulMathABI,
    CDaiDelegateABI,
    CErc20ABI,
    CErc20DelegateABI,
    CErc20DelegatorABI,
    CErc20PluginDelegateABI,
    CErc20PluginRewardsDelegateABI,
    CErc20RewardsDelegateABI,
    CEtherABI,
    CEtherDelegateABI,
    CEtherDelegatorABI,
    ComptrollerABI,
    ComptrollerG1ABI,
    ComptrollerInterfaceABI,
    // ComptrollerStorageABI,
    CTokenABI,
    // CTokenInterfacesABI,
    DAIInterestRateModelV2ABI,
    EIP20InterfaceABI,
    EIP20NonStandardInterfaceABI,
    // ErrorReporterABI,
    ExponentialABI,
    ExponentialNoErrorABI,
    IERC4626ABI,
    IFuseFeeDistributorABI,
    InterestRateModelABI,
    JumpRateModelABI,
    JumpRateModelV2ABI,
    MaximillionABI,
    PriceOracleABI,
    ReactiveJumpRateModelV2ABI,
    ReservoirABI,
    RewardsDistributorDelegateABI,
    RewardsDistributorDelegatorABI,
    // RewardsDistributorStorageABI,
    SafeMathABI,
    SimplePriceOracleABI,
    TimelockABI,
    UnitrollerABI,
    WhitePaperInterestRateModelABI,

    // Liquidator abis
    AlphaHomoraV1BankLiquidatorABI,
    AlphaHomoraV2SafeBoxETHLiquidatorABI,
    AlphaHomoraV2SafeBoxLiquidatorABI,
    BadgerSettLiquidatorABI,
    BadgerSettLiquidatorEnclaveABI,
    CErc20LiquidatorABI,
    CEtherLiquidatorABI,
    CurveLiquidityGaugeV2LiquidatorABI,
    CurveLpTokenLiquidatorABI,
    // CurveMetapoolLpTokenLiquidatorABI,
    CurveSwapLiquidatorABI,
    CurveTriCryptoLpTokenLiquidatorABI,
    CustomLiquidatorABI,
    DolaStabilizerLiquidatorABI,
    ETHMAXYLiquidatorABI,
    EthRiseLiquidatorABI,
    GelatoGUniLiquidatorABI,
    GFloorLiquidatorABI,
    GOhmLiquidatorABI,
    HarvestLiquidatorABI,
    IRedemptionStrategyABI,
    MStableLiquidatorABI,
    PoolTogetherLiquidatorABI,
    SOhmLiquidatorABI,
    StakedFodlLiquidatorABI,
    StakedSdtLiquidatorABI,
    StakedSpellLiquidatorABI,
    SushiBarLiquidatorABI,
    SynthetixSynthLiquidatorABI,
    UniswapLpTokenLiquidatorABI,
    UniswapV1LiquidatorABI,
    UniswapV2LiquidatorABI,
    UniswapV3LiquidatorABI,
    WSTEthLiquidatorABI,
    XVaultLiquidatorABI,
    YearnYVaultV1LiquidatorABI,
    YearnYVaultV2LiquidatorABI,

    // Oracle abis
    AlphaHomoraV1PriceOracleABI,
    AlphaHomoraV2PriceOracleABI,
    BadgerPriceOracleABI,
    BalancerLpTokenPriceOracleABI,
    BalancerStableLpTokenPriceOracleABI,
    BalancerV2TwapPriceOracleABI,
    BasePriceOracleABI,
    ChainlinkPriceOracleABI,
    ChainlinkPriceOracleV2ABI,
    ChainlinkPriceOracleV3ABI,
    CurveFactoryLpTokenPriceOracleABI,
    CurveLiquidityGaugeV2PriceOracleABI,
    CurveLpTokenPriceOracleABI,
    CurveTriCryptoLpTokenPriceOracleABI,
    CvxFXSPriceOracleABI,
    ETHMAXYPriceOracleABI,
    FixedEthPriceOracleABI,
    FixedEurPriceOracleABI,
    FixedTokenPriceOracleABI,
    FixedUsdPriceOracleABI,
    GAlcxPriceOracleABI,
    GelatoGUniPriceOracleABI,
    GFloorPriceOracleABI,
    GOhmPriceOracleABI,
    HarvestPriceOracleABI,
    Keep3rPriceOracleABI,
    Keep3rV2PriceOracleABI,
    MasterPriceOracleABI,
    MockPriceOracleABI,
    MStablePriceOracleABI,
    PreferredPriceOracleABI,
    RecursivePriceOracleABI,
    REthPriceOracleABI,
    RgtTempPriceOracleABI,
    SaddleLpTokenPriceOracleABI,
    StakedFodlPriceOracleABI,
    StakedSdtPriceOracleABI,
    StakedSpellPriceOracleABI,
    SushiBarPriceOracleABI,
    SynthetixPriceOracleABI,
    TemplePriceOracleABI,
    TokemakPoolTAssetPriceOracleABI,
    UniswapLpTokenPriceOracleABI,
    UniswapTwapPriceOracleABI,
    UniswapTwapPriceOracleRootABI,
    UniswapTwapPriceOracleV2ABI,
    UniswapTwapPriceOracleV2FactoryABI,
    UniswapTwapPriceOracleV2RootABI,
    UniswapV3TwapPriceOracleABI,
    UniswapV3TwapPriceOracleV2ABI,
    UniswapV3TwapPriceOracleV2FactoryABI,
    VoltPriceOracleABI,
    WSSquidPriceOracleABI,
    WSTEthPriceOracleABI,
    WXBtrflyPriceOracleABI,
    XVaultPriceOracleABI,
    YVaultV1PriceOracleABI,
    YVaultV2PriceOracleABI,
    ZeroPriceOracleABI,

    // Fuse abis
    FuseFeeDistributorABI,
    FusePoolDirectoryABI,
    FusePoolLensABI,
    FusePoolLensSecondaryABI,
    FuseSafeLiquidatorABI,
  };

  const addresses = getAddresses(chainId);

  const contracts = {
    // Core contracts

    // Oracle contracts

    // Liquidator contracts

    // Fuse contracts
    FusePoolDirectory: new Contract(
      addresses.FUSE_POOL_DIRECTORY_CONTRACT_ADDRESS,
      FusePoolDirectoryABI,
      provider
    ),
  };

  return {
    abis,
    addresses,
    contracts,
  };
};
