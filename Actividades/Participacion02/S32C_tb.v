// poner el timescale para saber en que correra el codigo
`timescale 1ns/1ns

//inicialicazion de modeulos, inputs y outputs
module S32C_tb();

// incicializar registros y wires
reg [31:0]A_tb;
reg [31:0]B_tb;
wire [31:0]C_tb;

//instanciar
	
S32C Test(
	.A(A_tb),
	.B(B_tb),
	.C(C_tb)
);

// inicio del test bench y poner valores

initial begin
	A_tb = 0;
	B_tb = 0;
	A_tb = 10; B_tb = 5; #10;
	A_tb = 100; B_tb = 50; #10;
	A_tb = 255; B_tb = 1; #10;
	A_tb = 1000; B_tb = 500; #10;
	A_tb = 5000; B_tb = 1234; #10;
	A_tb = 0; B_tb = 0; #10;
	A_tb = 1; B_tb = 1; #10;
	A_tb = 32767; B_tb = 2; #10;
	A_tb = 65535; B_tb = 10; #10;
	A_tb = 99999; B_tb = 11111; #10;

	A_tb = -1; B_tb = 1; #10;
	A_tb = -5; B_tb = -10; #10;
	A_tb = -100; B_tb = 50; #10;
	A_tb = 200; B_tb = -75; #10;
	A_tb = -1000; B_tb = -500; #10;
	A_tb = -32768; B_tb = 1; #10;
	A_tb = 2147483647; B_tb = -1; #10;
	A_tb = -2147483648; B_tb = 1; #10;
	A_tb = -9999; B_tb = 9999; #10;
	A_tb = -123456; B_tb = -654321; #10;
end

endmodule

