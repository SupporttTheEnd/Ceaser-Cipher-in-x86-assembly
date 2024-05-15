# Caesar Cipher Program

This program implements a Caesar Cipher in assembly language. It takes a shift value and applies that shift as a Caesar Cipher to the inputted text. The program includes two checks:

1. Ensures that the shift value is between -25 and 25 (inclusive).
2. Ensures that the entered string is more than 8 characters including the end-of-string newline character.

## Usage

1. Run the program.
2. Enter a shift value between -25 and 25 (inclusive) when prompted.
3. Enter a string greater than 8 characters when prompted.
4. The program will output the original message and the edited message after applying the Caesar Cipher with the given shift value.

## Program Structure

- `main`: The entry point of the program.
- `convert`: Subroutine to convert the user input string to an integer.
- `caesar_cipher`: Subroutine to apply the Caesar Cipher to the input string.
- The program includes sections for data, text, and the BSS segment for defining variables and messages.

## Requirements

- This program is designed to run on an x86-64 Linux system.

## Build Instructions

- Assemble the program using an x86-64 assembler.
- Link the object file to create the executable.
