`timescale 1ns/1ns
//1. Definir modulo con I/O

module U_Control(
	input [5:0] op,
	output reg regDst,
	output reg branch,
	output reg memToReg,
	output reg memToWrite,
	output reg memToRead,
	output reg aluSrc,
	output reg [2:0] aluOp,
	output reg regWrite
);

//2. Comp. internos = NA, Reg = NA


//3. Cuerpo, Assigns = NA, Instancias = NA, BloqueSecuencial = SI

always @*
begin
	case(op)

		// Tipo R: add, sub, and, or, slt, nop
		6'b000000:
		begin
			regDst     = 1'b1;     // Escribe en rd
			branch     = 1'b0;
			memToReg   = 1'b0;     // ALU
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;     // BR
			aluOp      = 3'b010;   // ALU_Ctrl usa funct
			regWrite   = 1'b1;
		end

		// addi
		6'b001000:
		begin
			regDst     = 1'b0;     // Escribe en rt
			branch     = 1'b0;
			memToReg   = 1'b0;     // ALU
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;     // inmediato
			aluOp      = 3'b000;   // ADD
			regWrite   = 1'b1;
		end

		// slti
		6'b001010:
		begin
			regDst     = 1'b0;     // Escribe en rt
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;     // Inmediato
			aluOp      = 3'b101;   // SLT
			regWrite   = 1'b1;
		end

		// andi
		6'b001100:
		begin
			regDst     = 1'b0;     // Escribe en rt
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;     // Inmediato
			aluOp      = 3'b011;   // AND
			regWrite   = 1'b1;
		end

		// ori
		6'b001101:
		begin
			regDst     = 1'b0;     // Escribe en rt
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;     // Inmediato
			aluOp      = 3'b100;   // OR
			regWrite   = 1'b1;
		end

		// lw
		6'b100011:
		begin
			regDst     = 1'b0;     // Escribe en rt
			branch     = 1'b0;
			memToReg   = 1'b1;     // memoria
			memToWrite = 1'b0;
			memToRead  = 1'b1;
			aluSrc     = 1'b1;     // offset
			aluOp      = 3'b000;   // ADD para calcular direccion
			regWrite   = 1'b1;
		end

		// sw
		6'b101011:
		begin
			regDst     = 1'b0;     // No importa
			branch     = 1'b0;
			memToReg   = 1'b0;     // No importa
			memToWrite = 1'b1;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;     // offset
			aluOp      = 3'b000;   // ADD para calcular direccion
			regWrite   = 1'b0;
		end

		// beq
		6'b000100:
		begin
			regDst     = 1'b0;     // No importa
			branch     = 1'b1;
			memToReg   = 1'b0;     // No importa
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;     // Compara registros
			aluOp      = 3'b001;   // SUB para comparar
			regWrite   = 1'b0;
		end

		// Default
		default:
		begin
			regDst     = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;
			aluOp      = 3'b110;   // NOP / seguro
			regWrite   = 1'b0;
		end

	endcase
end

endmodule