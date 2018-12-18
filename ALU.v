/*
Designing the ALU for use in the cpu calculations,
get inputs as code -> to selct what to do,
first input, second input
then finally get result
*/
/*
`include "opcodes.v"

module ALU(
    input [15:0] inA,
    input [15:0] inB,
    output [15:0] result,

    input [3:0] opcode,

    input carry_in,
    output carry_out,
);
    always @(*) begin
        case(opcode)
            FUNC_ADD: ADD add(
                .in1(inA),
                .in2(B),
                .cin(carry_in),
                .carry_out(carry_out),
                .result(result)
            );
        endcase
    end


    module ADD(
        input [15:0] in1, in2,
        input cin,
        output cout,
        output [15:0] result
    );
        always @(*) begin
            {cout, result} <= {in1 + in2 + cin};
        end
    endmodule


endmodule
*/
module ALU(
    input [15:0] inA,
    input [15:0] inB,
    input operation,
    output [15:0] result
    )
    always @(*) begin
        if (operation)
            result={inB[7:0], 8'd0};
        else
            result = inA + inB;
    end
endmodule 

