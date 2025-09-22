`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 23:02:19
// Design Name: 
// Module Name: player_screen
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


module player_screen(input clk, input [6:0] x, y, input btnU_in, input btnC_in, input btnD_in, 
                     input [1:0] btnState, output reg [15:0] pixel_data);

    reg [95:0] player_choice [0:63];
    reg [7:0] player1_text [0:6][0:7];  
    reg [7:0] player2_text [0:7][0:7]; 
    reg [7:0] arrow [0:7];
    
    initial begin
        player_choice[0]  = 0;
        player_choice[1]  = 96'b000000011111111000000111111000010000000100011111111100110000001100001111110000110000001000000000;
        player_choice[1]  = 96'b000000011111111000000111111000011000000110111111111100110000001100001111110000110000001100000000;
        player_choice[2]  = 96'b000000011000000110011000000110011000011000111000000000111100111100110000001100110000001100000000; 
        player_choice[3]  = 96'b000000011000000110011000000110011000011000110000000000111100111100110000001100110000001100000000;
        player_choice[4]  = 96'b000000011000000110011000000110011001100000110000000000110011001100110000001100111100001100000000;
        player_choice[5]  = 96'b000000011000000110011000000110011001100000110000000000110011001100110000001100111100001100000000;
        player_choice[6]  = 96'b000000011111111000011000000110011110000000111111110000110011001100110000001100110011001100000000;
        player_choice[7]  = 96'b000000011111111000011000000110011110000000111111110000110011001100110000001100110011001100000000;
        player_choice[8]  = 96'b000000011000000000011000000110011001000000111000000000110011001100110000001100110000111100000000;
        player_choice[9]  = 96'b000000011000000000011000000110011001100000110000000000110011001100110000001100110000111100000000;  
        player_choice[10] = 96'b000000011000000000011000000110011000010000110000000000110000001100110000001100110000001100000000;
        player_choice[11] = 96'b000000011000000000011000000110011000011000111000000000110000001100110000001100110000001100000000;
        player_choice[12] = 96'b000000011000000000000111111000011000000100111111111100110000001100001111110000110000001100000000;
       

        arrow[0] = 8'b11000000;
        arrow[1] = 8'b11100000;
        arrow[2] = 8'b11110000;
        arrow[3] = 8'b11111100;
        arrow[4] = 8'b11111100;
        arrow[5] = 8'b11110000;
        arrow[6] = 8'b11100000;
        arrow[7] = 8'b11000000;

        player1_text[0][0] = 8'b00110000;
        player1_text[0][1] = 8'b01110000;
        player1_text[0][2] = 8'b00110000;
        player1_text[0][3] = 8'b00110000;
        player1_text[0][4] = 8'b00110000;
        player1_text[0][5] = 8'b00110000;
        player1_text[0][6] = 8'b11111100;
        player1_text[0][7] = 8'b00000000;
    
        player1_text[1][0] = 8'b11111100;
        player1_text[1][1] = 8'b10000100;
        player1_text[1][2] = 8'b10000100;
        player1_text[1][3] = 8'b11111100;
        player1_text[1][4] = 8'b10000000;
        player1_text[1][5] = 8'b10000000;
        player1_text[1][6] = 8'b10000000;
        player1_text[1][7] = 8'b00000000;
    
        player1_text[2][0] = 8'b10000000;
        player1_text[2][1] = 8'b10000000;
        player1_text[2][2] = 8'b10000000;
        player1_text[2][3] = 8'b10000000;
        player1_text[2][4] = 8'b10000000;
        player1_text[2][5] = 8'b10000000;
        player1_text[2][6] = 8'b11111100;
        player1_text[2][7] = 8'b00000000;
    
        player1_text[3][0] = 8'b00110000;
        player1_text[3][1] = 8'b01001000;
        player1_text[3][2] = 8'b10000100;
        player1_text[3][3] = 8'b11111100;
        player1_text[3][4] = 8'b10000100;
        player1_text[3][5] = 8'b10000100;
        player1_text[3][6] = 8'b10000100;
        player1_text[3][7] = 8'b00000000;
    
        player1_text[4][0] = 8'b10000100;
        player1_text[4][1] = 8'b10000100;
        player1_text[4][2] = 8'b01001000;
        player1_text[4][3] = 8'b00110000;
        player1_text[4][4] = 8'b00110000;
        player1_text[4][5] = 8'b00110000;
        player1_text[4][6] = 8'b00110000;
        player1_text[4][7] = 8'b00000000;
    
        player1_text[5][0] = 8'b11111100;
        player1_text[5][1] = 8'b10000000;
        player1_text[5][2] = 8'b10000000;
        player1_text[5][3] = 8'b11111100;
        player1_text[5][4] = 8'b10000000;
        player1_text[5][5] = 8'b10000000;
        player1_text[5][6] = 8'b11111100;
        player1_text[5][7] = 8'b00000000;
    
        player1_text[6][0] = 8'b11111100;
        player1_text[6][1] = 8'b10000100;
        player1_text[6][2] = 8'b10000100;
        player1_text[6][3] = 8'b11111100;
        player1_text[6][4] = 8'b10010000;
        player1_text[6][5] = 8'b10001000;
        player1_text[6][6] = 8'b10000100;
        player1_text[6][7] = 8'b00000000;
        
        player2_text[0][0] = 8'b01111100;
        player2_text[0][1] = 8'b10000100;
        player2_text[0][2] = 8'b00001000;
        player2_text[0][3] = 8'b00010000;
        player2_text[0][4] = 8'b00100000;
        player2_text[0][5] = 8'b11000000;
        player2_text[0][6] = 8'b11111100;
        player2_text[0][7] = 8'b00000000;
        
        player2_text[1][0] = 8'b11111100;
        player2_text[1][1] = 8'b10000100;
        player2_text[1][2] = 8'b10000100;
        player2_text[1][3] = 8'b11111100;
        player2_text[1][4] = 8'b10000000;
        player2_text[1][5] = 8'b10000000;
        player2_text[1][6] = 8'b10000000;
        player2_text[1][7] = 8'b00000000;
        
        player2_text[2][0] = 8'b10000000;
        player2_text[2][1] = 8'b10000000;
        player2_text[2][2] = 8'b10000000;
        player2_text[2][3] = 8'b10000000;
        player2_text[2][4] = 8'b10000000;
        player2_text[2][5] = 8'b10000000;
        player2_text[2][6] = 8'b11111100;
        player2_text[2][7] = 8'b00000000;
        
        player2_text[3][0] = 8'b00110000;
        player2_text[3][1] = 8'b01001000;
        player2_text[3][2] = 8'b10000100;
        player2_text[3][3] = 8'b11111100;
        player2_text[3][4] = 8'b10000100;
        player2_text[3][5] = 8'b10000100;
        player2_text[3][6] = 8'b10000100;
        player2_text[3][7] = 8'b00000000;
        
        player2_text[4][0] = 8'b10000100;
        player2_text[4][1] = 8'b10000100;
        player2_text[4][2] = 8'b01001000;
        player2_text[4][3] = 8'b00110000;
        player2_text[4][4] = 8'b00110000;
        player2_text[4][5] = 8'b00110000;
        player2_text[4][6] = 8'b00110000;
        player2_text[4][7] = 8'b00000000;
        
        player2_text[5][0] = 8'b11111100;
        player2_text[5][1] = 8'b10000000;
        player2_text[5][2] = 8'b10000000;
        player2_text[5][3] = 8'b11111100;
        player2_text[5][4] = 8'b10000000;
        player2_text[5][5] = 8'b10000000;
        player2_text[5][6] = 8'b11111100;
        player2_text[5][7] = 8'b00000000;
        
        player2_text[6][0] = 8'b11111100;
        player2_text[6][1] = 8'b10000100;
        player2_text[6][2] = 8'b10000100;
        player2_text[6][3] = 8'b11111100;
        player2_text[6][4] = 8'b10010000;
        player2_text[6][5] = 8'b10001000;
        player2_text[6][6] = 8'b10000100;
        player2_text[6][7] = 8'b00000000;
        
        player2_text[7][0] = 8'b01111100;
        player2_text[7][1] = 8'b10000100;
        player2_text[7][2] = 8'b10000000;
        player2_text[7][3] = 8'b01111100;
        player2_text[7][4] = 8'b00000100;
        player2_text[7][5] = 8'b10000100;
        player2_text[7][6] = 8'b01111100;
        player2_text[7][7] = 8'b00000000;
    end

    reg [25:0] blink_counter = 0;
    reg blink_on = 1;

    always @(posedge clk) begin
        blink_counter <= blink_counter + 1;
        if (blink_counter >= 49999999) begin
            blink_counter <= 0;
            blink_on <= ~blink_on;
        end
    end

    reg player_selected = 0;
    integer char_idx;
    integer pixel_in_char;

always @(*) begin
        pixel_data = 0;
    
        if (y >= 1 && y <= 13 && x >= 7 && x <= 88) begin
            if (player_choice[y][95 - x]) begin
                pixel_data = 16'hffe0;
            end
        end
    
        if (y >= 30 && y < 38) begin
            if ( ( (btnState==2'b00) ||(btnState==2'b10) ) && x >= 10 && x < 18) begin
                if (arrow[y - 30][7 - (x - 20)] && blink_on) begin
                    pixel_data = 16'b00000_000000_11111;
                end
            end
    
            if (x >= 20 && x < 20 + 8 * 7) begin
                char_idx = (x - 20) / 8;
                pixel_in_char = (x - 20) % 8;
                if (char_idx < 7 && player1_text[char_idx][y - 30][7 - pixel_in_char]) begin
                    pixel_data = 16'hffff;
                end
            end
        end
    
        if (y >= 40 && y < 48) begin
            if (btnState==2'b01 && x >= 10 && x < 18) begin
                if (arrow[y - 40][7 - (x - 20)] && blink_on) begin
                    pixel_data = 16'b00000_000000_11111;
                end
            end
    
            if (x >= 20 && x < 20 + 8 * 8) begin
                char_idx = (x - 20) / 8;
                pixel_in_char = (x - 20) % 8;
                if (char_idx < 8 && player2_text[char_idx][y - 40][7 - pixel_in_char]) begin
                    pixel_data = 16'hFFFF;
                end
            end
        end
    end
endmodule
