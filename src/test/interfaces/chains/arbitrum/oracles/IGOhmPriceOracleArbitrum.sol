pragma solidity ^0.8.10;

interface GOhmPriceOracleArbitrum {
    function GOHM() external view returns (address);

    function OHM() external view returns (address);

    function OHM_INDEX_PRICE_FEED() external view returns (address);

    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function price(address underlying) external view returns (uint256);
}
