// Vendor
import { Contract, providers } from "ethers";

// Fuse
import { getAddresses } from "./addresses";

// Utilities
import { ChainID, isSupportedChainId } from "../utilities/network";

// ABI Core
import BaseJumpRateModelV2ABI from "../../abi/src/core/BaseJumpRateModelV2.json";
// import CarefulMathABI from "../../abi/src/core/CarefulMath.json"; // Empty ABI
import CDaiDelegateABI from "../../abi/src/core/CDaiDelegate.json";
import CErc20ABI from "../../abi/src/core/CErc20.json";
import CErc20DelegateABI from "../../abi/src/core/CErc20Delegate.json";
import CErc20DelegatorABI from "../../abi/src/core/CErc20Delegator.json";
import CErc20PluginDelegateABI from "../../abi/src/core/CErc20PluginDelegate.json";
import CErc20PluginRewardsDelegateABI from "../../abi/src/core/CErc20PluginRewardsDelegate.json";
import CErc20RewardsDelegateABI from "../../abi/src/core/CErc20RewardsDelegate.json";
import CEtherABI from "../../abi/src/core/CEther.json";
import CEtherDelegateABI from "../../abi/src/core/CEtherDelegate.json";
import CEtherDelegatorABI from "../../abi/src/core/CEtherDelegator.json";
import ComptrollerABI from "../../abi/src/core/Comptroller.json";
import ComptrollerG1ABI from "../../abi/src/core/ComptrollerG1.json";
import ComptrollerInterfaceABI from "../../abi/src/core/ComptrollerInterface.json";
// import ComptrollerStorageABI from "../../../abi/src/core/ComptrollerStorage.json";
import CTokenABI from "../../abi/src/core/CToken.json";
// import CTokenInterfacesABI from "../../../abi/src/core/CTokenInterfaces.json";
import DAIInterestRateModelV2ABI from "../../abi/src/core/DAIInterestRateModelV2.json";
import EIP20InterfaceABI from "../../abi/src/core/EIP20Interface.json";
import EIP20NonStandardInterfaceABI from "../../abi/src/core/EIP20NonStandardInterface.json";
// import ErrorReporterABI from "../../../abi/src/core/ErrorReporter.json";
// import ExponentialABI from "../../abi/src/core/Exponential.json"; // Empty ABI
// import ExponentialNoErrorABI from "../../abi/src/core/ExponentialNoError.json"; // Empty ABI
import IERC4626ABI from "../../abi/src/core/IERC4626.json";
import IFuseFeeDistributorABI from "../../abi/src/core/IFuseFeeDistributor.json";
import InterestRateModelABI from "../../abi/src/core/InterestRateModel.json";
import JumpRateModelABI from "../../abi/src/core/JumpRateModel.json";
import JumpRateModelV2ABI from "../../abi/src/core/JumpRateModelV2.json";
import MaximillionABI from "../../abi/src/core/Maximillion.json";
import PriceOracleABI from "../../abi/src/core/PriceOracle.json";
import ReactiveJumpRateModelV2ABI from "../../abi/src/core/ReactiveJumpRateModelV2.json";
import ReservoirABI from "../../abi/src/core/Reservoir.json";
import RewardsDistributorDelegateABI from "../../abi/src/core/RewardsDistributorDelegate.json";
import RewardsDistributorDelegatorABI from "../../abi/src/core/RewardsDistributorDelegator.json";
// import RewardsDistributorStorageABI from "../../../abi/src/core/RewardsDistributorStorage.json";
// import SafeMathABI from "../../abi/src/core/SafeMath.json"; // Empty ABI
import SimplePriceOracleABI from "../../abi/src/core/SimplePriceOracle.json";
import TimelockABI from "../../abi/src/core/Timelock.json";
import UnitrollerABI from "../../abi/src/core/Unitroller.json";
import WhitePaperInterestRateModelABI from "../../abi/src/core/WhitePaperInterestRateModel.json";

