`timescale 1ns / 1ps

module newColor(
    input [11:0] foreground,
    input [11:0] background,
    input [9:0] rowNumber,
    input state,
    output reg [11:0] newRGB
    );
    
    localparam totalX = 640; // vertical display area
    localparam totalY = 480;
    
    always @(rowNumber)
    begin
    if(!state) begin
        newRGB[11:8] = (((totalX-rowNumber)*foreground[11:8])/totalX + (rowNumber*background[11:8])/totalX); 
        newRGB[7:4] = (((totalX-rowNumber)*foreground[7:4])/totalX + (rowNumber*background[7:4])/totalX); 
        newRGB[3:0] = (((totalX-rowNumber)*foreground[3:0])/totalX + (rowNumber*background[3:0])/totalX); 
    end
    else begin
        newRGB[11:8] = (((totalY-rowNumber)*foreground[11:8])/totalY + (rowNumber*background[11:8])/totalY); 
        newRGB[7:4] = (((totalY-rowNumber)*foreground[7:4])/totalY + (rowNumber*background[7:4])/totalY); 
        newRGB[3:0] = (((totalY-rowNumber)*foreground[3:0])/totalY + (rowNumber*background[3:0])/totalY); 
    end
    end
endmodule
