`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 14:04:25
// Design Name: 
// Module Name: led_control
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


module led_control(input clk, reset, currPlyr, valid_states, output reg [15:0] led = 16'hffff,input gamestart, input startani);
    localparam [31:0] STEP_CYCLES = 62499999;

    reg [31:0] step_counter = 0;
//    reg [15:0] led_mask = 16'hffff;
    reg ender = 0;
    reg prevPlyr = 0;
    always @(posedge clk) begin
        if (startani==1) ender <= 1;
        
        if (reset || (currPlyr != prevPlyr)|| (gamestart==0) ) begin
            led <= 16'hffff;
            step_counter <= 0;
            ender = 0;
        end
        
        if (valid_states && !ender) begin
            if (step_counter == STEP_CYCLES) begin
                step_counter <= 0;
                led <= led >> 1;
            end
            else begin
                step_counter <= step_counter + 1;
            end
        end

        prevPlyr <= currPlyr;
    end
    
endmodule
