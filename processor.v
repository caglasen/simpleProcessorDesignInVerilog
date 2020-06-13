module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31];
reg [7:0] mem[0:511]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
sum,		//ALU result
extad,	//Output of sign-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,
adder3out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad, //Output of shift left 2 unit
zextad,//Output of zero extend unit
signexteddORzeroextended;	

wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1;		//Write data input of Register File

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit



wire zout,	//Zero output of ALU
nout,
jmorsigg, //negative output of ALU******************************
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop2,aluop1,aluop0,andisign, blezsign, jalsing, jmorsign, balrnsign, sllsign;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];
 
wire[4:0] shamtt;//***************************************************SHIFT AMOUNT FOR ALU
assign shamtt=instruc[10:6];//****************************************SHIFT AMOUNT FOR ALU

wire [25:0] targett;//*****************************************  JAL INST.da KULLANILACAK OLAN TARGET
assign targett=instruc[25:0];//********************************

// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
 registerfile[out1]= regwrite ? out3:registerfile[out1];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],regdest);

// input olarak sign extended imm. ve zero extended imm., select bit olarak andisignal alan bir mux eklendi********************************
mult2_to_1_32 mult5(signexteddORzeroextended, extad, zextad, andisign);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,signexteddORzeroextended,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg);

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);



// load pc
always @(negedge clk)
pc=out4;

// alu, adder and control logic connections

//ALU unit operate on dataa and out2
alu32 alu1(sum,dataa,out2,shamtt,zout,nout, jmorsigg, gout); //nout eklendi****************

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out); //pc+4 , MESELA JMOR PC+4e GİDECEK

//adder with result PC + 4 + LABEL ***************************************     ????????????????????????????????????????????????????      
adder add3(adder1out,targett,adder3out);

//adder which adds PC+4 and 2 shifted sign-extend result 			BU BLEZ İÇİN KULLANILACAK
adder add2(adder1out,sextad,adder2out); // adder2out= PC + 4 + 4*LABEL

wire [1:0] cont;

jumpbrcontrol jumpandbranchcontrolUnit(beq,balrn,blez,jal,jmor,nout,zout,cont); // BURASI DEĞİŞECEK!!!

//4x1 mux for choosing the jump destinastion
mult4_to_1_32 mult7(outDestination,????,adder2out,adder1out,sextad,cont);

//Control unit
control cont(instruc[5:0],instruc[31:26], regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,andisign, blezsign, jalsing, sllsign, jmorsign, balrnsign, aluop2, //fcode 6 bite çıktı(ilk arguman)
aluop1,aluop0);//buraya andisignal eklendi

//Sign extend unit
signext sext(instruc[15:0],extad);

//andi için zero extend unit eklendi
zeroextend zext(instruc[15:0],zextad);

//ALU control unit
alucont acont(aluop2, aluop1,aluop0,instruc[5],instruc[4],instruc[3],instruc[2], instruc[1], instruc[0] ,gout);

//Shift-left 2 unit
shift shift2(sextad,extad);

//AND gate
assign pcsrc=branch && zout; 

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
//#400 $finish;
#2000 $finish;

	
end
initial
begin
clk=1;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

