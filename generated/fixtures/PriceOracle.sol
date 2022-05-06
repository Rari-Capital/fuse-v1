pragma solidity ^0.8.10;

import {Test} from "forge-std/Test.sol";

interface IPriceOracle {
    function getUnderlyingPrice(address cToken) external view returns (uint256);

    function isPriceOracle() external view returns (bool);
}

abstract contract FPriceOracle is Test {
    IPriceOracle public PriceOracle =
        IPriceOracle(deployCode("PriceOracle.sol:PriceOracle"));
}
