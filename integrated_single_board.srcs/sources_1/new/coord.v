`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 22:17:37
// Design Name: 
// Module Name: coord
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


module coord(input [12:0] pixel_index, output [6:0] x, output [6:0] y);

    assign x = pixel_index % 96;
    assign y = pixel_index / 96;

endmodule
