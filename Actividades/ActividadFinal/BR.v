`timescale 1ns/1ns
//1. Definir modulo con I/O

module BR(
	input [4:0]AR1,
	input [4:0]AR2,
	input [4:0]AW,
	input [31:0]DW,
	input RegWrite, //Enable to Write
	output reg [31:0]DR1,
	output reg [31:0]DR2
);

//2. definen comp. internos Reg o wires
reg [31:0] carnita[0:31];


//segundo pan
//3. cuerpo del modulo, assigns, instancias
//bloq. secuenciales

initial //inicializar la mem/reg bidimencional
begin
//$readmeamb("condimento.txt",carnita)
	carnita[0]=32'd100;
	carnita[1]=32'd200;
	carnita[2]=32'd300;
	carnita[3]=32'd400;
	carnita[4]=32'd500;
	carnita[5]=32'd600;
	carnita[6]=32'd700;

end

always @*
begin
	DR1=carnita[AR1];
	DR2=carnita[AR2];
	if(RegWrite)
	begin
		carnita[AW]=DW;
	end
end

endmodule