// ABI Liquidators
import AlphaHomoraV1BankLiquidatorABI from "../../abi/src/liquidators/AlphaHomoraV1BankLiquidator.json";
import AlphaHomoraV2SafeBoxETHLiquidatorABI from "../../abi/src/liquidators/AlphaHomoraV2SafeBoxETHLiquidator.json";
import AlphaHomoraV2SafeBoxLiquidatorABI from "../../abi/src/liquidators/AlphaHomoraV2SafeBoxLiquidator.json";
import BadgerSettLiquidatorABI from "../../abi/src/liquidators/BadgerSettLiquidator.json";
import BadgerSettLiquidatorEnclaveABI from "../../abi/src/liquidators/BadgerSettLiquidatorEnclave.json";
import CErc20LiquidatorABI from "../../abi/src/liquidators/CErc20Liquidator.json";
import CEtherLiquidatorABI from "../../abi/src/liquidators/CEtherLiquidator.json";
import CurveLiquidityGaugeV2LiquidatorABI from "../../abi/src/liquidators/CurveLiquidityGaugeV2Liquidator.json";
import CurveLpTokenLiquidatorABI from "../../abi/src/liquidators/CurveLpTokenLiquidator.json";
// import CurveMetapoolLpTokenLiquidatorABI from "../../../abi/src/liquidators/CurveMetapoolLpTokenLiquidator.json";
import CurveSwapLiquidatorABI from "../../abi/src/liquidators/CurveSwapLiquidator.json";
import CurveTriCryptoLpTokenLiquidatorABI from "../../abi/src/liquidators/CurveTriCryptoLpTokenLiquidator.json";
import CustomLiquidatorABI from "../../abi/src/liquidators/CustomLiquidator.json";
import DolaStabilizerLiquidatorABI from "../../abi/src/liquidators/DolaStabilizerLiquidator.json";
import ETHMAXYLiquidatorABI from "../../abi/src/liquidators/ETHMAXYLiquidator.json";
import EthRiseLiquidatorABI from "../../abi/src/liquidators/EthRiseLiquidator.json";
import GelatoGUniLiquidatorABI from "../../abi/src/liquidators/GelatoGUniLiquidator.json";
import GFloorLiquidatorABI from "../../abi/src/liquidators/GFloorLiquidator.json";
import GOhmLiquidatorABI from "../../abi/src/liquidators/GOhmLiquidator.json";
import HarvestLiquidatorABI from "../../abi/src/liquidators/HarvestLiquidator.json";
import IRedemptionStrategyABI from "../../abi/src/liquidators/IRedemptionStrategy.json";
import MStableLiquidatorABI from "../../abi/src/liquidators/MStableLiquidator.json";
import PoolTogetherLiquidatorABI from "../../abi/src/liquidators/PoolTogetherLiquidator.json";
import SOhmLiquidatorABI from "../../abi/src/liquidators/SOhmLiquidator.json";
import StakedFodlLiquidatorABI from "../../abi/src/liquidators/StakedFodlLiquidator.json";
import StakedSdtLiquidatorABI from "../../abi/src/liquidators/StakedSdtLiquidator.json";
import StakedSpellLiquidatorABI from "../../abi/src/liquidators/StakedSpellLiquidator.json";
import SushiBarLiquidatorABI from "../../abi/src/liquidators/SushiBarLiquidator.json";
import SynthetixSynthLiquidatorABI from "../../abi/src/liquidators/SynthetixSynthLiquidator.json";
import UniswapLpTokenLiquidatorABI from "../../abi/src/liquidators/UniswapLpTokenLiquidator.json";
import UniswapV1LiquidatorABI from "../../abi/src/liquidators/UniswapV1Liquidator.json";
import UniswapV2LiquidatorABI from "../../abi/src/liquidators/UniswapV2Liquidator.json";
import UniswapV3LiquidatorABI from "../../abi/src/liquidators/UniswapV3Liquidator.json";
import WSTEthLiquidatorABI from "../../abi/src/liquidators/WSTEthLiquidator.json";
import XVaultLiquidatorABI from "../../abi/src/liquidators/XVaultLiquidator.json";
import YearnYVaultV1LiquidatorABI from "../../abi/src/liquidators/YearnYVaultV1Liquidator.json";
import YearnYVaultV2LiquidatorABI from "../../abi/src/liquidators/YearnYVaultV2Liquidator.json";

