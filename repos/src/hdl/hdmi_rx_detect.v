`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////
////////
// Company:
// Engineer:
//
// Create Date: 2022/12/10 18:01:29
// Design Name:
// Module Name: hdmi_rx_detect
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////
////////
module hdmi_rx_detect#(
parameter integer C_TDATA_WIDTH = 32,
parameter integer C_TID_WIDTH   = 1,
parameter integer C_TDEST_WIDTH = 1,
parameter integer C_TUSER_WIDTH = 1,
parameter [31:0]  C_SIGNAL_SET  = 32'hFF,
// C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional 
//signals are present
//   [0] => TREADY present
//   [1] => TDATA present
//   [2] => TSTRB present, TDATA must be present
//   [3] => TKEEP present, TDATA must be present
//   [4] => TLAST present
//   [5] => TID present
//   [6] => TDEST present
//   [7] => TUSER present
parameter integer C_S_ACLKEN_CAN_TOGGLE = 1,
parameter integer C_M_ACLKEN_CAN_TOGGLE = 1
)(
input  wire                       ACLK,
input  wire                       ARESETN,
input  wire                       s_axis_tvalid,
input  wire                       s_axis_tready,
input  wire [47:0]                s_axis_tdata,
input  wire                       s_axis_tlast,
input  wire [0:0]                 s_axis_tuser,
output reg [12:0]                 o_col_cnt,
output reg [11:0]                 o_row_cnt,
output wire [31:0]                o_frame_cnt
);
//assign s_axis_tready = 1'b1;
reg [12:0] col_cnt;
reg [11:0] row_cnt;
reg tlast_i;
reg tlast_ii;
wire tlast;
// this used for making a counter per second
reg [31:0] frame_bucket;
reg [31:0] frame_cnt;
reg [31:0] count;
always @(posedge ACLK) begin
if (ARESETN == 1'b0) begin
tlast_i <= 1'b0;
tlast_ii <= 1'b0;
end else begin
tlast_i <= s_axis_tlast;
tlast_ii <= tlast_i;
end
end
assign tlast = (~tlast_ii)&tlast_i;
always @(posedge ACLK) begin
if (ARESETN == 1'b0) begin
col_cnt <= 13'h0;
end else  begin
if (tlast == 1'b1) begin
o_col_cnt <= col_cnt;
col_cnt <= 13'h0;
end else if (s_axis_tready & s_axis_tvalid== 1'b1) begin
col_cnt <= col_cnt + 1;
end
end
end
reg tuser_i;
reg tuser_ii;
wire tuser;
always @(posedge ACLK) begin
if (ARESETN == 1'b0) begin
tuser_i <= 1'b0;
tuser_ii <= 1'b0;
end else begin
tuser_i <= s_axis_tuser;
tuser_ii <= tuser_i;
end
end
assign tuser = (~tuser_ii)&tuser_i;
//
// assign o_row_cnt_new = row_cnt;
// assign o_col_cnt_new = col_cnt;
always @(posedge ACLK) begin
if (ARESETN == 1'b0) begin
row_cnt <= 12'h0;
end else if (tuser == 1'b1) begin
row_cnt <= 12'h0;
o_row_cnt <= row_cnt;
end else if (tlast == 1'b1) begin
row_cnt <= row_cnt + 1;
end
end
// this part is for frame counter per second
always @(posedge ACLK) begin
if (ARESETN == 1'b0) begin
frame_bucket <= 32'h0;
frame_cnt <= 32'h0;
count <= 32'h0;
end else if (tuser) begin
frame_cnt <= frame_cnt+1;
end else if (count == 300000000) begin 
frame_bucket <= frame_cnt;            
frame_cnt <= 32'h0;
count<=0;
end else begin
count <= count + 1;
end
end
assign o_frame_cnt = frame_bucket;
endmodule
