module upcount2(
	input logic CLR, CLKb,
	output logic [1:0]CNT
);
	
	// negative triggered 2 bit up coutner with active high synchronous clear
	
	always_ff@(negedge CLKb) begin
		if (CLR) CNT <= 2'd0;
		else CNT <= CNT + 2'd1;
	end

endmodule