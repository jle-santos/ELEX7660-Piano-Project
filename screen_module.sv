//Screen module version 2 using UART protocol

module screen_module (input logic reset_n, clk,
					  output logic outScreen,
					  input logic [7:0] scale
					  );

`define BAUD_RATE 5208
`define FRAME_BITS 10
`define VALID_BIT 9

`define IDLE '1
`define TRANSMIT '0

`define NOT_READY '0
`define READY '1

`define START_BIT '0
`define STOP_BIT '1

`define COMMAND 8'hFE
`define CLEAR_DISPLAY 8'h01

`define ASC_S 8'h53
`define ASC_C 8'h41
`define ASC_A 8'h41
`define ASC_L 8'h4C
`define ASC_E 8'h45
`define ASC_COLON 8'h3A

`define ASC_1 8'h31
`define ASC_2 8'h32
`define ASC_3 8'h33
`define ASC_4 8'h34
`define ASC_5 8'h35

logic [13:0] divCount, next_divCount;
logic [3:0] bitCount, next_bitCount;
logic state;
logic [3:0] index;
logic [9:0] dataBuffer;


logic [7:0] SCALE_TABLE [0:8] = '{8'hFE, 8'h80, 8'h53, 8'h43, 8'h41, 
								  8'h4C, 8'h45, 8'h3A, 
								`ASC_1};

always_comb
	begin
		
		next_divCount = divCount;
		next_bitCount = bitCount;
		
		if(state == `TRANSMIT)
			begin
			if(next_divCount < `BAUD_RATE - 1)	
				next_divCount++;
			else
				begin
				next_divCount = '0;
				next_bitCount++;
				end
			end
		
		
	end
	
always_ff @(posedge clk, negedge reset_n)
	begin
	
	if(reset_n == 0)
		begin
		divCount <= '0;
		bitCount <= '0;
		state <= `IDLE;
		index <= '0;
		outScreen <= `IDLE;
		dataBuffer <= '0;
		end
	else
		begin
		divCount <= next_divCount;
		bitCount <= next_bitCount;
		
		case(state)
			`IDLE : begin
					if(scale)
						begin
						state <= `TRANSMIT;
						
						case(scale)
							1 : SCALE_TABLE[8] <= `ASC_1;
							2 : SCALE_TABLE[8] <= `ASC_2;
							3 : SCALE_TABLE[8] <= `ASC_3;
							4 : SCALE_TABLE[8] <= `ASC_4;
							5 : SCALE_TABLE[8] <= `ASC_5;
							default :  SCALE_TABLE[8] <= `ASC_1;
						endcase
						
						dataBuffer <= {`STOP_BIT, SCALE_TABLE[index], `START_BIT};
						end
					else
						begin
						state <= `IDLE;
						end
						
					bitCount <= '0;
					outScreen <= `IDLE;
					divCount <= '0;
					end
			
			`TRANSMIT : begin
						//Check if it has finished sending the frame
						if(bitCount >= `FRAME_BITS)
							begin
							state <= `IDLE;
							index++;
							
							if(index > `VALID_BIT)
								index <= '0;
							else
								index <= index;
								
							end
						else
							outScreen <= dataBuffer[bitCount];
						end
			endcase
		end
	end

endmodule 