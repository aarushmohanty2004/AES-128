module aes_top (
    input wire clk,
    input wire en,
    input wire start,
	input wire [127:0] aes_inp,
	input wire [127:0] key_128,
	output wire [127:0] aes_out,
	output wire done,
	output wire key_done
);
	
	// wires for addroundkey
	wire [127:0] ark_r0_out,ark_r1_out,ark_r2_out,ark_r3_out,ark_r4_out,ark_r5_out,ark_r6_out,ark_r7_out,ark_r8_out,ark_r9_out;
	
	// wires for subbytes
	wire [127:0] sub_r1_out,sub_r2_out,sub_r3_out,sub_r4_out,sub_r5_out,sub_r6_out,sub_r7_out,sub_r8_out,sub_r9_out,sub_r10_out;
	wire sub_r1_done,sub_r2_done,sub_r3_done,sub_r4_done,sub_r5_done,sub_r6_done,sub_r7_done,sub_r8_done,sub_r9_done;
	
	//wires for shiftrows
	wire [127:0] shift_r1_out,shift_r2_out,shift_r3_out,shift_r4_out,shift_r5_out,shift_r6_out,shift_r7_out,shift_r8_out,shift_r9_out,shift_r10_out;
	
	// wires for mixcolumns
	wire [127:0] mix_r1_out,mix_r2_out,mix_r3_out,mix_r4_out,mix_r5_out,mix_r6_out,mix_r7_out,mix_r8_out,mix_r9_out;
	
	// wires for keys and keygeneration
	wire [1407:0] all_round_keys;
	wire [127:0] k0  = all_round_keys[127:0];
	wire [127:0] k1  = all_round_keys[255:128];
	wire [127:0] k2  = all_round_keys[383:256];
	wire [127:0] k3  = all_round_keys[511:384];
	wire [127:0] k4  = all_round_keys[639:512];
	wire [127:0] k5  = all_round_keys[767:640];
	wire [127:0] k6  = all_round_keys[895:768];
	wire [127:0] k7  = all_round_keys[1023:896];
	wire [127:0] k8  = all_round_keys[1151:1024];
	wire [127:0] k9  = all_round_keys[1279:1152];
	wire [127:0] k10 = all_round_keys[1407:1280];
	
	keyExpansion key_gen (
    .clk(clk),
    .ena(en),
    .start(start),
    .key(key_128),
    .w(all_round_keys),
    .done(key_done),
    .busy()
	);
	
	//round 0
	addRoundKey rk_r0 ( .inp(aes_inp), .key(k0), .out(ark_r0_out) );
	
	//round 1
	subBytes sub_r1 (
    .clk(clk),
    .ena(en),
    .start(key_done),
    .state(ark_r0_out),
    .sub_out(sub_r1_out),
    .done(sub_r1_done),
    .busy());
	shiftRows shift_r1 ( .state(sub_r1_out), .shift_out(shift_r1_out) );
	mixColumns mix_r1 ( .in(shift_r1_out), .out(mix_r1_out) );
	addRoundKey rk_r1 ( .inp(mix_r1_out), .key(k1), .out(ark_r1_out) );
	
	//round 2
	subBytes sub_r2 (
    .clk(clk),
    .ena(en),
    .start(sub_r1_done),
    .state(ark_r1_out),
    .sub_out(sub_r2_out),
    .done(sub_r2_done),
    .busy());
	shiftRows shift_r2 ( .state(sub_r2_out), .shift_out(shift_r2_out) );
	mixColumns mix_r2 ( .in(shift_r2_out), .out(mix_r2_out) );
	addRoundKey rk_r2 ( .inp(mix_r2_out), .key(k2), .out(ark_r2_out) );
	
	//round 3
	subBytes sub_r3 (
    .clk(clk),
    .ena(en),
    .start(sub_r2_done),
    .state(ark_r2_out),
    .sub_out(sub_r3_out),
    .done(sub_r3_done),
    .busy());
	shiftRows shift_r3 ( .state(sub_r3_out), .shift_out(shift_r3_out) );
	mixColumns mix_r3 ( .in(shift_r3_out), .out(mix_r3_out) );
	addRoundKey rk_r3 ( .inp(mix_r3_out), .key(k3), .out(ark_r3_out) );
	
	//round 4
	subBytes sub_r4 (
    .clk(clk),
    .ena(en),
    .start(sub_r3_done),
    .state(ark_r3_out),
    .sub_out(sub_r4_out),
    .done(sub_r4_done),
    .busy());
	shiftRows shift_r4 ( .state(sub_r4_out), .shift_out(shift_r4_out) );
	mixColumns mix_r4 ( .in(shift_r4_out), .out(mix_r4_out) );
	addRoundKey rk_r4 ( .inp(mix_r4_out), .key(k4), .out(ark_r4_out) );
	
	//round 5
	subBytes sub_r5 (
    .clk(clk),
    .ena(en),
    .start(sub_r4_done),
    .state(ark_r4_out),
    .sub_out(sub_r5_out),
    .done(sub_r5_done),
    .busy());
	shiftRows shift_r5 ( .state(sub_r5_out), .shift_out(shift_r5_out) );
	mixColumns mix_r5 ( .in(shift_r5_out), .out(mix_r5_out) );
	addRoundKey rk_r5 ( .inp(mix_r5_out), .key(k5), .out(ark_r5_out) );
	
	//round 6
	subBytes sub_r6 (
    .clk(clk),
    .ena(en),
    .start(sub_r5_done),
    .state(ark_r5_out),
    .sub_out(sub_r6_out),
    .done(sub_r6_done),
    .busy());
	shiftRows shift_r6 ( .state(sub_r6_out), .shift_out(shift_r6_out) );
	mixColumns mix_r6 ( .in(shift_r6_out), .out(mix_r6_out) );
	addRoundKey rk_r6 ( .inp(mix_r6_out), .key(k6), .out(ark_r6_out) );
	
	//round 7
	subBytes sub_r7 (
    .clk(clk),
    .ena(en),
    .start(sub_r6_done),
    .state(ark_r6_out),
    .sub_out(sub_r7_out),
    .done(sub_r7_done),
    .busy());
	shiftRows shift_r7 ( .state(sub_r7_out), .shift_out(shift_r7_out) );
	mixColumns mix_r7 ( .in(shift_r7_out), .out(mix_r7_out) );
	addRoundKey rk_r7 ( .inp(mix_r7_out), .key(k7), .out(ark_r7_out) );
	
	//round 8
	subBytes sub_r8 (
    .clk(clk),
    .ena(en),
    .start(sub_r7_done),
    .state(ark_r7_out),
    .sub_out(sub_r8_out),
    .done(sub_r8_done),
    .busy());
	shiftRows shift_r8 ( .state(sub_r8_out), .shift_out(shift_r8_out) );
	mixColumns mix_r8 ( .in(shift_r8_out), .out(mix_r8_out) );
	addRoundKey rk_r8 ( .inp(mix_r8_out), .key(k8), .out(ark_r8_out) );
	
	//round 9
	subBytes sub_r9 (
    .clk(clk),
    .ena(en),
    .start(sub_r8_done),
    .state(ark_r8_out),
    .sub_out(sub_r9_out),
    .done(sub_r9_done),
    .busy());
	shiftRows shift_r9 ( .state(sub_r9_out), .shift_out(shift_r9_out) );
	mixColumns mix_r9 ( .in(shift_r9_out), .out(mix_r9_out) );
	addRoundKey rk_r9 ( .inp(mix_r9_out), .key(k9), .out(ark_r9_out) );
	
	//last round (round 10)
	subBytes sub_r10 (
    .clk(clk),
    .ena(en),
    .start(sub_r9_done),
    .state(ark_r9_out),
    .sub_out(sub_r10_out),
    .done(done),
    .busy());
	shiftRows shift_r10 ( .state(sub_r10_out), .shift_out(shift_r10_out) );
	addRoundKey rk_r10 ( .inp(shift_r10_out), .key(k10), .out(aes_out) );
endmodule