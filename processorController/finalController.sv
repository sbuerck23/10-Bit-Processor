module finalController(
	input logic [9:0]INSTR,
	input logic [1:0]TIME,
	output tri [9:0]IMM,
	output logic [1:0]Rin, Rout, 
    output logic [3:0]ALUcont,
	output logic ENW, ENR, Ain, Gin, Gout, Ext, IRin, Clr
);

logic [1:0]RX, RY;
logic [3:0]FN;

parameter   LOAD = 4'b0000, COPY = 4'b0001, ADD  = 4'b0010, SUB  = 4'b0011,
            INV  = 4'b0100, FLP  = 4'b0101, AND  = 4'b0110, OR   = 4'b0111,
            XOR  = 4'b1000, LSL  = 4'b1001, LSR  = 4'b1010, ASR  = 4'b1011;

//"Decode" the instruction into function and registers to be used
assign FN = INSTR[3:0]; //Sets the function based on the instruction from the user
assign RY = INSTR[5:4]; //Sets the RY register based on the instruction from the user
assign RX = INSTR[7:6]; //Sets the RX register based on the instruction from the user

always_comb
begin
//Default values
Rin = 2'b00; Rout = 2'b00; ALUcont = 4'b0000;
ENW = 1'b0; ENR = 1'b0; Ain = 1'b0; Gin = 1'b0;
Gout = 1'b0; Ext = 1'b0; IRin = 1'b0; Clr = 1'b0;
IMM = 10'bz;
	
	case(TIME)
		2'b00:
		begin
			Ext = 1'b1; IRin = 1'b1;
		end
		2'b01:
			begin	
			if (INSTR[9]) 
			begin
				Rout = RX; ENR = 1'b1; Ain = 1'b1;	
			end
			else 
				case (FN)
					LOAD:
					begin
						Ext = 1'b1; Rin = RX; ENW = 1'b1; Clr = 1'b1;
					end
					COPY:
					begin
						Rout = RY; Rin = RX; ENR = 1'b1; ENW = 1'b1; Clr = 1'b1;
					end
					ADD, SUB, AND, OR, XOR, LSL, LSR, ASR:
					begin
						Rout = RX; ENR = 1'b1; Ain = 1'b1;
					end
					FLP:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = FLP;
					end
					INV:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = INV;
					end
					default:;
			endcase
		end
		2'b10:
		begin
			if (INSTR[9]) 
			begin
				Gin = 1'b1; IMM = {4'd0, INSTR[5:0]};
				if(INSTR[8])
					ALUcont = SUB;
				else	
					ALUcont = ADD;
			end
			else
				case (FN)
					ADD:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = ADD;
					end
					SUB:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = SUB;
					end
					AND:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = AND;
					end
					OR:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = OR;
					end
					XOR:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = XOR;
					end
					LSL:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = LSL;
					end
					LSR:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = LSR;
					end
					ASR:
					begin
						Rout = RY; ENR = 1'b1; Gin = 1'b1; ALUcont = ASR;
					end
					FLP, INV:
						begin
							Rin = RX; ENW = 1'b1; Gout = 1'b1; Clr = 1'b1;
						end
					default:;
				endcase
		end
		2'b11:
			begin
				Gout = 1'b1; Rin = RX; ENW = 1'b1; Clr = 1'b1;
			end
		default:;
	endcase
end

endmodule