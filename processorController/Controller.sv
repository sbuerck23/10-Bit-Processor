module Controller(
		input logic [9:0]INSTR,
		input logic [1:0]TIME,
		input logic CLK,
		output logic [9:0]IMM,
		output logic [1:0]Rin, Rout,
		output logic [3:0]FN,
		output logic ENW, ENR, Ain, Gin, Gout, Ext, INSTin, DONE, enIMM
);

parameter   LOAD = 4'b0000,
            COPY = 4'b0001,
            ADD  = 4'b0010,
            SUB  = 4'b0011,
            INV  = 4'b0100,
            FLP  = 4'b0101,
            AND  = 4'b0110,
            OR   = 4'b0111,
            XOR  = 4'b1000,
            LSL  = 4'b1001,
            LSR  = 4'b1010,
            ASR  = 4'b1011,
            ADDI = 4'b1100,
            SUBI = 4'b1101;

logic [1:0]RX, RY;
logic [5:0]IMMED;

//"Decodes" the instruction into function and registers to be used and immidate value if needed
always_ff@(posedge CLK)
begin
    //If immidiate instruction
    if(INSTR[9])
    begin
		  IMMED <= INSTR[5:0];
		  RX <= INSTR[7:6];
        //If both MSBs are 11
        if(INSTR[8])
            FN <= 4'b1101;
        else //If MSBs are 10
            FN <= 4'b1100;
     end
     else //All other functions
	  begin
        FN <= INSTR[3:0];
		  RX <= INSTR[7:6]; //Sets the RX register based on the instruction from the user
		  RY <= INSTR[5:4]; //Sets the RY register based on the instruction from the user
		  IMMED <= 5'd0;
	  end

end
assign IMM[9:6] = 4'b0000; // for immediate value, last 4 bits of bus are not used
assign IMM[5:0] = IMMED;
				
always_ff@(posedge CLK)
begin
	if(DONE)
	begin
		ENW <= 1'b0;
		ENR <= 1'b0;
		Ain <= 1'b0; 
		Gin <= 1'b0; 
		Gout <= 1'b0; 
		Ext <= 1'b0; 
		INSTin <= 1'b0; 
		DONE <= 1'b0; 
		enIMM <= 1'b0;
	end

	if(TIME == 2'b00)
	begin
		Ext <= 1'b1;
		INSTin <= 1'b1;
	end
	else
	begin
		case(FN)
			LOAD:
				case(TIME)
					2'd1:
					begin
						INSTin <= 1'b0;
						Ext <= 1'b1;
						ENW <= 1'b1;
						Rin <= RX;
						DONE <= 1'b1;
					end
				endcase
			COPY:
				case(TIME)
					2'd1:
					begin
						Rout <= RY;
						Rin <= RX;
						ENR <= 1'b1;
						ENW <= 1'b1;
					end
				endcase
			ADD:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			SUB:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			INV:
				case(TIME)
					2'd1:
					begin
						Rout <= RY;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			FLP:
				case(TIME)
					2'd1:
					begin
						Rout <= RY;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			AND: 
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			OR:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			XOR:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			LSL:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			LSR:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			ASR:
				case(TIME)
					2'd1:
					begin
						Rout <= RX;
						ENR <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RY;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			ADDI:
				case(TIME)
					2'd1:
					begin
						enIMM <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RX;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			SUBI:
				case(TIME)
					2'd1:
					begin
						enIMM <= 1'b1;
						Ain <= 1'b1;
					end
					2'd2:
					begin
						Ain <= 1'b0;
						Rout <= RX;
						ENR <= 1'b1;
						Gin <= 1'b1;
					end
					2'd3:
					begin
						Gin <= 1'b0;
						Gout <= 1'b1;
						Rin <= RX;
						ENW <= 1'b1;
						DONE <= 1'b1;
					end
				endcase
			default:;
		endcase
	end
end								
				
endmodule