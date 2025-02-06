module seven_seg(input logic [3:0]D, output logic [6:0]S);
	logic [15:0]B;

	// 4:16 decoder
	dec416 decode(.A(D), .Y(B));
	
	// active low seven segment display
	assign S[0] = ~(B[0] | B[2] |B[3] | B[5] | B[6] | B[7]|B[8]|B[9]|B[10] | B[12] | B[14] | B[15]);
	assign S[1] = ~(B[0] |B[1] |B[2] |B[3] |B[4] | B[7] |B[8] |B[9] |B[10] | B[13]);
	assign S[2] = ~(B[0] |B[1] | B[3] |B[4] |B[5] |B[6] |B[7] |B[8] |B[9] |B[10] |B[11] | B[13]);
	assign S[3] = ~(B[0] | B[2] |B[3] | B[5] |B[6] | B[8] | B[11] |B[12] |B[13] |B[14]);
	assign S[4] = ~(B[0] | B[2] | B[6] | B[8] | B[10] |B[11] |B[12] |B[13] |B[14] |B[15]);
	assign S[5] = ~(B[0] | B[4] |B[5] |B[6] | B[8] |B[9] |B[10] |B[11] |B[12] | B[14] |B[15]);
	assign S[6] = ~(B[2] |B[3] |B[4] |B[5] |B[6] |B[8] |B[9] |B[10] |B[11] |B[13] |B[14] |B[15]);
	
endmodule
