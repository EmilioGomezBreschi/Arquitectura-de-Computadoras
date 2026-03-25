//1. Declaracion de modulo y sus I/O
module demux(
	input [31:0] in,
	input sel,
	output reg [31:0] out0,
	output reg [31:0] out1
);

//2. Cables o registros

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
always @(*) begin
	if (sel == 1'b0) begin
		out0 = in;
		out1 = 32'b0;
	end else begin
		out0 = 32'b0;
		out1 = in;
	end
end

endmodule