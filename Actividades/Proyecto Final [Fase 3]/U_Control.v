`timescale 1ns/1ns
//1. Definir modulo con I/O

module U_Control(
	input [5:0] op,
	output reg regDst,
	output reg jump,
	output reg branch,
	output reg memToReg,
	output reg memToWrite,
	output reg memToRead,
	output reg aluSrc,
	output reg [2:0] aluOp,
	output reg regWrite
);

//2. Comp. internos = NA


//3. Cuerpo, Assigns = NA, Instancias = NA, BloqueSecuencial = SI

always @*
begin
	case(op)

		// Tipo R
		6'b000000:
		begin
			regDst     = 1'b1;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;
			aluOp      = 3'b010;
			regWrite   = 1'b1;
		end

		// addi
		6'b001000:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;
			aluOp      = 3'b000;
			regWrite   = 1'b1;
		end

		// slti
		6'b001010:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;
			aluOp      = 3'b101;
			regWrite   = 1'b1;
		end

		// andi
		6'b001100:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;
			aluOp      = 3'b011;
			regWrite   = 1'b1;
		end

		// ori
		6'b001101:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;
			aluOp      = 3'b100;
			regWrite   = 1'b1;
		end

		// lw
		6'b100011:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b1;
			memToWrite = 1'b0;
			memToRead  = 1'b1;
			aluSrc     = 1'b1;
			aluOp      = 3'b000;
			regWrite   = 1'b1;
		end

		// sw
		6'b101011:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b1;
			memToRead  = 1'b0;
			aluSrc     = 1'b1;
			aluOp      = 3'b000;
			regWrite   = 1'b0;
		end

		// beq
		6'b000100:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b1;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;
			aluOp      = 3'b001;
			regWrite   = 1'b0;
		end

		// j
		6'b000010:
		begin
			regDst     = 1'b0;
			jump       = 1'b1;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;
			aluOp      = 3'b110;
			regWrite   = 1'b0;
		end

		// Default
		default:
		begin
			regDst     = 1'b0;
			jump       = 1'b0;
			branch     = 1'b0;
			memToReg   = 1'b0;
			memToWrite = 1'b0;
			memToRead  = 1'b0;
			aluSrc     = 1'b0;
			aluOp      = 3'b110;
			regWrite   = 1'b0;
		end

	endcase
end

endmodule