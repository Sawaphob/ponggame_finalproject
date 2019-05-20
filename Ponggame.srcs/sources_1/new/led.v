`timescale 1ns / 1ps

module led(
    output reg [1:0] led,
    input state, clk
    );
    always@ (posedge clk)
        begin
            led[0] <= !state;
            led[1] <= state;
        end
    
endmodule
