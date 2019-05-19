`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2019 03:41:51 PM
// Design Name: 
// Module Name: segmentTest
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


module segmentTest();

    localparam BALL_SIZE = 8;
    localparam BAR_WIDTH = 10;
    localparam BAR_HEIGHT = 150;
    localparam scorePlayer1X = 200;
    localparam scorePlayer1Y = 30;
    localparam scoreWidth = 16;
    localparam scoreHeight = 20;

    reg [9:0] x;
    reg [9:0] y;
    reg [9:0] wsStartX = scorePlayer1X;
    reg [9:0] wsStartY = scorePlayer1Y;
    wire [4:0] wsSegment;
    wire [19:0] segments;
    reg [4:0] psInput;
    reg [11:0] color;
    

    whichSegment ws(x,y,wsStartX,wsStartY,wsSegment);
    pixelSegment pS(segments,psInput);


    always @(*) begin
    // ----------------- Score Player1 -----------------
    if ((x >= scorePlayer1X && x <= scorePlayer1X+scoreWidth) && (y >= scorePlayer1Y && y <= scorePlayer1Y+scoreHeight)) begin
        if(segments[wsSegment] == 1'b1) begin
            color <= 12'h888;
        end else begin
            color <= 12'hFFF;
        end
    end 
    
    else begin
        color <= 12'h000;
    end
    
    end

    initial
    begin
        #0;
        x = 10'b0011001000; // x=200
        y = 10'b0000011110; // y=30
        psInput = 5'b00000;
        //row 0 col 0
        #10;
        x = 10'b0011001101; // x=205
        y = 10'b0000011110; // y=30
        psInput = 5'b00001;
        //row 0 col 1 
        #10;
        x = 10'b0011010001; // x=209
        y = 10'b0000011110; // y=35
        //row 0 col 2 
        #10;
        x = 10'b0011010101; // x=213
        y = 10'b0000011110; // y=35
        //row 0 col 3 
        #10;
        x = 10'b0011011000; // x=216
        y = 10'b0000011110; // y=35
        //row 0 col 3         
        #10;
        x = 10'b0011001000; // x=200
        y = 10'b0000100011; // y=35
        //row 1 col 0
        #10;
        x = 10'b0011001101; // x=205
        y = 10'b0000100111; // y=39
        //row 2 col 1 
        #10;
        x = 10'b0011010001; // x=209
        y = 10'b0000101011; // y=43
        //row 3 col 2 
        #10;
        x = 10'b0011010101; // x=213
        y = 10'b0000101111; // y=47
        //row 4 col 3 
        #10;
        x = 10'b0011001000; // x=200
        y = 10'b0000110001; // y=49
        //row 4 col 0   
     end

endmodule
