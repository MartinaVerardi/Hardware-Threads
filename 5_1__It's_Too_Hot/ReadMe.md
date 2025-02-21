# Nibble Finder - 2-of-5 Valid Sequence Checker

## Overview

This module is designed to receive five-bit sequences of bits (nibbles) one bit at a time and check if they are valid according to a specific encoding format called "2-of-5". In this format, each nibble has exactly two `1`s, and the module will output a "valid" signal when a valid 2-of-5 encoded nibble is received.

### 2-of-5 Encoding Table

The following 5-bit sequences represent the valid "2-of-5" encoded values:

| Binary Value | Decimal Equivalent |
|--------------|--------------------|
| 00011        | 3                  |
| 00101        | 5                  |
| 00110        | 6                  |
| 01010        | 10                 |
| 01100        | 12                 |
| 01001        | 9                  |
| 11000        | 24                 |
| 10100        | 20                 |
| 10010        | 18                 |
| 10001        | 17                 |

## Design Description

The design is implemented as a finite state machine (FSM), with the following states:

- **S0**: Initial idle state (Reset state).
- **S1**: Receive the 1st bit of the nibble.
- **S2**: Receive the 2nd bit of the nibble.
- **S3**: Receive the 3rd bit of the nibble.
- **S4**: Receive the 4th bit of the nibble.
- **S5**: Receive the 5th bit of the nibble and check the validity.

### Key Components

- **State Transition**: The FSM keeps track of the 5-bit sequence and moves through states to receive each bit.
- **Shift Register**: A 5-bit shift register holds the incoming bits as they are received.
- **Count of 1s**: A counter tracks the number of `1`s in the current nibble to check if the sequence adheres to the 2-of-5 format.
- **Valid Output**: The output `valid` is asserted when a valid nibble is detected in the final state (S5).

## FSM State Transition Diagram

