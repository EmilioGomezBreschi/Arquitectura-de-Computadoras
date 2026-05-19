`timescale 1ns/1ns
//1. Definir modulo con I/O

module Mux2_1_5(
	input [4:0] D0,
	input [4:0] D1,
	input sel,
	output [4:0] Y
);

//2. Comp. internos = NA


//3. Cuerpo, assigns, instancias y bloques

assign Y = (sel == 1'b0) ? D0 : D1;

endmodule
