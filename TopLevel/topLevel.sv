module topLevel(
    input logic [9:0]INPUTDATA, //All Switches
    input logic CLK, RAWCLK, RAWPEEK, //All Buttons
    output logic [9:0]DATABUS, //All LEDS
    output logic [6:0] HEX0, HEX1, HEX2, THEX, //Data Bus/Register Peek (HEX2:0)
    output logic DONE //Decimal Point on HEX5
);

logic [9:0]DATA, _inst, _Q1;
logic [3:0]FUNCT;
logic [1:0]_Rin, _Rout, COUNT;
logic enA, enGin, enGout, _DONE, INSTin, Ext, _ENW, _ENR, CLKb, PEEKb;

//Buffer for the input data
triStateBuffer( .Rout(Ext), .A(INPUTDATA), .Q(DATA) );

//Debounce the CLK and PEEK buttons
debouncer( .A(CLKb), .A_noisy(RAWCLK), .CLK50M(CLK) );
debouncer( .A(PEEKb), .A_noisy(RAWPEEK), .CLK50M(CLK) );

//ALU Module
multiStageALU( .INPUT(DATA), .ALUcont(FUNCT), .CLK(CLKb), .enA(enA), .enGin(enGin), 
               .enGout(enGout), .Q(DATA) );

//Instruction Register
instrReg( .D(DATA), .EN(INSTin), .CLKb(CLKb), .Q(_inst) );

//Processor Controller
finalController( .INSTR(_inst), .TIME(COUNT), .IMM(DATA), .Rin(_Rin), .Rout(_Rout), 
                 .ENW(_ENW), .ENR(_ENR), .Ain(enA), .Gin(enGin), .Gout(enGout), .ALUcont(FUNCT), 
                 .Ext(Ext), .IRin(INSTin), .Clr(_DONE) );

//Registers
registerFile( .D(DATA), .ENW(_ENW), .ENR0(_ENR), .ENR1(1'b1), .CLKb(CLKb), .WRA(_Rin), .RDA0(_Rout), 
              .RDA1(INPUTDATA[1:0]), .Q0(DATA), .Q1(_Q1) );

//Output Logic
outputLogic( .BUS(DATA), .REG(_Q1), .TIME(COUNT), .PEEKb(PEEKb), .DONE(_DONE), .LEDB(DATABUS), 
             .DHEX0(HEX0), .DHEX1(HEX1), .DHEX2(HEX2), .THEX(THEX), .LED_DONE(DONE) );

//Counter
upcount2( .CLR(_DONE), .CLKb(CLKb), .CNT(COUNT) );

endmodule