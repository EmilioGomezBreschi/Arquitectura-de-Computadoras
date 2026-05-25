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
wire jump_out;
wire [31:0] jump_address_out;

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

assign instr = mem_instr[pc_actual[6:2]];

DPTR uut(
	.clk(clk),
	.reset(reset),
	.instr(instr),

	.pc_actual(pc_actual),
	.pc_siguiente(pc_siguiente),
	.pc_src(pc_src),
	.jump_out(jump_out),
	.jump_address_out(jump_address_out),

	.alu_result(alu_result),
	.data_mem_out(data_mem_out),
	.write_back_data(write_back_data),
	.read_data1(read_data1),
	.read_data2(read_data2)
);

// Reloj
always
begin
	clk = 1'b0; #5;
	clk = 1'b1; #5;
end

initial
begin
	for(i = 0; i < 32; i = i + 1)
	begin
		mem_instr[i] = 32'h00000000;
	end

	// PC 0: nop
	mem_instr[0] = 32'h00000000;

	// PC 4: addi $t0, $zero, 10
	// R8 = 10
	mem_instr[1] = 32'h2008000A;

	// PC 8: j 20
	// Salta a direccion 20
	// target = 20 / 4 = 5
	mem_instr[2] = 32'h08000005;

	// PC 12: nop
	mem_instr[3] = 32'h00000000;

	// PC 16: nop
	mem_instr[4] = 32'h00000000;

	// PC 20: ori $t1, $zero, 5
	// R9 = 5
	mem_instr[5] = 32'h34090005;

	// PC 24: slti $t2, $zero, 10
	// R10 = 1
	mem_instr[6] = 32'h280A000A;

	// PC 28: sw $t0, 0($zero)
	// MEM[0] = R8 = 10
	mem_instr[7] = 32'hAC080000;

	// PC 32: lw $t4, 0($zero)
	// R12 = MEM[0] = 10
	mem_instr[8] = 32'h8C0C0000;

	// PC 36: beq $zero, $zero, 44
	// PC + 4 = 40
	// target = 44
	// offset = (44 - 40) / 4 = 1
	mem_instr[9] = 32'h10000001;

	// PC 40: nop
	mem_instr[10] = 32'h00000000;

	// PC 44: ori $t5, $zero, 7
	// R13 = 7
	mem_instr[11] = 32'h340D0007;

	// PC 48: nop
	mem_instr[12] = 32'h00000000;

	reset = 1'b1;
	#12;

	reset = 1'b0;

	$stop;
end

endmodule