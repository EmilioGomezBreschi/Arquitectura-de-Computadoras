`timescale 1ns/1ns
//1. Definir modulo con I/O

module BR(
	input [4:0] AR1,
	input [4:0] AR2,
	input [4:0] AW,
	input [31:0] DW,
	input RegWrite, //Enable to Write
	output reg [31:0] DR1,
	output reg [31:0] DR2
);

//2. definen comp. internos Reg o wires
reg [31:0] carnita[0:31];
integer i;


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

initial
begin
	// Inicializar todos los registros en cero
	for(i = 0; i < 32; i = i + 1)
	begin
		carnita[i] = 32'd0;
	end

	// En MIPS, $zero siempre debe valer 0
	carnita[0] = 32'd0;
end

// Lectura de dos registros
always @*
begin
	DR1 = carnita[AR1];
	DR2 = carnita[AR2];
end

// Escritura en el registro destino
always @*
begin
	if(RegWrite && AW != 5'd0)
	begin
		carnita[AW] = DW;
	end

	// Proteger $zero
	carnita[0] = 32'd0;
end

endmodule