	module data_mem(
		input clk,
		input [1:0]r_add1,
		input [1:0]r_add2,
		input [1:0] rg_sel,
		input [1:0]w_add,
		input w_flag,
		input [15:0]w_data,
		input reset,
		output [15:0]r_data1,
		output [15:0]r_data2,
		output [15:0]rgsel_data,
		output debug
	);
	reg [15:0] data [3:0];
	assign debug = data[0];
	integer i;
	always @(posedge clk) begin
		if(reset) 
			for(i=0;i<4;i=i+1)
				data[i] <= 0;
		else
			if (w_flag) 
				data[w_add] <= w_data;
	end
	assign r_data1 = data[r_add1];
	assign r_data2 = data[r_add2];
	assign rgsel_data = data[rg_sel];
	endmodule