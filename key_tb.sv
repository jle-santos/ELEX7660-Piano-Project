//Gets the key presses, sends the frequencies/screen commands to the control

module key_tb;

logic reset_n;
logic clk = '0;
logic [12:0] KEYBOARD;
logic [31:0] noteFrequency [12:0];
logic [7:0] LED;
logic spkr;

key_module key_0 (.*, .*, .*, .*);
tone_module tone_0 (.*, .*, .*, .*);

initial
begin
	  reset_n = '0;
	  repeat(1) @(posedge clk) ;
	  reset_n = '1;
	  repeat(2) @(posedge clk) ;
	  KEYBOARD = 13'b1000000000000;
	  repeat(10) @(posedge clk) ;
	  KEYBOARD = 13'b0100000000010;
	  repeat(10) @(posedge clk) ;
	  KEYBOARD = '1;
	  repeat(50) @(posedge clk) ;
	  $stop;
end

   always
     #500ns clk = ~clk ;
	 
endmodule