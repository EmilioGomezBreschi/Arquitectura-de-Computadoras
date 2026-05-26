`timescale 1ns/1ns
//1. Definir modulo con I/O

module MemDatos(
	input [31:0] Address,
	input [31:0] WriteData,
	input We, // escribir
	input Re, // leer
	output reg [31:0] ReadData
);

//2. Comp. internos
reg [31:0] sram[0:127];
integer i;


//3. Cuerpo, assigns, instancias y bloque secuencial

initial
begin
	// Inicializar toda la memoria en cero para evitar X
	for(i = 0; i < 128; i = i + 1)
	begin
		sram[i] = 32'd0;
	end

	// Valores opcionales de prueba
	sram[0] = 32'd100;
	sram[1] = 32'd200;
	sram[2] = 32'd300;
	sram[3] = 32'd400;
	sram[4] = 32'd500;
	sram[5] = 32'd600;
	sram[6] = 32'd700;
end

always @*
begin
	// Valor por defecto para evitar X
	ReadData = 32'd0;

	case({We, Re})
		2'b10:
		begin
			// SW: escribir en memoria
			sram[Address[6:0]] = WriteData;
		end

		2'b01:
		begin
			// LW: leer de memoria
			ReadData = sram[Address[6:0]];
		end

		default:
		begin
			ReadData = 32'd0;
		end
	endcase
end

endmodule
