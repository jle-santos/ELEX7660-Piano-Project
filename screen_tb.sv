module screen_tb ;

logic reset_n = '0, clk = '0;
logic outData;
logic [9:0] inputData;
screen_module screen_0 (.reset_n, .clk, .outData, .inputData);

initial
begin
	  reset_n = '0 ;
      repeat(1) @(posedge clk) ;
      reset_n = '1 ;
	  //STOP BIT || DATA BITS || START BIT
	  inputData = 10'b1010101010;
	  repeat(4) @(posedge clk) ;
	  inputData = '0;
	  repeat(50) @(posedge clk) ;
	  inputData = 10'b1010101010;
	  repeat(4) @(posedge clk) ;
	  inputData = '0;
	  repeat(50) @(posedge clk) ;
	  /*inData = {'1, '0, 8'hA2, '1};
	  repeat(21) @(posedge clk) ;
	  inData = {'0, '0, 8'hA2, '1};
	  repeat(4) @(posedge clk) ;
	  inData = {'1, '0, 8'h7B, '1};
	  repeat(21) @(posedge clk) ;
	  inData = {'0, '0, 8'h7B, '1};
	  repeat(4) @(posedge clk) ;*/
	  $stop;
end

   always
     #500ns clk = ~clk ;

	
endmodule

