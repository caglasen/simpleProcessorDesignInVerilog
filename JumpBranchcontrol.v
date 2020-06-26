module jumpbrcontrol(beq,balrn,blez,jal,jmor,nout,zout,cont);

input beq,balrn,blez,jal,jmor;
input nout,zout;//acaba bunları zout ve nout olarak ayrı ayrı mı yapsak
output [1:0] cont;
reg [1:0] cont;



wire beqsign, blezsign, balrnsign,jalsignal,jmorsignal;

assign beqsign = zout & beq;
assign blezsign = (zout | nout) & blez;
assign balrnsign = nout & balrn;
assign jalsignal = jal;
assign jmorsignal = jmor;

always @(beq or balrn or blez or jal or jmor or nout or zout)
begin

	cont =2'b10; // PC + 4, dafault case

	if(balrnsign|jmorsignal) cont=2'b00; // pc + 4 + Mem[rs] or mem rs ??????
	if(blezsign | beqsign) cont=2'b01; // PC + 4 + 4*LABEL
	
	if(jalsignal) cont=2'b11;  // (PC+4)[31-28] concat Instruction[25-0] concat 00
	
end

endmodule
