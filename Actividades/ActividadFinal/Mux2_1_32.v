
//1. Declaracion de modulo y sus I/O
module Mux2_1_32(
	input [31:0] D0,
	input [31:0] D1,
	input sel,
	output [31:0] Y
);

//2. Cables o registros

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
assign Y = (sel == 1'b0) ? D0 : D1;

endmodule