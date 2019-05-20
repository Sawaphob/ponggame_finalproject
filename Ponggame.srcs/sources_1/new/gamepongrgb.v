`timescale 1ns / 1ps

module gamepongrgb(
    input [9:0] posX,
    input [9:0] posY,
    input [9:0] ballX,
    input [9:0] ballY,
    input [9:0] paddleLeftPosY,
    input [9:0] paddleRightPosY,
    output reg [11:0] color
    );
    
    localparam BALLSIZE = 8;
    localparam PADDLEWIDTH = 8;
    localparam PADDLEHEIGHT = 64;
    localparam scoreLeftPosX = 220;
    localparam scoreLeftPosY = 40;
    localparam scoreRightPosX = 404;
    localparam scoreRightPosY = 40;
    localparam SCOREWIDTH = 16;
    localparam SCOREHEIGHT = 20;
    localparam paddleLeftPosX = 100;
    localparam paddleRightPosX = 532;
    
    
    reg [9:0] wsStartX = scoreLeftPosX;
    reg [9:0] wsStartY = scoreLeftPosY;
    reg [4:0] score;
    wire [4:0] wsSegment;
    wire [19:0] segments;
    
    whichSegment ws (posX,posY,wsStartX,wsStartY,wsSegment);
    pixelSegment pS(segments,score);
    
    always @(*) 
        begin
            if( (posX >= ballX && posX <= ballX+BALLSIZE) && (posY >= ballY && posY <= ballY+BALLSIZE) ) 
                begin
                    color <= 12'hFFF;
                end 
            else if ((posX >= paddleLeftPosX && posX <= paddleLeftPosX + PADDLEWIDTH ) && (posY >= paddleLeftPosY && posY <= paddleLeftPosY + PADDLEHEIGHT ))  
                begin
                    color <= 12'hFFF;
                end 
            else if ((posX >= paddleRightPosX && posX <= paddleRightPosX + PADDLEWIDTH ) && (posY >= paddleRightPosY && posY <= paddleRightPosY + PADDLEHEIGHT )) 
                begin
                    color <= 12'hFFF;
                end 
    // ----------------- Score Player1 -----------------
        else if ( (posX >= scoreLeftPosX && posX <= scoreLeftPosX+SCOREWIDTH) &&  (posY >= scoreLeftPosY && posY <= scoreLeftPosY+SCOREHEIGHT)) 
            begin
                wsStartX <= scoreLeftPosX;
                wsStartY <= scoreLeftPosY;
                score <= 5'b00000;
                if(segments[wsSegment] == 1'b1)
                    begin
                        color <= 12'hFFF;
                    end 
                else 
                    begin
                        color <= 12'hFFF;
                    end
            end 
    // ----------------- Score Player2 -----------------
        else if ( (posX >= scoreRightPosX && posX <= scoreRightPosX+SCOREWIDTH) && (posY >= scoreRightPosY && posY <= scoreRightPosY+SCOREHEIGHT)) 
            begin
                wsStartX <= scoreRightPosX;
                wsStartY <= scoreRightPosY;
                score <= 5'b00000;
                if(segments[wsSegment] == 1'b1) 
                    begin
                        color <= 12'hFFF;
                    end 
                else 
                    begin
                        color <= 12'hFFF;
                    end
            end 
    
        else 
            begin
                color<=12'h000;
            end
        end
endmodule
