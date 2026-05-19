`timescale 1ns/1ns
//1. Definir modulo con I/O

module ALU_Ctrl(
	input [2:0] aluOP,
	input [5:0] fnc,
	output reg [2:0] salidaAC
);

//2. Comp. internos = NA, Reg = NA


//3. Cuerpo, Assigns = NA, Instancias = NA, BloqueSecuencial = SI

always @*
begin
	case(aluOP)

		// ADD
		3'b000:
		begin
			salidaAC = 3'b010;
		end

		// SUB
		3'b001:
		begin
			salidaAC = 3'b110;
		end

		// Tipo R
		3'b010:
		begin
			case(fnc)
				6'b100000: salidaAC = 3'b010; // ADD
				6'b100010: salidaAC = 3'b110; // SUB
				6'b100100: salidaAC = 3'b000; // AND
				6'b100101: salidaAC = 3'b001; // OR
				6'b101010: salidaAC = 3'b111; // SLT
				6'b000000: salidaAC = 3'b011; // NOP
				default:   salidaAC = 3'b011; // default es NOP
			endcase
		end

		// AND
		3'b011:
		begin
			salidaAC = 3'b000;
		end

		// OR
		3'b100:
		begin
			salidaAC = 3'b001;
		end

		// SLT
		3'b101:
		begin
			salidaAC = 3'b111;
		end

		// Default es NOP
		default:
		begin
			salidaAC = 3'b011;
		end

	endcase
end

endmodule