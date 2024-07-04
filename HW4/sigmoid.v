module sigmoid (
	input         clk,
	input         rst_n,
	input         i_in_valid,
	input  [ 7:0] i_x,
	output [15:0] o_y,
	output        o_out_valid,
	output [50:0] number
);
wire [7:0] i_x_ASR2, i_x_ABS, i_x_COM, i_x_ADD1, i_x_REG0;
wire [15:0] i_x_SQ, i_x_ASR1, i_x_OUT, i_x_REG1;
wire i_x_REG2, i_x_REG3;
wire [50:0] numbers [1:12];

// Your design
//REGP#(.BW(8)) REG_0(.D(i_x), .Q(i_x_REG0), .number(numbers[0]), .clk(clk), .rst_n(rst_n));
ASR#(.BW(8), .SH(2)) ASR2(.A(i_x), .Z(i_x_ASR2), .number(numbers[1]));
ABS ABS_0(.A(i_x_ASR2), .Z(i_x_ABS), .number(numbers[2]));
COM#(.BW(8)) COM_0(.A(i_x_ABS), .Z(i_x_COM), .number(numbers[3]));
ADD1#(.BW(8)) ADD1_0(.A(i_x_COM), .Z(i_x_ADD1), .number(numbers[4]));
SQ SQ_0(.i_x(i_x_ADD1), .o_x(i_x_SQ), .number(numbers[5]), .clk(clk), .rst_n(rst_n));
ASR#(.BW(16), .SH(1)) ASR1(.A(i_x_SQ), .Z(i_x_ASR1), .number(numbers[6]));
F_OP F_OP_0(.A(i_x_ASR1), .Sign(i_x[7]), .Z(i_x_OUT), .number(numbers[7]));
OUT OUT_0(.A(i_x_OUT), .Z(i_x_REG1), .number(numbers[8]));
REGP#(.BW(16)) REG_1(.D(i_x_REG1), .Q(o_y), .number(numbers[9]), .clk(clk), .rst_n(rst_n));
AN2 AN2_0(.A(rst_n), .B(i_in_valid), .Z(i_x_REG2), .number(numbers[10]));
REGP#(.BW(1)) REG_2(.D(i_x_REG2), .Q(i_x_REG3), .number(numbers[11]), .clk(clk), .rst_n(rst_n));
REGP#(.BW(1)) REG_3(.D(i_x_REG3), .Q(o_out_valid), .number(numbers[12]), .clk(clk), .rst_n(rst_n));

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=1; j<13; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input           clk,
	input           rst_n,
	output [BW-1:0] Q,
	input  [BW-1:0] D,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module ASR#( //0.174ns
	parameter BW,
	parameter SH
)(
	input [BW-1:0] A,
	output [BW-1:0] Z,
	output [50:0] number
);
wire [50:0] numbers [0:BW-1];
genvar i;
generate
	for (i=0; i<BW-SH; i=i+1) begin
		DRIVER D_0(.A(A[i+SH]), .Z(Z[i]), .number(numbers[i]));
	end
	for (i=BW-SH; i<BW; i=i+1) begin
		DRIVER D_1(.A(A[BW-1]), .Z(Z[i]), .number(numbers[i]));
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module ADD1#( //0.174ns
	parameter BW
)(
	input [BW-1:0] A,
	output [BW-1:0] Z,
	output [50:0] number
);
wire [50:0] numbers [0:BW-1];
genvar i;
generate
	for (i=0; i<BW*5/8; i=i+1) begin
		DRIVER D_0(.A(A[i]), .Z(Z[i]), .number(numbers[i]));
	end
	for (i=BW*5/8+1; i<BW; i=i+1) begin
		DRIVER D_1(.A(1'b0), .Z(Z[i]), .number(numbers[i]));
	end
endgenerate
IV IV_0(.A(A[BW-1]), .Z(Z[BW*5/8]), .number(numbers[BW*5/8]));

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module COM#( //2.147ns
	parameter BW
)(
	input [BW-1:0] A,
	output [BW-1:0] Z,
	output [50:0] number
);
wire [BW-2:1] O;
wire [BW-1:0] A_IV;
wire [50:0] numbers_D, numbers_OR [1:BW-2], numbers_MUX [0:BW-2], numbers_IV [1:BW-1];

DRIVER D_0(.A(A[0]), .Z(Z[0]), .number(numbers_D));
OR2 OR2_0(.A(A[0]), .B(A[1]), .Z(O[1]), .number(numbers_OR[1]));
MUX21H MUX21H_0(.A(A[1]), .B(A_IV[1]), .CTRL(A[0]), .Z(Z[1]), .number(numbers_MUX[0]));

genvar i;
generate
	for (i=1; i<BW; i=i+1) begin
		IV IV_0(.A(A[i]), .Z(A_IV[i]), .number(numbers_IV[i]));
	end
	for (i=2; i<BW-1; i=i+1) begin
		OR2 OR2_1(.A(A[i]), .B(O[i-1]), .Z(O[i]), .number(numbers_OR[i]));
	end
	for (i=2; i<BW; i=i+1) begin
		MUX21H MUX21H_1(.A(A[i]), .B(A_IV[i]), .CTRL(O[i-1]), .Z(Z[i]), .number(numbers_MUX[i-1]));
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=1; j<BW-1; j=j+1) begin 
		sum = sum + numbers_OR[j];
	end
	for (j=0; j<BW-1; j=j+1) begin 
		sum = sum + numbers_MUX[j];
	end
	for (j=1; j<BW; j=j+1) begin 
		sum = sum + numbers_IV[j];
	end
