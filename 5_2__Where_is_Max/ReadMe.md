# FindMax Hardware Thread

## Overview

This module is designed to find the **maximum unsigned number** from a sequence of inputs. It consists of a **Finite State Machine (FSM)** for control logic and a **Datapath** for computation.

## State Diagram

The FSM follows three states (Moore Machine):  

- **A (Idle, `done=0`)**: Waiting for `start=1`  
- **B (Finding Max, `done=0`)**: Updating `maxValue` while `start=1`  
- **C (Done, `done=1`)**: Holds max value for one cycle, then returns to `A`  

### FSM State Transitions  

```plaintext
    (A, done=0) -- start=1 --> (B, done=0)
    (B, done=0) -- start=1 --> (B, done=0)
    (B, done=0) -- start=0 --> (C, done=1)
    (C, done=1) -- automatic --> (A, done=0)
```
---

## FSM Components

- **State Register (Flip-Flop)**: Stores the current state (A, B, or C).
- **Next-State Logic (Combinational Logic)**: Determines state transitions based on the `start` signal.

### Control Signals:
- **done**: Asserted in state C for one clock cycle to indicate the process is complete and the `maxValue` has been calculated.

### Signal Diagram
![WhatsApp Image 2025-03-03 at 19 56 45_d977af5e](https://github.com/user-attachments/assets/2b71087c-a641-4861-afee-49c57adbb7fa)


### FSM Logic:
- In state **A (Idle)**, the system waits for the `start` signal to be asserted. Once `start` is asserted, the state transitions to **B (Finding Max)**.
- In state **B (Finding Max)**, the system compares the input (`inputA`) to the current `maxValue` and updates `maxValue` if the new value is greater.
- In state **C (Done)**, the system asserts the `done` signal for one clock cycle, indicating that the max value has been calculated. The system then returns to **A (Idle)** after the `done` signal is de-asserted.

## Datapath (Max Value Calculation)

The datapath is responsible for calculating and updating the maximum value based on the incoming inputs.

### Datapath Components
- **Flip-Flop (MaxReg)**: Stores the current max value.
- **Comparator (>)**: Compares `inputA` with `MaxReg` to determine if the input is greater than the current max value.
- **Control Signal (start)**: Determines when to update the max value.
- **Multiplexer (MUX)**: Selects between updating or keeping `MaxReg`, depending on the comparison result.

### Datapath Logic:
- On reset, `maxValue` is initialized to 0.
- In state **B (Finding Max)**, the datapath compares `inputA` with the current `MaxReg`:
  - If `inputA` is greater than `MaxReg`, the value of `MaxReg` is updated to `inputA`.
  - If `inputA` is not greater than `MaxReg`, `MaxReg` remains unchanged.
- When the `start` signal is de-asserted (i.e., processing is complete), the system moves to state **C (Done)**, and the `done` signal is asserted for one clock cycle to indicate that the process is finished.

### Data Path Diagram

```plaintext
  +-----------+      +-----------+      +-------------+
  |           |      |           |      |             |
  |   inputA  | ---> | Comparator | ---> | MaxReg (FF) |
  |           |      |           |      |             |
  +-----------+      +-----------+      +-------------+
        |                                |
        |    (If inputA > MaxReg)       |
        |--------------------------------|
        |            MaxReg Update      |
        +--------------------------------+
