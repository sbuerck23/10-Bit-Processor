module multiStageALU(
    input logic [9:0]INPUT,
    input logic [3:0]ALUcont,
    input logic CLK, enA, enGin, enGout,
    output logic [9:0]Q
);

logic [9:0]_Gin, _A, X;
logic [3:0]_FN;
	
//A Register
regN Areg( .D(INPUT), .CLKb(CLK), .Rin(enA), .Q(_A) );
	defparam Areg.N = 10; 
		
ALU( .A(_A), .B(INPUT), .FN(ALUcont), .Q(_Gin) );

// G Register
regN Greg( .D(_Gin), .CLKb(CLK), .Rin(enGin), .Q(X) );
	defparam Greg.N = 10;
//TriState Buffer
triStateBuffer( .Rout(enGout), .A(X), .Q(Q) );

endmodule