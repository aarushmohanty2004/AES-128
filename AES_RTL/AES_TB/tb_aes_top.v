`timescale 1ns / 1ps

module tb_aes_top;
	// inputs as reg and outputs as wire
    reg clk,en,start;
    reg [127:0] aes_inp;
    reg [127:0] key_128;
    wire [127:0] aes_out;
    wire done,key_done;

	//helper function
    function [127:0] byte_swap_128(input [127:0] in);
        integer idx;
        begin
            for (idx = 0; idx < 16; idx = idx + 1) begin
                byte_swap_128[idx*8 +: 8] = in[(15 - idx)*8 +: 8];
            end
        end
    endfunction

    // instantiate dut
    aes_top dut (
        .clk      (clk),
        .en       (en),
        .start    (start),
        .aes_inp  (aes_inp),
        .key_128  (key_128),
        .aes_out  (aes_out),
        .done     (done),
        .key_done (key_done)
    );

    //clock generation
    always #5 clk = ~clk;

    // Expected Test Variables from AES-128 document
    localparam [127:0] inp = 128'h3243f6a8885a308d313198a2e0370734;
    localparam [127:0] key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    localparam [127:0] expected_output = 128'h3925841d02dc09fbdc118597196a0b32;

    wire [127:0] aes_out_formatted = byte_swap_128(aes_out);

    initial begin
        clk = 1'b0;
        en = 1'b0;
        start = 1'b0;
        aes_inp = 128'd0;
        key_128 = 128'd0;

        #20;
        en = 1'b1;
        aes_inp = byte_swap_128(inp);
        key_128 = key;
		
		$display("---------------------------------------------------------------------");
        $display("Given Values:-");
        $display("Plaintext : 0x%032h", inp);
        $display("Key : 0x%032h", key);
        $display("Expected Cypher Text : 0x%032h", expected_output);
        $display("---------------------------------------------------------------------");

        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        @(posedge key_done);
        $display("Key Expansion Completed :- Time %0t ps", $time);
		
		$display("---------------------------------------------------------------------");
        @(posedge done);
        #1;

        if (aes_out_formatted === expected_output) 
			begin
				$display("TEST PASSED SUCCESSFULLY!!!");
			end 
		else 
			begin
				$display("TEST FAILED");
				$display("Observed Raw : 0x%032h", aes_out);
				$display("Observed Formatted: 0x%032h", aes_out_formatted);
				$display("Expected : 0x%032h", expected_output);
			end
        $display("---------------------------------------------------------------------");
        $finish;
    end

endmodule