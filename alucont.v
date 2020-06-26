module alucont(aluop3,aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0,jmorsig,gout);//Figure 4.12 //2 bit function code eklendi, jmor sinyali eklendi
input aluop3,aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0; //2 bit function code eklendi
output [2:0] gout;
reg [2:0] gout;
output jmorsig; //ALUCONTROLDEN JMOR S
reg jmorsig;
always @(aluop3 or aluop2 or aluop1 or aluop0 or f5 or f4 or f3 or f2 or f1 or f0) //2 bit function code eklendi
begin
	if(aluop3)gout=3'b010; //lw sw
	if(aluop2 & (~aluop1) & aluop0)gout=3'b110; // aluop =101 of blez is 101
	if((~aluop2)&(~aluop1) &aluop0)gout=3'b110; // aluop =001 -> beq
	if(aluop2&(~aluop1)&(~aluop0)) gout=3'b000; // aluop =100 ise andi inst. demektir.


	if(aluop1)//R-type
	begin
		if (~(f3|f2|f1|f0))gout=3'b010; 	//function code=0000,ALU control=010 (add)
		if (f1&f3)gout=3'b111;			//function code=1x1x,ALU control=111 (set on less than)
		if (f1&~(f3))gout=3'b110;		//function code=0x10,ALU control=110 (sub)
		if (f2&f0)gout=3'b001;			//function code=x1x1,ALU control=001 (or)
		if (f2&~(f0))gout=3'b000;		//function code=x1x0,ALU control=000 (and)
		if (~(f5)&~(f4)&~(f3)&~(f2)&~(f1)&~(f0)) gout=3'b011; //function code=000000, ALU control=011 (sll)*******************????????????????***
		if(f5 & ~f4 & ~f3 & f2 & f1 & ~f0) //fcode of jmor is 100110=38
			begin
			gout=3'b001; 
			jmorsig=1'b1; // fcode of jmor is 100101
			end
		end
end

endmodule
