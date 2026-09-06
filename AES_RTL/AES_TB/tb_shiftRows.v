`timescale 1ns / 1ps

module tb_shiftRows;

reg  [127:0] state;
wire [127:0] out;

integer errors;

shiftRows dut (
    .state(state),
    .shift_out(out)
);

initial 
begin
    errors = 0;

    // Test 1: All Zeros (Edge case)
    state = 128'h00000000000000000000000000000000;
    #10;
    if (out != 128'h00000000000000000000000000000000)
        errors = errors + 1;
    
    state = 128'h0f0e0d0c0b0a09080706050403020100;
    #10;
    if (out != 128'h0b06010c07020d08030e09040f0a0500)
        errors = errors + 1;

    state = 128'h475920a02be5cec730c74549d4c353d4;
    #10;
    if (out != 128'h2bc753a030c320c7d459ce4947e545d4)
        errors = errors + 1;

    if (errors == 0)
        $display("ALL TESTS PASSED!");
    else
        $display("ERRORS: %0d", errors);

    $finish;
end

endmodule