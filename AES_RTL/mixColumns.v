module mixColumns (
    input  wire [127:0] in,
    output wire [127:0] out
);

    function [7:0] mb2; // multiply by {02}
        input [7:0] x;
        begin
            if (x[7] == 1'b1) 
                mb2 = ((x << 1) ^ 8'h1b);
            else 
                mb2 = (x << 1);
        end
    endfunction

    function [7:0] mb3; // multiply by {03}
        input [7:0] x;
        begin
            mb3 = mb2(x) ^ x;
        end
    endfunction

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : m_col
            wire [7:0] r0 = in[i*32 + 0  +: 8];
            wire [7:0] r1 = in[i*32 + 8  +: 8];
            wire [7:0] r2 = in[i*32 + 16 +: 8];
            wire [7:0] r3 = in[i*32 + 24 +: 8];

            assign out[i*32 + 0  +: 8] = mb2(r0) ^ mb3(r1) ^ r2 ^ r3;
            assign out[i*32 + 8  +: 8] = r0 ^ mb2(r1) ^ mb3(r2) ^ r3;
            assign out[i*32 + 16 +: 8] = r0 ^ r1 ^ mb2(r2) ^ mb3(r3);
            assign out[i*32 + 24 +: 8] = mb3(r0) ^ r1 ^ r2 ^ mb2(r3);
        end
    endgenerate

endmodule