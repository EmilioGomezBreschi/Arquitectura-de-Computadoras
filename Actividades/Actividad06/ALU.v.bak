module ALU (
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] SUMA,
    output [15:0] RESTA,
    output [31:0] MULT,
    output [15:0] DIV,
    output [15:0] AND_OP,
    output [15:0] OR_OP,
    output [15:0] SHL1,
    output [15:0] XOR_OP
);

assign SUMA  = A + B;
assign RESTA = A - B;
assign MULT  = A * B;
assign DIV   = (B != 0) ? (A / B) : 16'b0;

assign AND_OP = A & B;
assign OR_OP  = A | B;
assign XOR_OP = A ^ B;

assign SHL1 = A << 1;

endmodule
