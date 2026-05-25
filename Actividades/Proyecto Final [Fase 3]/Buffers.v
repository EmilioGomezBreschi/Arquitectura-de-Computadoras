`timescale 1ns/1ns

// BUFFER IF/ID
// Guarda PC + 4 e instruccion
// Etapa: Instruction Fetch -> Instruction Decode

module Buffer_IF_ID(
	input clk,
	input reset,
	input [31:0] pc_in,
	input [31:0] instr_in,
	output reg [31:0] pc_out,
	output reg [31:0] instr_out
);

//2. Comp. internos = NA

//3. Cuerpo, assigns, instancias y bloques

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		pc_out <= 32'd0;
		instr_out <= 32'd0;
	end
	else
	begin
		pc_out <= pc_in;
		instr_out <= instr_in;
	end
end

endmodule

// BUFFER ID/EX
// Guarda señales y datos que salen de Decode
// Etapa: Instruction Decode -> Execute


module Buffer_ID_EX(
	input clk,
	input reset,

	// Señales de control
	input regDst_in,
	input branch_in,
	input memToReg_in,
	input memToWrite_in,
	input memToRead_in,
	input aluSrc_in,
	input regWrite_in,
	input jal_in,
	input [2:0] aluOp_in,

	// Datos
	input [31:0] pc_in,
	input [31:0] read_data1_in,
	input [31:0] read_data2_in,
	input [31:0] sign_ext_in,

	// Campos de instruccion
	input [4:0] rt_in,
	input [4:0] rd_in,
	input [5:0] funct_in,

	// Señales de control de salida
	output reg regDst_out,
	output reg branch_out,
	output reg memToReg_out,
	output reg memToWrite_out,
	output reg memToRead_out,
	output reg aluSrc_out,
	output reg regWrite_out,
	output reg jal_out,
	output reg [2:0] aluOp_out,

	// Datos de salida
	output reg [31:0] pc_out,
	output reg [31:0] read_data1_out,
	output reg [31:0] read_data2_out,
	output reg [31:0] sign_ext_out,

	// Campos de instruccion de salida
	output reg [4:0] rt_out,
	output reg [4:0] rd_out,
	output reg [5:0] funct_out
);

//2. Comp. internos = NA

//3. Cuerpo, assigns, instancias y bloques

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		regDst_out <= 1'b0;
		branch_out <= 1'b0;
		memToReg_out <= 1'b0;
		memToWrite_out <= 1'b0;
		memToRead_out <= 1'b0;
		aluSrc_out <= 1'b0;
		regWrite_out <= 1'b0;
		jal_out <= 1'b0;
		aluOp_out <= 3'b000;

		pc_out <= 32'd0;
		read_data1_out <= 32'd0;
		read_data2_out <= 32'd0;
		sign_ext_out <= 32'd0;

		rt_out <= 5'd0;
		rd_out <= 5'd0;
		funct_out <= 6'd0;
	end
	else
	begin
		regDst_out <= regDst_in;
		branch_out <= branch_in;
		memToReg_out <= memToReg_in;
		memToWrite_out <= memToWrite_in;
		memToRead_out <= memToRead_in;
		aluSrc_out <= aluSrc_in;
		regWrite_out <= regWrite_in;
		jal_out <= jal_in;
		aluOp_out <= aluOp_in;

		pc_out <= pc_in;
		read_data1_out <= read_data1_in;
		read_data2_out <= read_data2_in;
		sign_ext_out <= sign_ext_in;

		rt_out <= rt_in;
		rd_out <= rd_in;
		funct_out <= funct_in;
	end
end

endmodule

// BUFFER EX/MEM
// Guarda resultados que salen de Execute
// Etapa: Execute -> Memory

module Buffer_EX_MEM(
	input clk,
	input reset,

	// Señales de control
	input branch_in,
	input memToReg_in,
	input memToWrite_in,
	input memToRead_in,
	input regWrite_in,
	input jal_in,

	// Datos
	input [31:0] branch_target_in,
	input ifzero_in,
	input [31:0] alu_result_in,
	input [31:0] write_data_in,
	input [4:0] write_register_in,
	input [31:0] link_address_in,

	// Señales de control de salida
	output reg branch_out,
	output reg memToReg_out,
	output reg memToWrite_out,
	output reg memToRead_out,
	output reg regWrite_out,
	output reg jal_out,

	// Datos de salida
	output reg [31:0] branch_target_out,
	output reg ifzero_out,
	output reg [31:0] alu_result_out,
	output reg [31:0] write_data_out,
	output reg [4:0] write_register_out,
	output reg [31:0] link_address_out
);

//2. Comp. internos = NA

//3. Cuerpo, assigns, instancias y bloques

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		branch_out <= 1'b0;
		memToReg_out <= 1'b0;
		memToWrite_out <= 1'b0;
		memToRead_out <= 1'b0;
		regWrite_out <= 1'b0;
		jal_out <= 1'b0;

		branch_target_out <= 32'd0;
		ifzero_out <= 1'b0;
		alu_result_out <= 32'd0;
		write_data_out <= 32'd0;
		write_register_out <= 5'd0;
		link_address_out <= 32'd0;
	end
	else
	begin
		branch_out <= branch_in;
		memToReg_out <= memToReg_in;
		memToWrite_out <= memToWrite_in;
		memToRead_out <= memToRead_in;
		regWrite_out <= regWrite_in;
		jal_out <= jal_in;

		branch_target_out <= branch_target_in;
		ifzero_out <= ifzero_in;
		alu_result_out <= alu_result_in;
		write_data_out <= write_data_in;
		write_register_out <= write_register_in;
		link_address_out <= link_address_in;
	end
end

endmodule


// BUFFER MEM/WB
// Guarda datos que salen de Memory
// Etapa: Memory -> Write Back

module Buffer_MEM_WB(
	input clk,
	input reset,

	// Señales de control
	input memToReg_in,
	input regWrite_in,
	input jal_in,

	// Datos
	input [31:0] read_data_in,
	input [31:0] alu_result_in,
	input [4:0] write_register_in,
	input [31:0] link_address_in,

	// Señales de control de salida
	output reg memToReg_out,
	output reg regWrite_out,
	output reg jal_out,

	// Datos de salida
	output reg [31:0] read_data_out,
	output reg [31:0] alu_result_out,
	output reg [4:0] write_register_out,
	output reg [31:0] link_address_out
);

//2. Comp. internos = NA

//3. Cuerpo, assigns, instancias y bloques

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		memToReg_out <= 1'b0;
		regWrite_out <= 1'b0;
		jal_out <= 1'b0;

		read_data_out <= 32'd0;
		alu_result_out <= 32'd0;
		write_register_out <= 5'd0;
		link_address_out <= 32'd0;
	end
	else
	begin
		memToReg_out <= memToReg_in;
		regWrite_out <= regWrite_in;
		jal_out <= jal_in;

		read_data_out <= read_data_in;
		alu_result_out <= alu_result_in;
		write_register_out <= write_register_in;
		link_address_out <= link_address_in;
	end
end

endmodule