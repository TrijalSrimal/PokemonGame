`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 23:17:05
// Design Name: 
// Module Name: confirm_screen
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


module confirm_screen(input clk, input [6:0] x, y, input [1:0] btnState, input highlight_tick, output reg [15:0] pixel_data);
    
    reg [7:0] confirm_text [0:6][0:7];
    reg [12:0] tick [0:9];
    reg [10:0] cross [0:10];
    
    localparam BOX_X_START = 18;
    localparam BOX_Y_START = 10;
    localparam BOX_WIDTH   = 64;
    localparam BOX_HEIGHT  = 36;
    
    initial begin
        confirm_text[0][0] = 8'b01111100; 
        confirm_text[0][1] = 8'b10000000;
        confirm_text[0][2] = 8'b10000000; 
        confirm_text[0][3] = 8'b10000000;
        confirm_text[0][4] = 8'b10000000; 
        confirm_text[0][5] = 8'b10000000;
        confirm_text[0][6] = 8'b01111100; 
        confirm_text[0][7] = 8'b00000000; 
        
        confirm_text[1][0] = 8'b01111000;
        confirm_text[1][1] = 8'b10000100;
        confirm_text[1][2] = 8'b10000100;
        confirm_text[1][3] = 8'b10000100;
        confirm_text[1][4] = 8'b10000100;
        confirm_text[1][5] = 8'b10000100;
        confirm_text[1][6] = 8'b01111000;
        confirm_text[1][7] = 8'b00000000;
        
        confirm_text[2][0] = 8'b11000010; 
        confirm_text[2][1] = 8'b10100010;    
        confirm_text[2][2] = 8'b10100010;    
        confirm_text[2][3] = 8'b10010010;    
        confirm_text[2][4] = 8'b10001010;       
        confirm_text[2][5] = 8'b10000110;      
        confirm_text[2][6] = 8'b10000010;  
        confirm_text[2][7] = 8'b00000000;
        
        confirm_text[3][0] = 8'b11111100;
        confirm_text[3][1] = 8'b10000000;
        confirm_text[3][2] = 8'b10000000;
        confirm_text[3][3] = 8'b11110000;
        confirm_text[3][4] = 8'b10000000;
        confirm_text[3][5] = 8'b10000000;
        confirm_text[3][6] = 8'b10000000;
        confirm_text[3][7] = 8'b00000000; 
        
        confirm_text[4][0] = 8'b11111100;
        confirm_text[4][1] = 8'b00010000;
        confirm_text[4][2] = 8'b00010000;
        confirm_text[4][3] = 8'b00010000;
        confirm_text[4][4] = 8'b00010000;
        confirm_text[4][5] = 8'b00010000;
        confirm_text[4][6] = 8'b11111100;
        confirm_text[4][7] = 8'b00000000; 
    
        confirm_text[5][0] = 8'b11111000;
        confirm_text[5][1] = 8'b10000100;
        confirm_text[5][2] = 8'b10000100;
        confirm_text[5][3] = 8'b11111000;
        confirm_text[5][4] = 8'b10010000;
        confirm_text[5][5] = 8'b10001000;
        confirm_text[5][6] = 8'b10000100;
        confirm_text[5][7] = 8'b00000000;
    
        confirm_text[6][0] = 8'b10000010;
        confirm_text[6][1] = 8'b11000110;
        confirm_text[6][2] = 8'b10101010;
        confirm_text[6][3] = 8'b10010010;
        confirm_text[6][4] = 8'b10000010;
        confirm_text[6][5] = 8'b10000010;
        confirm_text[6][6] = 8'b10000010;
        confirm_text[6][7] = 8'b00000000;
        
        tick[0] = 13'b0000000000100; 
        tick[1] = 13'b0000000001010; 
        tick[2] = 13'b0010000010001; 
        tick[3] = 13'b0101000100010; 
        tick[4] = 13'b1000101000100; 
        tick[5] = 13'b0100010001000; 
        tick[6] = 13'b0010000010000; 
        tick[7] = 13'b0001000100000; 
        tick[8] = 13'b0000101000000; 
        tick[9] = 13'b0000010000000; 
        
        cross[0]  = 11'b00100000100;
        cross[1]  = 11'b01010001010;
        cross[2]  = 11'b10001010001;
        cross[3]  = 11'b01000100010;
        cross[4]  = 11'b00100000100;
        cross[5]  = 11'b00010001000;
        cross[6]  = 11'b00100000100;
        cross[7]  = 11'b01000100010;
        cross[8]  = 11'b10001010001;
        cross[9]  = 11'b01010001010;
        cross[10] = 11'b00100000100;
    end
    
    always @(posedge clk) begin
        pixel_data = 16'h0000; 
        
        if (y >= 16 && y < 24 && x >= 23 && x < (23 + 7 * 8)) begin
            if (confirm_text[(x - 23) / 8][y - 16] & (1 << (7 - ((x - 23) % 8))))
                pixel_data = 16'hffff; 
        end
        
        else if (y >= 30 && y < 40 && x >= 28 && x < (28 + 13)) begin
            if (tick[y - 30] & (1 << (12 - (x - 28))))
                pixel_data = 16'b00000_111111_00000;
        end
        
        else if (y >= 30 && y < 41 && x >= 58 && x < (58 + 11)) begin
            if (cross[y - 30] & (1 << (10 - (x - 58))))
                pixel_data = 16'b11111_000000_00000;
        end
        
        else if ((x == BOX_X_START || x == BOX_X_START + BOX_WIDTH - 1) && (y >= BOX_Y_START && y < BOX_Y_START + BOX_HEIGHT) || 
                (y == BOX_Y_START || y == BOX_Y_START + BOX_HEIGHT - 1) && (x >= BOX_X_START && x < BOX_X_START + BOX_WIDTH)) begin 
                pixel_data = 16'hffff; 
        end
        
        if (highlight_tick) begin
            if (((x == 26 || x == 41) && (y >= 28 && y <= 41)) ||
                ((y == 28 || y == 41) && (x >= 26 && x <= 41))) begin
                pixel_data = 16'b00000_111111_00000;
            end
        end
        else begin
            if (((x == 56 || x == 70) && (y >= 28 && y <= 41)) ||
                ((y == 28 || y == 41) && (x >= 56 && x <= 70))) begin
                pixel_data = 16'b11111_000000_00000;
            end
        end
    end
    
endmodule
