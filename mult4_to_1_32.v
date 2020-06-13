module mult4_to_1_32 (out,i0,i1,i2,i3,s0);
output [31:0] out;
input [31:0]i0,i1,i2,i3;
input [1:0]s0;

begin
		out = 	(s0 == 2'b00) ? i0: 
		(s0 == 2'b01) ? i1:
		(s0 == 2'b10) ? i2: i3;
end
endmodule