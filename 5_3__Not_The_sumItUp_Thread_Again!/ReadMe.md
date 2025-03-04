# summItUp Module

## Overview
This module implements a summation logic that continuously adds input values (`inA`) to an accumulated sum (`sum`). It includes overflow detection (`error`), which remains asserted until the `go_l` signal is asserted again.

## Features
- **16-bit summation**
- **Overflow detection** with persistent error flag
- **State machine-based control logic**
- **Resettable error handling**
- **Ensures `done` is not asserted when `error` is active**

## Module Interface
### Inputs
| Signal  | Width  | Description |
|---------|--------|-------------|
| `ck`    | 1-bit  | Clock signal |
| `reset_l` | 1-bit | Active-low reset signal |
| `go_l`  | 1-bit  | Control signal to start/reset summation |
| `inA`   | 16-bit | Input value to be added |

### Outputs
| Signal  | Width  | Description |
|---------|--------|-------------|
| `sum`   | 16-bit | Accumulated sum |
| `done`  | 1-bit  | Indicates completion of summation |
| `error` | 1-bit  | Indicates overflow occurred |
