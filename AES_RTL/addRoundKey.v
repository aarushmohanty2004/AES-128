module addRoundKey(
input wire [127:0] inp,
input wire [127:0] key,
output wire [127:0] out
);

assign out = key ^ inp;

endmodule