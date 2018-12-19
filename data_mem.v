	module data_mem(
		input clk,
		input [1:0]r_add1,
		input [1:0]r_add2,
		input [1:0]w_add,
		input w_flag,
		input [15:0]w_data,
		input reset,
		output [15:0]r_data1,
		output [15:0]r_data2,
		output debug
	);
	reg [3:0] data [15:0];
	
	assign r_data1 = data[r_add1];
	assign r_data2 = data[r_add2];
	assign debug = data[0];
	
	always @(negedge clk) begin
		if(reset) begin
			data[0] <= 16'd0;
			data [1] <= 16'd0;
			data [2] <= 16'd0;
			data [3] <= 16'd0;
		end
		else
		begin
			if (w_flag) begin
				data[w_add] <= w_data;
			end
		end
	end
	endmodule