//1.Declaracion de modulo y sus I/O
module HA(
	input a,
	input b,
	output s,
	output c
);
//2. Cables o registros
//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
assign s = a ^ b;
assign c = a & b;

endmodule
