`timescale 1ns/1ns

module ALU_tb;

reg  [15:0] A;
reg  [15:0] B;

wire [15:0] SUMA;
wire [15:0] RESTA;
wire [31:0] MULT;
wire [15:0] DIV;
wire [15:0] AND_OP;
wire [15:0] OR_OP;
wire [15:0] SHL1;
wire [15:0] XOR_OP;

ALU uut (
    .A(A),
    .B(B),
    .SUMA(SUMA),
    .RESTA(RESTA),
    .MULT(MULT),
    .DIV(DIV),
    .AND_OP(AND_OP),
    .OR_OP(OR_OP),
    .SHL1(SHL1),
    .XOR_OP(XOR_OP)
);

initial begin
    A = 16'd10; B = 16'd5; #10;
    A = 16'd20; B = 16'd4; #10;
    A = 16'd15; B = 16'd3; #10;
    A = 16'd8;  B = 16'd2; #10;
    A = 16'd7;  B = 16'd0; #10;
	
	$stop;
end

endmodule
