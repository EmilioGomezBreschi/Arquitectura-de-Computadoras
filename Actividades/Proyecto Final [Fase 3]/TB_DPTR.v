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
wire jal_out;
wire [31:0] jump_address_out;
wire [31:0] ra_data_out;

wire [31:0] alu_result;
wire [31:0] data_mem_out;
wire [31:0] write_back_data;
wire [31:0] read_data1;
wire [31:0] read_data2;

// Memoria de instrucciones para el testbench
// Formato del profesor: 8 bits por linea
reg [7:0] mem_instr[0:255];

integer i;


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

// Se arma una instruccion de 32 bits usando 4 bytes consecutivos
assign instr = {
	mem_instr[pc_actual],
	mem_instr[pc_actual + 1],
	mem_instr[pc_actual + 2],
	mem_instr[pc_actual + 3]
};

DPTR uut(
	.clk(clk),
	.reset(reset),
	.instr(instr),

	.pc_actual(pc_actual),
	.pc_siguiente(pc_siguiente),
	.pc_src(pc_src),
	.jump_out(jump_out),
	.jal_out(jal_out),
	.jump_address_out(jump_address_out),
	.ra_data_out(ra_data_out),

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
	// Inicializar memoria en ceros para evitar X
	for(i = 0; i < 256; i = i + 1)
	begin
		mem_instr[i] = 8'b00000000;
	end

	// Cargar archivo .mem en binario de 8 bits por linea
	$readmemb("TestF3_MemInst.mem", mem_instr);

	reset = 1'b1;
	#12;

	reset = 1'b0;

	// Tiempo suficiente para ejecutar el programa completo con buffers
	#800;

	$stop;
end

endmodule