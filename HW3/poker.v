`timescale 1ns/1ps

module poker(type, i0, i1, i2, i3, i4);
//DO NOT CHANGE!
	input  [5:0] i0, i1, i2, i3, i4;
	output [3:0] type;
//---------------------------------------------------
wire isFlush, isStraight, is4Kind, isFullHouse, is3Kind, is2Pair, is1Pair;
wire [5:0] temp1_w;
wire [1:0] temp2_w;
wire [7:0] temp3_w;
//type[3] 0.225ns
AN2 AN2_0(.A(isFlush), .B(isStraight), .Z(type[3]));
//type[2] 0.652ns
NR2 NR2_0(.A(isFlush), .B(isStraight), .Z(temp1_w[0]));
OR2 OR2_0(.A(is4Kind), .B(isFullHouse), .Z(temp1_w[1]));
ND2 ND2_0(.A(temp1_w[0]), .B(temp1_w[1]), .Z(temp1_w[2]));
ND2 ND2_1(.A(isFlush), .B(isStraight), .Z(temp1_w[3]));
OR2 OR2_1(.A(isFlush), .B(isStraight), .Z(temp1_w[4]));
ND2 ND2_2(.A(temp1_w[3]), .B(temp1_w[4]), .Z(temp1_w[5]));
ND2 ND2_3(.A(temp1_w[2]), .B(temp1_w[5]), .Z(type[2]));
//type[1] 0.596ns
NR2 NR2_1(.A(isFlush), .B(isStraight), .Z(temp2_w[0]));
OR4 OR4_0(.A(is4Kind), .B(isFullHouse), .C(is3Kind), .D(is2Pair), .Z(temp2_w[1]));
AN2 AN2_1(.A(temp2_w[0]), .B(temp2_w[1]), .Z(type[1]));
//type[0] 0.702ns
IV IV_0(.A(isStraight), .Z(temp3_w[0]));
OR2 OR2_2(.A(isFlush), .B(is4Kind), .Z(temp3_w[1]));
ND2 ND2_4(.A(temp3_w[0]), .B(temp3_w[1]), .Z(temp3_w[2]));
NR2 NR2_2(.A(isStraight), .B(is4Kind), .Z(temp3_w[3]));
IV IN_1(.A(isFullHouse), .Z(temp3_w[4]));
ND3 ND3_0(.A(temp3_w[3]), .B(temp3_w[4]), .C(is3Kind), .Z(temp3_w[5]));
NR2 NR2_3(.A(isFullHouse), .B(is2Pair), .Z(temp3_w[6]));
ND3 ND3_1(.A(temp3_w[3]), .B(temp3_w[6]), .C(is1Pair), .Z(temp3_w[7]));
ND3 ND3_2(.A(temp3_w[2]), .B(temp3_w[5]), .C(temp3_w[7]), .Z(type[0]));

Flush F(.out(isFlush), .in0(i0[5:4]), .in1(i1[5:4]), .in2(i2[5:4]), .in3(i3[5:4]), .in4(i4[5:4]));
Straight S(.out(isStraight), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
FourKind FK(.out(is4Kind), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
FullHouse FH(.out(isFullHouse), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
ThreeKind TK(.out(is3Kind), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
TwoPair TP(.out(is2Pair), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
OnePair OP(.out(is1Pair), .in0(i0[3:0]), .in1(i1[3:0]), .in2(i2[3:0]), .in3(i3[3:0]), .in4(i4[3:0]));
endmodule

module Flush( //0.956ns
	input  [1:0] in0, in1, in2, in3, in4,
	output out
);
wire t[16:0];
//bit[4]
AN5 AN5_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .D(in3[0]), .E(in4[0]), .Z(t[0]));
NR5 NR5_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .D(in3[0]), .E(in4[0]), .Z(t[1]));
NR2 NR2_0(.A(t[0]), .B(t[1]), .Z(t[2]));
//bit[4]
AN5 AN5_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .D(in3[1]), .E(in4[1]), .Z(t[3]));
NR5 NR5_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .D(in3[1]), .E(in4[1]), .Z(t[4]));
NR2 NR2_1(.A(t[3]), .B(t[4]), .Z(t[5]));
//isFlush
NR2 NR2_2(.A(t[2]), .B(t[5]), .Z(out));
endmodule

module Straight( //1.924ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [12:0] d0, d1, d2, d3, d4, t;
wire [11:0] o;
Decoder D0(.in(in0), .out(d0));
Decoder D1(.in(in1), .out(d1));
Decoder D2(.in(in2), .out(d2));
Decoder D3(.in(in3), .out(d3));
Decoder D4(.in(in4), .out(d4));
genvar i, j;
generate
	for(i=0; i<13; i=i+1) begin: OR5_13
		ND5 ND5_(.A(d0[i]), .B(d1[i]), .C(d2[i]), .D(d3[i]), .E(d4[i]), .Z(t[i]));
	end	
endgenerate
generate
	for(j=0; j<9; j=j+1) begin: AN5_9
		ND5 ND5_(.A(t[j]), .B(t[j+1]), .C(t[j+2]), .D(t[j+3]), .E(t[j+4]), .Z(o[j]));
	end
endgenerate
ND5 ND5_9(.A(t[12]), .B(t[11]), .C(t[10]), .D(t[9]), .E(t[0]), .Z(o[9]));

AN5 AN5_0(.A(o[0]), .B(o[1]), .C(o[2]), .D(o[3]), .E(o[4]), .Z(o[10]));
AN5 AN5_1(.A(o[5]), .B(o[6]), .C(o[7]), .D(o[8]), .E(o[9]), .Z(o[11]));
ND2 ND2_2(.A(o[10]), .B(o[11]), .Z(out));
endmodule

module FourKind( //1.352ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [4:0] t;
//All possibles.
SameCard4 Seq_0(.in0(in0), .in1(in1), .in2(in2), .in3(in3), .out(t[0]));
SameCard4 Seq_1(.in0(in0), .in1(in1), .in2(in2), .in3(in4), .out(t[1]));
SameCard4 Seq_2(.in0(in0), .in1(in1), .in2(in3), .in3(in4), .out(t[2]));
SameCard4 Seq_3(.in0(in0), .in1(in2), .in2(in3), .in3(in4), .out(t[3]));
SameCard4 Seq_4(.in0(in1), .in1(in2), .in2(in3), .in3(in4), .out(t[4]));
//isFourKind
OR5 OR5_0(.A(t[0]), .B(t[1]), .C(t[2]), .D(t[3]), .E(t[4]), .Z(out));
endmodule

module FullHouse( //1.769ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [31:0] t;
//All possibles.
SameCard3 Seq3_0(.in0(in0), .in1(in1), .in2(in2), .out(t[0]));
SameCard2 Seq2_0(.in0(in3), .in1(in4), .out(t[1]));
ND2 ND2_0(.A(t[0]), .B(t[1]), .Z(t[2]));
SameCard3 Seq3_1(.in0(in0), .in1(in1), .in2(in3), .out(t[3]));
SameCard2 Seq2_1(.in0(in2), .in1(in4), .out(t[4]));
ND2 ND2_1(.A(t[3]), .B(t[4]), .Z(t[5]));
SameCard3 Seq3_2(.in0(in0), .in1(in1), .in2(in4), .out(t[6]));
SameCard2 Seq2_2(.in0(in2), .in1(in3), .out(t[7]));
ND2 ND2_2(.A(t[6]), .B(t[7]), .Z(t[8]));
SameCard3 Seq3_3(.in0(in0), .in1(in2), .in2(in3), .out(t[9]));
SameCard2 Seq2_3(.in0(in1), .in1(in4), .out(t[10]));
ND2 ND2_3(.A(t[9]), .B(t[10]), .Z(t[11]));
SameCard3 Seq3_4(.in0(in0), .in1(in2), .in2(in4), .out(t[12]));
SameCard2 Seq2_4(.in0(in1), .in1(in3), .out(t[13]));
ND2 ND2_4(.A(t[12]), .B(t[13]), .Z(t[14]));
SameCard3 Seq3_5(.in0(in0), .in1(in3), .in2(in4), .out(t[15]));
SameCard2 Seq2_5(.in0(in1), .in1(in2), .out(t[16]));
ND2 ND2_5(.A(t[15]), .B(t[16]), .Z(t[17]));
SameCard3 Seq3_6(.in0(in1), .in1(in2), .in2(in3), .out(t[18]));
SameCard2 Seq2_6(.in0(in0), .in1(in4), .out(t[19]));
ND2 ND2_6(.A(t[18]), .B(t[19]), .Z(t[20]));
SameCard3 Seq3_7(.in0(in1), .in1(in2), .in2(in4), .out(t[21]));
SameCard2 Seq2_7(.in0(in0), .in1(in3), .out(t[22]));
ND2 ND2_7(.A(t[21]), .B(t[22]), .Z(t[23]));
SameCard3 Seq3_8(.in0(in1), .in1(in3), .in2(in4), .out(t[24]));
SameCard2 Seq2_8(.in0(in0), .in1(in2), .out(t[25]));
ND2 ND2_8(.A(t[24]), .B(t[25]), .Z(t[26]));
SameCard3 Seq3_9(.in0(in2), .in1(in3), .in2(in4), .out(t[27]));
SameCard2 Seq2_9(.in0(in0), .in1(in1), .out(t[28]));
ND2 ND2_9(.A(t[27]), .B(t[28]), .Z(t[29]));
//isFullHouse
AN5 AN5_0(.A(t[2]), .B(t[5]), .C(t[8]), .D(t[11]), .E(t[14]), .Z(t[30]));
AN5 AN5_1(.A(t[17]), .B(t[20]), .C(t[23]), .D(t[26]), .E(t[29]), .Z(t[31]));
ND2 ND2_10(.A(t[30]), .B(t[31]), .Z(out));
endmodule

module ThreeKind( //1.595ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [11:0] t;
//All possibles.
SameCard3 Seq_0(.in0(in0), .in1(in1), .in2(in2), .out(t[0]));
SameCard3 Seq_1(.in0(in0), .in1(in1), .in2(in3), .out(t[1]));
SameCard3 Seq_2(.in0(in0), .in1(in1), .in2(in4), .out(t[2]));
SameCard3 Seq_3(.in0(in0), .in1(in2), .in2(in3), .out(t[3]));
SameCard3 Seq_4(.in0(in0), .in1(in2), .in2(in4), .out(t[4]));
SameCard3 Seq_5(.in0(in0), .in1(in3), .in2(in4), .out(t[5]));
SameCard3 Seq_6(.in0(in1), .in1(in2), .in2(in3), .out(t[6]));
SameCard3 Seq_7(.in0(in1), .in1(in2), .in2(in4), .out(t[7]));
SameCard3 Seq_8(.in0(in1), .in1(in3), .in2(in4), .out(t[8]));
SameCard3 Seq_9(.in0(in2), .in1(in3), .in2(in4), .out(t[9]));
//isThreeKind
NR5 NR5_0(.A(t[0]), .B(t[1]), .C(t[2]), .D(t[3]), .E(t[4]), .Z(t[10]));
NR5 NR5_1(.A(t[5]), .B(t[6]), .C(t[7]), .D(t[8]), .E(t[9]), .Z(t[11]));
ND2 ND_0(.A(t[10]), .B(t[11]), .Z(out));
endmodule

module TwoPair( //1.651ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [47:0] t;
//All possibles.
SameCard2 Seq0_0(.in0(in0), .in1(in1), .out(t[0]));
SameCard2 Seq0_1(.in0(in2), .in1(in3), .out(t[1]));
ND2 ND2_0(.A(t[0]), .B(t[1]), .Z(t[2]));
SameCard2 Seq1_0(.in0(in0), .in1(in1), .out(t[3]));
SameCard2 Seq1_1(.in0(in2), .in1(in4), .out(t[4]));
ND2 ND2_1(.A(t[3]), .B(t[4]), .Z(t[5]));
SameCard2 Seq2_0(.in0(in0), .in1(in1), .out(t[6]));
SameCard2 Seq2_1(.in0(in3), .in1(in4), .out(t[7]));
ND2 ND2_2(.A(t[6]), .B(t[7]), .Z(t[8]));
SameCard2 Seq3_0(.in0(in0), .in1(in2), .out(t[9]));
SameCard2 Seq3_1(.in0(in1), .in1(in3), .out(t[10]));
ND2 ND2_3(.A(t[9]), .B(t[10]), .Z(t[11]));
SameCard2 Seq4_0(.in0(in0), .in1(in2), .out(t[12]));
SameCard2 Seq4_1(.in0(in1), .in1(in4), .out(t[13]));
ND2 ND2_4(.A(t[12]), .B(t[13]), .Z(t[14]));
SameCard2 Seq5_0(.in0(in0), .in1(in2), .out(t[15]));
SameCard2 Seq5_1(.in0(in3), .in1(in4), .out(t[16]));
ND2 ND2_5(.A(t[15]), .B(t[16]), .Z(t[17]));
SameCard2 Seq6_0(.in0(in0), .in1(in3), .out(t[18]));
SameCard2 Seq6_1(.in0(in1), .in1(in2), .out(t[19]));
ND2 ND2_6(.A(t[18]), .B(t[19]), .Z(t[20]));
SameCard2 Seq7_0(.in0(in0), .in1(in3), .out(t[21]));
SameCard2 Seq7_1(.in0(in1), .in1(in4), .out(t[22]));
ND2 ND2_7(.A(t[21]), .B(t[22]), .Z(t[23]));
SameCard2 Seq8_0(.in0(in0), .in1(in3), .out(t[24]));
SameCard2 Seq8_1(.in0(in2), .in1(in4), .out(t[25]));
ND2 ND2_8(.A(t[24]), .B(t[25]), .Z(t[26]));
SameCard2 Seq9_0(.in0(in0), .in1(in4), .out(t[27]));
SameCard2 Seq9_1(.in0(in1), .in1(in2), .out(t[28]));
ND2 ND2_9(.A(t[27]), .B(t[28]), .Z(t[29]));
SameCard2 Seq10_0(.in0(in0), .in1(in4), .out(t[30]));
SameCard2 Seq10_1(.in0(in1), .in1(in3), .out(t[31]));
ND2 ND2_10(.A(t[30]), .B(t[31]), .Z(t[32]));
SameCard2 Seq11_0(.in0(in0), .in1(in4), .out(t[33]));
SameCard2 Seq11_1(.in0(in2), .in1(in3), .out(t[34]));
ND2 ND2_11(.A(t[33]), .B(t[34]), .Z(t[35]));
SameCard2 Seq12_0(.in0(in1), .in1(in2), .out(t[36]));
SameCard2 Seq12_1(.in0(in3), .in1(in4), .out(t[37]));
ND2 ND2_12(.A(t[36]), .B(t[37]), .Z(t[38]));
SameCard2 Seq13_0(.in0(in1), .in1(in3), .out(t[39]));
SameCard2 Seq13_1(.in0(in2), .in1(in4), .out(t[40]));
ND2 ND2_13(.A(t[39]), .B(t[40]), .Z(t[41]));
SameCard2 Seq14_0(.in0(in1), .in1(in4), .out(t[42]));
SameCard2 Seq14_1(.in0(in2), .in1(in3), .out(t[43]));
ND2 ND2_14(.A(t[42]), .B(t[43]), .Z(t[44]));
//isTwoPair
AN5 AN5_0(.A(t[2]), .B(t[5]), .C(t[8]), .D(t[11]), .E(t[14]), .Z(t[45]));
AN5 AN5_1(.A(t[17]), .B(t[20]), .C(t[23]), .D(t[26]), .E(t[29]), .Z(t[46]));
AN5 AN5_2(.A(t[32]), .B(t[35]), .C(t[38]), .D(t[41]), .E(t[44]), .Z(t[47]));
ND3 ND3_0(.A(t[45]), .B(t[46]), .C(t[47]), .Z(out));
endmodule

module OnePair( //1.477ns
	input [3:0] in0, in1, in2, in3, in4,
	output out
);
wire [11:0] t;
//All possibles.
SameCard2 Seq_0(.in0(in0), .in1(in1), .out(t[0]));
SameCard2 Seq_1(.in0(in0), .in1(in2), .out(t[1]));
SameCard2 Seq_2(.in0(in0), .in1(in3), .out(t[2]));
SameCard2 Seq_3(.in0(in0), .in1(in4), .out(t[3]));
SameCard2 Seq_4(.in0(in1), .in1(in2), .out(t[4]));
SameCard2 Seq_5(.in0(in1), .in1(in3), .out(t[5]));
SameCard2 Seq_6(.in0(in1), .in1(in4), .out(t[6]));
SameCard2 Seq_7(.in0(in2), .in1(in3), .out(t[7]));
SameCard2 Seq_8(.in0(in2), .in1(in4), .out(t[8]));
SameCard2 Seq_9(.in0(in3), .in1(in4), .out(t[9]));
//isOnePair
NR5 NR5_0(.A(t[0]), .B(t[1]), .C(t[2]), .D(t[3]), .E(t[4]), .Z(t[10]));
NR5 NR5_1(.A(t[5]), .B(t[6]), .C(t[7]), .D(t[8]), .E(t[9]), .Z(t[11]));
ND2 ND_0(.A(t[10]), .B(t[11]), .Z(out));
endmodule

module Decoder( //0.423ns
	input [3:0] in,
	output [12:0] out
);
wire not_in[3:0];

IV not_0(.A(in[0]), .Z(not_in[0]));
IV not_1(.A(in[1]), .Z(not_in[1]));
IV not_2(.A(in[2]), .Z(not_in[2]));
IV not_3(.A(in[3]), .Z(not_in[3]));

ND4 Y0(.A(not_in[3]), .B(not_in[2]), .C(not_in[1]), .D(in[0]), .Z(out[0]));
ND4 Y1(.A(not_in[3]), .B(not_in[2]), .C(in[1]), .D(not_in[0]), .Z(out[1]));
ND4 Y2(.A(not_in[3]), .B(not_in[2]), .C(in[1]), .D(in[0]), .Z(out[2]));
ND4 Y3(.A(not_in[3]), .B(in[2]), .C(not_in[1]), .D(not_in[0]), .Z(out[3]));
ND4 Y4(.A(not_in[3]), .B(in[2]), .C(not_in[1]), .D(in[0]), .Z(out[4]));
ND4 Y5(.A(not_in[3]), .B(in[2]), .C(in[1]), .D(not_in[0]), .Z(out[5]));
ND4 Y6(.A(not_in[3]), .B(in[2]), .C(in[1]), .D(in[0]), .Z(out[6]));
ND4 Y7(.A(in[3]), .B(not_in[2]), .C(not_in[1]), .D(not_in[0]), .Z(out[7]));
ND4 Y8(.A(in[3]), .B(not_in[2]), .C(not_in[1]), .D(in[0]), .Z(out[8]));
ND4 Y9(.A(in[3]), .B(not_in[2]), .C(in[1]), .D(not_in[0]), .Z(out[9]));
ND4 Y10(.A(in[3]), .B(not_in[2]), .C(in[1]), .D(in[0]), .Z(out[10]));
ND4 Y11(.A(in[3]), .B(in[2]), .C(not_in[1]), .D(not_in[0]), .Z(out[11]));
ND4 Y12(.A(in[3]), .B(in[2]), .C(not_in[1]), .D(in[0]), .Z(out[12]));
endmodule

module SameCard4( //0.917ns
	input [3:0] in0, in1, in2, in3,
	output out
);
wire [11:0] t;
//bit[0]
AN4 AN4_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .D(in3[0]), .Z(t[0]));
NR4 NR4_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .D(in3[0]), .Z(t[1]));
NR2 NR2_0(.A(t[0]), .B(t[1]), .Z(t[2]));
//bit[1]
AN4 AN4_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .D(in3[1]), .Z(t[3]));
NR4 NR4_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .D(in3[1]), .Z(t[4]));
NR2 NR2_1(.A(t[3]), .B(t[4]), .Z(t[5]));
//bit[2]
AN4 AN4_2(.A(in0[2]), .B(in1[2]), .C(in2[2]), .D(in3[2]), .Z(t[6]));
NR4 NR4_2(.A(in0[2]), .B(in1[2]), .C(in2[2]), .D(in3[2]), .Z(t[7]));
NR2 NR2_2(.A(t[6]), .B(t[7]), .Z(t[8]));
//bit[3]
AN4 AN4_3(.A(in0[3]), .B(in1[3]), .C(in2[3]), .D(in3[3]), .Z(t[9]));
NR4 NR4_3(.A(in0[3]), .B(in1[3]), .C(in2[3]), .D(in3[3]), .Z(t[10]));
NR2 NR2_3(.A(t[9]), .B(t[10]), .Z(t[11]));
//isSameCard
NR4 NR4_4(.A(t[2]), .B(t[5]), .C(t[8]), .D(t[11]), .Z(out));
endmodule

module SameCard3( //0.917ns
	input [3:0] in0, in1, in2,
	output out
);
wire [11:0] t;
//bit[0]
AN3 AN3_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .Z(t[0]));
NR3 NR4_0(.A(in0[0]), .B(in1[0]), .C(in2[0]), .Z(t[1]));
NR2 NR2_0(.A(t[0]), .B(t[1]), .Z(t[2]));
//bit[1]
AN3 AN3_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .Z(t[3]));
NR3 NR4_1(.A(in0[1]), .B(in1[1]), .C(in2[1]), .Z(t[4]));
NR2 NR2_1(.A(t[3]), .B(t[4]), .Z(t[5]));
//bit[2]
AN3 AN3_2(.A(in0[2]), .B(in1[2]), .C(in2[2]), .Z(t[6]));
NR3 NR4_2(.A(in0[2]), .B(in1[2]), .C(in2[2]), .Z(t[7]));
NR2 NR2_2(.A(t[6]), .B(t[7]), .Z(t[8]));
//bit[3]
AN3 AN3_3(.A(in0[3]), .B(in1[3]), .C(in2[3]), .Z(t[9]));
NR3 NR4_3(.A(in0[3]), .B(in1[3]), .C(in2[3]), .Z(t[10]));
NR2 NR2_3(.A(t[9]), .B(t[10]), .Z(t[11]));
//isSameCard
NR4 NR4_4(.A(t[2]), .B(t[5]), .C(t[8]), .D(t[11]), .Z(out));
endmodule

module SameCard2( //0.799ns
	input [3:0] in0, in1,
	output out
);
wire [11:0] t;
//bit[0]
AN2 AN2_0(.A(in0[0]), .B(in1[0]), .Z(t[0]));
NR2 NR2_0(.A(in0[0]), .B(in1[0]), .Z(t[1]));
NR2 NR2_1(.A(t[0]), .B(t[1]), .Z(t[2]));
//bit[1]
AN2 AN2_1(.A(in0[1]), .B(in1[1]), .Z(t[3]));
NR2 NR2_2(.A(in0[1]), .B(in1[1]), .Z(t[4]));
NR2 NR2_3(.A(t[3]), .B(t[4]), .Z(t[5]));
//bit[2]
AN2 AN2_2(.A(in0[2]), .B(in1[2]), .Z(t[6]));
NR2 NR2_4(.A(in0[2]), .B(in1[2]), .Z(t[7]));
NR2 NR2_5(.A(t[6]), .B(t[7]), .Z(t[8]));
//bit[3]
AN2 AN2_3(.A(in0[3]), .B(in1[3]), .Z(t[9]));
NR2 NR2_6(.A(in0[3]), .B(in1[3]), .Z(t[10]));
NR2 NR2_7(.A(t[9]), .B(t[10]), .Z(t[11]));
//isSameCard
NR4 NR4_0(.A(t[2]), .B(t[5]), .C(t[8]), .D(t[11]), .Z(out));
endmodule

module AN5( //0.5ns
	input A, B, C, D, E,
	output Z
);
wire [2:0] t;
AN2 AN_0(.A(A), .B(B), .Z(t[0]));
AN2 AN_1(.A(C), .B(D), .Z(t[1]));
AN2 AN_2(.A(E), .B(E), .Z(t[2]));
AN3 AN_3(.A(t[0]), .B(t[1]), .C(t[2]), .Z(Z));
endmodule

module ND5( //0.451ns
	input A, B, C, D, E,
	output Z
);
wire [2:0] t;
AN2 AN_0(.A(A), .B(B), .Z(t[0]));
AN2 AN_1(.A(C), .B(D), .Z(t[1]));
AN2 AN_2(.A(E), .B(E), .Z(t[2]));
ND3 ND_3(.A(t[0]), .B(t[1]), .C(t[2]), .Z(Z));
endmodule

module OR5( //0.453ns
	input A, B, C, D, E,
	output Z
);
wire [2:0] t;
NR2 NR_0(.A(A), .B(B), .Z(t[0]));
NR2 NR_1(.A(C), .B(D), .Z(t[1]));
NR2 NR_2(.A(E), .B(E), .Z(t[2]));
ND3 ND_3(.A(t[0]), .B(t[1]), .C(t[2]), .Z(Z));
endmodule

module NR5( //0.502ns
	input A, B, C, D, E,
	output Z
);
wire [2:0] t;
NR2 ND_0(.A(A), .B(B), .Z(t[0]));
NR2 ND_1(.A(C), .B(D), .Z(t[1]));
NR2 ND_2(.A(E), .B(E), .Z(t[2]));
AN3 AN_0(.A(t[0]), .B(t[1]), .C(t[2]), .Z(Z));
endmodule