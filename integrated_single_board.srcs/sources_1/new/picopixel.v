`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 22:03:16
// Design Name: 
// Module Name: picopixel
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


module picopixel(input [6:0]X,
                   Y,
                   PosX,
                   PosY,
                   input [31:0] ASCII,
                   input [15:0] Current_Color,
                   Character_Color,
                   output [15:0] Pixel_data);
                   
       //Using Comparators to see if coordinates are within character boundary
       wire inside_box;
       assign inside_box = (X >= PosX) & (X < PosX + 3) & (Y >= PosY) & (Y < PosY + 5);
       
       //Use subtractors to see whre X and Y are located inside box if inside box = 1 else rubbish value will be produced
       wire [2:0] row_index = Y - PosY;
       wire [2:0] col_index = X - PosX;
       
       //Create an LUT for the H character
       //There are 5 rows in total
       wire [2:0] row_pattern;
       picopixel_LUT my_picopixel_LUT(.ASCII(ASCII),
                                      .Current_Row(row_index),
                                      .row_pattern(row_pattern));
       
       //Choose the pixel from the LUT assuming the X and Y are inside the box
       wire pixel_on = row_pattern[2-col_index];
       
       //2 to 1 mux to choose color
       assign Pixel_data = (pixel_on & inside_box)? Character_Color: Current_Color;
endmodule
