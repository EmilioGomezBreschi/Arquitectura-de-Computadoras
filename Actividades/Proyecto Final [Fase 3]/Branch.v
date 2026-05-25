`timescale 1ns/1ns
//1. Definir modulo con I/O

module Branch(
	input branch,
	input ifzero,
	output pc_src
);

//2. Comp. internos = NA


//3. Cuerpo, assigns, instancias y bloques

assign pc_src = branch & ifzero;

endmodule
