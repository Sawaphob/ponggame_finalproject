`timescale 1ns / 1ps

module gamepongrgb(
    input [9:0] posX,
    input [9:0] posY,
    input [9:0] ballX,
    input [9:0] ballY,
    input [9:0] paddleLeftPosY,
    input [9:0] paddleRightPosY,
    input [3:0] left_score,
    input [3:0] right_score,
    output reg [11:0] color
    );
    
    localparam BALLSIZE = 10;
    localparam PADDLEWIDTH = 8;
    localparam PADDLEHEIGHT = 75;
    localparam scoreLeftPosX = 180;
    localparam scoreLeftPosY = 40;
    localparam scoreRightPosX = 440;
    localparam scoreRightPosY = 40;
    localparam SCOREWIDTH = 16;
    localparam SCOREHEIGHT = 20;
    localparam paddleLeftPosX = 80;
    localparam paddleRightPosX = 560;
    
    
    reg [9:0] wsStartX = scoreLeftPosX;
    reg [9:0] wsStartY = scoreLeftPosY;
    reg [4:0] vgacode;
    wire [4:0] wsSegment;
    wire [19:0] segments;
    
    whichSegment ws (posX,posY,wsStartX,wsStartY,wsSegment);
    pixelSegment pS(segments,vgacode);
    
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
                if(left_score == 0)
                begin
                    vgacode <= 5'b00000;
                end
                else if (left_score == 1)
                begin
                    vgacode <= 5'b00001;
                end
                else if (left_score == 2)
                begin
                    vgacode <= 5'b00010;
                end
                else if (left_score == 3)
                begin
                    vgacode <= 5'b00011;
                end
                else if (left_score == 4)
                begin
                    vgacode <= 5'b00100;
                end
                else if (left_score == 5)
                begin
                    vgacode <= 5'b00101;
                end
                if(segments[wsSegment] == 1'b1)
                    begin
                        color <= 12'hFFF;
                    end 
                else 
                    begin
                        color <= 12'h000;
                    end
            end 
    // ----------------- Score Player2 -----------------
        else if ( (posX >= scoreRightPosX && posX <= scoreRightPosX+SCOREWIDTH) && (posY >= scoreRightPosY && posY <= scoreRightPosY+SCOREHEIGHT)) 
            begin
                wsStartX <= scoreRightPosX;
                wsStartY <= scoreRightPosY;
                if(right_score == 0)
                begin
                    vgacode <= 5'b00000;
                end
                else if (right_score == 1)
                begin
                    vgacode <= 5'b00001;
                end
                else if (right_score == 2)
                begin
                    vgacode <= 5'b00010;
                end
                else if (right_score == 3)
                begin
                    vgacode <= 5'b00011;
                end
                else if (right_score == 4)
                begin
                    vgacode <= 5'b00100;
                end
                else if (right_score == 5)
                begin
                    vgacode <= 5'b00101;
                end
                if(segments[wsSegment] == 1'b1) 
                    begin
                        color <= 12'hFFF;
                    end 
                else 
                    begin
                        color <= 12'h000;
                    end
            end 
    
        else 
            begin
                color<=12'h000;
            end
        end
endmodule
