pragma solidity ^0.8.10;

interface ICvxFXSPriceOracle {
    function FXS() external view returns (address);

    function cvxFXS() external view returns (address);

    function cvxFXSFXS() external view returns (address);

    function cvxFXSFXSMinter() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
