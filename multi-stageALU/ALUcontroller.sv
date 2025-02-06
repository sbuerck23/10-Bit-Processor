module ALUcontroller(
        input logic [9:0]INPUT,
        input logic CLK, enA, enGin, enGout,
        output logic [9:0]_A, _Gin, _Gout
);

ALUregisters Areg( .D(INPUT), .CLKb(CLK), .EN(enA), .Q(_A) );
	defparam Areg.N = 10; 

logic [9:0]X;
regN Greg( .D(_Gin), .CLKb(CLK), .Rin(enGin), .Q(X) );
	defparam Greg.N = 10;
triStateBuffer( .Rout(enGout), .A(X), .Q(_Gout) );


endmodule