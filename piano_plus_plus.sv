module piano_plus_plus ( 
					  input logic reset_n, clk, key,
					  input logic [12:0] KEYBOARD,
				      output logic spkr,
						output logic outScreen,
					  output logic [7:0] LED);

	logic [9:0] inputScreen;
	logic [31:0] noteFrequency [0:12];
	logic [7:0] scale;
	
	screen_module screen_0 (.reset_n, .clk, .outScreen, .scale);
	key_module key_0 (.reset_n, .clk, .KEYBOARD, .scale, .noteFrequency);
	tone_module tone_0 (.reset_n, .clk, .noteFrequency, .spkr);
	scale_module scale_0 (.reset_n, .clk, .key, .scale, .LED);
	

	/*
	always_ff @(posedge clk)
		begin
			if(reset_n)
				begin
				//scale <= 3'd1;
				index++;
				end
			else
				begin
				scale <= scale_table[index];
				//inputData <= {'1,8'h31, '0};
				end	*/
		//end
		
endmodule
