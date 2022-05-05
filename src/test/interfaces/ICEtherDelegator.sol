pragma solidity 0.8.13;

interface ICEtherDelegator {
    event NewImplementation(
        address oldImplementation,
        address newImplementation
    );

    function _setImplementation(
        address implementation_,
        bool allowResign,
        bytes memory becomeImplementationData
    ) external;

    function admin() external view returns (address);

    function adminHasRights() external view returns (bool);

    function delegateToImplementation(bytes memory data)
        external
        returns (bytes memory);

    function fuseAdminHasRights() external view returns (bool);

    function implementation() external view returns (address);
}
