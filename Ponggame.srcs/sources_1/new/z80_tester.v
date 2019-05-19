`timescale 1ns / 1ps

module z80_tester(
    input clk, //Comment Out for simulation
    input PS2Data,
    input PS2Clk,
    input wire reset, //Comment Out for simulation
    input wire [11:0] sw,
    input wire btnU,
    input wire btnL,
    output [15:0] led,
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
    
//    reg reset = 1'b0; // For Simulation
//    reg clk = 1'b0; //For Simulation

    wire nM1,nMREQ,nIORQ,nRD,nWR,nRFSH,nHALT,nBUSACK; // For Simulation

    // ----------------- INTERNAL WIRES -----------------
    wire [15:0] A;
    wire [7:0] D;
    
    wire RamWE;
    assign RamWE = nIORQ==1 && nRD==1 && nWR==0;
    assign led = A;
  
// Create Clock to SLOW DOWN CPU  
    wire targetClk;
    wire [22:0] tclk;
    assign tclk[0] = clk;
    genvar c;
    generate for(c=0;c<22;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1],tclk[c]);
    end endgenerate
    clockDiv fdivTarget(targetClk,tclk[22]);
    
    z80_top_direct_n cpu(nM1,nMREQ,nIORQ,nRD,nWR, nRFSH,nHALT,nBUSACK,nWAIT,nINT,nNMI,nRESET,nBUSRQ,targetClk,A,D);

    mem_mapped_keyboard mem(D,A,PS2Data,PS2Clk,RamWE,clk,reset,sw,btnU,btnL,seg,an,dp,hsync,vsync,rgb);


//FOR SIMULATION
//    initial
//    begin
//        #0;
//        nWAIT = 1;
//        nINT = 1;
//        nNMI = 1;
//        nRESET = 1;
//        nBUSRQ = 1;
//        reset = 0;
//        #100;
//        nRESET = 1;
//        #150;
//        nRESET = 1;
//        #160;
//        nNMI = 1;
//        #200;
//        nNMI = 1;
//     end

//    always
//    begin
//        #5 clk = ~clk; 
//    end
    
//END FOR SIMULATION
endmodule
