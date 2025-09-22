`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 22:14:22
// Design Name: 
// Module Name: flex_clk
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


module flex_clk(input clk, input [31:0] N, output reg slow_clk = 0);

    reg [31:0] count = 0;

    always @(posedge clk) begin
        count <= count + 1;
        if (count >= N) begin 
            count <= 0;
            slow_clk <= ~slow_clk;
        end
    end

endmodule
