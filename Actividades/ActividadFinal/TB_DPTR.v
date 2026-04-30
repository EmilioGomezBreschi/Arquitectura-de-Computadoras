
`timescale 1ns/1ns
//1. Definir modulo con I/O
module TB_DPTR;

//2. definen comp. internos Reg o wires
reg [31:0] instr;

wire [31:0] alu_result;
wire [31:0] data_mem_out;
wire [31:0] write_back_data;
wire [31:0] read_data1;
wire [31:0] read_data2;

//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

DPTR uut(
	.instr(instr),
	.alu_result(alu_result),
	.data_mem_out(data_mem_out),
	.write_back_data(write_back_data),
	.read_data1(read_data1),
	.read_data2(read_data2)
);

initial begin

	// ADD
	//200 + 300 = 500
	instr = {6'b000000, 5'd1, 5'd2, 5'd7, 5'd0, 6'b100000};
	#10;

	//400 + 500 = 900
	instr = {6'b000000, 5'd3, 5'd4, 5'd8, 5'd0, 6'b100000};
	#10;

	// SUB
	//600 - 200 = 400
	instr = {6'b000000, 5'd5, 5'd1, 5'd9, 5'd0, 6'b100010};
	#10;

	//700 - 300 = 400
	instr = {6'b000000, 5'd6, 5'd2, 5'd10, 5'd0, 6'b100010};
	#10;

	// AND
	// and r11, r1, r3
	instr = {6'b000000, 5'd1, 5'd3, 5'd11, 5'd0, 6'b100100};
	#10;

	// and r12, r4, r6
	instr = {6'b000000, 5'd4, 5'd6, 5'd12, 5'd0, 6'b100100};
	#10;

	// OR
	// or r13, r1, r2
	instr = {6'b000000, 5'd1, 5'd2, 5'd13, 5'd0, 6'b100101};
	#10;

	// or r14, r3, r5
	instr = {6'b000000, 5'd3, 5'd5, 5'd14, 5'd0, 6'b100101};
	#10;

	// SLT
	//200 < 300 => 1
	instr = {6'b000000, 5'd1, 5'd2, 5'd15, 5'd0, 6'b101010};
	#10;

	//700 < 600 => 0
	instr = {6'b000000, 5'd6, 5'd5, 5'd16, 5'd0, 6'b101010};
	#10;

	$stop;
end

endmodule