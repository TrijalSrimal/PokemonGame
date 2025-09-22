`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 22:02:24
// Design Name: 
// Module Name: rectangle_generator
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


module rectangle_generator(input [6:0]X,
                            Y,
                            OriginX,
                            OriginY,
                            height,
                            width,
                            input[15:0] rect_color,
                            current_pixel_color,
                            output [15:0] pixel_data);
                            
            
            //Check X and Y are within rectangle boundary using comparators
            wire inside_rectangle;
            assign inside_rectangle = (X >= OriginX) & (Y >= OriginY) & (X < (OriginX + width)) & (Y < (OriginY + height));
            
            //2 to 1 mux for pixel_data
            assign pixel_data = (inside_rectangle)? rect_color: current_pixel_color;
endmodule
