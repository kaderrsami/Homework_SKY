// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This is the answer to Exercise 1 - Function Encoding
contract FunctionEncoding {
    /**
     * @notice Computes the function selector for the function "HelloWorld(uint256[],bool)".
     * @dev The selector is defined as the first 4 bytes of the keccak256 hash of the function signature.
     * @return selector The 4-byte function selector.
     */
    function getSelector() public pure returns (bytes4 selector) {
        // The function signature must match exactly:
        // Note: In Solidity, "uint[]" is interpreted as "uint256[]"
        selector = bytes4(keccak256("HelloWorld(uint256[],bool)"));
    }
    
    /**
     * @notice Returns the full ABI-encoded call data for the function HelloWorld(uint256[], bool)
     * using sample parameters: an array of [1993, 1994] and the boolean true.
     * @dev This encoding follows the ABI standard:
     *  - First 4 bytes: function selector.
     *  - Next 32 bytes: offset for the dynamic array (points to where the array data begins).
     *  - Next 32 bytes: the bool value, encoded in a full 32-byte slot.
     *  - At the dynamic offset:
     *      - 32 bytes for the array length (2 in this case).
     *      - 32 bytes for each array element (each padded to 32 bytes).
     * @return data The ABI-encoded byte array.
     *
     * Total length calculation:
     *  4 (selector) + 32 (pointer) + 32 (bool) + 32 (array length) + (2 * 32 (elements)) 
     *  = 4 + 32 + 32 + 32 + 64 = 164 bytes.
     */
    function getEncodedCall() public pure returns (bytes memory data) {
        // Sample parameters: an array with 2 elements: [1993, 1994] and a boolean true.
        uint256[] memory arr = new uint256[](2);
        arr[0] = 1993;
        arr[1] = 1994;
        bool flag = true;
        
        // Using abi.encodeWithSelector automatically produces the standard ABI encoding.
        data = abi.encodeWithSelector(getSelector(), arr, flag);
    }
    
    /**
     * @notice Returns the tightly packed encoding of the call data using abi.encodePacked,
     * for the function HelloWorld(uint256[], bool) with the sample parameters.
     * @dev The abi.encodePacked function concatenates data without extra padding or offset/length information.
     * For our sample:
     *  - It produces 4 bytes for the function selector.
     *  - Then the dynamic array elements are concatenated directly (each element still occupies 32 bytes).
     *  - Then the bool is packed in 1 byte (0x01 for true).
     * @return packedData The packed byte array.
     *
     * Total length calculation:
     *  4 (selector) + (2 * 32 (array elements)) + 1 (bool)
     *  = 4 + 64 + 1 = 69 bytes.
     */
    function getEncodePacked() public pure returns (bytes memory packedData) {
        // Sample parameters identical to getEncodedCall(): array [1993, 1994] and boolean true.
        uint256[] memory arr = new uint256[](2);
        arr[0] = 1993;
        arr[1] = 1994;
        bool flag = true;
        
        // Using abi.encodePacked: no extra information for dynamic types is included.
        packedData = abi.encodePacked(getSelector(), arr, flag);
    }
}
