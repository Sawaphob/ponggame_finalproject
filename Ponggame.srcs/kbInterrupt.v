`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2019 12:41:38 PM
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input clk, PS2Data, PS2Clk,
    output wire [15:0] keycode,
    output [15:0] keycodev
    );
    
    reg [2:0] bcount;
    reg CLK50MHZ=0;
    reg  [15:0] keycodev=0;
    
    wire flag;
    reg cn = 0;
    reg start = 0;
    
    always @(posedge(clk))begin
    CLK50MHZ<=~CLK50MHZ;
end
    
    PS2Receiver uut (
    .clk(CLK50MHZ),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
    );
    
   
always@(keycode)
    if (keycode[7:0] == 8'hf0) begin
        cn <= 1'b0;
        bcount <= 3'd0;
    end else if (keycode[15:8] == 8'hf0) begin
        cn <= keycode != keycodev;
        bcount <= 3'd5;
    end else begin
        cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
        bcount <= 3'd2;
    end

always@(posedge clk)
    if (flag == 1'b1 && cn == 1'b1) begin
        start <= 1'b1;
        keycodev <= keycode;
    end else
        start <= 1'b0;
        
endmodule
