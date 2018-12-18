
///////////////////////////////////////////////////////////////////////////
// MODULE: CPU for TSC microcomputer: cpu.v
// Author: SNU HPCS
// Description: CPU module

// DEFINITIONS do not touch definition and 
`define WORD_SIZE 16    // data and address word size
`define MEMORY_SIZE 32 
`define PC_SIZE 8 
// INCLUDE files
`include "opcodes.v"    // "opcode.v" consists of "define" statements for
                        // the opcodes and function codes for all instructions

// MODULE DECLARATION
module cpu (
  input reset_cpu,                // reset signal for CPU. active-high(reset at 1)
  input clk,                          // clock signal
  input cpu_enable,              //enables CPU too move PC, and write register
  input wwd_enable,             //enables wwd. if unasserted then wwd operation
				  //should not assign register value to output_port
  input [1:0] register_selection , // selects which register to show on output_port. It should only work when wwd is disabled
  output reg[`WORD_SIZE-1:0] num_inst,   // number of instruction during execution. !!!!!!! IMPORTANT!!! DISABLE!! this port when programming FPGA
				    // You should enable num_inst port only for SIMULATION purposes.
  output [`WORD_SIZE-1:0] output_port,   // this will be used to show values in registers in case of WWD or register_selection
  output [7:0] PC_below8bit                   // lower 8-bit of PC for LED output on output_logic.v. You need to assign lower 8bit of current PC to this port
);
  ///////////////////////////////insturction memory//////////////////////////////////
// Do not touch this part. Otherwise, your CPU will not work properly according to the tsc-ISA
    reg [`WORD_SIZE-1:0] memory [0:`MEMORY_SIZE-1]; //memory where instruction is saved
	 always@(reset_cpu) begin
	 if(reset_cpu == 1'b1) begin               // when reset, it will be initialized as below
		memory[0]  <= 16'h6000;	//	LHI $0, 0
		memory[1]  <= 16'h6101;	//	LHI $1, 1
		memory[2]  <= 16'h6202;	//	LHI $2, 2
		memory[3]  <= 16'h6303;	//	LHI $3, 3
		memory[4]  <= 16'hf01c;	//	WWD $0
		memory[5]  <= 16'hf41c;	//	WWD $1
		memory[6]  <= 16'hf81c;	//	WWD $2
		memory[7]  <= 16'hfc1c;	//	WWD $3
		memory[8]  <= 16'h4204;	//	ADI $2, $0, 4
		memory[9]  <= 16'h47fc;	//	ADI $3, $1, -4
		memory[10] <= 16'hf81c;	//	WWD $2
		memory[11] <= 16'hfc1c;	//	WWD $3
		memory[12] <= 16'hf6c0;	//	ADD $3, $1, $2
		memory[13] <= 16'hf180;	//	ADD $2, $0, $1
		memory[14] <= 16'hf81c;	//	WWD $2
		memory[15] <= 16'hfc1c;	//	WWD $3
		memory[16] <= 16'h9015;	//	JMP 21
		memory[17] <= 16'hf01c;	//	WWD $0
		memory[18] <= 16'hf180;	//	ADD $2, $0, $1
		memory[19] <= 16'hf180;	//	ADD $2, $0, $1
		memory[20] <= 16'hf180;	//	ADD $2, $0, $1
		memory[21] <= 16'h6000;	//	LHI $0, 0
		memory[22] <= 16'h4000;	//	ADI $0, $0, 0
		memory[23] <= 16'hfd80;	//	ADD $2, $3, $1
		memory[24] <= 16'hf01c;	//	WWD $0
		memory[25] <= 16'hf41c;	//	WWD $1
		memory[26] <= 16'hf81c;	//	WWD $2
		memory[27] <= 16'hfc1c;	//	WWD $3
	 end
	 end
//////////////////////////////////////////////////////////////////////////////////////////
	module PC(
		input pc_reset,
		input clk,
		input [7:0] next,
		input jump_flag,
		output PC_counter,
	);
		reg [7:0 ]PC_cont;

		always @(pc_reset) begin
			PC_cont <= 0;
			end

		always @(posedge clk) begin
			if (jump_flag)
				begin
					PC_cont = next;
					end
			PC_counter =PC_cont;
			PC_cont = PC_cont+1;
			end

	endmodule
////////////////////////////////////////////////////////////////////////////////////////
	module JMP_ALU(
		input current_PC,
		input immidiate
	)
	 
endmodule
//////////////////////////////////////////////////////////////////////////
