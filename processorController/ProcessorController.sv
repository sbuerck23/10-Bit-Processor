module ProcessorController(

	// INTPUTS
	input logic [9:0]INSTR, // instruction from register
	input logic [1:0]T,		// current instruction timestep from counter
	
	// OUTPUTS
	output logic [9:0] IMM, 	// immediate value (to ALU?)
	
	// to register file:
	output logic [1:0] Rin,  	// addr for register to be written to
	output logic [1:0] Rout,  	// addr for register to be read from
	ENW,  							// enable - write to reg file
	ENR,  							// enable - read from reg file
	
	// to ALU:
	Ain,  							// enable - save data to intermediate ALU input "A"
	Gin,  							// enable - save data to intermediate ALU output "G"
	Gout,   							// enable - writat data from "G" to shared data bus
	output logic [3:0] ALUcont, // arithemetic operation control
	
	Ext,   							// enable - drive datbus from external "data" signal (to tri state buffer that outputs data bus)
	IRin,   							// enable - save data to instruction reg (to instruction register)
	CLR,  								// clear timestep counter (to counter, and output logic module)
	DONE
);
	
	logic I;
	
	parameter RX = 2'b00;
	parameter RY = 2'b01; // what are the other 2 registers used for?
	
	parameter [3:0]LOAD = 4'd0;
	parameter [3:0]COPY = 4'd1; 
	parameter [3:0]ADD = 4'd2;
	parameter [3:0]SUB = 4'd3;
	parameter [3:0]COMP = 4'd4;
	parameter [3:0]FLIP = 4'd5;
	parameter [3:0]AND = 4'd6;
	parameter [3:0]OR = 4'd7;
	parameter [3:0]XOR = 4'd8;
	parameter [3:0]SFTL = 4'd9;
	parameter [3:0]SFTR = 4'd10;
	parameter [3:0]ARSR = 4'd11;
	parameter [3:0]AIMM = 4'd12;
	parameter [3:0]SIMM = 4'd13;
	
	
	// How many bits of the instruction is used for the instruction, an how much is the data? 
	// not all 10 bits can be the instruction can they?
	// In the below cases, i'm treating a variable I as a 4 bit instrution. i'm not sure which 4 bits of INSTR that is

	assign I = INSTR[3:0]; //(I think this would not work for the immidiate instructions, check my choosingFunction file.)

	
	always_comb begin
		// set signals to default otherwise previous values will be retained
		IMM = 9'd0; Rin = 2'd0; Rout = 2'd0; ENW = 0; ENR = 0; 
		Ain = 0; Gin = 0; Gout = 0; ALUcont = 4'd0; Ext = 0; IRin = 0; CLR = 0; DONE = 1'b0;
		
		case(T)
		
			// define signals in Timestep 0
			2'b00 : begin
				Ext = 1'b1;
				IRin = 1'b1;
			end
			
			// define signals in Timestep 1
			2'b01 : begin
				if( I == LOAD ) begin // here if statements use less expressions than individual cases for each mode
					Ext = 1'b1; // why is this set again here? (I think it is set again to get a value from the user to load to the register)
					ENW = 1'b1; // do these enables get paired with every Rin and Rout? that's what I'm doing right now
					Rin = 1'b1;
				end else if (I == COPY) begin
					ENR = 1'b1;
					ENW = 1'b1;
					Rout = RY;
					Rin = RX;
				end else begin
					Ain = 1'b1;
				end
				
				if (I == COMP | I == FLIP) begin
					ENR = 1'b1;
					Rout = RY;
				end else if (I == AIMM | I == SIMM) begin
					IMM = INSTR; // <- am i doing this right? (I think this would not work because it would 
								 // 							take the register numbers from the instruction and 
								 //                             add that to the immidiate value which we don't want.)
				end else begin
					ENR = 1'b1;
					Rout = RX;
				end
			end
			
			// define signals in Timestep 2
			2'b10 : begin
				Gin = 1'b1; // enabled in every mode
				
				case(I) 
					ADD : begin // #'d2 : begin
						Rout = RY;
						ENR = 1'b1; // ? (Somewhere in all of these we need to enable G to take in data so that 
									//    it stores the result of the ALU. Also I think that the ENR is only used 
									//    to read data from the 4 main registers.)
						ALUcont = ADD;
					end
					SUB : begin
						ENR = 1'b1;
						Rout = RY;
						ALUcont = SUB;
					end
					COMP : begin
						ALUcont = COMP;
					end
					FLIP : begin
						ALUcont = FLIP;
					end
					AND : begin
						ENR = 1'b1;
						Rout = RY;
						ALUcont = AND;
					end
					XOR: begin
						ENR = 1'b1;
						Rout = RY;
						ALUcont = XOR;
					end
					SFTL : begin
						ENR = 1'b1;
						Rout = RY;
						ALUcont = SFTL;
					end
					SFTR : begin
						ENR = 1'b1;
						Rout = RY;
						ALUcont = SFTR;
					end
					AIMM : begin
						ENR = 1'b1;
						Rout = RX;
						ALUcont = AIMM;
					end
					SIMM : begin
						ENR = 1'b1;
						Rout = RX;
						ALUcont = SIMM;
					end
				endcase
			end
			
			// define signals in Timestep 3
			2'b11 : begin
				// true for all modes
				Gout = 1'b1;
				ENR = 1'b1;
				Rin = RX;
				DONE = 1'b1;
			end
			
		endcase
	end

endmodule