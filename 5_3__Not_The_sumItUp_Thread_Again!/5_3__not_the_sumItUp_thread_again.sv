/*

Starting with the sumItUp thread presented in the chapter, add an output signal, called error,
that indicates when there is an overflow (unsigned in the ALU). Once Overflow is detected, the error
output stays asserted until the next go_L signal is asserted. done is not asserted when error is 
asserted.

*/

module summItUp
(
    input logic ck, reset_l, go_l,
    input logic [15:0] inA,

    output logic done, error,
    output logic [15:0] sum
);

logic ld_l, cl_l, inAeq;
logic [16:0] addOut; // 17-bit to capture carry out

enum bit {sA, sB} state;

always_ff @(posedge ck, negedge reset_l) begin : st_machine
    if (~reset_l) 
        state <= sA;
    else begin
        if (((state == sA) & go_l) | ((state == sB) & inAeq)) 
            state <= sA;
        else if (((state == sA) & ~go_l) | ((state == sB) & ~inAeq)) 
            state <= sB;
    end
end

always_ff @(posedge ck, negedge reset_l) begin : reg_sum
    if (~reset_l) 
        sum <= 0;
    else if (~ld_l) 
        sum <= addOut[15:0]; // Store only lower 16 bits
    else if (~cl_l) 
        sum <= 0;
end

assign addOut = {1'b0, sum} + {1'b0, inA}, // Extend to 17 bits to detect overflow
       ld_l = ~(((state == sA) & ~go_l) | ((state == sB) & ~inAeq)),
       cl_l = ~(((state == sB) & inAeq)),
       done = (state == sB) & inAeq & ~error, // done is not asserted if error is active
       inAeq = (inA == 0);

always_ff @(posedge ck, negedge reset_l) begin
    if (~reset_l) 
        error <= 0;
    else if (go_l) 
        error <= 0; // Reset error when go_l is asserted
    else if (addOut[16]) 
        error <= 1; // Overflow detected, latch error
end

endmodule
