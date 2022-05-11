pragma solidity ^0.8.10;

interface IMigrations {
    function last_completed_migration() external view returns (uint256);

    function owner() external view returns (address);

    function setCompleted(uint256 completed) external;

    function upgrade(address new_address) external;
}