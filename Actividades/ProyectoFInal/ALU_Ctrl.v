`timescale 1ns/1ns
//1. Definir modulo con I/O
module ALU_Ctrl(
	input [2:0] aluOP,
	input [5:0] fnc,
	output reg [2:0] salidaAC
);

//2. definen comp. internos Reg o wires


//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

always @*
begin
	case(aluOP)
		3'b010: // Instruccion tipo R
		begin
			case(fnc)
				6'b100000: salidaAC = 3'b010; // ADD
				6'b100010: salidaAC = 3'b110; // SUB
				6'b100100: salidaAC = 3'b000; // AND
				6'b100101: salidaAC = 3'b001; // OR
				6'b101010: salidaAC = 3'b111; // SLT
				6'b000000: salidaAC = 3'b011; // NOP
				default:   salidaAC = 3'b011; // NOP / seguro
			endcase
		end

		default:
		begin
			salidaAC = 3'b011; // NOP
		end
	endcase
end

endmodule