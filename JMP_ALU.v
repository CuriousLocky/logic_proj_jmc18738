	module JMP_ALU(
		input [15:0] current_PC,
		input [11:0] target,
		output [15:0] jump_PC
	);

	 assign jump_PC={current_PC[15:12], target[11:0]};

	endmodule
	//what does jump_ALU do?