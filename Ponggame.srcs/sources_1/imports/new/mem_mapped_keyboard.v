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
	output reg [1:0] player2Action = 2'b0,
	output reg state
);
    
    parameter DATA_WIDTH=8;
    parameter ADDR_WIDTH=16;
    
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
    
    reg [9:0] ballPosX = 10'b0101000000;
    reg [9:0] ballPosY = 10'b0011110000;
    reg [9:0] leftPaddlePos = 10'b0010100000;
    reg [9:0] rightPaddlePos = 10'b0010100000;
    reg resetgame = 1'b0;
    reg [3:0] left_score = 4'b0;
    reg [3:0] right_score = 4'b0;
    reg [7:0] timer = 8'b0;
    reg acceralationX = 1'b0;
    reg acceralationY = 1'b0;
    
    reg [11:0] rgb_reg = 12'b000000000000;
    wire video_on;
    wire vsync,hsync;
    wire p_tick;
    wire [9:0] x,y;
    reg [9:0] reg_x,reg_y = 12'b000000000000;
    //reg state = 1'b0;
    reg [11:0] topColor = 12'b000000000000;
    wire [11:0] start_rgb;
    wire [11:0] game_rgb;
    wire [11:0] selectrgb;
    reg [9:0] rowNumber;
        
    vga_sync vga_sync_unit (clk,reset,hsync,vsync,video_on,p_tick,x,y);
    screenrom rom (start_rgb,x,y);
    gamepongrgb pong (x,y,ballPosX,ballPosY,leftPaddlePos,rightPaddlePos,game_rgb);
    assign selectrgb = (state) ? game_rgb : start_rgb;
    assign rgb = (video_on) ? selectrgb : 12'b0;
    
    reg	[7:0]	mem[0:1<<ADDR_WIDTH - 1];
    reg	[DATA_WIDTH-1:0]	data_out;
    
    assign data=(wr==0) ? data_out:32'bz;
    
    always @(posedge(clk))
        begin
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
        if (keycode[7:0] == 8'hf0)
            begin
                cn <= 1'b0;
                bcount <= 3'd0;
            end
        else if (keycode[15:8] == 8'hf0)
            begin
                cn <= keycode != keycodev;
                bcount <= 3'd5;
            end 
        else
            begin
                cn <= keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0;
                bcount <= 3'd2;
            end
    
    always@(posedge clk)
        if (flag == 1'b1 && cn == 1'b1)
            begin
                start <= 1'b1;
                keycodev <= keycode;
            end
        else
            start <= 1'b0;
    
    always@(keycode) 
        begin
            if((keycode[15:8] == 8'hf0) && (keycode[7:0] == 8'h1c)) 
                begin
                    player1Action <= 2'b00;
                end 
            else if ((keycode[15:8] == 8'hf0) && (keycode[7:0] == 8'h1b)) 
                begin
                    player1Action <= 2'b00;
                end 
            else if ((keycode[15:8] != 8'hf0) && (keycode[7:0] == 8'h1c)) 
                begin
                    player1Action <= 2'b10;
                end 
            else if ((keycode[15:8] != 8'hf0) && (keycode[7:0] == 8'h1b)) 
                begin
                    player1Action <= 2'b01;
                end
    
            if((keycode[15:8] == 8'hf0) && (keycode[7:0] == 8'h3b)) 
                begin
                    player2Action <= 2'b00;
                end 
            else if ((keycode[15:8] == 8'hf0) && (keycode[7:0] == 8'h42)) 
                begin
                    player2Action <= 2'b00;
                end 
            else if ((keycode[15:8] != 8'hf0) && (keycode[7:0] == 8'h3b)) 
                begin
                    player2Action <= 2'b10;
                end 
            else if ((keycode[15:8] != 8'hf0) && (keycode[7:0] == 8'h42)) 
                begin
                    player2Action <= 2'b01;
                end
        end
    
    wire [18:0] tclk;
    assign tclk[0] = clk;
    genvar c;
    generate for(c=0;c<18;c=c+1)
        begin
            clockDiv fdiv(tclk[c+1],tclk[c]);
        end
    endgenerate
    clockDiv fdivTarget(targetClk,tclk[18]);
    
    quadSevenSeg q7seg(seg,dp,an,keycodev[3:0],keycodev[7:4],keycodev[11:8],keycodev[15:12],targetClk);
    
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
    
    always @(address)
        begin
            case (address)
                16'h44F0 : data_out <= ballPosX[9:2];
                16'h44E0 : data_out <= ballPosY[9:2];
                16'h44D0 : data_out <= leftPaddlePos[9:2];
                16'h44C0 : data_out <= rightPaddlePos[9:2];
                16'h44B0 : data_out <= {7'b0000000,state};
                16'h44A0 : data_out <= {7'b0000000,resetgame};
                16'h4490 : data_out <= {4'b0000,left_score};
                16'h4480 : data_out <= {7'b0000000,right_score};
                16'h4470 : data_out <= timer;
                16'h4460 : data_out <= {7'b0000000,acceralationX};
                16'h4450 : data_out <= {7'b0000000,acceralationY};
                16'h4440 : data_out <= {6'b000000,player1Action};
                16'h4430 : data_out <= {6'b000000,player2Action};
                default : data_out <= mem[address];
            endcase
        end
    
    always @(posedge clk)
        begin : MEM_WRITE
            if(wr)
                begin
                    case(address)
                        16'h44F0 : ballPosX <= {data,2'b00};
                        16'h44E0 : ballPosY <= {data,2'b00};
                        16'h44D0 : leftPaddlePos <= {data,2'b00};
                        16'h44C0 : rightPaddlePos <= {data,2'b00};
                        16'h44B0 : state <= data[0];
                        16'h44A0 : resetgame <= data[0];
                        16'h4490 : left_score <= data[3:0];
                        16'h4480 : right_score <= data[3:0];
                        16'h4470 : timer <= data;
                        16'h4460 : acceralationX <= data[0];
                        16'h4450 : acceralationY <= data[0];
                        default: mem[address] <= data;
                    endcase		
                end
            else 
                begin
                    if(keycode[7:0] == 8'h29 && state == 0) // press spacebar to start
                        begin
                            state <= 1'b1;
                        end
                    /*if(state == 1)
                        begin
                        if(keycode[7:0] == 8'h1C) // press A to move left padd up
                            begin
                                leftPaddlePos <= leftPaddlePos - 10'b0000000100;
                            end
                        if(keycode[7:0] == 8'h23) // press D to move left padd down
                            begin
                                leftPaddlePos <= leftPaddlePos + 10'b0000000100;
                            end
                        end*/
                end
        end
endmodule