module subBytes (
    input  wire clk,
    input  wire en,
    input  wire start,
    input  wire [127:0] state,
    output reg [127:0] sub_out = 128'd0,
    output reg done = 1'b0,
    output reg busy = 1'b0
);
	
	// register
    reg [1:0] state_fsm = 2'd0;
    wire sel_upper = (state_fsm == 2'd2);

	// address wires for brams
    wire [7:0] addra_0 = (!sel_upper) ? state[7:0]   : state[71:64];
    wire [7:0] addrb_0 = (!sel_upper) ? state[15:8]  : state[79:72];

    wire [7:0] addra_1 = (!sel_upper) ? state[23:16] : state[87:80];
    wire [7:0] addrb_1 = (!sel_upper) ? state[31:24] : state[95:88];

    wire [7:0] addra_2 = (!sel_upper) ? state[39:32] : state[103:96];
    wire [7:0] addrb_2 = (!sel_upper) ? state[47:40] : state[111:104];

    wire [7:0] addra_3 = (!sel_upper) ? state[55:48] : state[119:112];
    wire [7:0] addrb_3 = (!sel_upper) ? state[63:56] : state[127:120];

	// data wires for brams
    wire [31:0] douta_0, doutb_0;
    wire [31:0] douta_1, doutb_1;
    wire [31:0] douta_2, doutb_2;
    wire [31:0] douta_3, doutb_3;

    wire mem_en = ena && (busy || start);

    // BRAM 0
    blk_mem_gen_0 sbox0 (
        .clka  (clk),
        .ena   (mem_en),
        .addra (addra_0),
        .douta (douta_0),

        .clkb  (clk),
        .enb   (mem_en),
        .addrb (addrb_0),
        .doutb (doutb_0)
    );

    // BRAM 1
    blk_mem_gen_0 sbox1 (
        .clka  (clk),
        .ena   (mem_en),
        .addra (addra_1),
        .douta (douta_1),

        .clkb  (clk),
        .enb   (mem_en),
        .addrb (addrb_1),
        .doutb (doutb_1)
    );

    // BRAM 2
    blk_mem_gen_0 sbox2 (
        .clka  (clk),
        .ena   (mem_en),
        .addra (addra_2),
        .douta (douta_2),

        .clkb  (clk),
        .enb   (mem_en),
        .addrb (addrb_2),
        .doutb (doutb_2)
    );

    // BRAM 3
    blk_mem_gen_0 sbox3 (
        .clka  (clk),
        .ena   (mem_en),
        .addra (addra_3),
        .douta (douta_3),

        .clkb  (clk),
        .enb   (mem_en),
        .addrb (addrb_3),
        .doutb (doutb_3)
    );

    always @(posedge clk) begin
        if (ena) begin
            done <= 1'b0;

            case (state_fsm)
                2'd0: begin
                    if (start) begin
                        busy      <= 1'b1;
                        state_fsm <= 2'd1;
                    end
                end

                2'd1: begin
                    state_fsm <= 2'd2;
                end

                2'd2: begin
                    sub_out[7:0]   <= douta_0[7:0];
                    sub_out[15:8]  <= doutb_0[7:0];
                    sub_out[23:16] <= douta_1[7:0];
                    sub_out[31:24] <= doutb_1[7:0];
                    sub_out[39:32] <= douta_2[7:0];
                    sub_out[47:40] <= doutb_2[7:0];
                    sub_out[55:48] <= douta_3[7:0];
                    sub_out[63:56] <= doutb_3[7:0];

                    state_fsm <= 2'd3;
                end

                2'd3: begin
                    sub_out[71:64]   <= douta_0[7:0];
                    sub_out[79:72]   <= doutb_0[7:0];
                    sub_out[87:80]   <= douta_1[7:0];
                    sub_out[95:88]   <= doutb_1[7:0];
                    sub_out[103:96]  <= douta_2[7:0];
                    sub_out[111:104] <= doutb_2[7:0];
                    sub_out[119:112] <= douta_3[7:0];
                    sub_out[127:120] <= doutb_3[7:0];

                    done      <= 1'b1;
                    busy      <= 1'b0;
                    state_fsm <= 2'd0;
                end
            endcase
        end
    end

endmodule