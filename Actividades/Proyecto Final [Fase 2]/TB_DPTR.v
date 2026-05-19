`timescale 1ns/1ns
//1. Definir modulo con I/O

module TB_DPTR;

//2. definen comp. internos Reg o wires
reg clk;
reg reset;

wire [31:0] instr;
wire [31:0] pc_actual;
wire [31:0] pc_siguiente;
wire pc_src;

wire [31:0] alu_result;
wire [31:0] data_mem_out;
wire [31:0] write_back_data;
wire [31:0] read_data1;
wire [31:0] read_data2;

// Memoria de instrucciones para el testbench
reg [31:0] mem_instr[0:31];

integer i;


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

// La instruccion que entra al DPTR depende del PC actual
assign instr = mem_instr[pc_actual[6:2]];

DPTR uut(
	.clk(clk),
	.reset(reset),
	.instr(instr),

	.pc_actual(pc_actual),
	.pc_siguiente(pc_siguiente),
	.pc_src(pc_src),

	.alu_result(alu_result),
	.data_mem_out(data_mem_out),
	.write_back_data(write_back_data),
	.read_data1(read_data1),
	.read_data2(read_data2)
);

// Generador de reloj
always
begin
	clk = 1'b0; #5;
	clk = 1'b1; #5;
end

initial
begin
	// Inicializar memoria de instrucciones en NOP
	for(i = 0; i < 32; i = i + 1)
	begin
		mem_instr[i] = 32'h00000000;
	end

	// ====================================================
	// Programa de prueba Fase 2
	// ====================================================
	// 0:  nop
	mem_instr[0] = 32'h00000000;

	// 4:  addi $t0, $zero, 10
	// R8 = 10
	mem_instr[1] = 32'h2008000A;

	// 8:  slti $t1, $zero, 10
	// R9 = 1 porque 0 < 10
	mem_instr[2] = 32'h2809000A;

	// 12: andi $t2, $zero, 10
	// R10 = 0 porque 0 & 10 = 0
	mem_instr[3] = 32'h300A000A;

	// 16: ori $t3, $zero, 10
	// R11 = 10 porque 0 | 10 = 10
	mem_instr[4] = 32'h340B000A;

	// 20: sw $t0, 0($zero)
	// MEM[0] = R8 = 10
	mem_instr[5] = 32'hAC080000;

	// 24: lw $t4, 0($zero)
	// R12 = MEM[0] = 10
	mem_instr[6] = 32'h8C0C0000;

	// 28: beq $zero, $zero, inicio
	// PC + 4 = 32
	// destino = 4
	// offset = (4 - 32) / 4 = -7 = FFF9
	mem_instr[7] = 32'h1000FFF9;

	// 32: nop
	mem_instr[8] = 32'h00000000;

	reset = 1'b1;
	#12;

	reset = 1'b0;

	// Se deja correr más tiempo porque ahora hay buffers/pipeline
	#220;
	$stop;
end

endmodule