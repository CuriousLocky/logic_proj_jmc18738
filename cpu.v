
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
  output reg[`WORD_SIZE-1:0] output_port,   // this will be used to show values in registers in case of WWD or register_selection
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
		input [15:0] next,
		input jump_flag,
		output reg PC_counter
	);
		reg [15:0 ]PC_cont;


		always @(posedge clk) begin
			if(pc_reset) begin
				PC_cont <= 0;
				end
			else if (jump_flag) begin
					parameter next_pc = 0;
					next_pc = PC_cont +{{16{next[8]}}, next[8:0]};
					if(next_pc > 27)
						next_pc = 27;
					PC_cont <= next_pc;
					end
			else if (PC_cont < 27) begin
				PC_cont = PC_cont+1;
				end
			end

	endmodule
////////////////////////////////////////////////////////////////////////////////////////
	module JMP_ALU(
		input [15:0] current_PC,
		input [11:0] target,
		output [15:0] jump_PC
	);
	 always begin
	 jump_PC={current_PC[15:12], target[11:0]};
	 end
	endmodule
	//what does jump_ALU do?
//////////////////////////////////////////////////////////////////////////
	module data_mem(
		input [1:0]r_add1,
		input [1:0]r_add2,
		input [1:0]w_add,
		input w_flag,
		input [15:0]w_data,
		input clk,
		input reset,
		output reg [15:0]r_data1,
		output reg [15:0]r_data2
	);
	reg [1:0] data [15:0];
	
	initial begin
		data = 0;
	end

	always @(reset or posedge clk) begin
		if(reset) begin
			data = 0;
		end
		else begin
			r_data1 <= data[r_add1];
			r_data2 <= data[r_add2];
			if (w_flag);
			begin
				data[w_add] <= w_data;
			end
		end
	end
	endmodule
///////////////////////////////////////////////////////////////////////
	module controller(
		input clk, 
		input [3:0] opcode,
		input [5:0] func,

		output reg ALU_op,
		output reg immidiate_mux,
		output reg pc_flag,
		output reg data_mem_w_flag,
		output reg data_mem_w_mux,
		output reg output_port_flag
	);

	always @(*) begin
		case(opcode)
			4'd0: begin
				case(func)
					6'd0:begin
						ALU_op <= 0;
						immidiate_mux <= 0;
						pc_flag <= 0;
						data_mem_w_flag <=1;
						data_mem_w_mux <= 0;
						output_port_flag <=0;
						end
					default: begin
						ALU_op <= 0;
						immidiate_mux <= 0;
						pc_flag <= 0;
						data_mem_w_flag <=0;
						data_mem_w_mux <=0;
						output_port_flag <=1;
						end
					endcase
				end
			4'd4: begin
				ALU_op <= 0;
				immidiate_mux <= 1;
				pc_flag <= 0;
				data_mem_w_flag <=1;
				data_mem_w_mux <= 1;
				output_port_flag <= 0;
				end
			4'd6: begin
				ALU_op <= 1;
				immidiate_mux <= 1;
				pc_flag <= 0;
				data_mem_w_flag <= 1;
				data_mem_w_mux <= 1;
				output_port_flag <= 0;
				end
			4'd9: begin
				ALU_op <= 0;
				immidiate_mux <= 0;
				pc_flag <= 1;
				data_mem_w_flag <=0;
				data_mem_w_mux <= 0;
				output_port_flag <= 0;
				end
			endcase
		end
	endmodule

/////////////////////////////////////////////////////////////////////////
	module MUX2Bits(
		input [1:0] inA, 
		input [1:0] inB,
		input selector,

		output reg [1:0] result
	);
		initial begin
			if(selector == 0)
				result <=inA;
			else
				result <= inB;
		end
	endmodule
/////////////////////////////////////////////////////////////////////////
	wire PC_flag;
	wire[15:0] PC_write;
	wire[15:0] current_PC;
	wire[3:0] opcode;
	wire[5:0] func;
	wire data_w_flag;
	wire[1:0] data_w_add;
	wire immidiate_mux_selector;
	wire mem_w_mux_selector;
	wire[15:0] data1;
	wire[15:0] data2;
	wire[15:0] inB;
	wire ALU_op;
	wire[15:0] ALU_in_2;
	wire[15:0] ALU_result;
	wire[1:0] rs;
	wire[1:0] rd;
	wire[1:0] rt;
	wire[1:0] mem_w_add;
	wire [7:0] immidiate;
	wire [11:0] target;
	wire output_port_flag;

	assign rs = memory[current_PC][11:10];
	assign rt = memory[current_PC][9:8];
	assign rd = memory[current_PC][7:6];
	assign immidiate = memory[current_PC][7:0];
	assign target = memory[curren_PC][11:0];
	assign opcode = memory[current_PC][15:12];
	assign func = memory[current_PC][5:1];
	
	PC PC(reset_cpu, clk, PC_write, PC_flag, current_PC);
	JMP_ALU JUMP_ALU(current_PC, target, PC_write);
	MUX2Bits rd_rt_selection(rd, rt,mem_w_mux_selector, mem_w_add);
	data_mem datamem(rs, rt, data_w_add, data_2_flag, ALU_result, clk, reset_cpu, data1, data2);
	MUX16Bits data2_selection(data2, {immidiate[7], immidiate[7], immidiate[7], immidiate[7], immidiate[7], immidiate[7], immidiate[7], immidiate[7], immidiate}, immidiate_mux_selector, dataALU_in_2);
	ALU ALU(data1, ALU_in_2, ALU_result);
	controller controller(clk, opcode, func, ALU_op, immidiate_mux_selector, PC_flag, data_w_flag, mem_w_mux_selector, output_port_flag);

	assign PC_below8bit = PC[7:0];

	always @(wwd_enable)
		if (output_port_flag)
			output_port <= data1;
		else
			//I dont understand what our TA means so I left it blank
				//alright, I will take some time through it too..till morning probably.
				//will check some gramma and see whether I can make it done XD
endmodule
			
