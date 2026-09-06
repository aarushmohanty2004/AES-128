`timescale 1ns / 1ps

module tb_sBox;

reg [7:0] d;
wire [7:0] sout;

integer errors;

sBox dut (
    .d(d),
    .sout(sout)
);

initial 
begin
    errors=0;

    d = 8'he5;
    #10;
    if(sout != 8'hd9)
        errors = errors + 1;
    
    d = 8'h00;
    #10;
    if(sout != 8'h63)
        errors = errors + 1;

    d = 8'hff;
    #10;
    if(sout != 8'h16)
        errors = errors + 1;


    if(errors==0)
        $display("ALL TESTS PASSED!");
    else
        $display("ERRORS: %0d", errors);

    $finish;
end

endmodule