`timescale 1ns/1ns
//1. Definir modulo con I/O
module alu(
	input [2:0] ALUctl,
	input [31:0] A,
	input [31:0] B,
	output reg [31:0] result
);

//2. definen comp. internos Reg o wires


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

always @*
begin
	case(ALUctl)
		3'b000: result = A & B;                           // AND
		3'b001: result = A | B;                           // OR
		3'b010: result = A + B;                           // ADD
		3'b100: result = ~(A | B);                        // NOR
		3'b110: result = A - B;                           // SUB
		3'b111: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; 	 // SLT
		default: result = 32'd0;
	endcase
end

endmodule