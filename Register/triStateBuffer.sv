module triStateBuffer(
		input logic Rout, 
		input logic [9:0]A,
		output logic [9:0]Q
);

always_comb
begin
	if(Rout)
		Q <= A;
	else
		Q <= 10'bzzzzzzzzzz;
end

endmodule