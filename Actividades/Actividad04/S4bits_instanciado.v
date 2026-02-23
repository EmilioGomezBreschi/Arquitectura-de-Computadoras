
//1.Declaracion de modulo y sus I/O
module S4bits_instanciado(
	input [3:0]X,
	input [3:0]Y,
	input Cin,
	output [4:0]W
);
//2. Cables o registros
wire c1;
wire c2;
wire c3;


//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
FA F0(
	.A(X[0]),
	.B(Y[0]),
	.CIN(Cin),
	.S(W[0]),
	.COUT(c1)
);
FA F1(
	.A(X[1]),
	.B(Y[1]),
	.CIN(c1),
	.S(W[1]),
	.COUT(c2)
);
FA F2(
	.A(X[2]),
	.B(Y[2]),
	.CIN(c2),
	.S(W[2]),
	.COUT(c3)
);
FA F3(
	.A(X[3]),
	.B(Y[3]),
	.CIN(c3),
	.S(W[3]),
	.COUT(W[4])
);
endmodule