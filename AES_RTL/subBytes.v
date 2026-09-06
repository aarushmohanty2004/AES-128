module subBytes (
    input wire [127:0] state,
    output wire [127:0] sub_out
);

    genvar i;
    generate 
        for (i=0; i<128; i=i+8) 
        begin :sub_Bytes 
            sBox s (
                .d(state[i+:8]),
                .sout(sub_out[i+:8])
            );
        end
    endgenerate

endmodule