`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/27 10:25:39
// Design Name: 
// Module Name: video_count
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


module video_count(
    input clk,
    input rstn,
    input video_tuser,
    input video_valid,
    input video_ready,
    input video_last,
    input m_axis_video_last,
    input m_axis_video_valid,
    input m_axis_video_ready,
    input m_axis_video_user,
    output reg [23:0] axi_video_cnt,
    output reg [23:0] video_cnt,
    output reg [23:0] frame_cnt,
    output reg [23:0] video_line_cnt,
    output reg [23:0] axi_video_line_cnt
//    output reg [23:0] line_cnt,
//    output reg [23:0] word_cnt
    );
    
wire [15:0] FrameNumber,LineNumber,WordCount;
wire framestart;
reg [15:0] FrameNumber1,LineNumber1,WordCount1;
reg framestart1,user1,axi_user1,video_last1,m_axis_video_last1;
//reg [23:0] frame_cnt,line_cnt,word_cnt;

//assign FrameNumber = video_tuser[31:16];
//assign LineNumber = video_tuser[47:32];
//assign WordCount = video_tuser[63:48];
assign framestart = video_tuser;

always@(posedge clk or negedge rstn)begin 
    if(~rstn)begin
//        FrameNumber1 <= 0;
//        LineNumber1  <= 0;
//        WordCount1   <= 0;
        framestart1  <= 0;
        user1 <= 0;
        axi_user1 <= 0;
        video_last1 <= 0;
        m_axis_video_last1 <= 0;
    end else begin
//        FrameNumber1 <= FrameNumber;
//        LineNumber1  <= LineNumber; 
//        WordCount1   <= WordCount;
        framestart1  <= framestart;    
        user1 <= video_tuser;
        axi_user1 <= m_axis_video_user;
        video_last1 <= video_last;
        m_axis_video_last1 <= m_axis_video_last;
    end
end
    
always@(posedge clk or negedge rstn)begin    
    if(~rstn)
        axi_video_cnt <= 0;
    else begin
        if(m_axis_video_last==1)
            axi_video_cnt <= 0;
        else begin
            if(m_axis_video_valid==1 && m_axis_video_ready==1)
                axi_video_cnt <= axi_video_cnt + 1;
        end
    end
end    

always@(posedge clk or negedge rstn)begin    
    if(~rstn)
        video_cnt <= 0;
    else begin
        if(video_last==1)
            video_cnt <= 0;
        else begin
            if(video_valid==1 && video_ready==1)
                video_cnt <= video_cnt + 1;
        end
    end
end   

always@(posedge clk or negedge rstn)begin    
    if(~rstn)
        frame_cnt <= 0;
    else begin
        if(framestart1==0 && framestart==1)
            frame_cnt <= 0;
        else if(video_valid)
            frame_cnt <= frame_cnt + 1;
    end
end

always@(posedge clk or negedge rstn)begin    
    if(~rstn)
        video_line_cnt <= 0;
    else begin
        if(user1==0 && video_tuser==1)
            video_line_cnt <= 0;
        else if(video_last == 1 && video_last1 == 0)
            video_line_cnt <= video_line_cnt + 1;
    end
end

always@(posedge clk or negedge rstn)begin    
    if(~rstn)
        axi_video_line_cnt <= 0;
    else begin
        if(axi_user1==0 && m_axis_video_user==1)
            axi_video_line_cnt <= 0;
        else if(m_axis_video_last == 1 && m_axis_video_last1 == 0)
            axi_video_line_cnt <= axi_video_line_cnt + 1;
    end
end

//always@(posedge clk or negedge rstn)begin    
//    if(~rstn)
//        line_cnt <= 0;
//    else begin
//        if((LineNumber[0]==1 && LineNumber1[0]==0) || (LineNumber[0]==0 && LineNumber1[0]==1) || (framestart1==0 && framestart==1))
//            line_cnt <= 0;
//        else if(video_vaild)
//            line_cnt <= line_cnt + 1;
//    end
//end

//always@(posedge clk or negedge rstn)begin    
//    if(~rstn)
//        word_cnt <= 0;
//    else begin
//        if((WordCount[0]==1 && WordCount1[0]==0) || (WordCount[0]==0 && WordCount1[0]==1) || (framestart1==0 && framestart==1))
//            word_cnt <= 0;
//        else if(video_vaild)
//            word_cnt <= word_cnt + 1; 
//    end
//end
  
    
endmodule
