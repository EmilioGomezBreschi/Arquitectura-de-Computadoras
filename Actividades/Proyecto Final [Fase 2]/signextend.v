
`timescale 1ns/1ns
//1. Definir modulo con I/O

module signextend(
	input [15:0] in,
	output [31:0] out
);

//2. Comp. internos = NA


//3. Cuerpo, assigns, instancias y bloques

assign out = {{16{in[15]}}, in};

endmodule