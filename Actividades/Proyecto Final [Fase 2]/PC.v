
`timescale 1ns/1ns
//1. Definir modulo con I/O

module PC(
	input clk,
	input reset,
	input [31:0] pc_in,
	output reg [31:0] pc_out
);

//2. Comp. internos = NA


//3. Cuerpo, assigns, instancias y bloques

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		pc_out <= 32'd0;
	end
	else
	begin
		pc_out <= pc_in;
	end
end

endmodule