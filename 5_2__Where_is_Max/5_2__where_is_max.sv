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

module findMax(
input logic start,
input logic [7:0] inputA,
input logic clk, rst

ouput logic done,
output logic [7:0] maxValue
);

typedef enum logic [1:0] {
    Idle = 3'b00,
    FindingMax = 3'b01,
    Done = 3'b10
    } stateList;


stateList state;

logic [7:0] MaxReg = 0;

// FSM: Handles state transitions
always_ff @(posedge clk, negedge rst) begin
    if (~rst) begin
        state <= Idle;
        done <= 0;
        MaxReg <= 0;
    end else begin
        case (state)
            Idle: begin
                if (start) begin
                    state <= FindingMax;
                    done <= 0; // don't assert done until processing is done
                end
            end
            FindingMax: begin
                if (~start) begin
                    state <= Done;
                    done <= 1; // assert done when done processing
                end
            end
            Done: begin
                state <= Idle; // back to Idle after one clock cycle
                done <= 0; // reset done
            end
            default: state <= Idle;
        endcase
    end
end

// Data Path: Find Max Value
always_ff @(posedge clk, negedge rst) begin
    if (~rst) begin
        maxValue <= 0;
        MaxReg <= 0;
    end else begin
        if (start) begin // Only process when start is asserted
            if (inputA > MaxReg) begin
                MaxReg <= inputA; // Update MaxReg with new input
            end
        end
        maxValue <= MaxReg; // Output the max value
    end
end

endmodule