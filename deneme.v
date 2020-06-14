module deneme(a,b,out0,out1);

input a,b;
output out0, out1;

reg [31:0] a,b,out0,out1;

always @(a or b )
begin
	out0=a&b;
	out1=a|b;
end

endmodule