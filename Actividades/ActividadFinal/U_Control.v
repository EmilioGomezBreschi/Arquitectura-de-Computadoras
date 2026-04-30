
//1. Definir modulo & I/O

module U_Control(
	input [5:0]op,
	output reg memToReg,
	output reg memToWrite,
	output reg memToRead,
	output reg [2:0]aluOp,
	output reg regWrite
);

//2. Comp. internos=Na,Reg=NA

//3.Cuerpo, Assigns=na, Insta=na, BloqueSecuencial =SI


always @*
	begin
		case(op)
		6'b000000: //tipo R
			begin
				memToReg=1'b0;
				memToWrite=1'b0;
				memToRead=1'b0;
				aluOp=3'b010;
				regWrite=1'b1;
				
			end
		default:
			begin
				
			end
		endcase
	end

endmodule