end

assign number = sum + numbers_D;

endmodule

module ABS#( //2.494ns
	parameter BW = 8
)(
	input [BW-1:0] A,
	output [BW-1:0] Z,
	output [50:0] number
);

wire [BW-1:0] A_COM;
wire [50:0] numbers [0:BW];
COM#(.BW(8)) A_COM8(.A(A), .Z(A_COM), .number(numbers[0]));
genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H MUX21H_0(.A(A[i]), .B(A_COM[i]), .CTRL(A[BW-1]), .Z(Z[i]), .number(numbers[i+1]));
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW+1; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module SQ( //max(5.66, 6.1)ns
	input  [7:0]i_x,
	output [15:0]o_x,
	output [50:0] number,
	input clk,
	input rst_n
);
wire [7:0]  i_a, i_b, o_ab [0:7];
wire [50:0] num_REG [0:7], num_a [0:7], num_b [0:7], num_00 [0:8], num_01 [0:7], num_02 [0:7], num_03 [0:7], num_04 [0:7], num_05 [0:7], num_06 [0:8], sum[0:9];
wire [50:0] num_07 [0:7][0:7];
reg  [50:0] total_sum;
wire ha_0_w;
wire [7:0] REG, fa_0_w, fa_1_w, fa_2_w, fa_3_w, fa_4_w, fa_5_w, fa_6_w, fa_7_w, fa_01_w, fa_02_w, fa_03_w, fa_04_w, fa_05_w, fa_06_w;

genvar i;
generate 
for ( i=0; i<8 ;i=i+1 ) begin
	DRIVER D_0(.Z(i_a[i]), .A(i_x[i]),.number(num_a[i]));
	DRIVER D_1(.Z(i_b[i]), .A(i_x[i]),.number(num_b[i]));
end
endgenerate

genvar p,q;
generate 
for (p=0; p<8; p=p+1) begin
	for (q=0; q<8; q=q+1) begin
		AN2 A_0(.Z(o_ab[p][q]),.A(i_a[p]),.B(i_b[q]),.number(num_07[p][q]));
	end
end
endgenerate 
integer u,y;
always @(*)begin
	total_sum=0;
	for ( u=0; u<8 ;u=u+1 ) begin
		for (y=0;y<8; y=y+1) begin
			total_sum = total_sum + num_07[u][y];
		end
	end
