 //Fatima Lisette Hernandez Barajas
 //arquitectura de computadoras
 //ejemplo capuccino 
`timescale 1ns/1ns
 //definicion del modulo
module capuccino(
    input [7:0]lala,//7 - 4, 3 - 0
    input [7:0]planchuela,
    output [7:0]bebida
);
 //definicion de cables (si) o registros 
 wire [3:0]espumar;
 wire [3:0]extraer;

 //cuerpo del modulo assigns (si) instancias(si) always(na)
 //asignaciones 
 //espumar (bits mas significativos) va a la izquierda
 //extraer (bits menos significativos) va a la derecha
 assign bebida = {espumar,extraer};  //concatenacion
                //{extraer[3:2],espumar[0],extraer[1:0],espumar[3:1]}

 //instancias
 leche venti(
    .h(lala[3:0]), //LSB
    .i(lala[7:4]), //MSB
    .j(espumar) //8 bits, no se especifica, espumar y j tienen el mismo tam

 );

 expresso carga1(
    .a(planchuela[3:0]),
    .b(planchuela[7:4]),
    .c(extraer)
 );


 endmodule