module piano_plus_plus ( 
					  input logic reset_n, clk,
					  input logic [12:0] KEYBOARD,
				      output logic outData, spkr,
						output logic outScreen,
					  output logic [7:0] LED);

   logic [9:0] inputData;
	logic [31:0] noteFrequency [0:12];

	logic [2:0] scale;
   
    screen_module screen_0 (.reset_n, .clk, .inputData, .outScreen);
	tone_module tone_0 (.reset_n, .clk, .noteFrequency, .spkr);
	key_module key_0 (.reset_n, .clk, .KEYBOARD, .scale, .inputData, .noteFrequency, .LED);
	
	logic [3:0] index;
	logic [2:0] scale_table [0:4] = '{1,2,3,4,5};
	
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
				end	
		end
		
endmodule
