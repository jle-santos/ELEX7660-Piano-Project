//Screen data buffer module FIFO
					
module data_module
   ( 
	 input logic reset_n, clk, 
	 
     output logic iready,       //Ready/valid input
     input  logic ivalid, 		//Valid input
     input  logic [9:0] idata,	//inputData [UART Formatted]

     input  logic oready,       //Screen idle/transmit check
     output logic ovalid,     	//If the output valid is correct
     output logic [9:0] odata,	//outputData to screen [UART Formatted]
     ) ;

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
		
		if(reset) //Reset FIFO, empty
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
	   end
   
endmodule
				
						