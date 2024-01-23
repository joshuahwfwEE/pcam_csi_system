`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 15:57:51
// Design Name: 
// Module Name: clk100k
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


module clk100k(
    input clk,
    input rstn,
    output reg clk100k
    );
    
reg [9:0] cnt;    
    
always@(posedge clk or negedge rstn)begin
    if(~rstn)begin
        cnt <= 0;
        clk100k <= 0;
    end else begin
        if(cnt == 499)begin
            clk100k <= ~clk100k;
            cnt <= 0;
        end else
            cnt <= cnt + 1;
    end
end
    
endmodule
