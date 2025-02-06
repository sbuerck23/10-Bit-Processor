module regN#(
	parameter N = 8 //variable width register
)
(
	input logic [N-1:0] D,
	input logic CLKb, Rin,
	output logic [N-1:0] Q
);

logic [N-1:0] T;
	
	//negedge register with synchronous active-high enable
	always_ff@(negedge CLKb)
	begin
		if(Rin)
			T <= D;
		else
			T <= T;			
	end
	
assign Q = T;
endmodule 