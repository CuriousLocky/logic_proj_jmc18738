	module PC(
		input pc_reset,
		input clk,
		input [15:0] next,
		input jump_flag,
		output[15:0] PC_counter
	);
		reg [15:0 ]PC_cont;
		assign PC_counter = PC_cont;

		//parameter next_pc = 0;
		
		always @(posedge clk) begin
			if(pc_reset) begin
				PC_cont <= 0;
				end
			else begin
			/*
				if (jump_flag) begin
					next_pc = PC_cont +{{16{next[8]}}, next[8:0]};
					if(next_pc > 27) begin
						next_pc = 27;
					end
					PC_cont <= next_pc;
					end
				else begin
				if (PC_cont < 27) begin
						PC_cont = PC_cont+1;
						end
				end
			end
		end
		*/
				if (jump_flag) begin
					PC_cont <= next;
					end
				else begin
					if (PC_cont == 2) begin
						PC_cont <= 2;
						end
					else begin
					PC_cont <= PC_cont + 1;
					end
				end
			end
		end
	endmodule