# FindMax Hardware Thread

## Overview

This module is designed to find the **maximum unsigned number** from a sequence of inputs. It consists of a **Finite State Machine (FSM)** for control logic and a **Datapath** for computation.

## State Diagram

The FSM follows three states:  

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

## 🏗 FSM (Finite State Machine)

The FSM controls when to start processing, when to update the max value, and when to assert `done`.

### **FSM Components**
- **State Register (Flip-Flop)** → Stores the **current state** (`A`, `B`, `C`).  
- **Next-State Logic (Combinational Logic)** → Determines state transitions based on `start`.  
- **Control Signals**:  
  - `loadMax` → Enables updating the max value.  
  - `done` → Asserted in **state C** for one cycle.  

### **FSM State Transitions**

| Current State | `start = 0` | `start = 1` |
|--------------|------------|------------|
| **A (Idle, `done=0`)** | Stay in A  | Go to B  |
| **B (Finding Max, `done=0`)** | Go to C  | Stay in B  |
| **C (Done, `done=1`)** | Go to A (automatically) | Go to A (automatically) |

---

## 📊 Datapath (Max Value Calculation)

The **datapath processes and updates the maximum value**.

### **Datapath Components**
- **Flip-Flop (`MaxReg`)** → Stores the current max value.  
- **Comparator (`>`)** → Compares `inputA` with `maxValue`.  
- **Multiplexer (`MUX`)** → Selects between updating or keeping `maxValue`.  
- **Control Signal (`loadMax`)** → Comes from FSM to enable updates.  

### **Datapath Logic**
1. **On reset**, `maxValue = 0`.  
2. **In state B**, compare `inputA` with `maxValue`:  
   - If `inputA > maxValue`, update `maxValue`.  
   - Else, keep the old value.  
3. **When `start = 0`**, FSM moves to **C**, and `done` is asserted.  
