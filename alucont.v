module alucont(aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0,jmorsig,gout);//Figure 4.12 //2 bit function code eklendi, jmor sinyali eklendi
input aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0; //2 bit function code eklendi
output [2:0] gout;
output jmorsig; //ALUCONTROLDEN JMOR SİNYALİ ÇIKARIYORUZ
reg [2:0] gout;
always @(aluop2,aluop1 or aluop0 or f5 or f4 or f3 or f2 or f1 or f0) //2 bit function code eklendi
begin
if(~(aluop1|aluop0))  gout=3'b010;
if(aluop0)gout=3'b110;
if(aluop2) gout=3'b000; // aluop2 =1 ise andi inst. demektir.
if(aluop1 & ~aluop0) gout=3'b011; // aluop of sll is x10
if(f5 & ~f4 & ~f3 & f2 & ~f1 & f0) 
	begin
		gout=3'b001 
		jmorsig=1'b1; // fcode of jmor is 100101
	end
if(aluop1)//R-type
begin
	if (~(f3|f2|f1|f0))gout=3'b010; 	//function code=0000,ALU control=010 (add)
	if (f1&f3)gout=3'b111;			//function code=1x1x,ALU control=111 (set on less than)
	if (f1&~(f3))gout=3'b110;		//function code=0x10,ALU control=110 (sub)
	if (f2&f0)gout=3'b001;			//function code=x1x1,ALU control=001 (or)
	if (f2&~(f0))gout=3'b000;		//function code=x1x0,ALU control=000 (and)
	if (~(f5)&~(f4)&~(f3)&~(f2)&~(f1)&~(f0)) gout=3'b011; //function code=000000, ALU control=011 (sll)*******************????????????????***
end
end
endmodule
