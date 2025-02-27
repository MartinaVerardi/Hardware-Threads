/*

Five-bit sequences of bits (a nibble) are being received one bit at the time and 
you are to determine if the nibbles are valid. Each nibble represent a decimal
number encoded in a format called "2-of-5". The format is called this because 
each nibble has only two 1s in it (see table below). these are the only valid nibbles.

2-of-5
------
00011
00101
00110
01010
01100
01001
11000
10100
10010
10001


From reset, begin reciving the bits (the right-hand bit of the nibble arrive first). 
When the fifth bit is on the input, assert the valid output if one of the 2-of-5 nibbles;
don't assert valid if is not. The next bit on the input will be the fist bit of the next
nibble. the valid output is asserted only when the correct last input is on the input.

In your design, use a counter to keep track of the bit number within the nibble and another counter
to keep track of how many ones have been seen in the current nibble.

Draw the state transition diagram for the system. Identify the control and the status points.
Write and test the SystemVerilog (the input is "in" and the output is "valid"). Compare this to a
design where there is no datapath - only a FSM to encode the whole system.


-----------------

            ** STATE TRANSITION DIAGRAM **

                +----------------+
        +------>|       S0       |  (Idle - Reset)
        |       |  in=0 or in=1  |
        |       |  (1st bit)     |
        |       +----------------+
        |                |
        | in=0 / in=1    v
        |       +----------------+
        |------>|       S1       |  (Receive 1st bit) 
        |       |  Count 1's     |
        |       +----------------+
        |                |
        | in=0 / in=1    v
        |       +----------------+
        |------>|       S2       |  (Receive 2nd bit)
        |       |  Count 1's     |
        |       +----------------+
        |                |
        | in=0 / in=1    v
        |       +----------------+
        |------>|       S3       |  (Receive 3rd bit)
        |       |  Count 1's     |
        |       +----------------+
        |                |
        | in=0 / in=1    v
        |       +----------------+
        |------>|       S4       |  (Receive 4th bit)
        |       |  Count 1's     |
        |       +----------------+
        |                |
        | in=0 / in=1    v
        |       +----------------+
        |------>|       S5       |  (Receive 5th bit)
        |       | Check LUT      |
        | in=Valid  → valid = 1  |
        | in=Invalid → valid = 0 |
        |       +----------------+
        |                |
        | next nibble     v
        +----------------> S0  
                      (Reset & process next nibble)


*/

module nibbleFider (
    input logic clk, reset_l, in,
    output logic valid
);

typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101
        } stateList;

stateList state;

logic [4:0] shiftRegister;  // Stores 5-bit nibble
int countOnes; 

// FSM: Handles state transitions
always_ff @(posedge clk, negedge reset_l) begin
    if (~reset_l) begin
        state <= S0;
        countOnes <= 0;
        shiftRegister <= 5'b00000;
    end else begin
        case (state)
            S0: state <= S1;
            S1: state <= S2;
            S2: state <= S3;
            S3: state <= S4;
            S4: state <= S5;
            S5: state <= S0; // Reset to process next nibble
            default: state <= S0;
        endcase
    end
end

// Data Path: Shifting input bits and counting 1s
always_ff @(posedge clk, negedge reset_l) begin
    if (~reset_l) begin
        shiftRegister <= 5'b00000;
        countOnes <= 0;
    end else begin
        shiftRegister <= {shiftRegister[3:0], in};  // Shift in new bit
        if (in) countOnes <= countOnes + 1;
        if (state == S0) countOnes <= (in) ? 1 : 0;  // Reset countOnes at new nibble
    end
end

// Check if the 5-bit sequence is valid
always_comb begin
    case (shiftRegister)
        5'b00011, 5'b00101, 5'b00110, 5'b01010, 5'b01100, 
        5'b01001, 5'b11000, 5'b10100, 5'b10010, 5'b10001: valid = (state == S5);
        default: valid = 0;
    endcase
end

endmodule
