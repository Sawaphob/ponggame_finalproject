`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2019 05:55:04 PM
// Design Name: 
// Module Name: blackOrWhite
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Choose if this pixel is black or white
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blackOrWhite(
    input [9:0] x,
    input [9:0] y,
    input [9:0] ballX,
    input [9:0] ballY,
    input [9:0] bar1X,
    input [9:0] bar1Y,
    input [9:0] bar2X,
    input [9:0] bar2Y,
//    input gameState,
    output reg [11:0] color
    );
    
    localparam BALL_SIZE = 8;
    localparam BAR_WIDTH = 10;
    localparam BAR_HEIGHT = 150;
    localparam scorePlayer1X = 200;
    localparam scorePlayer1Y = 30;
    localparam scorePlayer2X = 400;
    localparam scorePlayer2Y = 30;
    localparam scoreWidth = 16;
    localparam scoreHeight = 20;
    localparam memberRow0 = 200;
    localparam memberRow1 = 300;
    localparam memberRow2 = 400;
    localparam memberColumnStart = 200;
    
    
    reg [9:0] wsStartX = scorePlayer1X;
    reg [9:0] wsStartY = scorePlayer1Y;
    reg [4:0] score;
    wire [4:0] wsSegment;
    wire [19:0] segments;
    
    whichSegment ws(x,y,wsStartX,wsStartY,wsSegment);
    pixelSegment pS(segments,score);
    
    always @(*) begin
    if( (x >= ballX && x <= ballX+BALL_SIZE) && (y >= ballY && y <= ballY+BALL_SIZE) ) 
    begin
        color <= 12'hF00;
    end else if ( (x >= bar1X && x <= bar1X + BAR_WIDTH ) && (y >= bar1Y && y <= bar1Y + BAR_HEIGHT ))  begin
        color <= 12'h0F0;
    end else if ( (x >= bar2X && x <= bar2X + BAR_WIDTH ) && (y >= bar2Y && y <= bar2Y + BAR_HEIGHT )) begin
        color <= 12'h00F;
    end 
    // ----------------- Score Player1 -----------------
    else if ((x >= scorePlayer1X && x <= scorePlayer1X+scoreWidth) && (y >= scorePlayer1Y && y <= scorePlayer1Y+scoreHeight)) begin
        wsStartX <= scorePlayer1X;
        wsStartY <= scorePlayer1Y;
        score <= 5'b00100;
        if(segments[wsSegment] == 1'b1) begin
            color <= 12'hFF0;
        end else begin
            color <= 12'h000;
        end
    end 
    
    // ----------------- Score Player2 -----------------
    else if ((x >= scorePlayer2X && x <= scorePlayer2X+scoreWidth) && (y >= scorePlayer2Y && y <= scorePlayer2Y+scoreHeight)) begin
        wsStartX <= scorePlayer2X;
        wsStartY <= scorePlayer2Y;
        score <= 5'b00000;
        if(segments[wsSegment] == 1'b1) begin
            color <= 12'h0FF;
        end else begin
            color <= 12'h000;
        end
    end 
    
    
    // ------------------Member Row 0 --------------------
    else if (y >= memberRow0 && y < memberRow0+scoreHeight) begin
        wsStartY <= memberRow0;
        if(x >= memberColumnStart && x < memberColumnStart + scoreWidth) begin
            wsStartX <= memberColumnStart;
            score <= 5'b10011;
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+scoreWidth && x < memberColumnStart + (scoreWidth*2)) begin
            wsStartX <= memberColumnStart+scoreWidth;
            score <= 5'b01110; // H
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*2) && x < memberColumnStart + (scoreWidth*3)) begin
            wsStartX <= memberColumnStart+(scoreWidth*2);
            score <= 5'b10010; //O
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+(scoreWidth*3) && x < memberColumnStart + (scoreWidth*4)) begin
            wsStartX <= memberColumnStart+(scoreWidth*3);
            score <= 5'b10001; // N
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+(scoreWidth*4) && x < memberColumnStart + (scoreWidth*5)) begin
            wsStartX <= memberColumnStart+(scoreWidth*4);
            score <= 5'b01101; //G
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+(scoreWidth*5) && x < memberColumnStart + (scoreWidth*6)) begin
            wsStartX <= memberColumnStart+(scoreWidth*5);
            score <= 5'b10011; //P
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*6) && x < memberColumnStart + (scoreWidth*7)) begin
            wsStartX <= memberColumnStart+(scoreWidth*6);
            score <= 5'b01010; //A
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*7) && x < memberColumnStart + (scoreWidth*8)) begin
            wsStartX <= memberColumnStart+(scoreWidth*7);
            score <= 5'b10000 ; //K
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*8) && x < memberColumnStart + (scoreWidth*9)) begin
            color <= 12'h000;
        end else if (x >= memberColumnStart+(scoreWidth*9) && x < memberColumnStart + (scoreWidth*10)) begin
            color <= 12'h000;
        end else if (x >= memberColumnStart+(scoreWidth*10) && x < memberColumnStart + (scoreWidth*11)) begin
            wsStartX <= memberColumnStart+(scoreWidth*10);
            score <= 5'b00101 ; //5
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*11) && x < memberColumnStart + (scoreWidth*12)) begin
            wsStartX <= memberColumnStart+(scoreWidth*11);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*12) && x < memberColumnStart + (scoreWidth*13)) begin
            wsStartX <= memberColumnStart+(scoreWidth*12);
            score <= 5'b00011 ; //3
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*13) && x < memberColumnStart + (scoreWidth*14)) begin
            wsStartX <= memberColumnStart+(scoreWidth*13);
            score <= 5'b00001 ; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*14) && x < memberColumnStart + (scoreWidth*15)) begin
            wsStartX <= memberColumnStart+(scoreWidth*14);
            score <= 5'b00000 ; //0
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*15) && x < memberColumnStart + (scoreWidth*16)) begin
            wsStartX <= memberColumnStart+(scoreWidth*15);
            score <= 5'b00011 ; //3
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*16) && x < memberColumnStart + (scoreWidth*17)) begin
            wsStartX <= memberColumnStart+(scoreWidth*16);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*17) && x < memberColumnStart + (scoreWidth*18)) begin
            wsStartX <= memberColumnStart+(scoreWidth*17);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*18) && x < memberColumnStart + (scoreWidth*19)) begin
            wsStartX <= memberColumnStart+(scoreWidth*18);
            score <= 5'b00010 ; //2
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*19) && x < memberColumnStart + (scoreWidth*20)) begin
            wsStartX <= memberColumnStart+(scoreWidth*19);
            score <= 5'b00001 ; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else begin
            color <= 12'h000;

        end
    end  
    
    
    //------------------------------ Member row 1 -------------------//
    else if (y >= memberRow1 && y < memberRow1+scoreHeight) begin
        wsStartY <= memberRow1;
        if(x >= memberColumnStart && x < memberColumnStart + scoreWidth) begin
            wsStartX <= memberColumnStart;
            score <= 5'b10011; //P
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+scoreWidth && x < memberColumnStart + (scoreWidth*2)) begin
            wsStartX <= memberColumnStart+scoreWidth;
            score <= 5'b01100; // E
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*2) && x < memberColumnStart + (scoreWidth*3)) begin
            wsStartX <= memberColumnStart+(scoreWidth*2);
            score <= 5'b10001; //N
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+(scoreWidth*3) && x < memberColumnStart + (scoreWidth*4)) begin
            wsStartX <= memberColumnStart+(scoreWidth*3);
            score <= 5'b10011; //P
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*4) && x < memberColumnStart + (scoreWidth*5)) begin
            wsStartX <= memberColumnStart+(scoreWidth*4);
            score <= 5'b01111; //I
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*5) && x < memberColumnStart + (scoreWidth*6)) begin
            wsStartX <= memberColumnStart+(scoreWidth*5);
            score <= 5'b01011; //C
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*6) && x < memberColumnStart + (scoreWidth*7)) begin
            wsStartX <= memberColumnStart+(scoreWidth*6);
            score <= 5'b01110; // H
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*7) && x < memberColumnStart + (scoreWidth*8)) begin
            wsStartX <= memberColumnStart+(scoreWidth*7);
            score <= 5'b01010; //A
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*8) && x < memberColumnStart + (scoreWidth*9)) begin
            color <= 12'h000;
        end else if (x >= memberColumnStart+(scoreWidth*9) && x < memberColumnStart + (scoreWidth*10)) begin
            color <= 12'h000;
        end else if (x >= memberColumnStart+(scoreWidth*10) && x < memberColumnStart + (scoreWidth*11)) begin
            wsStartX <= memberColumnStart+(scoreWidth*10);
            score <= 5'b00101 ; //5
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*11) && x < memberColumnStart + (scoreWidth*12)) begin
            wsStartX <= memberColumnStart+(scoreWidth*11);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*12) && x < memberColumnStart + (scoreWidth*13)) begin
            wsStartX <= memberColumnStart+(scoreWidth*12);
            score <= 5'b00011 ; //3
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*13) && x < memberColumnStart + (scoreWidth*14)) begin
            wsStartX <= memberColumnStart+(scoreWidth*13);
            score <= 5'b00001 ; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*14) && x < memberColumnStart + (scoreWidth*15)) begin
            wsStartX <= memberColumnStart+(scoreWidth*14);
            score <= 5'b00000 ; //0
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*15) && x < memberColumnStart + (scoreWidth*16)) begin
            wsStartX <= memberColumnStart+(scoreWidth*15);
            score <= 5'b00100 ; //4
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*16) && x < memberColumnStart + (scoreWidth*17)) begin
            wsStartX <= memberColumnStart+(scoreWidth*16);
            score <= 5'b00100; //4
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*17) && x < memberColumnStart + (scoreWidth*18)) begin
            wsStartX <= memberColumnStart+(scoreWidth*17);
            score <= 5'b00000; //0
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*18) && x < memberColumnStart + (scoreWidth*19)) begin
            wsStartX <= memberColumnStart+(scoreWidth*18);
            score <= 5'b00010 ; //2
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*19) && x < memberColumnStart + (scoreWidth*20)) begin
            wsStartX <= memberColumnStart+(scoreWidth*19);
            score <= 5'b00001 ; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else begin
            color <= 12'h000;

        end
    end  

    //------------------------------ Member row 2 -------------------//
    else if (y >= memberRow2 && y < memberRow2+scoreHeight) begin
        wsStartY <= memberRow2;
        if(x >= memberColumnStart && x < memberColumnStart + scoreWidth) begin
            wsStartX <= memberColumnStart;
            score <= 5'b10001; //N
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+scoreWidth && x < memberColumnStart + (scoreWidth*2)) begin
            wsStartX <= memberColumnStart+scoreWidth;
            score <= 5'b01010; // A
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*2) && x < memberColumnStart + (scoreWidth*3)) begin
            wsStartX <= memberColumnStart+(scoreWidth*2);
            score <= 5'b10100; //T
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*3) && x < memberColumnStart + (scoreWidth*4)) begin
            wsStartX <= memberColumnStart+(scoreWidth*3);
            score <= 5'b10100; //T
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*4) && x < memberColumnStart + (scoreWidth*5)) begin
            wsStartX <= memberColumnStart+(scoreWidth*4);
            score <= 5'b01110; //H
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*5) && x < memberColumnStart + (scoreWidth*6)) begin
            wsStartX <= memberColumnStart+(scoreWidth*5);
            score <= 5'b01010; //A
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*6) && x < memberColumnStart + (scoreWidth*7)) begin
            wsStartX <= memberColumnStart+(scoreWidth*6);
            score <= 5'b10001; //N
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x > memberColumnStart+(scoreWidth*7) && x < memberColumnStart + (scoreWidth*8)) begin
            wsStartX <= memberColumnStart+(scoreWidth*7);
            score <= 5'b01010; //A
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*8) && x < memberColumnStart + (scoreWidth*9)) begin
            wsStartX <= memberColumnStart+(scoreWidth*8);
            score <= 5'b10001; //N
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*9) && x < memberColumnStart + (scoreWidth*10)) begin
            color <= 12'h000;
        end else if (x >= memberColumnStart+(scoreWidth*10) && x < memberColumnStart + (scoreWidth*11)) begin
            wsStartX <= memberColumnStart+(scoreWidth*10);
            score <= 5'b00101 ; //5
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*11) && x < memberColumnStart + (scoreWidth*12)) begin
            wsStartX <= memberColumnStart+(scoreWidth*11);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*12) && x < memberColumnStart + (scoreWidth*13)) begin
            wsStartX <= memberColumnStart+(scoreWidth*12);
            score <= 5'b00011 ; //3
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*13) && x < memberColumnStart + (scoreWidth*14)) begin
            wsStartX <= memberColumnStart+(scoreWidth*13);
            score <= 5'b00000 ; //0
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*14) && x < memberColumnStart + (scoreWidth*15)) begin
            wsStartX <= memberColumnStart+(scoreWidth*14);
            score <= 5'b00001; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*15) && x < memberColumnStart + (scoreWidth*16)) begin
            wsStartX <= memberColumnStart+(scoreWidth*15);
            score <= 5'b00111 ; //7
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*16) && x < memberColumnStart + (scoreWidth*17)) begin
            wsStartX <= memberColumnStart+(scoreWidth*16);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*17) && x < memberColumnStart + (scoreWidth*18)) begin
            wsStartX <= memberColumnStart+(scoreWidth*17);
            score <= 5'b01001 ; //9
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*18) && x < memberColumnStart + (scoreWidth*19)) begin
            wsStartX <= memberColumnStart+(scoreWidth*18);
            score <= 5'b00010 ; //2
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else if (x >= memberColumnStart+(scoreWidth*19) && x < memberColumnStart + (scoreWidth*20)) begin
            wsStartX <= memberColumnStart+(scoreWidth*19);
            score <= 5'b00001 ; //1
            if(segments[wsSegment] == 1'b1) begin
                color <= 12'hFFF;
            end else begin
                color <= 12'h000;
            end
        end else begin
            color <= 12'h000;

        end
    end  

    
    else begin
        color<=12'h000;
    end
    
    end
    

endmodule
