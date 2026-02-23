
  `timescale 1ns/1ns
 //definicion del modulo
module capuccino_tb;
 //definicion de cables o registros 
wire [7:0]bebida_tb;
reg[7:0]lala_tb;
reg[7:0]planchuela_tb;
 //cuerpo del modulo  instancias initial
 capuccino DUV(
    .lala(lala_tb),
    .planchuela(planchuela_tb),
    .bebida(bebida_tb)
 );
 //generacion de estimulos en initial
 initial
 begin
    lala_tb = 8'd17;
    planchuela_tb = 8'd165;#100; 

    lala_tb = 8'd17;
    planchuela_tb = 8'd99;#100; 
    $stop;
 end 

 endmodule