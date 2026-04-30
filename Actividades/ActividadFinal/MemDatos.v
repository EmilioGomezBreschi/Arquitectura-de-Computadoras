//1. def mod I/O

module MemDatos(
	input [31:0]Address,
	input [31:0]WriteData,
	input We, //escribir
	input Re, //leer
	output reg [31:0]ReadData
);

reg [31:0]sram[0:127];

initial //inicializar la mem/reg bidimencional
begin
//$readmeamb("data.txt",sram)
	sram[0]=32'd100;
	sram[1]=32'd200;
	sram[2]=32'd300;
	sram[3]=32'd400;
	sram[4]=32'd500;
	sram[5]=32'd600;
	sram[6]=32'd700;

end

always @*
begin
//	if(We)
//	begin
//		sram[Address]
//	end
//	else if(Re)
//	begin
//	end	
	case({We,Re})
		2'b10:sram[Address]=WriteData;
		2'b01:ReadData=sram[Address];
	endcase
end

endmodule
