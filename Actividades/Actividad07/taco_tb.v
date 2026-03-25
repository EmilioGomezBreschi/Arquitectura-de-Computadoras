`timescale 1ns/1ns

//1. Declaracion de modulo y sus I/O
module taco_tb;

//2. Cables o registros
reg [4:0] addr;
reg [31:0] data_in;
reg EN;
reg [3:0] ALUctl;
reg sel;

wire [31:0] data_out;
wire [31:0] alu_result;

//3. Cuerpo del modulo, assigns, instancias y bloque secuencial

TACO uut(
    .addr(addr),
    .data_in(data_in),
    .EN(EN),
    .ALUctl(ALUctl),
    .sel(sel),
    .data_out(data_out),
    .alu_result(alu_result)
);

initial begin

    // Valores iniciales
    addr = 5'd0;
    data_in = 32'd0;
    EN = 1'b0;
    ALUctl = 4'd2;
    sel = 1'b0;
    #10;

    // CASO 1: Escritura en RAM
    // mem[0] = 10
    addr = 5'd0;
    data_in = 32'd10;
    EN = 1'b1;
    #10;

    // mem[1] = 4
    addr = 5'd1;
    data_in = 32'd4;
    EN = 1'b1;
    #10;

    // mem[2] = 20
    addr = 5'd2;
    data_in = 32'd20;
    EN = 1'b1;
    #10;

    // Desactivar escritura
    EN = 1'b0;
    data_in = 32'd0;
    #10;

    // CASO 2: Lectura de RAM
    addr = 5'd0;  //lee 10
    #10;

    addr = 5'd1;  //lee 4
    #10;

    addr = 5'd2;  //lee 20
    #10;

    // CASO 3: Operaciones ALU distintas

    // SUMA: RAM(10) + 5 = 15
    addr = 5'd0;
    data_in = 32'd5;
    ALUctl = 4'd2;
    sel = 1'b0;
    #10;

    // RESTA: 30 - RAM(4) = 26
    addr = 5'd1;
    data_in = 32'd30;
    ALUctl = 4'd6;
    sel = 1'b1;
    #10;

    // AND: RAM(20) & 6 = 4
    addr = 5'd2;
    data_in = 32'd6;
    ALUctl = 4'd0;
    sel = 1'b0;
    #10;

    // OR: RAM(4) | 8 = 12
    addr = 5'd1;
    data_in = 32'd8;
    ALUctl = 4'd1;
    sel = 1'b0;
    #10;

    // NOR: RAM(10) NOR 5
    addr = 5'd0;
    data_in = 32'd5;
    ALUctl = 4'd12;
    sel = 1'b0;
    #10;

    // SLT: RAM(4) < 10 -> 1
    addr = 5'd1;
    data_in = 32'd10;
    ALUctl = 4'd7;
    sel = 1'b0;
    #10;

    // CASO 4: Cambio de seleccion del DEMUX

    // sel = 0 -> A = RAM, B = data_in
    addr = 5'd0;      // RAM = 10
    data_in = 32'd3;
    ALUctl = 4'd2;    // 10 + 3 = 13
    sel = 1'b0;
    #10;

    // sel = 1 -> A = data_in, B = RAM
    addr = 5'd0;      // RAM = 10
    data_in = 32'd3;
    ALUctl = 4'd6;    // 3 - 10 = -7
    sel = 1'b1;
    #10;

    $stop;
end

endmodule