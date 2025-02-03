# Exercise 1 - Function Encoding


**1. Full ABI Encoding for HelloWorld(uint[], bool):**

Imagine you have a function call to HelloWorld with two inputs:
- A dynamic array of unsigned integers (for example, [1993, 1994])
- A boolean value (for example, true)

Here’s how the full encoding is built:

- **First 4 bytes – Function Selector:**  
  You get these 4 bytes by taking the Keccak-256 hash of the string  
  `"HelloWorld(uint256[],bool)"` and then using the first 4 bytes.  
  (This uniquely identifies the function.)

- **Next 32 bytes – Pointer for the Array:**  
  Since the first input is a dynamic array, you don’t put the array’s contents here. Instead, you write a 32‑byte number (a “pointer”) that tells you where in the overall data the array’s actual data starts. For example, you might decide the array data begins 64 bytes after the start of the parameters.

- **Next 32 bytes – Boolean Value:**  
  The boolean is a value type, so it gets its own 32‑byte slot. For `true`, you fill 31 bytes with zeros and the last byte with `1`.

- **At the Array’s Location (Offset):**  
  The pointer you provided earlier tells you where to look for the array data. There you store:
  1. A 32‑byte word for the length of the array (if your array has 2 items, this word represents the number 2).
  2. Then each element of the array is written in its own 32‑byte slot.  
     For example, the number 1993 is padded with zeros to 32 bytes, and so is 1994.

- **Total Size:**  
  When you add it up:
  - 4 bytes for the function selector  
  - 32 bytes for the array pointer  
  - 32 bytes for the boolean  
  - 32 bytes for the array length  
  - 32 bytes for each of the 2 elements (2 × 32 = 64 bytes)  
  That equals: 4 + 32 + 32 + 32 + 64 = **164 bytes.**

---

**2. What encodePacked Would Give You:**

The `abi.encodePacked` function creates a “tightly packed” version of the data, which means:
- It still starts with the 4‑byte function selector.
- Instead of writing a pointer and length for the array, it just sticks the array elements right next to each other.
- It also packs the boolean in its shortest form—only 1 byte (0x01 for true).

Using our example:
- 4 bytes for the selector
- The two array elements, each still taking up 32 bytes, so 2 × 32 = 64 bytes
- 1 byte for the boolean

That totals: 4 + 64 + 1 = **69 bytes.**


**Summary in Simple Terms:**

- **Full ABI Encoding:**  
  Includes the function selector, extra 32‑byte words (for a pointer and the array length), the boolean in a full 32‑byte slot, and each array element padded to 32 bytes. For our example ([1993, 1994] and true), that comes out to 164 bytes.

- **encodePacked:**  
  Packs everything together tightly without extra information. It still starts with the 4‑byte selector, then the array’s numbers (each 32 bytes), and finally the boolean in just 1 byte. For our example, that makes 69 bytes.
