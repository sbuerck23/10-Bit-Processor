module registerFile (
		input logic [9:0] D,
		input logic ENW, ENR0, ENR1, CLKb,
		input logic [1:0] WRA, RDA0, RDA1,
		output logic [9:0] Q0, Q1
);

	//need to decode the read/write addresses
	//ENR + RDA -> Rout[3:0]
	logic [3:0] Rout0, Rout1;
	always_comb
	begin
		case ({ENR0, RDA0})
			3'b100: Rout0 = 4'b0001;
			3'b101: Rout0 = 4'b0010;
			3'b110: Rout0 = 4'b0100;
			3'b111: Rout0 = 4'b1000;	
			default: Rout0 = 4'b0000;
		endcase
		case ({ENR1, RDA1})
			3'b100: Rout1 = 4'b0001;
			3'b101: Rout1 = 4'b0010;
			3'b110: Rout1 = 4'b0100;
			3'b111: Rout1 = 4'b1000;	
			default: Rout1 = 4'b0000;
		endcase	
	end
	
	//ENW + WRA -> Rin[3:0]
	logic [3:0] Rin;
	always_comb
	begin
		case ({ENW, WRA})
			3'b100: Rin = 4'b0001;
			3'b101: Rin = 4'b0010;
			3'b110: Rin = 4'b0100;
			3'b111: Rin = 4'b1000;
			default: Rin = 4'b0000;
		endcase
	end

triregN R0( .D(D), .Rin(Rin[0]), .Rout0(Rout0[0]), .Rout1(Rout1[0]), .CLKb(CLKb), .Q0(Q0), .Q1(Q1) );
	defparam R0.N = 10;
triregN R1( .D(D), .Rin(Rin[1]), .Rout0(Rout0[1]), .Rout1(Rout1[1]), .CLKb(CLKb), .Q0(Q0), .Q1(Q1) );
	defparam R1.N = 10;
triregN R2( .D(D), .Rin(Rin[2]), .Rout0(Rout0[2]), .Rout1(Rout1[2]), .CLKb(CLKb), .Q0(Q0), .Q1(Q1) );
	defparam R2.N = 10;
triregN R3( .D(D), .Rin(Rin[3]), .Rout0(Rout0[3]), .Rout1(Rout1[3]), .CLKb(CLKb), .Q0(Q0), .Q1(Q1) );
	defparam R3.N = 10;


endmodule
