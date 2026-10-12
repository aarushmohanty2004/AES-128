`timescale 1ns / 1ps

module tb_aes_top;
    reg clk, en, start, rst;
    reg [15:0] aes_inp;
    reg [15:0] key_128;
    wire [127:0] aes_out;
    wire done, key_done;

    reg reset_glitch_detected = 1'b0;

    function [127:0] byte_swap_128(input [127:0] in);
        integer idx;
        begin
            for (idx = 0; idx < 16; idx = idx + 1) begin
                byte_swap_128[idx*8 +: 8] = in[(15 - idx)*8 +: 8];
            end
        end
    endfunction

    aes_top dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .start(start),
        .aes_inp(aes_inp),
        .key_128(key_128),
        .aes_out(aes_out),
        .done(done),
        .key_done(key_done)
    );

    always #5 clk = ~clk;

    localparam [127:0] inp = 128'h3243f6a8885a308d313198a2e0370734;
    localparam [127:0] key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    localparam [127:0] expected_output = 128'h3925841d02dc09fbdc118597196a0b32;

    wire [127:0] aes_out_formatted = byte_swap_128(aes_out);
    wire [127:0] full_inp_swapped = byte_swap_128(inp);

    // Checks if reset works at each and every clock cycle when reset is 1 and reports errors if it stops working in between
    always @(posedge clk) begin
        if (rst) begin
            #1;
            if (done !== 1'b0 || key_done !== 1'b0 || aes_out !== 128'd0) begin
                reset_glitch_detected <= 1'b1;
                $display("ERROR at %0t ps: Output non-zero while rst is asserted! (done=%b, key_done=%b, aes_out=0x%032h)",
                         $time, done, key_done, aes_out);
            end
        end
    end

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        en = 1'b0;
        start = 1'b0;
        aes_inp = 16'd0;
        key_128 = 16'd0;

        $display("---------------------------------------------------------------------");
        $display("Given Values:-");
        $display("Plaintext : 0x%032h", inp);
        $display("Key : 0x%032h", key);
        $display("Expected Cypher Text : 0x%032h", expected_output);
        $display("---------------------------------------------------------------------");

        // Hold reset at 1 for 50 cycles
        repeat (50) @(posedge clk);

        #1;
        if (!reset_glitch_detected) begin
            $display("FIRST 50 CYCLES RESET CHECK: PASSED (Outputs strictly zero)");
        end else begin
            $display("FIRST 50 CYCLES RESET CHECK: FAILED!");
        end
        $display("---------------------------------------------------------------------");

        // Give input and key
        @(posedge clk); aes_inp = full_inp_swapped[127:112]; key_128 = key[127:112];
        @(posedge clk); aes_inp = full_inp_swapped[111:96]; key_128 = key[111:96];
        @(posedge clk); aes_inp = full_inp_swapped[95:80]; key_128 = key[95:80];
        @(posedge clk); aes_inp = full_inp_swapped[79:64]; key_128 = key[79:64];
        @(posedge clk); aes_inp = full_inp_swapped[63:48]; key_128 = key[63:48];
        @(posedge clk); aes_inp = full_inp_swapped[47:32]; key_128 = key[47:32];
        @(posedge clk); aes_inp = full_inp_swapped[31:16]; key_128 = key[31:16];
        @(posedge clk); aes_inp = full_inp_swapped[15:0]; key_128 = key[15:0];

        // Start AES
        @(posedge clk);
        rst = 1'b0;
        en = 1'b1;
        start = 1'b1;
        aes_inp = 16'd0;
        key_128 = 16'd0;

        @(posedge clk);
        start = 1'b0;

        @(posedge key_done);
        $display("Key Expansion Completed :- Time %0t ps", $time);

        $display("---------------------------------------------------------------------");
        @(posedge done);
        #1;

        if (aes_out_formatted === expected_output) begin
            $display("TEST PASSED SUCCESSFULLY!!!");
        end else begin
            $display("TEST FAILED");
            $display("Observed Raw : 0x%032h", aes_out);
            $display("Observed Formatted : 0x%032h", aes_out_formatted);
            $display("Expected : 0x%032h", expected_output);
        end
        $display("---------------------------------------------------------------------");
        $finish;
    end

endmodule