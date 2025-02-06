module instrReg(
	input logic [9:0]D,
	input logic EN, CLKb,
	output logic [9:0]Q
);

	// negedge 10 bit register with synchronous active-high enable
	always_ff@(negedge CLKb)
	begin
		if(EN)
			Q <= D;
		else
			Q <= Q;
	end

endmodule