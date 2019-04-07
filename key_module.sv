//Gets the key presses, sends the frequencies/screen commands to the control

module key_module (input logic reset_n, clk,
				  input logic [12:0] KEYBOARD,
				  input logic [7:0] scale,
				  output logic [31:0] noteFrequency [12:0]);

`define IDLE_SOUND '0
`define PLAY '1
`define RESET '0

`define VALID '1
`define NOT_VALID '0

`define NUM_OF_NOTES 13

//Note table
logic [31:0] noteTable [12:0] = '{32'd95556, 32'd101238, 32'd107258, 
								32'd113636, 32'd120394, 32'd127553, 
								32'd135137, 32'd143173, 32'd151686, 
								32'd160706, 32'd170262, 32'd180387,
								32'd191113};											
								
logic [3:0] index; 
	
always_comb
	begin
		if(reset_n == 0)
			begin
			
			for(index = '0; index < `NUM_OF_NOTES; index++)
				begin
				noteFrequency[index] = '0;
				end
			end
		else
		
			begin
			for(index = '0; index < `NUM_OF_NOTES; index++)
				begin
				if(KEYBOARD[index])
					begin
					noteFrequency[index] = ((noteTable[index])/(2*scale));
					end
				else
					begin
					noteFrequency[index] <= '0;
					end
				end
			end
	end

endmodule 