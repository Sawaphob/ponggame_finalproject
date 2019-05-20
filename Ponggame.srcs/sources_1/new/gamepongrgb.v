`timescale 1ns / 1ps

module gamepongrgb(
    input [9:0] x,
    input [9:0] y,
    input [9:0] ballX,
    input [9:0] ballY,
    input [9:0] bar1Y,
    input [9:0] bar2Y,
    output reg [11:0] color
    );
    
    localparam BALL_SIZE = 8;
    localparam BAR_WIDTH = 8;
    localparam BAR_HEIGHT = 100;
    localparam scorePlayer1X = 200;
    localparam scorePlayer1Y = 30;
    localparam scorePlayer2X = 400;
    localparam scorePlayer2Y = 30;
    localparam scoreWidth = 16;
    localparam scoreHeight = 20;
    localparam bar1X = 100;
    localparam bar2X = 532;
    
    
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
    
    else begin
        color<=12'h000;
    end
    
    end
    

endmodule
