`timescale 1ns/1ns
//1. Definir modulo con I/O
module U_Control(
	input [5:0] op,
	output reg memToReg,
	output reg memToWrite,
	output reg memToRead,
	output reg [2:0] aluOp,
	output reg regWrite
);

//2. definen comp. internos Reg o wires


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

always @*
begin
	case(op)
		6'b000000: // Instrucciones tipo R
		begin
			memToReg  = 1'b0;
			memToWrite = 1'b0;
			memToRead = 1'b0;
			aluOp     = 3'b010;
			regWrite  = 1'b1;
		end

		default:
		begin
			memToReg  = 1'b0;
			memToWrite = 1'b0;
			memToRead = 1'b0;
			aluOp     = 3'b000;
			regWrite  = 1'b0;
		end
	endcase
end

endmodule