pragma solidity 0.8.13;

interface IProxy {
    event AdminChanged(address previousAdmin, address newAdmin);
    event Upgraded(address indexed implementation);

    function admin() external returns (address);

    function changeAdmin(address newAdmin) external;

    function implementation() external returns (address);

    function upgradeTo(address newImplementation) external;

    function upgradeToAndCall(address newImplementation, bytes memory data)
        external
        payable;
}
