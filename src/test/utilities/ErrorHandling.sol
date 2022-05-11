pragma solidity 0.8.13;

// library ErrorHandling {
//     /**
//      * @dev Performs a Solidity function call using a low level `call`. A
//      * plain `call` is an unsafe replacement for a function call: use this
//      * function instead.
//      * If `target` reverts with a revert reason, it is bubbled up by this
//      * function (like regular Solidity function calls).
//      * Returns the raw returned data. To convert to the expected return value,
//      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
//      * Copied from `CErc20.sol`.
//      * @param data The call data (encoded using abi.encode or one of its variants).
//      * @param errorMessage The revert string to return on failure.
//      */
//     function functionCall(
//         address target,
//         bytes memory data,
//         string memory errorMessage
//     ) internal returns (bytes memory) {
//         (bool success, bytes memory returndata) = target.call(data);

//         if (!success) {
//             // Look for revert reason and bubble it up if present
//             if (returndata.length > 0) {
//                 // The easiest way to bubble the revert reason is using memory via assembly

//                 // solhint-disable-next-line no-inline-assembly
//                 assembly {
//                     let returndata_size := mload(returndata)
//                     revert(add(32, returndata), returndata_size)
//                 }
//             } else {
//                 revert(errorMessage);
//             }
//         }

//         return returndata;
//     }
// }
