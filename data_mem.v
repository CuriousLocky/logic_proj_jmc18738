	module data_mem(
		input [1:0]r_add1,
		input [1:0]r_add2,
		input [1:0]w_add,
		input w_flag,
		input [15:0]w_data,
		input reset,
		output reg [15:0]r_data1,
		output reg [15:0]r_data2
	);
	reg [3:0] data [15:0];
	
	initial begin
		data[0] <= 16'd0;
		data [1] <= 16'd0;
		data [2] <= 16'd0;
		data [3] <= 16'd0;
	end

	always begin
		if(reset) begin
			data[0] <= 16'd0;
			data [1] <= 16'd0;
			data [2] <= 16'd0;
			data [3] <= 16'd0;
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