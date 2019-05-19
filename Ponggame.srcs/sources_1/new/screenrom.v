`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2019 02:39:06 PM
// Design Name: 
// Module Name: screenrom
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


module screenrom(
    output wire [11:0] z,
    input wire [9:0] x,
    input wire [9:0] y);
// declares a memory rom of 8 4-bit registers.
//The indices are 0 to 7
    (* synthesis, rom_block = "ROM_CELL XYZ01" *)
    reg [11:0] rom[0:76800 - 1];
    wire [16:0] idx;
// NOTE: To infer combinational logic instead of a ROM, use
// (* synthesis, logic_block *)
    assign idx = 320* y[9:1]+x[9:1];
    initial $readmemb("myfile.data", rom );
    assign z = rom[idx];
    
endmodule
