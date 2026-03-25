//1. Declaracion de modulo y sus I/O
module ram(
	input [4:0] addr,
	input [31:0] data_in,
	input EN,
	output [31:0] data_out
);

//2. Cables o registros
reg [31:0] mem [0:31];

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial

// Escritura controlada por EN
always @(*) begin
	if (EN) begin
		mem[addr] = data_in;
	end
end

// Lectura asincrona
assign data_out = mem[addr];

endmodule
