	module controller(
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
			4'd15: begin
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
