pragma solidity ^0.8.10;

interface Reservoir {
    function drip() external returns (uint256);

    function dripRate() external view returns (uint256);

    function dripStart() external view returns (uint256);

    function dripped() external view returns (uint256);

    function target() external view returns (address);

    function token() external view returns (address);
}
