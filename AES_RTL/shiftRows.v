module shiftRows (
    input wire [127:0] state,
    output wire [127:0] shift_out
);

//Row 1
assign shift_out[7:0] = state[7:0];
assign shift_out[39:32] = state[39:32];
assign shift_out[71:64] = state[71:64];
assign shift_out[103:96] = state[103:96];

//Row 2
assign shift_out[15:8]    = state[47:40];
assign shift_out[47:40]   = state[79:72];
assign shift_out[79:72]   = state[111:104];
assign shift_out[111:104] = state[15:8];

//Row 3
assign shift_out[23:16]   = state[87:80];
assign shift_out[55:48]   = state[119:112];
assign shift_out[87:80]   = state[23:16];
assign shift_out[119:112] = state[55:48];

//Row 4
assign shift_out[31:24]   = state[127:120];
assign shift_out[63:56]   = state[31:24];
assign shift_out[95:88]   = state[63:56];
assign shift_out[127:120] = state[95:88];

endmodule