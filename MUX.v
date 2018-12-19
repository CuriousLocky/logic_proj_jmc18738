/*
Simple design for a 2:1 multiplexer
Set selector to 0 for the first inputA,
else you will get the second input,
*/

module MUX16Bits(
    input [15:0] inA,
    input [15:0] inB,

    input selector,

    output reg [15:0] result
);
    initial begin
        if(selector == 0)
            result <= inA;
        else
            result <= inB;
    end
endmodule