end
//第一列的FA和HA
//S0
DRIVER DR_00(.Z(o_x[0]),.A(o_ab[0][0]),.number(num_00[0]));
//HA,s1
HA1 ha_00(.O(ha_0_w), .S(o_x[1]), .A(o_ab[1][0]), .B(o_ab[0][1]), .number(num_00[1]));
//FA
FA1 fa_10(.CO(fa_0_w[0]), .S(fa_01_w[0]), .A(o_ab[2][0]), .B(o_ab[1][1]), .CI(ha_0_w), .number(num_00[2]));
FA1 fa_20(.CO(fa_0_w[1]), .S(fa_01_w[1]), .A(o_ab[3][0]), .B(o_ab[2][1]), .CI(fa_0_w[0]), .number(num_00[3]));
FA1 fa_30(.CO(fa_0_w[2]), .S(fa_01_w[2]), .A(o_ab[4][0]), .B(o_ab[3][1]), .CI(fa_0_w[1]), .number(num_00[4]));
FA1 fa_40(.CO(fa_0_w[3]), .S(fa_01_w[3]), .A(o_ab[5][0]), .B(o_ab[4][1]), .CI(fa_0_w[2]), .number(num_00[5]));
FA1 fa_50(.CO(fa_0_w[4]), .S(fa_01_w[4]), .A(o_ab[6][0]), .B(o_ab[5][1]), .CI(fa_0_w[3]), .number(num_00[6]));
FA1 fa_60(.CO(fa_0_w[5]), .S(fa_01_w[5]), .A(o_ab[7][0]), .B(o_ab[6][1]), .CI(fa_0_w[4]), .number(num_00[7]));
 //FA END
 //HA
HA1 ha_70(.O(fa_0_w[6]), .S(fa_01_w[6]), .A(fa_0_w[5]), .B(o_ab[7][1]), .number(num_00[8]));
 //HA END

//第二至第七列的HA

//第二~七的HA END

//第二~七的FA
genvar j,k,l,m,n,o;
HA1 ha_01(.O(fa_1_w[0]), .S(o_x[2]), .A(fa_01_w[0]), .B(o_ab[0][2]), .number(num_01[0]));
generate 
	for ( j=0; j<6 ;j=j+1 ) begin    
		FA1 fa_02(.CO(fa_1_w[j+1]), .S(fa_02_w[j]), .A(fa_01_w[j+1]), .B(o_ab[j+1][2]), .CI(fa_1_w[j]), .number(num_01[j+1]));
	end
endgenerate
FA1 fa_71(.CO(fa_1_w[7]), .S(fa_02_w[6]), .A(fa_0_w[6]), .B(o_ab[7][2]), .CI(fa_1_w[6]), .number(num_01[7]));

//pipeline
FD2 reg_0(.D(fa_02_w[0]), .Q(REG[0]), .number(num_REG[0]), .RESET(rst_n), .CLK(clk));
HA1 ha_02(.O(fa_2_w[0]), .S(o_x[3]), .A(REG[0]), .B(o_ab[0][3]), .number(num_02[0]));
generate 
	for( k=0;k<6; k=k+1) begin
		//HA1 ha_01(.O(), .S(s[3]), .A(), .B(), .CI([]), .number(num));
		FD2 reg_1(.D(fa_02_w[k+1]), .Q(REG[k+1]), .number(num_REG[k+1]), .RESET(rst_n), .CLK(clk));
		FA1 fa_03(.CO(fa_2_w[k+1]), .S(fa_03_w[k]), .A(REG[k+1]), .B(o_ab[k+1][3]), .CI(fa_2_w[k]), .number(num_02[k+1]));
	end 
endgenerate
FD2 reg_2(.D(fa_1_w[7]), .Q(REG[7]), .number(num_REG[7]), .RESET(rst_n), .CLK(clk));
FA1 fa_72(.CO(fa_2_w[7]), .S(fa_03_w[6]), .A(REG[7]), .B(o_ab[7][3]), .CI(fa_2_w[6]), .number(num_02[7]));

