`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2019 09:49:39 AM
// Design Name: 
// Module Name: whichSegment
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


module whichSegment(
        input [9:0] x,
        input [9:0] y,
        input [9:0] startX,
        input [9:0] startY,
        output reg [4:0] segments
    );
    
    localparam segmentSize = 6'b000100;
    
    reg [2:0] row = 3'b000;
    reg [1:0] column = 2'b00;
    
    always @(*) begin
    
    // --------------Decide column ---------------//
        if(x>=startX && x<(startX+segmentSize)) begin
            column <= 2'b00;
        end else if (x>=startX+segmentSize && x<startX+(segmentSize*2)) begin
            column <= 2'b01;
        end else if (x>=startX+(segmentSize*2) && x<startX+(segmentSize*3)) begin
            column <= 2'b10;
        end else if (x>=startX+(segmentSize*3) && x<startX+(segmentSize*4)) begin
            column <= 2'b11;
        end else begin
            column <= 2'b11;
        end
        
        
    // --------------Decide row ---------------//
    if(y>=startY && y<=startY+segmentSize) begin
        row <= 3'b000;
    end else if (y>=startY+segmentSize && y<startY+(segmentSize*2)) begin
        row <= 3'b001;
    end else if (y>=startY+(segmentSize*2) && y<startY+(segmentSize*3)) begin
        row <= 3'b010;
    end else if (y>=startY+(segmentSize*3) && y<startY+(segmentSize*4)) begin
        row <= 3'b011;
    end else if (y>=startY+(segmentSize*4) && y<startY+(segmentSize*5)) begin
        row <= 3'b100;
    end else begin
        row <= 3'b111;
    end
    
    segments <= {row,column};
    
    end
    
endmodule
