module control(fcode,in,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch, beqsignal, andisignal,blezsignal, jalsignal, sllsignal, jmorsignal, balrnsignal,aluop3,aluop2,aluop1,aluop0); //buradan andiyi sildim, sllsignal,jmorsignal ekledim
input [5:0] in;
input [5:0] fcode;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,beqsignal,jmorsignal,aluop3,aluop2,aluop1,aluop0,andisignal, blezsignal, jalsignal,balrnsignal, sllsignal;//sllsignal,jmorsignal ekledim
wire rformat,lw,sw,beq;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign andisignal=(~in[5])&(~in[4])&in[3]&in[2]&(~in[1])&(~in[0]);
assign blezsignal=(~in[5])&(~in[4])&(~in[3])&in[2]&in[1]&(~in[0]);    //blez opcode is -> 000110
assign jalsignal=(~in[5])&(~in[4])&(~in[3])&(~in[2])&in[1]&in[0];     //jal opcode is -> 000011
assign beqsignal=(~in[5])&(~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);  //beq opcode is -> 000100

//R TYPE INSTRUCTIONS ARE DETERMINED BY THEIR FUNCT. CODES 
assign sllsignal=(~fcode[5])&(~fcode[4])&(~fcode[3])&(~fcode[2])&(~fcode[1])&(~fcode[0]) & rformat; // for fcode=000000, sllsignal=1*************
assign jmorsignal=(fcode[5])&(~fcode[4])&(~fcode[3])&(fcode[2])&(fcode[1])&(~fcode[0]) & rformat; //for fcode=100110, jmorsignal=1************
assign balrnsignal=(~fcode[5])&fcode[4]&(~fcode[3])&(fcode[2])&fcode[1]&(fcode[0]) & rformat; //for fcode=010111, balrnsignal=1************

assign regdest=rformat;
assign alusrc=(lw|sw|andisignal);
assign memtoreg=(lw|jmorsignal) ; //jmor writes memory to register
assign regwrite=(rformat|lw|andisignal|jalsignal); //buraya andisignal,jalsignal eklendi
assign memread=(lw|jmorsignal); //jmor reads from memory
assign memwrite=sw;
assign branch=beq;
assign aluop3=lw|sw;
assign aluop2=andisignal | blezsignal;
assign aluop1=rformat ; // aluop1 of sllsignal is 1???????????????????????????????????????????????????
assign aluop0= beq |blezsignal; // aluop0 of sllsignal is 0????????????
endmodule
