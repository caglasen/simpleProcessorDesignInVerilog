module mult4_to_1_32(out,i0,i1,i2,i3, s0, s1);

input wire [31:0] i0,i1,i2,i3;
input wire s0, s1;
output reg[31:0]  out;

always @(i0 or i1 or i2 or i3 or s0, s1)
begin

	case ( {s1,s0} )
		2'b00 : out = i0;
		2'b01 : out = i1;
		2'b10 : out = i2;
		2'b11 : out = i3;
	endcase

end

endmodule