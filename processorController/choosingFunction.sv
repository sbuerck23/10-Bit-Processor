module choosingFunction(
    input logic [9:0]INSTR,     //Instruction given by user
	 input logic CLK,
    output logic [3:0]FUNCT,    //Function to be given to ALU
    output logic [1:0]RX, RY,   //Registers to be used
	 output logic [5:0]IMM		  //Immidiate value
);

logic [3:0]OUTPUT;
logic [1:0]XX, YY;
logic [5:0]IMMED;

//"Decodes" the instruction into function and registers to be used
always_ff@(posedge CLK)
begin
    //If immidiate instruction
    if(INSTR[9])
    begin
		  IMMED <= INSTR[5:0];
		  XX <= INSTR[7:6];
        //If both MSBs are 11
        if(INSTR[8])
            OUTPUT <= 4'b1101;
        else //If MSBs are 10
            OUTPUT <= 4'b1100;
     end
     else //All other functions
	  begin
        OUTPUT <= INSTR[3:0];
		  XX <= INSTR[7:6]; //Sets the RX register based on the instruction from the user
		  YY <= INSTR[5:4]; //Sets the RY register based on the instruction from the user
		  IMMED <= 6'd0;
	  end

end

assign FUNCT = OUTPUT;
assign RX = XX;
assign RY = YY;
assign IMM = IMMED;

endmodule