HA1 ha_03(.O(fa_3_w[0]), .S(o_x[4]), .A(fa_03_w[0]), .B(o_ab[0][4]), .number(num_03[0])); 
generate 
	for( l=0;l<6; l=l+1) begin
		//HA1 ha_01(.O(), .S(s[4]), .A(), .B(), .CI([]), .number(num));
		FA1 fa_04(.CO(fa_3_w[l+1]), .S(fa_04_w[l]), .A(fa_03_w[l+1]), .B(o_ab[l+1][4]), .CI(fa_3_w[l]), .number(num_03[l+1]));
	end
endgenerate
FA1 fa_73(.CO(fa_3_w[7]), .S(fa_04_w[6]), .A(fa_2_w[6]), .B(o_ab[7][4]), .CI(fa_3_w[6]), .number(num_03[7]));

HA1 ha_04(.O(fa_4_w[0]), .S(o_x[5]), .A(fa_04_w[0]), .B(o_ab[0][5]), .number(num_04[0]));
generate 
	for( m=0;m<6; m=m+1) begin
		//HA1 ha_01(.O(), .S(s[5]), .A(), .B(), .CI([]), .number(num));
		FA1 fa_05(.CO(fa_4_w[m+1]), .S(fa_05_w[m]), .A(fa_04_w[m+1]), .B(o_ab[m+1][5]), .CI(fa_4_w[m]), .number(num_04[m+1]));
	end
endgenerate
FA1 fa_74(.CO(fa_4_w[7]), .S(fa_05_w[6]), .A(fa_3_w[6]), .B(o_ab[7][5]), .CI(fa_4_w[6]), .number(num_04[7]));

HA1 ha_05(.O(fa_5_w[0]), .S(o_x[6]), .A(fa_05_w[0]), .B(o_ab[0][6]), .number(num_05[0]));
generate 
	for( n=0;n<6; n=n+1) begin
		//HA1 ha_01(.O(), .S(s[6]), .A(), .B(), .CI([]), .number(num));
		FA1 fa_06(.CO(fa_5_w[n+1]), .S(fa_06_w[n]), .A(fa_05_w[n+1]), .B(o_ab[n+1][6]), .CI(fa_5_w[n]), .number(num_05[n+1]));
	end
endgenerate
FA1 fa_75(.CO(fa_5_w[7]), .S(fa_06_w[6]), .A(fa_4_w[6]), .B(o_ab[7][6]), .CI(fa_5_w[6]), .number(num_05[7]));

HA1 ha_06(.O(fa_6_w[0]), .S(o_x[7]), .A(fa_06_w[0]), .B(o_ab[0][7]), .number(num_06[0]));
generate 
	for( o=0;o<6; o=o+1) begin
		//HA1 ha_01(.O(), .S(s[7]), .A(), .B(), .CI([]), .number(num));
		FA1 fa_07(.CO(fa_6_w[o+1]), .S(o_x[o+8]), .A(fa_06_w[o+1]), .B(o_ab[o+1][7]), .CI(fa_6_w[o]), .number(num_06[o+1]));
	end
endgenerate
FA1 fa_76(.CO(fa_6_w[7]), .S(o_x[14]), .A(fa_5_w[6]), .B(o_ab[7][7]), .CI(fa_6_w[6]), .number(num_06[7]));

DRIVER DR_77(.Z(o_x[15]), .A(fa_6_w[7]),.number(num_06[8]));

assign sum[0] = num_a[0] + num_a[1] + num_a[2] + num_a[3] + num_a[4] + num_a[5] + num_a[6] + num_a[7];
assign sum[1] = num_b[0] + num_b[1] + num_b[2] + num_b[3] + num_b[4] + num_b[5] + num_b[6] + num_b[7];
assign sum[2] = num_00[0] + num_00[1] + num_00[2] + num_00[3] + num_00[4] + num_00[5] + num_00[6] + num_00[7]+ num_00[8];
assign sum[3] = num_01[0] + num_01[1] + num_01[2] + num_01[3] + num_01[4] + num_01[5] + num_01[6] + num_01[7];
assign sum[4] = num_02[0] + num_02[1] + num_02[2] + num_02[3] + num_02[4] + num_02[5] + num_02[6] + num_02[7];
assign sum[5] = num_03[0] + num_03[1] + num_03[2] + num_03[3] + num_03[4] + num_03[5] + num_03[6] + num_03[7];
assign sum[6] = num_04[0] + num_04[1] + num_04[2] + num_04[3] + num_04[4] + num_04[5] + num_04[6] + num_04[7];
assign sum[7] = num_05[0] + num_05[1] + num_05[2] + num_05[3] + num_05[4] + num_05[5] + num_05[6] + num_05[7];
assign sum[8] = num_06[0] + num_06[1] + num_06[2] + num_06[3] + num_06[4] + num_06[5] + num_06[6] + num_06[7]+num_06[8];
assign sum[9] = num_REG[0] + num_REG[1] + num_REG[2] + num_REG[3] + num_REG[4] + num_REG[5] + num_REG[6] + num_REG[7];

