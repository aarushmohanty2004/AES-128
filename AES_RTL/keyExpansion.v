module keyExpansion (
    input wire clk,
    input wire ena,
    input wire start,
    input wire [127:0] key,
    output reg [1407:0] w = 1408'd0,
    output reg done = 1'b0,
    output wire busy
);

    reg [31:0] w_words [0:43];
    reg [5:0] i = 6'd0;
    reg [1:0] state_fsm = 2'd0;

    localparam IDLE = 2'd0;
    localparam RUN = 2'd1;
    localparam WAIT_BRAM = 2'd2;
    localparam FINISH = 2'd3;

    assign busy = (state_fsm != IDLE) || start;

    reg [31:0] temp;

    // Rot_word
    wire [7:0] rot_b0 = temp[23:16];
    wire [7:0] rot_b1 = temp[15:8];
    wire [7:0] rot_b2 = temp[7:0];
    wire [7:0] rot_b3 = temp[31:24];

    wire [31:0] douta_0, doutb_0;
    wire [31:0] douta_1, doutb_1;

    wire bram_en = ena && ((state_fsm == RUN) || (state_fsm == WAIT_BRAM));

    blk_mem_gen_0 sbox_k0 (
        .clka (clk),
        .ena (bram_en),
        .addra (rot_b0),
        .douta (douta_0),

        .clkb (clk),
        .enb (bram_en),
        .addrb (rot_b1),
        .doutb (doutb_0)
    );

    blk_mem_gen_0 sbox_k1 (
        .clka (clk),
        .ena (bram_en),
        .addra (rot_b2),
        .douta (douta_1),

        .clkb (clk),
        .enb (bram_en),
        .addrb (rot_b3),
        .doutb (doutb_1)
    );

    wire [31:0] subword_out = {douta_0[7:0], doutb_0[7:0], douta_1[7:0], doutb_1[7:0]};

    // AES-128 Round Constants (Rcon)
    function [31:0] rconx(input [3:0] r);
        case (r)
            4'h1: rconx = 32'h01000000;
            4'h2: rconx = 32'h02000000;
            4'h3: rconx = 32'h04000000;
            4'h4: rconx = 32'h08000000;
            4'h5: rconx = 32'h10000000;
            4'h6: rconx = 32'h20000000;
            4'h7: rconx = 32'h40000000;
            4'h8: rconx = 32'h80000000;
            4'h9: rconx = 32'h1b000000;
            4'ha: rconx = 32'h36000000;
            default: rconx = 32'h00000000;
        endcase
    endfunction

    // Helper function
    function [31:0] swap32(input [31:0] dw);
        swap32 = {dw[7:0], dw[15:8], dw[23:16], dw[31:24]};
    endfunction

    always @(posedge clk) begin
        if (ena) begin
            done <= 1'b0;

            case (state_fsm)
                IDLE: begin
                    if (start) begin
                        // Initial key loaded as first 4 words
                        w_words[0] <= key[127:96];
                        w_words[1] <= key[95:64];
                        w_words[2] <= key[63:32];
                        w_words[3] <= key[31:0];

                        temp <= key[31:0];
                        i <= 6'd4;
                        state_fsm <= RUN;
                    end
                end

                RUN: begin
                    if (i < 6'd44) 
					begin
                        if (i[1:0] == 2'b00) 
							begin
								state_fsm <= WAIT_BRAM;
							end
						else 
							begin
								w_words[i] <= w_words[i - 4] ^ temp;
								temp <= w_words[i - 4] ^ temp;
								i <= i + 1'b1;
							end
                    end 
					else 
						begin
							state_fsm <= FINISH;
						end
                end

                WAIT_BRAM: begin
                    w_words[i] <= w_words[i - 4] ^ subword_out ^ rconx(i[5:2]);
                    temp <= w_words[i - 4] ^ subword_out ^ rconx(i[5:2]);
                    i <= i + 1'b1;
                    state_fsm <= RUN;
                end

                FINISH: begin
                    w[127:0] <= {swap32(w_words[3]),  swap32(w_words[2]),  swap32(w_words[1]),  swap32(w_words[0])};
                    w[255:128] <= {swap32(w_words[7]),  swap32(w_words[6]),  swap32(w_words[5]),  swap32(w_words[4])};
                    w[383:256] <= {swap32(w_words[11]), swap32(w_words[10]), swap32(w_words[9]),  swap32(w_words[8])};
                    w[511:384] <= {swap32(w_words[15]), swap32(w_words[14]), swap32(w_words[13]), swap32(w_words[12])};
                    w[639:512] <= {swap32(w_words[19]), swap32(w_words[18]), swap32(w_words[17]), swap32(w_words[16])};
                    w[767:640] <= {swap32(w_words[23]), swap32(w_words[22]), swap32(w_words[21]), swap32(w_words[20])};
                    w[895:768] <= {swap32(w_words[27]), swap32(w_words[26]), swap32(w_words[25]), swap32(w_words[24])};
                    w[1023:896] <= {swap32(w_words[31]), swap32(w_words[30]), swap32(w_words[29]), swap32(w_words[28])};
                    w[1151:1024] <= {swap32(w_words[35]), swap32(w_words[34]), swap32(w_words[33]), swap32(w_words[32])};
                    w[1279:1152] <= {swap32(w_words[39]), swap32(w_words[38]), swap32(w_words[37]), swap32(w_words[36])};
                    w[1407:1280] <= {swap32(w_words[43]), swap32(w_words[42]), swap32(w_words[41]), swap32(w_words[40])};

                    done <= 1'b1;
                    state_fsm <= IDLE;
                end

                default: state_fsm <= IDLE;
            endcase
        end
    end

endmodule