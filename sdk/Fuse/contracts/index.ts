// Vendor
import { Contract, providers } from "ethers";

// Contracts
import { getAddresses } from "./addresses";

// Utilities
import { ChainID, isSupportedChainId } from "../../utilities/networks";

// ABI
import FuseFeeDistributorABI from "../../../abi/FuseFeeDistributor.json";
import FusePoolDirectoryABI from "../../../abi/FusePoolDirectory.json";
import FusePoolLensABI from "../../../abi/FusePoolLens.json";
import FusePoolLensSecondaryABI from "../../../abi/FusePoolLensSecondary.json";
import FuseSafeLiquidatorABI from "../../../abi/FuseSafeLiquidator.json";

// ABI Core
import CErc20DelegateABI from "../../../abi/core/CErc20Delegate.json";
// import CErc20DelegatorABI from "../../../../abi/core/CErc20Delegator.json";
import CEtherDelegateABI from "../../../abi/core/CEtherDelegate.json";
// import CEtherDelegatorABI from "../../../../abi/core/CEtherDelegator.json";
// import CTokenInterfacesABI from "../../../abi/core/CTokenInterfaces.json";
import ComptrollerABI from "../../../abi/core/Comptroller.json";
// import EIP20InterfaceABI from "../../../../abi/core/EIP20Interface.json";
// import JumpRateModelABI from "../../../../abi/core/JumpRateModel.json";
import RewardsDistributorDelegateABI from "../../../abi/core/RewardsDistributorDelegate.json";
// import RewardsDistributorDelegatorABI from "../../../../abi/core/RewardsDistributorDelegator.json";
// import SimplePriceOracleABI from "../../../../abi/core/SimplePriceOracle.json";
// import UnitrollerABI from "../../../../abi/core/Unitroller.json";
// import WhitePaperInterestRateModelABI from "../../../../abi/core/WhitePaperInterestRateModel.json";

// ABI Oracles
// import AlphaHomoraV1PriceOracleABI from "../../../../abi/oracles/AlphaHomoraV1PriceOracle.json";
// import BalancerLpTokenPriceOracleABI from "../../../../abi/oracles/BalancerLpTokenPriceOracle.json";
// import ChainlinkPriceOracleABI from "../../../../abi/oracles/ChainlinkPriceOracle.json";
// import CurveLpTokenPriceOracleABI from "../../../../abi/oracles/CurveLpTokenPriceOracle.json";
// import Keep3rPriceOracleABI from "../../../../abi/oracles/Keep3rPriceOracle.json";
// import MasterPriceOracleABI from "../../../../abi/oracles/MasterPriceOracle.json";
// import PreferredPriceOracleABI from "../../../../abi/oracles/PreferredPriceOracle.json";
// import RecursivePriceOracleABI from "../../../../abi/oracles/RecursivePriceOracle.json";
// import SynthetixPriceOracleABI from "../../../../abi/oracles/SynthetixPriceOracle.json";
// import UniswapLpTokenPriceOracleABI from "../../../../abi/oracles/UniswapLpTokenPriceOracle.json";
// import UniswapTwapPriceOracleV2FactoryABI from "../../../../abi/oracles/UniswapTwapPriceOracleV2Factory.json";
// import UniswapV3TwapPriceOracleV2FactoryABI from "../../../../abi/oracles/UniswapV3TwapPriceOracleV2Factory.json";
// import YVaultV1PriceOracleABI from "../../../../abi/oracles/YVaultV1PriceOracle.json";
// import YVaultV2PriceOracleABI from "../../../../abi/oracles/YVaultV2PriceOracle.json";

export const ORACLE_CONTRACTS = {};

export const getContracts = (
  provider: providers.JsonRpcProvider,
  chainId: ChainID
) => {
  if (!isSupportedChainId(chainId)) {
    throw new Error(`Unsupported chainid: ${chainId}`);
  }

  const addresses = getAddresses(chainId);

  return {
    // Fuse contracts
    FusePoolDirectory: new Contract(
      addresses.FUSE_POOL_DIRECTORY_CONTRACT_ADDRESS,
      FusePoolDirectoryABI,
      provider
    ),
    FusePoolLens: new Contract(
      addresses.FUSE_POOL_LENS_CONTRACT_ADDRESS,
      FusePoolLensABI,
      provider
    ),
    FusePoolLensSecondary: new Contract(
      addresses.FUSE_POOL_LENS_SECONDARY_CONTRACT_ADDRESS,
      FusePoolLensSecondaryABI,
      provider
    ),
    FuseSafeLiquidator: new Contract(
      addresses.FUSE_SAFE_LIQUIDATOR_CONTRACT_ADDRESS,
      FuseSafeLiquidatorABI,
      provider
    ),
    FuseFeeDistributor: new Contract(
      addresses.FUSE_FEE_DISTRIBUTOR_CONTRACT_ADDRESS,
      FuseFeeDistributorABI,
      provider
    ),

    // Core contracts
    CErc20Delegate: new Contract(
      addresses.CERC20_DELEGATE_CONTRACT_ADDRESS,
      CErc20DelegateABI,
      provider
    ),
    CEtherDelegate: new Contract(
      addresses.CETHER_DELEGATE_CONTRACT_ADDRESS,
      CEtherDelegateABI,
      provider
    ),
    // Error: Duplicate definition of ActionPaused (ActionPaused(string,bool), ActionPaused(address,string,bool)) ?
    // Comptroller: new Contract(
    //   addresses.COMPTROLLER_IMPLEMENTATION_CONTRACT_ADDRESS,
    //   ComptrollerABI,
    //   provider
    // ),
    // RewardsDistributorDelegate: new Contract(
    //   addresses.REWARDS_DISTRIBUTOR_DELEGATE_CONTRACT_ADDRESS,
    //   RewardsDistributorDelegateABI,
    //   provider
    // ),

    // Oracle contracts

    // ["AlphaHomoraV1PriceOracleABI"]: AlphaHomoraV1PriceOracleABI,
    // ["BalancerLpTokenPriceOracleABI"]: BalancerLpTokenPriceOracleABI,
    // ["ChainlinkPriceOracleABI"]: ChainlinkPriceOracleABI,
    // ["CurveLpTokenPriceOracleABI"]: CurveLpTokenPriceOracleABI,
    // ["Keep3rPriceOracleABI"]: Keep3rPriceOracleABI,
    // ["MasterPriceOracleABI"]: MasterPriceOracleABI,
    // ["PreferredPriceOracleABI"]: PreferredPriceOracleABI,
    // ["RecursivePriceOracleABI"]: RecursivePriceOracleABI,
    // ["SynthetixPriceOracleABI"]: SynthetixPriceOracleABI,
    // ["UniswapLpTokenPriceOracleABI"]: UniswapLpTokenPriceOracleABI,
    // ["UniswapTwapPriceOracleV2FactoryABI"]: UniswapTwapPriceOracleV2FactoryABI,
    // ["UniswapV3TwapPriceOracleV2FactoryABI"]:
    //   UniswapV3TwapPriceOracleV2FactoryABI,
    // ["YVaultV1PriceOracleABI"]: YVaultV1PriceOracleABI,
    // ["YVaultV2PriceOracleABI"]: YVaultV2PriceOracleABI,
  };
};
