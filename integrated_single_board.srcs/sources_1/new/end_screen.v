`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2025 19:59:00
// Design Name: 
// Module Name: end_screen
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


module end_screen(input clk, input [6:0] x, y, input endgame_p1, input endgame_p2, 
                    output reg [15:0] pixel_data);
    
    
    reg [47:0] player_text[0:7] ; 
    reg [7:0] one [0:7];
    reg [7:0] two [0:7];
    reg [95:0] initial_screen_design [0:20];
    reg [25:0] win [0:7];
    
    initial begin
            player_text[0] = 48'b111111001000000000110000100001001111110011111100;
            player_text[1] = 48'b100001001000000001001000100001001000000010000100;
            player_text[2] = 48'b100001001000000010000100010010001000000010000100;
            player_text[3] = 48'b111111001000000011111100001100001111110011111100;
            player_text[4] = 48'b100000001000000010000100001100001000000010010000;
            player_text[5] = 48'b100000001000000010000100001100001000000010001000;
            player_text[6] = 48'b100000001111110010000100001100001111110010000100;
            player_text[7] = 0;
        
            
            one[0] = 8'b00110000;
            one[1] = 8'b01110000;
            one[2] = 8'b00110000;
            one[3] = 8'b00110000;
            one[4] = 8'b00110000;
            one[5] = 8'b00110000;
            one[6] = 8'b11111100;
            one[7] = 8'b00000000;
            
            two[0] = 8'b01111100;
            two[1] = 8'b10000100;
            two[2] = 8'b00001000;
            two[3] = 8'b00010000;
            two[4] = 8'b00100000;
            two[5] = 8'b11000000;
            two[6] = 8'b11111100;
            two[7] = 8'b00000000;
            
            
            initial_screen_design[0] = 48'b000000000111010100110101000000100111010100000000;
            initial_screen_design[1] = 48'b000000000111010100100111000001010101001000000000;
            initial_screen_design[2] = 48'b000000000100010100100111000001110101001000000000;
            initial_screen_design[3] = 48'b000000000100011101100101000001010101001000000000;
            initial_screen_design[4] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[5] = 48'b000000000000000000000000000000000000000000000000; 
            initial_screen_design[6] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[7] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[8] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[9] = 48'b000000000000111010101110111011101110000000000000;
            initial_screen_design[10] = 48'b000000000000110010101110111010101010000000000000;
            initial_screen_design[11] = 48'b000000000000111010100100010010101010000000000000;
            initial_screen_design[12] = 48'b000000000000111011100100010011101010000000000000;
            initial_screen_design[13] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[14] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[15] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[16] = 48'b000000000000000000000000000000000000000000000000;
            initial_screen_design[17] = 48'b000001110111000011101110011011100100111011100000;
            initial_screen_design[18] = 48'b000001110101000010101110010011101010101011100000;
            initial_screen_design[19] = 48'b000000100101000011101100010001001110110001000000;
            initial_screen_design[20] = 48'b000000100111000010101110110001001010101001000000;
            
            win[0] = 26'b10000001011111111011000001;
            win[1] = 26'b10000001000011000010100001;
            win[2] = 26'b10000001000011000010010001;
            win[3] = 26'b10000001000011000010001001;
            win[4] = 26'b10011001000011000010000101;
            win[5] = 26'b10100101000011000010000011;
            win[6] = 26'b11000011011111111010000001;
            win[7] = 0;
        
         
     
     end
     
     
     
     always @(posedge clk) begin
         pixel_data = 16'hffff;  
            if (x >= 25 && x <= 72 && y >= 6 && y <= 13) begin
                 case(y)
                     6: pixel_data = player_text[0][47 - (x - 25)] ? 0 : 16'hffff;
                     7: pixel_data = player_text[1][47 - (x - 25)] ? 0 : 16'hffff;
                     8: pixel_data = player_text[2][47 - (x - 25)] ? 0 : 16'hffff;
                     9: pixel_data = player_text[3][47 - (x - 25)] ? 0 : 16'hffff;
                     10: pixel_data = player_text[4][47 - (x - 25)] ? 0 : 16'hffff;
                     11: pixel_data = player_text[5][47 - (x - 25)] ? 0 : 16'hffff;
                     12: pixel_data = player_text[6][47 - (x - 25)] ? 0 : 16'hffff;
                     13: pixel_data = player_text[7][47 - (x - 25)] ? 0 : 16'hffff;
                 endcase
            end
            
            if (x >= 72 && x <= 79 && y >= 6 && y <= 13) begin
                 if (endgame_p2) begin 
                 case(y)
                     6: pixel_data = one[0][7 - (x - 72)] ? 0 : 16'hffff;
                     7: pixel_data = one[1][7 - (x - 72)] ? 0 : 16'hffff;
                     8: pixel_data = one[2][7 - (x - 72)] ? 0 : 16'hffff;
                     9: pixel_data = one[3][7 - (x - 72)] ? 0 : 16'hffff;
                     10: pixel_data = one[4][7 - (x - 72)] ? 0 : 16'hffff;
                     11: pixel_data = one[5][7 - (x - 72)] ? 0 : 16'hffff;
                     12: pixel_data = one[6][7 - (x - 72)] ? 0 : 16'hffff;
                     13: pixel_data = one[7][7 - (x - 72)] ? 0 : 16'hffff;
                 endcase
                 end
                 if (endgame_p1) begin 
                  case(y)
                      6: pixel_data = two[0][7 - (x - 65)] ? 0 : 16'hffff;
                      7: pixel_data = two[1][7 - (x - 65)] ? 0 : 16'hffff;
                      8: pixel_data = two[2][7 - (x - 65)] ? 0 : 16'hffff;
                      9: pixel_data = two[3][7 - (x - 65)] ? 0 : 16'hffff;
                      10: pixel_data = two[4][7 - (x - 65)] ? 0 : 16'hffff;
                      11: pixel_data = two[5][7 - (x - 65)] ? 0 : 16'hffff;
                      12: pixel_data = two[6][7 - (x - 65)] ? 0 : 16'hffff;
                      13: pixel_data = two[7][7 - (x - 65)] ? 0 : 16'hffff;
                  endcase
                  end
            end
            
            if (x >= 40 && x <= 65 && y >= 17 && y <= 24) begin
                 case(y)
                     17: pixel_data = win[0][25 - (x - 40)] ? 0 : 16'hffff;
                     18: pixel_data = win[1][25 - (x - 40)] ? 0 : 16'hffff;
                     19: pixel_data = win[2][25 - (x - 40)] ? 0 : 16'hffff;
                     20: pixel_data = win[3][25 - (x - 40)] ? 0 : 16'hffff;
                     21: pixel_data = win[4][25 - (x - 40)] ? 0 : 16'hffff;
                     22: pixel_data = win[5][25 - (x - 40)] ? 0 : 16'hffff;
                     23: pixel_data = win[6][25 - (x - 40)] ? 0 : 16'hffff;
                     24: pixel_data = win[7][25 - (x - 40)] ? 0 : 16'hffff;
                 endcase
            end
            
            if (x >= 30 && x <= 77 && y >= 31 && y <= 51) begin
                 case(y)
                     31: pixel_data = initial_screen_design[0][47 - (x - 30)] ? 0 : 16'hffff;
                     32: pixel_data = initial_screen_design[1][47 - (x - 30)] ? 0 : 16'hffff;
                     33: pixel_data = initial_screen_design[2][47 - (x - 30)] ? 0 : 16'hffff;
                     34: pixel_data = initial_screen_design[3][47 - (x - 30)] ? 0 : 16'hffff;
                     35: pixel_data = initial_screen_design[4][47 - (x - 30)] ? 0 : 16'hffff;
                     36: pixel_data = initial_screen_design[5][47 - (x - 30)] ? 0 : 16'hffff;
                     37: pixel_data = initial_screen_design[6][47 - (x - 30)] ? 0 : 16'hffff;
                     38: pixel_data = initial_screen_design[7][47 - (x - 30)] ? 0 : 16'hffff;
                     39: pixel_data = initial_screen_design[8][47 - (x - 30)] ? 0 : 16'hffff;
                     40: pixel_data = initial_screen_design[9][47 - (x - 30)] ? 0 : 16'hffff;
                     41: pixel_data = initial_screen_design[10][47 - (x - 30)] ? 0 : 16'hffff;
                     42: pixel_data = initial_screen_design[11][47 - (x - 30)] ? 0 : 16'hffff;
                     43: pixel_data = initial_screen_design[12][47 - (x - 30)] ? 0 : 16'hffff;
                     44: pixel_data = initial_screen_design[13][47 - (x - 30)] ? 0 : 16'hffff;
                     45: pixel_data = initial_screen_design[14][47 - (x - 30)] ? 0 : 16'hffff;
                     46: pixel_data = initial_screen_design[15][47 - (x - 30)] ? 0 : 16'hffff;
                     47: pixel_data = initial_screen_design[16][47 - (x - 30)] ? 0 : 16'hffff;
                     48: pixel_data = initial_screen_design[17][47 - (x - 30)] ? 0 : 16'hffff;
                     49: pixel_data = initial_screen_design[18][47 - (x - 30)] ? 0 : 16'hffff;
                     50: pixel_data = initial_screen_design[19][47 - (x - 30)] ? 0 : 16'hffff;
                     51: pixel_data = initial_screen_design[20][47 - (x - 30)] ? 0 : 16'hffff;
                 endcase
            end
     end
endmodule
