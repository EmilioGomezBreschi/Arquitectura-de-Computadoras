//1. Declaracion de modulo y sus I/O
module alu(
    input [3:0] ALUctl,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result
);

//2. Cables o registros

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial
always @(ALUctl, A, B) begin
    case (ALUctl)
        4'd0: result <= A & B;
        4'd1: result <= A | B;
        4'd2: result <= A + B;
        4'd6: result <= A - B;
        4'd7: result <= A < B ? 1 : 0;
        4'd12: result <= ~(A | B);
        default: result <= 0;
    endcase
end

endmodule