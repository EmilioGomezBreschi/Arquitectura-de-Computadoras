`timescale 1ns/1ns
//1. Definir modulo con I/O

module DPTR(
	input clk,
	input reset,
	input [31:0] instr,

	output [31:0] pc_actual,
	output [31:0] pc_siguiente,
	output pc_src,
	output jump_out,
	output [31:0] jump_address_out,

	output [31:0] alu_result,
	output [31:0] data_mem_out,
	output [31:0] write_back_data,
	output [31:0] read_data1,
	output [31:0] read_data2
);

//2. definen comp. internos Reg o wires

// IF

wire [31:0] pc_out;
wire [31:0] pc_plus_4;
wire [31:0] pc_next;
wire [31:0] pc_branch;
wire [31:0] jump_address;

// IF/ID

wire [31:0] ifid_pc;
wire [31:0] ifid_instr;


// Campos de instruccion en ID

wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] funct;
wire [15:0] inmediato;
wire [25:0] jump_index;


// Señales de control en ID

wire regDst;
wire jump;
wire branch;
wire memToReg;
wire memToWrite;
wire memToRead;
wire aluSrc;
wire regWrite;
wire [2:0] aluOp;


// Banco de registros en ID

wire [31:0] br_out1;
wire [31:0] br_out2;


// Sign extend

wire [31:0] inmediato_extendido;
wire [31:0] inmediato_zero;
wire [31:0] inmediato_final;


// ID/EX

wire idex_regDst;
wire idex_branch;
wire idex_memToReg;
wire idex_memToWrite;
wire idex_memToRead;
wire idex_aluSrc;
wire idex_regWrite;
wire [2:0] idex_aluOp;

wire [31:0] idex_pc;
wire [31:0] idex_read_data1;
wire [31:0] idex_read_data2;
wire [31:0] idex_sign_ext;

wire [4:0] idex_rt;
wire [4:0] idex_rd;
wire [5:0] idex_funct;


// EX

wire [2:0] alu_ctrl_out;
wire [31:0] alu_b;
wire [31:0] alu_out;
wire ifzero;
wire [31:0] branch_offset;
wire [31:0] branch_target_ex;
wire [4:0] write_register_ex;


// EX/MEM

wire exmem_branch;
wire exmem_memToReg;
wire exmem_memToWrite;
wire exmem_memToRead;
wire exmem_regWrite;

wire [31:0] exmem_branch_target;
wire exmem_ifzero;
wire [31:0] exmem_alu_result;
wire [31:0] exmem_write_data;
wire [4:0] exmem_write_register;


// MEM

wire [31:0] mem_read_data;


// MEM/WB

wire memwb_memToReg;
wire memwb_regWrite;

wire [31:0] memwb_read_data;
wire [31:0] memwb_alu_result;
wire [4:0] memwb_write_register;


// WB

wire [31:0] mux_wb_out;

// NOP
wire is_nop_id;
wire regWrite_id_final;


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales


// IF - PC y PC + 4


assign pc_plus_4 = pc_out + 32'd4;

// Primero se decide si hay branch
assign pc_branch = (pc_src === 1'b1) ? exmem_branch_target : pc_plus_4;

// Luego se decide si hay jump
assign pc_next = (jump === 1'b1) ? jump_address : pc_branch;

PC PC0(
	.clk(clk),
	.reset(reset),
	.pc_in(pc_next),
	.pc_out(pc_out)
);


// BUFFER IF/ID


Buffer_IF_ID IF_ID(
	.clk(clk),
	.reset(reset),
	.pc_in(pc_plus_4),
	.instr_in(instr),
	.pc_out(ifid_pc),
	.instr_out(ifid_instr)
);


// ID - Separacion de instruccion


assign op         = ifid_instr[31:26];
assign rs         = ifid_instr[25:21];
assign rt         = ifid_instr[20:16];
assign rd         = ifid_instr[15:11];
assign shamt      = ifid_instr[10:6];
assign funct      = ifid_instr[5:0];
assign inmediato  = ifid_instr[15:0];
assign jump_index = ifid_instr[25:0];

// Direccion de jump:
// {PC+4[31:28], Instruction[25:0], 2'b00}
assign jump_address = {ifid_pc[31:28], jump_index, 2'b00};

// Detectar NOP en ID
assign is_nop_id = (ifid_instr == 32'b00000000000000000000000000000000);


// Unidad de Control


U_Control UC(
	.op(op),
	.regDst(regDst),
	.jump(jump),
	.branch(branch),
	.memToReg(memToReg),
	.memToWrite(memToWrite),
	.memToRead(memToRead),
	.aluSrc(aluSrc),
	.aluOp(aluOp),
	.regWrite(regWrite)
);

// Si es NOP, no escribe al banco de registros
assign regWrite_id_final = regWrite & ~is_nop_id;


// Banco de Registros
// Escritura viene de WB
// Lectura se hace en ID


BR BancoReg(
	.AR1(rs),
	.AR2(rt),
	.AW(memwb_write_register),
	.DW(mux_wb_out),
	.RegWrite(memwb_regWrite),
	.DR1(br_out1),
	.DR2(br_out2)
);


// Sign Extend


signextend SE(
	.in(inmediato),
	.out(inmediato_extendido)
);

// ANDI y ORI usan zero extend
assign inmediato_zero = {16'b0, inmediato};

assign inmediato_final = ((op == 6'b001100) || (op == 6'b001101)) ? inmediato_zero : inmediato_extendido;


// BUFFER ID/EX


Buffer_ID_EX ID_EX(
	.clk(clk),
	.reset(reset),

	.regDst_in(regDst),
	.branch_in(branch),
	.memToReg_in(memToReg),
	.memToWrite_in(memToWrite),
	.memToRead_in(memToRead),
	.aluSrc_in(aluSrc),
	.regWrite_in(regWrite_id_final),
	.aluOp_in(aluOp),

	.pc_in(ifid_pc),
	.read_data1_in(br_out1),
	.read_data2_in(br_out2),
	.sign_ext_in(inmediato_final),

	.rt_in(rt),
	.rd_in(rd),
	.funct_in(funct),

	.regDst_out(idex_regDst),
	.branch_out(idex_branch),
	.memToReg_out(idex_memToReg),
	.memToWrite_out(idex_memToWrite),
	.memToRead_out(idex_memToRead),
	.aluSrc_out(idex_aluSrc),
	.regWrite_out(idex_regWrite),
	.aluOp_out(idex_aluOp),

	.pc_out(idex_pc),
	.read_data1_out(idex_read_data1),
	.read_data2_out(idex_read_data2),
	.sign_ext_out(idex_sign_ext),

	.rt_out(idex_rt),
	.rd_out(idex_rd),
	.funct_out(idex_funct)
);


// EX - ALU Control


ALU_Ctrl AC(
	.aluOP(idex_aluOp),
	.fnc(idex_funct),
	.salidaAC(alu_ctrl_out)
);


// EX - MUX ALUSrc


muxALUSrc MUX_ALUSRC(
	.D0(idex_read_data2),
	.D1(idex_sign_ext),
	.sel(idex_aluSrc),
	.Y(alu_b)
);


// EX - ALU


alu ALU0(
	.ALUctl(alu_ctrl_out),
	.A(idex_read_data1),
	.B(alu_b),
	.result(alu_out),
	.ifzero(ifzero)
);


// EX - Branch target


assign branch_offset = idex_sign_ext << 2;
assign branch_target_ex = idex_pc + branch_offset;


// EX - MUX RegDst


Mux2_1_5 MUX_REGDST(
	.D0(idex_rt),
	.D1(idex_rd),
	.sel(idex_regDst),
	.Y(write_register_ex)
);


// BUFFER EX/MEM


Buffer_EX_MEM EX_MEM(
	.clk(clk),
	.reset(reset),

	.branch_in(idex_branch),
	.memToReg_in(idex_memToReg),
	.memToWrite_in(idex_memToWrite),
	.memToRead_in(idex_memToRead),
	.regWrite_in(idex_regWrite),

	.branch_target_in(branch_target_ex),
	.ifzero_in(ifzero),
	.alu_result_in(alu_out),
	.write_data_in(idex_read_data2),
	.write_register_in(write_register_ex),

	.branch_out(exmem_branch),
	.memToReg_out(exmem_memToReg),
	.memToWrite_out(exmem_memToWrite),
	.memToRead_out(exmem_memToRead),
	.regWrite_out(exmem_regWrite),

	.branch_target_out(exmem_branch_target),
	.ifzero_out(exmem_ifzero),
	.alu_result_out(exmem_alu_result),
	.write_data_out(exmem_write_data),
	.write_register_out(exmem_write_register)
);


// MEM - Branch


Branch BRANCH0(
	.branch(exmem_branch),
	.ifzero(exmem_ifzero),
	.pc_src(pc_src)
);


// MEM - Memoria de Datos


MemDatos MEM(
	.Address(exmem_alu_result),
	.WriteData(exmem_write_data),
	.We(exmem_memToWrite),
	.Re(exmem_memToRead),
	.ReadData(mem_read_data)
);


// BUFFER MEM/WB


Buffer_MEM_WB MEM_WB(
	.clk(clk),
	.reset(reset),

	.memToReg_in(exmem_memToReg),
	.regWrite_in(exmem_regWrite),

	.read_data_in(mem_read_data),
	.alu_result_in(exmem_alu_result),
	.write_register_in(exmem_write_register),

	.memToReg_out(memwb_memToReg),
	.regWrite_out(memwb_regWrite),

	.read_data_out(memwb_read_data),
	.alu_result_out(memwb_alu_result),
	.write_register_out(memwb_write_register)
);


// WB - MUX MemToReg


Mux2_1_32 MUX_WB(
	.D0(memwb_alu_result),
	.D1(memwb_read_data),
	.sel(memwb_memToReg),
	.Y(mux_wb_out)
);


// Salidas visibles para simulacion


assign pc_actual       = pc_out;
assign pc_siguiente    = pc_next;
assign branch_target   = exmem_branch_target;
assign jump_out        = jump;
assign jump_address_out = jump_address;

assign alu_result      = exmem_alu_result;
assign data_mem_out    = mem_read_data;
assign write_back_data = mux_wb_out;
assign read_data1      = br_out1;
assign read_data2      = br_out2;

endmodule