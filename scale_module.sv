module scale_module ( input logic reset_n, clk, key,
					  output logic [7:0] scale,
					  output logic [7:0] LED) ;
					
`define INCREASE_SCALE 1
`define FULL_SCALE 5
`define MIN_SCALE 1
`define RESET_BUTTON 0
`define FULL_COUNT 9375000
`define ON 0

logic [32:0] counter;
logic [32:0] next_counter;
logic [7:0] next_LED;
logic	[7:0] next_scale;

always_comb
	begin
		next_scale = scale;
		next_LED = LED;
		next_counter = counter;
		if (counter == `FULL_COUNT)
		begin
			if (key == `ON)
				begin
				if (scale == `FULL_SCALE)
					next_scale = `MIN_SCALE;
				else
					next_scale = scale + `INCREASE_SCALE;
				next_LED = next_scale;
				end
			next_counter = `RESET_BUTTON;
		end
		else 
			begin
			next_counter++;
			next_scale = next_scale;
			next_LED = next_LED;
			end
	end
	
always_ff @ (posedge clk)
	begin
		if (~reset_n)
			begin
			scale <= `MIN_SCALE;
			LED <= 7'b0000000; 
			counter <= `RESET_BUTTON;
			end
		else
		begin
			scale <= next_scale;
			counter <= next_counter;
			LED <= next_LED;
		end
	end
endmodule 