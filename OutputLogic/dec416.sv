module dec416(input logic [3:0]A, output logic [15:0]Y);
	// 4:16 decoder used in seven segment display
	assign Y[0] = ~A[3] & ~A[2] & ~A[1] & ~A[0];
	assign Y[1] = ~A[3] & ~A[2] & ~A[1] & A[0];
	assign Y[2] = ~A[3] & ~A[2] & A[1] & ~A[0];
	assign Y[3] = ~A[3] & ~A[2] & A[1] & A[0];
	
	assign Y[4] = ~A[3] & A[2] & ~A[1] & ~A[0];
	assign Y[5] = ~A[3] & A[2] & ~A[1] & A[0];
	assign Y[6] = ~A[3] & A[2] & A[1] & ~A[0];
	assign Y[7] = ~A[3] & A[2] & A[1] & A[0];
	
	assign Y[8] = A[3] & ~A[2] & ~A[1] & ~A[0];
	assign Y[9] = A[3] & ~A[2] & ~A[1] & A[0];
	assign Y[10] = A[3] & ~A[2] & A[1] & ~A[0];
	assign Y[11] = A[3] & ~A[2] & A[1] & A[0];
	
	assign Y[12] = A[3] & A[2] & ~A[1] & ~A[0];
	assign Y[13] = A[3] & A[2] & ~A[1] & A[0];
	assign Y[14] = A[3] & A[2] & A[1] & ~A[0];
	assign Y[15] = A[3] & A[2] & A[1] & A[0];

endmodule