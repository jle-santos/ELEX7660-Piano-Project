//Gets the key presses, sends the frequencies/screen commands to the control

module key_module (input logic reset_n, clk,
				  input logic [12:0] KEYBOARD,
				  input logic [2:0] scale,
					//output logic [9:0] inputData,
				  output logic [31:0] noteFrequency [12:0]);
					//output logic [7:0] LED);

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

//ASCII Table
/*logic [7:0] keyTable [12:0] = '{8'h43, 8'h42, 8'h61, 
								8'h41, 8'h67, 8'h47, 
								8'h66, 8'h46, 8'h45,
								8'h64, 8'h44, 8'h63, 
								8'h43};*/
								
logic [3:0] index; 
	
always_comb
	begin
		if(reset_n == 0)
			begin
			
			for(index = '0; index < `NUM_OF_NOTES; index++)
				begin
				noteFrequency[index] = '0;
				end
			
			//inputData = '0;
			/*LED[7] = '0;
			LED[6] = '0;
			LED[2:0] = scale;
			*/
			//ivalid <= `NOT_VALID;
			
			end
		else
		
			begin
			
			//LED[7] = '1;
			
			for(index = '0; index < `NUM_OF_NOTES; index++)
				begin
				if(KEYBOARD[index])
					begin
					noteFrequency[index] = ((noteTable[index])/(2*scale)); //Toggling halfway
					
					//ivalid <= `VALID;
					
					/*if(iready)
						inputData = {`STOP_BIT, 8'h31, `START_BIT};
					else
						inputData = '0;*/
						
					//LED[6] = '0;
					//LED[2:0] = scale;
					end
				else
					begin
					//ivalid <= `NOT_VALID;
					//inputData = '0;
					noteFrequency[index] <= '0;
					//LED[6] = '1;
					//LED[2:0] = scale;
					end
				end
			end
	end

endmodule 