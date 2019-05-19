`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2019 07:32:27 AM
// Design Name: 
// Module Name: pixelSegment
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


module pixelSegment(
    output reg [19:0] segments,
    input [4:0] alphaNumeric
);

   always @(alphaNumeric)
      case (alphaNumeric)
          5'b00001 : segments <= 20'h22223;   // 1
          5'b00010 : segments <= 20'h71747;   // 2
          5'b00011 : segments <= 20'h74247;   // 3
          5'b00100 : segments <= 20'h47564;   // 4
          5'b00101 : segments <= 20'h74717;   // 5
          5'b00110 : segments <= 20'h75717;   // 6
          5'b00111 : segments <= 20'h44647;   // 7
          5'b01000 : segments <= 20'h75757;   // 8
          5'b01001 : segments <= 20'h74757;   // 9
          5'b01010 : segments <= 20'h57552;   // A
          5'b01011 : segments <= 20'h75157;   // C
          5'b01100 : segments <= 20'h71317;   // E
          5'b01101 : segments <= 20'h69d16;   // G
          5'b01110 : segments <= 20'h55755;   // H
          5'b01111 : segments <= 20'h72227;   // I
          5'b10000 : segments <= 20'h95359;   // K
          5'b10001 : segments <= 20'h9db99;   // N
          5'b10010 : segments <= 20'h69996;   // O
          5'b10011 : segments <= 20'h11757;   // P
          5'b10100 : segments <= 20'h22227;   // T
          default : segments <= 20'h75557;   // 0
      endcase
      
endmodule
