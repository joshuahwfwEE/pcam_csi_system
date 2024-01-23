`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 17:16:20
// Design Name: 
// Module Name: hsvs_cnt
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
//////////////////////////////////////////////////////////////////////////////////


module hsvs_cnt(
    input clk,
    input hs,
    input vs,
    input de,
    output reg [15:0] hs_cnt,
    output reg [15:0] vs_cnt
    );
    
reg hs1,vs1;    
    
always@(posedge clk)begin
    hs1 <= hs;
    vs1 <= vs;
end

always@(posedge clk)begin
    if(hs==1 && hs1==0)
        hs_cnt <= 0;
    else if (de==1)
        hs_cnt <= hs_cnt + 1;
end

always@(posedge clk)begin
    if(vs==1 && vs1==0)
        vs_cnt <= 0;
    else if (hs==1 && hs1==0)
        vs_cnt <= vs_cnt + 1;
end
    
endmodule
