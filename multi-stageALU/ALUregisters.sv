module ALUregisters#(
	parameter N = 10 //variable width register
)
(
	input logic [N-1:0] D,
	input logic CLKb, EN,
	output logic [N-1:0] Q
);

logic [N-1:0]T;
	
	//negedge register with synchronous active-high enable
	always_ff@(negedge CLKb)
	begin
		if(EN)
			T <= D;
		else
			T <= T;			
	end

assign Q = T;
	
endmodule 