//Screen module version 2 using UART protocol

module screen_module (input logic reset_n, clk,
					  output logic outScreen,
					  input logic [2:0] scale
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

logic [13:0] divCount, next_divCount;
logic [3:0] bitCount, next_bitCount;
logic state;
logic [5:0] index;
logic [9:0] dataBuffer;


logic [7:0] SCALE_TABLE [0:5] = '{8'h53, 8'h41, 8'h41, 8'h4C, 8'h45, 8'h3A};

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
							state <= `IDLE;
						else
							outScreen <= dataBuffer[bitCount];
						end
			endcase
		end
	end

endmodule 