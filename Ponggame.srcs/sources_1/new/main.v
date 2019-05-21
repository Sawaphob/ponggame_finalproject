`timescale 1ns / 1ps

module main(
    input clk,
    input PS2Data,
    input PS2Clk,
    input wire reset,
    input wire [11:0] sw,
    input wire btnU,
    input wire btnL,
    output [1:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp,
    output wire hsync, vsync,
	output wire [11:0] rgb
);

    reg nWAIT = 1'b1;
    reg nINT = 1'b1;
    reg nNMI = 1'b1;
    reg nRESET = 1'b1;
    reg nBUSRQ = 1'b1;

    wire nM1,nMREQ,nIORQ,nRD,nWR,nRFSH,nHALT,nBUSACK;
    wire state;
    wire [15:0] A;
    wire [7:0] D;
    
    wire RamWE;
    assign RamWE = nIORQ==1 && nRD==1 && nWR==0;
    
    wire targetClk;
    wire [11:0] tclk;
    assign tclk[0] = clk;
    genvar c;
    generate for(c=0;c<11;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1],tclk[c]);
    end endgenerate
    clockDiv fdivTarget(targetClk,tclk[11]);
    
    z80_top_direct_n cpu(nM1,nMREQ,nIORQ,nRD,nWR, nRFSH,nHALT,nBUSACK,nWAIT,nINT,nNMI,nRESET,nBUSRQ,targetClk,A,D);
    mem_mapped_keyboard mem(D,A,PS2Data,PS2Clk,RamWE,clk,reset,sw,btnU,btnL,seg,an,dp,hsync,vsync,rgb,state);
    assign led[0] = !state;
    assign led[1] = state;
endmodule
