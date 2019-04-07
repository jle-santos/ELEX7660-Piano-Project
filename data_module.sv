//Screen data buffer module FIFO
					
module data_module
   ( 
	 input logic reset_n, clk, 
	 input logic inputReady,
	 output logic dataValid, 
	 output logic [9:0] inputScreen,
	 output logic [7:0] LED);
	 
	 /*
     output logic iready,       //Ready/valid input
     input  logic ivalid, 		//Valid input
     input  logic [9:0] idata,	//inputData [UART Formatted]

     input  logic oready,       //Screen idle/transmit check
     output logic ovalid,     	//If the output valid is correct
     output logic [9:0] odata,	//outputData to screen [UART Formatted]
	  output logic [7:0] LED*/
    //) ;

`define COMMAND 8'hFE
`define CLEAR_DISPLAY 8'h01

`define ASC_S 8'h53
`define ASC_C 8'h41
`define ASC_A 8'h41
`define ASC_L 8'h4C
`define ASC_E 8'h45
`define ASC_COLON 8'h3A

`define ASC_1 8'h30

logic [7:0] SCALE_TABLE [0:5] = '{8'h53, 8'h41, 8'h41, 8'h4C, 8'h45, 8'h3A};
//logic [7:0] SCALE_TABLE [0:4] = '{8'h30, 8'h31, 8'h32, 8'h33, 8'h34};

/*
`define ASC_1 8'h30
`define ASC_2 8'h31
`define ASC_3 8'h32
`define ASC_4 8'h33
`define ASC_5 8'h34
*/

//logic [15:0] cursor;
logic [2:0] count, next_count;

//6 SCALE Characters, 1 command, 1 reset cursor command

always_comb
	begin
	next_count = count;
	
	if(inputReady)
		begin
		next_count++;
		
		case(count)
			0: inputScreen = {'1, `ASC_S, '0};
			1: inputScreen = {'1, `ASC_C, '0};
			2: inputScreen = {'1, `ASC_A, '0};
			3: inputScreen = {'1, `ASC_L, '0};
			4: inputScreen = {'1, `ASC_E, '0};
			5: inputScreen = {'1, `ASC_COLON, '0};
			6: inputScreen = {'1, `ASC_1, '0};
			7: inputScreen = {'1, `COMMAND, '0};
			8: inputScreen = {'1, 8'h80, '0};
		endcase
		
		end
	else
		begin
		inputScreen = '1;
		next_count = next_count;
		end
	end
	
always_ff @(posedge clk, negedge reset_n)
	begin
	if(reset_n == 0)
		begin
		dataValid <= '0;
		count <= '0;
		end
	else
		begin
		dataValid <= '1;
		
		LED[2:0] <= count;
		count <= next_count;
		end
	end
	
/*
   parameter W = 3 ;
   parameter N = 8 ;
   
   //Registers (RAM & Pointers)
   logic [9:0] ram[N];
   logic nextiready, nextovalid;
   logic [W-1:0] writePtr, nextWrite, readPtr, nextRead, readyTemp;
   
   always_comb 
   begin
		nextWrite = writePtr;
		nextRead = readPtr;
		nextiready = iready;
		nextovalid = ovalid;
		readyTemp = 0;
		
		if(reset_n) //Reset FIFO, empty
		begin
			nextWrite = 0;
			nextRead = 0;
		end
		else 
			begin
				readyTemp = nextWrite + 1;	
				
				if((readyTemp) != nextRead)
					nextiready = 1;
				else
					nextiready = 0;
					
				if(nextWrite != nextRead)
					nextovalid = 1;
				else
					nextovalid = 0;

				if(ivalid && nextiready)
					nextWrite = writePtr + 1;
				
				if(nextovalid && oready)
					nextRead = readPtr + 1;
			end
   end
   
  always_ff @(posedge clk) 
	   begin
			ram[writePtr] <= idata; //Write idata into register of RAM
			odata <= ram[readPtr];	//Write outData to the screen_module	
			
			writePtr <= nextWrite;	//Increment writePtr
			readPtr <= nextRead;	//Increment readPtr
			
			iready <= nextiready;	
			ovalid <= nextovalid;
			
			LED[3:0] <= {ivalid, ovalid, iready, ivalid};
	   end
   */
endmodule
				
						