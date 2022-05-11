pragma solidity ^0.8.10;

interface ICurveTriCryptoLpTokenPriceOracle {
    function ETH_USD_PRICE_FEED() external view returns (address);

    function SOURCE_ORACLE() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
