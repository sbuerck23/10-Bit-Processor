module ALU(
        input logic [9:0]A, 
        input logic [9:0]B, 
        input logic [3:0]FN,
        output logic [9:0]Q
);

logic [9:0]RES;

parameter   LOAD = 4'b0000,
            COPY = 4'b0001,
            ADD  = 4'b0010,
            SUB  = 4'b0011,
            INV  = 4'b0100,
            FLP  = 4'b0101,
            AND  = 4'b0110,
            OR   = 4'b0111,
            XOR  = 4'b1000,
            LSL  = 4'b1001,
            LSR  = 4'b1010,
            ASR  = 4'b1011;

always_comb
begin
    RES = 10'd0;
    //all functions
    case(FN)
        ADD:
            RES = A + B;
        SUB:
            RES = A - B;
        INV:
            RES = -A;
        FLP:
            RES = ~A;
        AND:
            RES = A & B;
        OR:
            RES = A | B;
        XOR:
            RES = A ^ B;
        LSL:
            RES = A << B;
        LSR:
            RES = A >> B;
        ASR:
            RES = $signed(A) >>> B;
        default:;
    endcase
end

assign Q = RES;

endmodule