//1. Declaracion de modulo y sus I/O
module TACO(
    input [4:0] addr,
    input [31:0] data_in,
    input EN,
    input [3:0] ALUctl,
    input sel,
    output [31:0] data_out,
    output [31:0] alu_result
);

//2. Cables o registros
wire [31:0] ram_data;
reg [31:0] alu_a;
reg [31:0] alu_b;

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial

ram memoria(
    .addr(addr),
    .data_in(data_in),
    .EN(EN),
    .data_out(ram_data)
);

assign data_out = ram_data;

// sel = 0 -> A = RAM, B = data_in
// sel = 1 -> A = data_in, B = RAM
always @(ram_data, data_in, sel) begin
    if (sel == 1'b0) begin
        alu_a = ram_data;
        alu_b = data_in;
    end else begin
        alu_a = data_in;
        alu_b = ram_data;
    end
end

alu unidad_aritmetica_logica(
    .ALUctl(ALUctl),
    .A(alu_a),
    .B(alu_b),
    .result(alu_result)
);

endmodule