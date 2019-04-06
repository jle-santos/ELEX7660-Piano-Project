//Screen module version 2 using UART protocol

module tone_module (input logic reset_n, clk,
					  input logic [31:0] noteFrequency [12:0],
				      output logic spkr);

`define IDLE_SOUND '0
`define PLAY '1
`define RESET '0
`define NUM_OF_NOTES 13

//Note table
logic [31:0] noteCount [12:0], next_noteCount [12:0];

logic [3:0] index;
logic [12:0] spkrTable, next_spkrTable;
logic next_spkr;

always_comb
	begin
	
	for(index = 0; index < `NUM_OF_NOTES; index++)
		begin
		next_noteCount[index] = noteCount[index];
		next_spkrTable[index] = spkrTable[index];
		
		if(noteFrequency[index])
			begin
			if(next_noteCount[index] > noteFrequency[index])
				begin
				
				//Toggle each note's speaker after rollover
				if(next_spkrTable[index])
					next_spkrTable[index] = '0;
				else
					next_spkrTable[index] = '1;
				
				//Reset tone's counter back to zero
				next_noteCount[index] = '0;
				end
			else
				begin
				next_spkrTable[index] = next_spkrTable[index];
				next_noteCount[index]++;
				end
			end
		else
			begin
			next_spkrTable[index] = '0;
			next_noteCount[index] = '0;
			end
		end
		
	//XOR all the spkr outputs
	next_spkr = ~(^next_spkrTable);

	end
	
always_ff @(posedge clk, negedge reset_n)
	begin
	
	if(reset_n == 0)
		begin
		noteCount <= '{default: '0};
		spkrTable <= '0;
		spkr <= '0;
		end
	else
		begin
		spkr <= next_spkr;
		
		//Instead of a for loop (which is combinational)
		spkrTable[0] <= next_spkrTable[0];
		spkrTable[1] <= next_spkrTable[1];
		spkrTable[2] <= next_spkrTable[2];
		spkrTable[3] <= next_spkrTable[3];
		spkrTable[4] <= next_spkrTable[4];
		spkrTable[5] <= next_spkrTable[5];
		spkrTable[6] <= next_spkrTable[6];
		spkrTable[7] <= next_spkrTable[7];
		spkrTable[8] <= next_spkrTable[8];
		spkrTable[9] <= next_spkrTable[9];
		spkrTable[10] <= next_spkrTable[10];
		spkrTable[11] <= next_spkrTable[11];
		spkrTable[12] <= next_spkrTable[12];
		
		noteCount[0] <= next_noteCount[0];
		noteCount[1] <= next_noteCount[1];
		noteCount[2] <= next_noteCount[2];
		noteCount[3] <= next_noteCount[3];
		noteCount[4] <= next_noteCount[4];
		noteCount[5] <= next_noteCount[5];
		noteCount[6] <= next_noteCount[6];
		noteCount[7] <= next_noteCount[7];
		noteCount[8] <= next_noteCount[8];
		noteCount[9] <= next_noteCount[9];
		noteCount[10] <= next_noteCount[10];
		noteCount[11] <= next_noteCount[11];
		noteCount[12] <= next_noteCount[12];
		end
	end

endmodule 