assign number = sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7] + sum[8] + sum[9] + total_sum;
//全部的AND

 
endmodule

// module SQ (
// 	input [7:0] A,
// 	output [15:0] Z,
// 	output [50:0] number
// );
// wire [15:0] mul [0:7];

// genvar i, j;
// generate
// 	for (i=0; i<8; i=i+1) begin
// 		for (j=0; j<8; j=j+1) begin
// 			AN2 AN2_0(.A(A[j]), .B(A[i]), .Z(mul[i][i+j]), .number());
// 		end
// 		for (j=i+8; j<16; j=j+1) begin
// 			DRIVER D_0(.A(mul[i][i+7]), .Z(mul[i][j]), .number());
// 		end
// 		for (j=0; j<i; j=j+1) begin
// 			DRIVER D_1(.A(1'b0), .Z(mul[i][j]), .number());
// 		end

// 	end
// endgenerate
// endmodule

// module COM16_ADD1#(
// 	parameter BW = 16
// )(
// 	input [BW-1:0] A,
// 	output [BW-1:0] Z,
// 	output [50:0] number
// );

// wire [BW-1:0] A_COM;
// wire [50:0] numbers [0:BW];
// COM#(.BW(BW)) A_COM16(.A(A), .Z(A_COM), .number(numbers[0]));
// genvar i;
// generate
// 	for (i=0; i<BW*5/8; i=i+1) begin
// 		DRIVER D_0(.A(A_COM[i]), .Z(Z[i]), .number(numbers[i+1]));
// 	end
// 	for (i=BW*5/8; i<BW; i=i+1) begin
// 		IV IV_0(.A(A_COM[i]), .Z(Z[i]), .number(numbers[i+1]));
// 	end
// endgenerate

// reg [50:0] sum;
// integer j;
// always @(*) begin
// 	sum = 0;
// 	for (j=0; j<BW+1; j=j+1) begin 
// 		sum = sum + numbers[j];
// 	end
// end

// assign number = sum;

// endmodule

module F_OP#( //2.668ns
	parameter BW = 16
)(
	input [BW-1:0] A,
	input Sign,
	output [BW-1:0] Z,
	output [50:0] number
);
wire [BW-1:0] A_COM, A_NEG;
wire [50:0] numbers [0:BW+1];
COM#(.BW(BW)) COM16(.A(A), .Z(A_COM), .number(numbers[0]));
ADD1#(.BW(BW)) ADD1(.A(A_COM), .Z(A_NEG), .number(numbers[1]));
genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H MUX21H_0(.A(A_NEG[i]), .B(A[i]), .CTRL(Sign), .Z(Z[i]), .number(numbers[i+2]));
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW+2; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module OUT#( //0.174ns
	parameter BW = 16
)(
	input [BW-1:0] A,
	output [BW-1:0] Z,
	output [50:0] number
);
wire [50:0] numbers [0:BW-1];
genvar i;
generate
	for (i=0; i<BW*3/8-1; i=i+1) begin
		DRIVER D_0(.A(1'b0), .Z(Z[i]), .number(numbers[i]));
	end
	for (i=BW*3/8-1; i<BW; i=i+1) begin
		DRIVER D_1(.A(A[i-5]), .Z(Z[i]), .number(numbers[i]));
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule