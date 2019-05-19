module vga_test
	(
		input wire clk, reset,
		input wire [11:0] sw,
		input wire btnU,
		input wire btnL,
		output wire hsync, vsync,
		output wire [11:0] rgb
	);
	
	// register for Basys 2 8-bit RGB DAC 
	reg [11:0] rgb_reg = 12'b0;
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
	wire vsync,hsync; //hsync means a row has been displayed
	wire p_tick; //Switching pixel
	wire [9:0] x,y;
	reg [9:0] reg_x,reg_y = 12'b0;
	reg state = 0;
	reg [11:0] topColor = 12'b0;
    wire [11:0] new_rgb;
    reg [9:0] rowNumber;
        // instantiate vga_sync
        vga_sync vga_sync_unit (clk,reset,hsync,vsync,video_on,p_tick,x,y);
        newColor newRGB(sw,topColor,rowNumber,state,new_rgb);
         
         always @(posedge clk)
         begin
         if(btnU) begin
            state = (state+1)%2;
         end
         if(btnL) begin 
            topColor = sw;
         end
         end
        
         always @(posedge p_tick)
         if(!state) begin
         rowNumber = x;
         if(video_on)
         begin
            if(x !== reg_x)
            begin
                reg_x = x;
                rgb_reg = new_rgb;
            end
            if(y !== reg_y) 
            begin
                reg_y = y;
                rgb_reg = sw;
            end
         end
         end
         else begin
         rowNumber = y;
         if(video_on)
         begin
            if(y !== reg_y)
            begin
                reg_y = y;
                rgb_reg = new_rgb;
            end
            if(vsync) 
            begin
                rgb_reg = sw;
            end
         end
         end
       
        // output
        assign rgb = (video_on) ? rgb_reg : 12'b0;
endmodule

