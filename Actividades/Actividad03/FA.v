//1.Declaracion de modulo y sus I/O
module FA (
	input A,
	input B,
	input CIN,
	output S,
	output COUT
);
//2. Cables o registros
wire S1;
wire C1;
wire C2;

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
HA half_adder(
	.a(A),
	.b(B),
	.s(S1),
	.c(C1)
);

HA full_adder(
	.a(S1),
	.b(CIN),
	.s(S),
	.c(C2)
	
);

assign COUT = C1 | C2;

endmodule