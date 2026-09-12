module aes_top (
	input wire clk,
	input wire en,
	output wire e128,
	output wire d128
);
	wire [127:0] inp;
	wire [127:0] key128;
	
	wire [127:0] sin;
	wire [127:0] sout;
	reg sub_start = 1'b0;
	wire sub_done;
	wire sub_busy;

	subBytes sub (
		.clk(clk),
		.en(en),
		.start(sub_start),
		.state(sin),
		.sub_out(sout),
		.done(sub_done),
		.busy(sub_busy)
	);
	
	wire [127:0] shiftin;
	wire [127:0] shiftout;
	shiftRows shift (
		.state(shiftin),
		.shift_out(shiftout)
	);
	
endmodule