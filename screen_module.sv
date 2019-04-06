//Screen module version 2 using UART protocol

module screen_module (input logic reset_n, clk, ovalid
					  output logic outScreen, oready,
					  input logic [9:0] inputScreen);

`define BAUD_RATE 5208
`define START_BIT 10
`define VALID_BIT 9

`define IDLE '1
`define TRANSMIT '0

`define NOT_READY '0
`define READY '1

logic [13:0] divCount, next_divCount;
logic [3:0] bitCount, next_bitCount;
logic state;
logic [9:0] dataBuffer;

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
		outScreen <= `IDLE;
		oready <= `READY;
		dataBuffer <= '0;
		end
	else
		begin
		divCount <= next_divCount;
		bitCount <= next_bitCount;
		
		case(state)
			`IDLE : begin
					if(ovalid)
						begin
						state <= `TRANSMIT;
						oready <= `NOT_READY;
						dataBuffer <= inputData;
						end
					else
						begin
						state <= `IDLE;
						oready <= `READY;
						end
						
					bitCount <= '0;
					outScreen <= `IDLE;
					divCount <= '0;
					end
			
			`TRANSMIT : begin
						//Check if it has finished sending the frame
						if(bitCount >= `START_BIT)
							state <= `IDLE;
						else
							outScreen <= dataBuffer[bitCount];
						end
			endcase
		end
	
	end

endmodule 