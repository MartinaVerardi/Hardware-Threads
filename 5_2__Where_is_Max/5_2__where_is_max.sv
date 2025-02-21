/*

Design and implement a hardware thread to find the maximum unsigned number on it's input.
The thread port definitions are:

module findMax(
input logic start,
input logic [7:0] inputA,
input logic clk, rst

ouput logic done,
output logic [7:0] maxValue
);

start is a control signal, telling the thread when to start recivig inputs. The FSM-D will wait until
the start signal is asserted before proceeding. When its first asserted, the first inputA value is on 
the input. While start remaining asserted, there will be new input values on inputA at each successive 
clock edge. As each of these inputs is available, maxValue is updated so that it is always the maximum 
of the prior input.

When start becomes non-asserted, done is asserted, indicating that the maxValue output has the maximum
value of the sequence of inputs; it remain asserted for one clock edge. The system then waits for the 
next start to be asserted. On reset, maxValue should be 0 and the system is waiting for start. There
could be more/less than four inputs in the sequence.

Do This: design the STD for the thread and the logic for the datapath. Use components such as those 
presented in this chapter. Draw the DataPath; label control and status points. Also, write the
SystemVerilog Code for this. Then write a testbench that sends several sequences of values to the thread.

*/