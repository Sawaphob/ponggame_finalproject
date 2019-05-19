`timescale 1ns / 1ps

module tester;


reg clk,reset = 0;
reg [11:0] sw;

wire hsync,vsync;
wire [11:0]rgb;

vga_test vgat (clk,reset,sw,hsync,vsync,rgb);

initial
    begin
    #0;
    clk = 0;
    reset = 1;
    #20
    reset = 0;
    sw = 12'b0;
    #10000000
    $finish;
end

always
    #10 clk=~clk;

endmodule
