pragma solidity ^0.8.10;

interface InitializableClones {
    event Deployed(address instance);

    function clone(address master, bytes memory initializer)
        external
        returns (address instance);
}
