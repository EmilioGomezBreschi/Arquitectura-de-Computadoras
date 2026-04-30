
//1. Declaracion de modulo y sus I/O
module DPTR(
	input [31:0] instr,
	output [31:0] alu_result,
	output [31:0] data_mem_out,
	output [31:0] write_back_data,
	output [31:0] read_data1,
	output [31:0] read_data2
);

//2. Cables o registros

// Campos de instruccion tipo R
wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] shamt;
wire [5:0] funct;

// Señales de control
wire memToReg;
wire memToWrite;
wire memToRead;
wire regWrite;
wire [2:0] aluOp;

// Señal ALU control
wire [2:0] alu_ctrl_out;

// Salidas internas
wire [31:0] br_out1;
wire [31:0] br_out2;
wire [31:0] alu_out;
wire [31:0] mem_out;
wire [31:0] mux_out;

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial

// Separacion de campos
assign op    = instr[31:26];
assign rs    = instr[25:21];
assign rt    = instr[20:16];
assign rd    = instr[15:11];
assign shamt = instr[10:6];
assign funct = instr[5:0];

// Unidad de Control
U_Control UC(
	.op(op),
	.memToReg(memToReg),
	.memToWrite(memToWrite),
	.memToRead(memToRead),
	.aluOp(aluOp),
	.regWrite(regWrite)
);

// Banco de Registros
BR BancoReg(
	.AR1(rs),
	.AR2(rt),
	.AW(rd),
	.DW(mux_out),
	.RegWrite(regWrite),
	.DR1(br_out1),
	.DR2(br_out2)
);

// ALU Control
ALU_Ctrl AC(
	.aluOP(aluOp),
	.fnc(funct),
	.salidaAC(alu_ctrl_out)
);

// ALU
alu ALU0(
	.ALUctl(alu_ctrl_out),
	.A(br_out1),
	.B(br_out2),
	.result(alu_out)
);

// Memoria de Datos
MemDatos MEM(
	.Address(alu_out),
	.WriteData(br_out2),
	.We(memToWrite),
	.Re(memToRead),
	.ReadData(mem_out)
);

// MUX MemToReg
Mux2_1_32 MUX_WB(
	.D0(alu_out),
	.D1(mem_out),
	.sel(memToReg),
	.Y(mux_out)
);

// Salidas visibles
assign alu_result      = alu_out;
assign data_mem_out    = mem_out;
assign write_back_data = mux_out;
assign read_data1      = br_out1;
assign read_data2      = br_out2;

endmodule