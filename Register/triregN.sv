module triregN#(
	parameter N = 8 //variable width register
)
(
	input logic [N-1:0] D,
	input logic CLKb, Rin, Rout0, Rout1,
	output logic [N-1:0] Q0, Q1
);

logic [N-1:0] T, Z, X;
	
	//negedge register with synchronous active-high enable
	always_ff@(negedge CLKb)
	begin
		if(Rin)
			T <= D;
		else
			T <= T;			
	end
	
triStateBuffer( .A(T), .Rout(Rout0), .Q(Z) );
triStateBuffer( .A(T), .Rout(Rout1), .Q(X) );	

assign Q0 = Z;
assign Q1 = X;

endmodule 