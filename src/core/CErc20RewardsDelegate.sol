pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./CErc20Delegate.sol";
import "./EIP20Interface.sol";

contract CErc20RewardsDelegate is CErc20Delegate {
    /// @notice A reward token claim function
    /// to be overriden for use cases where rewardToken needs to be pulled in
    function claim() external {}

    /// @notice token approval function
    function approve(address _token, address _spender) external {
        require(hasAdminRights(), "!admin");
        require(_token != underlying, "!underlying");

        EIP20Interface(_token).approve(_spender, uint256(-1));
    }
}
