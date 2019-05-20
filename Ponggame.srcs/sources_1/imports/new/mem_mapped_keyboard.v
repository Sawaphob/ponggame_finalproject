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
	output wire [11:0] rgb,
	output reg [1:0] player1Action = 2'b0,
	output reg [1:0] player2Action = 2'b0
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
reg  [15:0] keycodev=0;
wire [15:0] keycode;
wire flag;
reg cn = 0;
reg [2:0] bcount;
reg start = 0;
reg [15:0] addr = 16'b0000000000000000;

reg [9:0] ball_x = 10'b0101000000;
reg [9:0] ball_y = 10'b0011110000;
reg [9:0] left_bar_y = 10'b0010100000;
reg [9:0] right_bar_y = 10'b0010100000;
reg stage = 1'b0;
reg restart = 1'b0;
reg [3:0] left_score = 4'b0;
reg [3:0] right_score = 4'b0;
reg [7:0] timer = 8'b0;
reg ball_speed_x = 1'b0;
reg ball_speed_y = 1'b0;

//START VGA BLOCK
    reg [11:0] rgb_reg = 12'b000000000000;
    wire video_on;
    wire vsync,hsync; //hsync means a row has been displayed
    wire p_tick; //Switching pixel
    wire [9:0] x,y;
    reg [9:0] reg_x,reg_y = 12'b000000000000;
    reg state = 0;
    reg [11:0] topColor = 12'b000000000000;
    wire [11:0] start_rgb;
    wire [11:0] game_rgb;
    wire [11:0] selectrgb;
    reg [9:0] rowNumber;
    
    vga_sync vga_sync_unit (clk,reset,hsync,vsync,video_on,p_tick,x,y);
    screenrom rom (start_rgb,x,y);
    gamepongrgb pong (x,y,ball_x,ball_y,left_bar_y,right_bar_y,game_rgb);
    assign selectrgb = (state) ? game_rgb : start_rgb;
    assign rgb = (video_on) ? selectrgb : 12'b0;
   
   // assign rgb = (video_on) ? new_rgb : 12'b0;
//END VGA block        

//Memory
reg	[7:0]	mem[0:1<<ADDR_WIDTH - 1];
reg	[DATA_WIDTH-1:0]	data_out;

// Tri-State buffer
assign data=(wr==0) ? data_out:32'bz;

//START PS2 Keyboard Block
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
generate
    begin: init_bram_to_zero
        integer ram_index;
        initial
        for (ram_index = 0; ram_index < 2**ADDR_WIDTH; ram_index = ram_index + 1)
            mem[ram_index] = 8'b0;
    end
endgenerate

initial
begin
    $readmemh("data2.mem",mem,0);
	$readmemh("data.mem",mem,32768);
end

//END Memory initialization

//Memory Mapping for read
always @(address)
begin
      case (address)
          16'h44F0 : data_out <= ball_x[9:2];
          16'h44E0 : data_out <= ball_y[9:2];
          16'h44D0 : data_out <= left_bar_y[9:2];
          16'h44C0 : data_out <= right_bar_y[9:2];
          16'h44B0 : data_out <= {7'b0,stage};
          16'h44A0 : data_out <= {7'b0,restart};
          16'h4490 : data_out <= {4'b0,left_score};
          16'h4480 : data_out <= {7'b0,right_score};
          16'h4470 : data_out <= timer;
          16'h4460 : data_out <= {7'b0,ball_speed_x};
          16'h4450 : data_out <= {7'b0,ball_speed_y};
          16'h4440 : data_out <= {6'b0,player1Action};
          16'h4430 : data_out <= {6'b0,player2Action};
          default : data_out <= mem[address];
      endcase
end

//Mem Mapping for write
always @(posedge clk)
begin : MEM_WRITE
	if (wr) begin
        case(address)
            16'h44F0 : ball_x <= {data,2'b00};
            16'h44E0 : ball_y <= {data,2'b00};
            16'h44D0 : left_bar_y <= {data,2'b00};
            16'h44C0 : right_bar_y <= {data,2'b00};
            16'h44B0 : stage <= data[0];
            16'h44A0 : restart <= data[0];
            16'h4490 : left_score <= data[3:0];
            16'h4480 : right_score <= data[3:0];
            16'h4470 : timer <= data;
            16'h4460 : ball_speed_x <= data[0];
            16'h4450 : ball_speed_y <= data[0];
            default: mem[address] <= data;
        endcase		
	end else begin
        if(keycode[7:0] == 8'h29) begin
            state <= 1;
        end
	end
 
end


endmodule