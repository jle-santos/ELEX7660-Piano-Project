module piano_plus_plus ( 
					  input logic reset_n, clk,
					  input logic [12:0] KEYBOARD,
				      output logic outData, spkr,
						output logic outScreen,
					  output logic [7:0] LED);

    logic [9:0] inputScreen;
	logic [31:0] noteFrequency [0:12];
	logic [2:0] scale;
	//logic inputReady, dataValid;
	
	//FIFO variables
	//logic iready, ivalid, oready, ovalid;
	//logic [9:0] idata, odata;
   
	screen_module screen_0 (.reset_n, .clk, .outScreen, .scale);
	key_module key_0 (.reset_n, .clk, .KEYBOARD, .scale, .noteFrequency);
	//data_module data_0 (.reset_n, .clk, .inputReady, .dataValid, .inputScreen, .LED);
	tone_module tone_0 (.reset_n, .clk, .noteFrequency, .spkr);
	
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
				//inputData <= {'1,8'h31, '0};
				end	
		end
		
endmodule
