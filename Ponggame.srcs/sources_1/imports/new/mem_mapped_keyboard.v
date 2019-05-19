`timescale 1ns / 1ps

module mem_mapped_keyboard(
    inout [7:0] data,
    input [15:0] address,
    input PS2Data, PS2Clk, wr, clk,
    input wire reset,
    input wire [11:0] sw,
	input wire btnU, btnL,
    output [6:0] seg,
    output [3:0] an,
    output dp,
    output wire hsync, vsync,
	output wire [11:0] rgb
);

parameter DATA_WIDTH=8;
parameter ADDR_WIDTH=16;

//wire [15:0] data = 16'b0; //For Testing
//reg [7:0] address = 8'b0; //For Testing
//reg wr = 1'b0; //For Testing

reg [3:0] num0,num1,num2,num3;
reg [3:0] A,B,OP;
wire targetClk;
reg CLK50MHZ=0;
wire  [15:0] keycodev;
wire [15:0] keycode;
wire flag;
reg cn = 0;
reg [2:0] bcount;
reg start = 0;
reg [15:0] addr = 16'b0000000000000000;

//START VGA BLOCK
    reg [11:0] rgb_reg = 12'b000000000000;
    wire video_on;
//    wire vsync,hsync; //hsync means a row has been displayed
    wire p_tick; //Switching pixel
    wire [9:0] x,y;
    reg [9:0] reg_x,reg_y = 12'b000000000000;
    reg state = 0;
    reg [11:0] topColor = 12'b000000000000;
    wire [11:0] new_rgb;
    reg [9:0] rowNumber;
    
    vga_sync vga_sync_unit (clk,reset,hsync,vsync,video_on,p_tick,x,y);
  //  blackOrWhite bOrW (x,y,10'b0101000000,10'b0011110000,10'b0001100100,10'b0001100100,10'b1000011100,10'b0011001000,new_rgb);
    screenrom rom (new_rgb,x,y);
    assign rgb = (video_on) ? new_rgb : 12'b0;
//END VGA block        

//Memory
reg	[7:0]	mem[0:1<<ADDR_WIDTH - 1];
reg	[DATA_WIDTH-1:0]	data_out;

// Tri-State buffer
assign data=(wr==0) ? data_out:32'bz;

//START PS2 Keyboard Block

reg	[1:0] clk_transfer;
always @(posedge clk)
	clk_transfer <= { clk_transfer[0], PS2Data};
   
wire	ck_sck; // Our version of the SCK signal, having gone through the clock transfer
assign	ck_sck = clk_transfer[1];

reg	ck_stb;	// True on any positive edge of the clock
always @(posedge clk)
	ck_stb <= (clk_transfer[1:0] == 2'b01);

keyboard kb(clk,ck_stb,PS2Clk,keycode,keycodev);

//START quad7seg
wire [18:0] tclk;
assign tclk[0] = clk;
genvar c;
generate for(c=0;c<18;c=c+1)
begin
    clockDiv fdiv(tclk[c+1],tclk[c]);
end endgenerate
clockDiv fdivTarget(targetClk,tclk[18]);

quadSevenSeg q7seg(seg,dp,an,keycodev[3:0],keycodev[7:4],keycodev[11:8],keycodev[15:12],targetClk);

//START Memory initialization

// init to 0
//generate
//    begin: init_bram_to_zero
//        integer ram_index;
//        initial
//        for (ram_index = 0; ram_index < ADDR_WIDTH; ram_index = ram_index + 1)
//            mem[ram_index] = 8'b0;
//    end
//endgenerate

initial
begin
	$readmemb("data.mem",mem);
end

//END Memory initialization

//Memory Mapping for read
always @(address)
begin
           if(address == 16'hFFFF) begin 
                data_out = {keycodev[7:0]};
            end
            else if (address == 16'hFFFE) begin
                data_out = {keycodev[15:8]};
            end
            else
            
            begin
                $display("%10d - mem[%h] -  %h\n",$time, address,data_out);	
                data_out = {mem[address]};
            end    

end

//Mem Mapping for write
always @(posedge clk)
begin : MEM_WRITE
    if (wr) begin
                $display("%10d - MEM[%h] <- %h",$time, address, data);
                mem[address]={data[7:0]};
            end   
end


endmodule
