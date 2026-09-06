`timescale 1ns / 1ps

module tb_subBytes;

reg [127:0] state;
wire [127:0] out;

integer errors;

subBytes dut (
    .state(state),
    .sub_out(out)
);

initial 
begin
    errors=0;

    state = 128'h00000000000000000000000000000000;
    #10;
    if (out != 128'h63636363636363636363636363636363)
        errors = errors + 1;

    state = 128'h161553540b83ec40083168a419335019;
    #10;
    if (out != 128'h4759ed202becce0930c74549d4c353d4)
        errors = errors + 1; 

    state = 128'h0f0e0d0c0b0a09080706050403020100;
    #10;
    if (out != 128'h76abd7fe2b670130c56f6bf27b777c63)
        errors = errors + 1; 

    if(errors==0)
        $display("ALL TESTS PASSED!");
    else
        $display("ERRORS: %0d", errors);

    $finish;
end

endmodule