// ABI Oracles
import AlphaHomoraV1PriceOracleABI from "../../abi/src/oracles/AlphaHomoraV1PriceOracle.json";
import AlphaHomoraV2PriceOracleABI from "../../abi/src/oracles/AlphaHomoraV2PriceOracle.json";
import BadgerPriceOracleABI from "../../abi/src/oracles/BadgerPriceOracle.json";
import BalancerLpTokenPriceOracleABI from "../../abi/src/oracles/BalancerLpTokenPriceOracle.json";
import BalancerStableLpTokenPriceOracleABI from "../../abi/src/oracles/BalancerStableLpTokenPriceOracle.json";
import BalancerV2TwapPriceOracleABI from "../../abi/src/oracles/BalancerV2TwapPriceOracle.json";
import BasePriceOracleABI from "../../abi/src/oracles/BasePriceOracle.json";
import ChainlinkPriceOracleABI from "../../abi/src/oracles/ChainlinkPriceOracle.json";
import ChainlinkPriceOracleV2ABI from "../../abi/src/oracles/ChainlinkPriceOracleV2.json";
import ChainlinkPriceOracleV3ABI from "../../abi/src/oracles/ChainlinkPriceOracleV3.json";
import CurveFactoryLpTokenPriceOracleABI from "../../abi/src/oracles/CurveFactoryLpTokenPriceOracle.json";
import CurveLiquidityGaugeV2PriceOracleABI from "../../abi/src/oracles/CurveLiquidityGaugeV2PriceOracle.json";
import CurveLpTokenPriceOracleABI from "../../abi/src/oracles/CurveLpTokenPriceOracle.json";
import CurveTriCryptoLpTokenPriceOracleABI from "../../abi/src/oracles/CurveTriCryptoLpTokenPriceOracle.json";
import CvxFXSPriceOracleABI from "../../abi/src/oracles/CvxFXSPriceOracle.json";
import ETHMAXYPriceOracleABI from "../../abi/src/oracles/ETHMAXYPriceOracle.json";
import FixedEthPriceOracleABI from "../../abi/src/oracles/FixedEthPriceOracle.json";
import FixedEurPriceOracleABI from "../../abi/src/oracles/FixedEurPriceOracle.json";
import FixedTokenPriceOracleABI from "../../abi/src/oracles/FixedTokenPriceOracle.json";
import FixedUsdPriceOracleABI from "../../abi/src/oracles/FixedUsdPriceOracle.json";
import GAlcxPriceOracleABI from "../../abi/src/oracles/GAlcxPriceOracle.json";
import GelatoGUniPriceOracleABI from "../../abi/src/oracles/GelatoGUniPriceOracle.json";
import GFloorPriceOracleABI from "../../abi/src/oracles/GFloorPriceOracle.json";
import GOhmPriceOracleABI from "../../abi/src/oracles/GOhmPriceOracle.json";
import HarvestPriceOracleABI from "../../abi/src/oracles/HarvestPriceOracle.json";
import Keep3rPriceOracleABI from "../../abi/src/oracles/Keep3rPriceOracle.json";
import Keep3rV2PriceOracleABI from "../../abi/src/oracles/Keep3rV2PriceOracle.json";
import MasterPriceOracleABI from "../../abi/src/oracles/MasterPriceOracle.json";
import MockPriceOracleABI from "../../abi/src/oracles/MockPriceOracle.json";
import MStablePriceOracleABI from "../../abi/src/oracles/MStablePriceOracle.json";
import PreferredPriceOracleABI from "../../abi/src/oracles/PreferredPriceOracle.json";
import RecursivePriceOracleABI from "../../abi/src/oracles/RecursivePriceOracle.json";
import REthPriceOracleABI from "../../abi/src/oracles/REthPriceOracle.json";
import RgtTempPriceOracleABI from "../../abi/src/oracles/RgtTempPriceOracle.json";
import SaddleLpTokenPriceOracleABI from "../../abi/src/oracles/SaddleLpTokenPriceOracle.json";
import StakedFodlPriceOracleABI from "../../abi/src/oracles/StakedFodlPriceOracle.json";
import StakedSdtPriceOracleABI from "../../abi/src/oracles/StakedSdtPriceOracle.json";
import StakedSpellPriceOracleABI from "../../abi/src/oracles/StakedSpellPriceOracle.json";
import SushiBarPriceOracleABI from "../../abi/src/oracles/SushiBarPriceOracle.json";
import SynthetixPriceOracleABI from "../../abi/src/oracles/SynthetixPriceOracle.json";
import TemplePriceOracleABI from "../../abi/src/oracles/TemplePriceOracle.json";
import TokemakPoolTAssetPriceOracleABI from "../../abi/src/oracles/TokemakPoolTAssetPriceOracle.json";
import UniswapLpTokenPriceOracleABI from "../../abi/src/oracles/UniswapLpTokenPriceOracle.json";
import UniswapTwapPriceOracleABI from "../../abi/src/oracles/UniswapTwapPriceOracle.json";
import UniswapTwapPriceOracleRootABI from "../../abi/src/oracles/UniswapTwapPriceOracleRoot.json";
import UniswapTwapPriceOracleV2ABI from "../../abi/src/oracles/UniswapTwapPriceOracleV2.json";
import UniswapTwapPriceOracleV2FactoryABI from "../../abi/src/oracles/UniswapTwapPriceOracleV2Factory.json";
import UniswapTwapPriceOracleV2RootABI from "../../abi/src/oracles/UniswapTwapPriceOracleV2Root.json";
import UniswapV3TwapPriceOracleABI from "../../abi/src/oracles/UniswapV3TwapPriceOracle.json";
import UniswapV3TwapPriceOracleV2ABI from "../../abi/src/oracles/UniswapV3TwapPriceOracleV2.json";
import UniswapV3TwapPriceOracleV2FactoryABI from "../../abi/src/oracles/UniswapV3TwapPriceOracleV2Factory.json";
import VoltPriceOracleABI from "../../abi/src/oracles/VoltPriceOracle.json";
import WSSquidPriceOracleABI from "../../abi/src/oracles/WSSquidPriceOracle.json";
import WSTEthPriceOracleABI from "../../abi/src/oracles/WSTEthPriceOracle.json";
import WXBtrflyPriceOracleABI from "../../abi/src/oracles/WXBtrflyPriceOracle.json";
import XVaultPriceOracleABI from "../../abi/src/oracles/XVaultPriceOracle.json";
import YVaultV1PriceOracleABI from "../../abi/src/oracles/YVaultV1PriceOracle.json";
import YVaultV2PriceOracleABI from "../../abi/src/oracles/YVaultV2PriceOracle.json";
import ZeroPriceOracleABI from "../../abi/src/oracles/ZeroPriceOracle.json";

// ABI Fuse
import FuseFeeDistributorABI from "../../abi/src/FuseFeeDistributor.json";
import FusePoolDirectoryABI from "../../abi/src/FusePoolDirectory.json";
import FusePoolLensABI from "../../abi/src/FusePoolLens.json";
import FusePoolLensSecondaryABI from "../../abi/src/FusePoolLensSecondary.json";
import FuseSafeLiquidatorABI from "../../abi/src/FuseSafeLiquidator.json";

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
    // CarefulMathABI,
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
    // ExponentialABI,
    // ExponentialNoErrorABI,
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
    // SafeMathABI,
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
