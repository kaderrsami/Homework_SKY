// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BinaryConverter
 * @dev Demonstrates:
 *      Part A - Converting a binary string (unsigned) to its decimal representation.
 *      Part B - Decomposing a uint8 into an array of decimal values using bitwise masking.
 */
contract BinaryConverter {
    /**
     * @notice Part A - Converts a binary string to its decimal representation.
     * @param binString A string representing a binary number (e.g., "1101").
     * @return decimalValue The decimal (base-10) equivalent of `binString`.
     */
    function convertBinStringToDecimal(string memory binString)
        public
        pure
        returns (uint decimalValue)
    {
        // Convert the input string to a bytes array for easier indexing
        bytes memory stringBytes = bytes(binString);

        // Iterate over each character in the string
        for (uint i = 0; i < stringBytes.length; i++) {
            // Optional: Validate to ensure only '0' or '1'
            require(
                stringBytes[i] == "0" || stringBytes[i] == "1",
                "Invalid character: must be '0' or '1'"
            );

            // If the character is '1', accumulate its power-of-two value
            if (stringBytes[i] == "1") {
                /**
                 * Example:
                 * "1101" -> lengths is 4
                 * Index i = 0 -> '1' => add 2^(4 - 1 - 0) = 2^3 = 8
                 * Index i = 1 -> '1' => add 2^(4 - 1 - 1) = 2^2 = 4
                 * Index i = 2 -> '0' => add 0
                 * Index i = 3 -> '1' => add 2^(4 - 1 - 3) = 2^0 = 1
                 * Total = 13
                 */
                decimalValue += 2 ** (stringBytes.length - 1 - i);
            }
        }
    }

    /**
     * @notice Part B - Decompose a uint8 value into an array of decimal values using bitwise masking.
     * @param inputVal A uint8 number (0 - 255).
     * @return decomposedBits An array of length 8, where each position contains
     *         the decimal value (2^i) if that bit is 1, or 0 if that bit is 0.
     */
     function decomposeBits(uint8 inputVal) public pure returns (uint[] memory) {
        uint[] memory decomposedBits = new uint[](8);
        uint bitMask = 1;  // 'uint' by default is an alias for 'uint256'
    
        for (uint i = 0; i < 8; ++i) {
            // Convert 'inputVal' to 'uint' when doing the & operation
            if ((uint(inputVal) & (bitMask << i)) != 0) {
                decomposedBits[i] = 2 ** i;
            } else {
                decomposedBits[i] = 0;
            }
        }
        return decomposedBits;
    }
    
}