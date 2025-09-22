`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 23:11:58
// Design Name: 
// Module Name: player2
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


module player2(input clk, input [6:0] x, y, input [1:0] btnState, output reg [15:0] pixel_data);
    
    reg [7:0] player2_text [0:6][0:7]; 
    reg [7:0] squirtle [0:7][0:7];   
    reg [7:0] charmander [0:9][0:7]; 
    reg [7:0] bulbasaur [0:8][0:7];  

    initial begin
        player2_text[0][0] = 8'b11111100;
        player2_text[0][1] = 8'b10000100;
        player2_text[0][2] = 8'b10000100;
        player2_text[0][3] = 8'b11111100;
        player2_text[0][4] = 8'b10000000;
        player2_text[0][5] = 8'b10000000;
        player2_text[0][6] = 8'b10000000;
        player2_text[0][7] = 8'b00000000;
    
        player2_text[1][0] = 8'b10000000;
        player2_text[1][1] = 8'b10000000;
        player2_text[1][2] = 8'b10000000;
        player2_text[1][3] = 8'b10000000;
        player2_text[1][4] = 8'b10000000;
        player2_text[1][5] = 8'b10000000;
        player2_text[1][6] = 8'b11111100;
        player2_text[1][7] = 8'b00000000;
   
        player2_text[2][0] = 8'b00110000;
        player2_text[2][1] = 8'b01001000;
        player2_text[2][2] = 8'b10000100;
        player2_text[2][3] = 8'b11111100;
        player2_text[2][4] = 8'b10000100;
        player2_text[2][5] = 8'b10000100;
        player2_text[2][6] = 8'b10000100;
        player2_text[2][7] = 8'b00000000;
    
        player2_text[3][0] = 8'b10000100;
        player2_text[3][1] = 8'b10000100;
        player2_text[3][2] = 8'b01001000;
        player2_text[3][3] = 8'b00110000;
        player2_text[3][4] = 8'b00110000;
        player2_text[3][5] = 8'b00110000;
        player2_text[3][6] = 8'b00110000;
        player2_text[3][7] = 8'b00000000;
    
        player2_text[4][0] = 8'b11111100;
        player2_text[4][1] = 8'b10000000;
        player2_text[4][2] = 8'b10000000;
        player2_text[4][3] = 8'b11111100;
        player2_text[4][4] = 8'b10000000;
        player2_text[4][5] = 8'b10000000;
        player2_text[4][6] = 8'b11111100;
        player2_text[4][7] = 8'b00000000;
    
        player2_text[5][0] = 8'b11111100;
        player2_text[5][1] = 8'b10000100;
        player2_text[5][2] = 8'b10000100;
        player2_text[5][3] = 8'b11111100;
        player2_text[5][4] = 8'b10010000;
        player2_text[5][5] = 8'b10001000;
        player2_text[5][6] = 8'b10000100;
        player2_text[5][7] = 8'b00000000;
   
        player2_text[6][0] = 8'b01111100;
        player2_text[6][1] = 8'b10000100;
        player2_text[6][2] = 8'b00001000;
        player2_text[6][3] = 8'b00010000;
        player2_text[6][4] = 8'b00100000;
        player2_text[6][5] = 8'b11000000;
        player2_text[6][6] = 8'b11111100;
        player2_text[6][7] = 8'b00000000;
        
        
        squirtle[0][0] = 8'b01111000; 
        squirtle[0][1] = 8'b10000100; 
        squirtle[0][2] = 8'b10000000; 
        squirtle[0][3] = 8'b01111000; 
        squirtle[0][4] = 8'b00000100; 
        squirtle[0][5] = 8'b10000100; 
        squirtle[0][6] = 8'b01111000; 
        squirtle[0][7] = 8'b00000000;

        squirtle[1][0] = 8'b01111000; 
        squirtle[1][1] = 8'b10000100; 
        squirtle[1][2] = 8'b10000100; 
        squirtle[1][3] = 8'b10000100; 
        squirtle[1][4] = 8'b10010100; 
        squirtle[1][5] = 8'b10001100; 
        squirtle[1][6] = 8'b01111010; 
        squirtle[1][7] = 8'b00000000; 
        
        squirtle[2][0] = 8'b10000010; 
        squirtle[2][1] = 8'b10000010;
        squirtle[2][2] = 8'b10000010; 
        squirtle[2][3] = 8'b10000010;
        squirtle[2][4] = 8'b10000010; 
        squirtle[2][5] = 8'b10000010;
        squirtle[2][6] = 8'b01111100; 
        squirtle[2][7] = 8'b00000000;
        
        squirtle[3][0] = 8'b00111100;  
        squirtle[3][1] = 8'b00010000;  
        squirtle[3][2] = 8'b00010000;  
        squirtle[3][3] = 8'b00010000;  
        squirtle[3][4] = 8'b00010000;  
        squirtle[3][5] = 8'b00010000;  
        squirtle[3][6] = 8'b00111100;   
        squirtle[3][7] = 8'b00000000;
        
        squirtle[4][0] = 8'b11111100;  
        squirtle[4][1] = 8'b10000010;    
        squirtle[4][2] = 8'b10000010;  
        squirtle[4][3] = 8'b11111100;  
        squirtle[4][4] = 8'b10010000;  
        squirtle[4][5] = 8'b10001000;  
        squirtle[4][6] = 8'b10000100;  
        squirtle[4][7] = 8'b00000000; 
        
        squirtle[5][0] = 8'b11111110;  
        squirtle[5][1] = 8'b00010000;  
        squirtle[5][2] = 8'b00010000;  
        squirtle[5][3] = 8'b00010000;  
        squirtle[5][4] = 8'b00010000;  
        squirtle[5][5] = 8'b00010000;  
        squirtle[5][6] = 8'b00010000;  
        squirtle[5][7] = 8'b00000000;
        
        squirtle[6][0] = 8'b10000000;    
        squirtle[6][1] = 8'b10000000;    
        squirtle[6][2] = 8'b10000000;    
        squirtle[6][3] = 8'b10000000;   
        squirtle[6][4] = 8'b10000000;   
        squirtle[6][5] = 8'b10000000;    
        squirtle[6][6] = 8'b11111100;  
        squirtle[6][7] = 8'b00000000;
        
        squirtle[7][0] = 8'b11111110;    
        squirtle[7][1] = 8'b10000000;    
        squirtle[7][2] = 8'b10000000;    
        squirtle[7][3] = 8'b11110000;    
        squirtle[7][4] = 8'b10000000;       
        squirtle[7][5] = 8'b10000000;      
        squirtle[7][6] = 8'b11111110;  
        squirtle[7][7] = 8'b00000000;
        
        charmander[0][0] = 8'b01111100; 
        charmander[0][1] = 8'b10000000;
        charmander[0][2] = 8'b10000000; 
        charmander[0][3] = 8'b10000000;
        charmander[0][4] = 8'b10000000; 
        charmander[0][5] = 8'b10000000;
        charmander[0][6] = 8'b01111100; 
        charmander[0][7] = 8'b00000000; 

        charmander[1][0] = 8'b10000010; 
        charmander[1][1] = 8'b10000010;
        charmander[1][2] = 8'b10000010; 
        charmander[1][3] = 8'b11111110;
        charmander[1][4] = 8'b10000010; 
        charmander[1][5] = 8'b10000010;
        charmander[1][6] = 8'b10000010; 
        charmander[1][7] = 8'b00000000; 
        
        charmander[2][0] = 8'b00110000;  
        charmander[2][1] = 8'b01001000;    
        charmander[2][2] = 8'b10000100;    
        charmander[2][3] = 8'b11111100;    
        charmander[2][4] = 8'b10000100;       
        charmander[2][5] = 8'b10000100;      
        charmander[2][6] = 8'b10000100;  
        charmander[2][7] = 8'b00000000; 
        
        charmander[3][0] = 8'b11111100;  
        charmander[3][1] = 8'b10000010;  
        charmander[3][2] = 8'b10000010;  
        charmander[3][3] = 8'b11111100;  
        charmander[3][4] = 8'b10010000;  
        charmander[3][5] = 8'b10001000;  
        charmander[3][6] = 8'b10000100;  
        charmander[3][7] = 8'b00000000; 
        
        charmander[4][0] = 8'b11000110;    
        charmander[4][1] = 8'b10101010;   
        charmander[4][2] = 8'b10010010;    
        charmander[4][3] = 8'b11000010;    
        charmander[4][4] = 8'b10000010;       
        charmander[4][5] = 8'b10000010;      
        charmander[4][6] = 8'b10000010;     
        charmander[4][7] = 8'b00000000;  
        
       charmander[5][0] = 8'b11111110;    
       charmander[5][1] = 8'b10000010;    
       charmander[5][2] = 8'b10000010;    
       charmander[5][3] = 8'b11111110;    
       charmander[5][4] = 8'b10000010;       
       charmander[5][5] = 8'b10000010;      
       charmander[5][6] = 8'b10000010;  
       charmander[5][7] = 8'b00000000;
        
       charmander[6][0] = 8'b11000010;    
       charmander[6][1] = 8'b10100010;    
       charmander[6][2] = 8'b10100010;    
       charmander[6][3] = 8'b10010010;    
       charmander[6][4] = 8'b10001010;       
       charmander[6][5] = 8'b10000110;      
       charmander[6][6] = 8'b10000010;  
       charmander[6][7] = 8'b00000000;
       
       charmander[7][0] = 8'b11111100;    
       charmander[7][1] = 8'b10000010;    
       charmander[7][2] = 8'b10000010;    
       charmander[7][3] = 8'b00000010;    
       charmander[7][4] = 8'b10000010;       
       charmander[7][5] = 8'b10000010;      
       charmander[7][6] = 8'b11111100;   
       charmander[7][7] = 8'b00000000; 
       
       charmander[8][0] = 8'b11111110;    
       charmander[8][1] = 8'b10000000;    
       charmander[8][2] = 8'b10000000;    
       charmander[8][3] = 8'b11111000;    
       charmander[8][4] = 8'b10000000;       
       charmander[8][5] = 8'b10000000;      
       charmander[8][6] = 8'b11111110;  
       charmander[8][7] = 8'b00000000;  
       
       charmander[9][0] = 8'b11111100;    
       charmander[9][1] = 8'b10000010;    
       charmander[9][2] = 8'b10000010;    
       charmander[9][3] = 8'b11111100;    
       charmander[9][4] = 8'b10010000;       
       charmander[9][5] = 8'b10001000;      
       charmander[9][6] = 8'b10000100;   
       charmander[9][7] = 8'b00000000; 
       
        bulbasaur[0][0] = 8'b11111110; 
        bulbasaur[0][1] = 8'b10000010;
        bulbasaur[0][2] = 8'b10000010;
        bulbasaur[0][3] = 8'b11111100;
        bulbasaur[0][4] = 8'b10000010;
        bulbasaur[0][5] = 8'b10000010;
        bulbasaur[0][6] = 8'b11111100; 
        bulbasaur[0][7] = 8'b00000000; 

        bulbasaur[1][0] = 8'b10000010; 
        bulbasaur[1][1] = 8'b10000010;
        bulbasaur[1][2] = 8'b10000010; 
        bulbasaur[1][3] = 8'b10000010;
        bulbasaur[1][4] = 8'b10000010; 
        bulbasaur[1][5] = 8'b10000010;
        bulbasaur[1][6] = 8'b11111110; 
        bulbasaur[1][7] = 8'b00000000; 
        
        bulbasaur[2][0] = 8'b10000000;
        bulbasaur[2][1] = 8'b10000000;    
        bulbasaur[2][2] = 8'b10000000;    
        bulbasaur[2][3] = 8'b10000000;   
        bulbasaur[2][4] = 8'b10000000;   
        bulbasaur[2][5] = 8'b10000000;    
        bulbasaur[2][6] = 8'b11111110;  
        bulbasaur[2][7] = 8'b00000000;  
        
        bulbasaur[3][0] = 8'b11111110; 
        bulbasaur[3][1] = 8'b10000010;
        bulbasaur[3][2] = 8'b10000010;
        bulbasaur[3][3] = 8'b11111100;
        bulbasaur[3][4] = 8'b10000010;
        bulbasaur[3][5] = 8'b10000010;
        bulbasaur[3][6] = 8'b11111100; 
        bulbasaur[3][7] = 8'b00000000; 
        
        bulbasaur[4][0] = 8'b11111110;  
        bulbasaur[4][1] = 8'b10000010;    
        bulbasaur[4][2] = 8'b10000010;    
        bulbasaur[4][3] = 8'b11111110;    
        bulbasaur[4][4] = 8'b10000010;       
        bulbasaur[4][5] = 8'b10000010;      
        bulbasaur[4][6] = 8'b10000010;  
        bulbasaur[4][7] = 8'b00000000;  
        
        bulbasaur[5][0] = 8'b01111000; 
        bulbasaur[5][1] = 8'b10000100; 
        bulbasaur[5][2] = 8'b10000000; 
        bulbasaur[5][3] = 8'b01111000; 
        bulbasaur[5][4] = 8'b00000100; 
        bulbasaur[5][5] = 8'b10000100; 
        bulbasaur[5][6] = 8'b01111000; 
        bulbasaur[5][7] = 8'b00000000; 
        
        bulbasaur[6][0] = 8'b11111110;    
        bulbasaur[6][1] = 8'b10000010;    
        bulbasaur[6][2] = 8'b10000010;    
        bulbasaur[6][3] = 8'b11111110;    
        bulbasaur[6][4] = 8'b10000010;       
        bulbasaur[6][5] = 8'b10000010;      
        bulbasaur[6][6] = 8'b10000010;  
        bulbasaur[6][7] = 8'b00000000;  
                
        bulbasaur[7][0] = 8'b10000010; 
        bulbasaur[7][1] = 8'b10000010;
        bulbasaur[7][2] = 8'b10000010; 
        bulbasaur[7][3] = 8'b10000010;
        bulbasaur[7][4] = 8'b10000010; 
        bulbasaur[7][5] = 8'b10000010;
        bulbasaur[7][6] = 8'b11111110; 
        bulbasaur[7][7] = 8'b00000000; 
                        
       bulbasaur[8][0] = 8'b11111100;    
       bulbasaur[8][1] = 8'b10000010;    
       bulbasaur[8][2] = 8'b10000010;    
       bulbasaur[8][3] = 8'b11111100;    
       bulbasaur[8][4] = 8'b10010000;       
       bulbasaur[8][5] = 8'b10001000;      
       bulbasaur[8][6] = 8'b10000100;   
       bulbasaur[8][7] = 8'b00000000;      
    end

    always @(posedge clk) begin
        pixel_data = 16'h0000;
        if (y >= 0 && y < 8 && x >= 20 && x < (20 + 7 * 8)) begin
                if (player2_text[(x - 20) / 8][y] & (1 << (7 - ((x - 20) % 8))))
                    pixel_data = 16'b11111_000000_00000; 
            end
        if ((y == 17 || y == 28) && (x >= 14 && x < (16 + 8 * 8 + 2)) ||
            (x == 14 || x == (16 + 8 * 8 + 1)) && (y >= 17 && y <= 28)) begin
            if (btnState == 2'b00) pixel_data = 16'b00000_000000_11111;
            else pixel_data = 16'hffff;
        end
        
        else if (y >= 20 && y < 28 && x >= 16 && x < (16 + 8 * 8)) begin
            if (squirtle[(x - 16) / 8][(y - 20)] & (1 << (7 - ((x - 16) % 8))))
                pixel_data = 16'hffff;
        end
    
        else if ((y == 35 || y == 46) && (x >= 6 && x < (8 + 10 * 8 + 2)) ||
                 (x == 6 || x == (8 + 10 * 8 + 1)) && (y >= 35 && y <= 46) ) begin
            if (btnState == 'b01) pixel_data = 16'b11111_000000_00000; 
            else pixel_data = 16'hffff;
        end
    
        else if (y >= 38 && y < 46 && x >= 8 && x < (8 + 10 * 8)) begin
            if (charmander[(x - 8) / 8][(y - 38)] & (1 << (7 - ((x - 8) % 8))))
                pixel_data = 16'hffff;
        end
        
        else if ((y == 53 || y == 62) && (x >= 10 && x < (12 + 9 * 8 + 2))||
                   (x == 10 || x == (12 + 9 * 8 + 1)) && (y >= 53 && y <= 62) ) begin
            if (btnState==2'b10) pixel_data = 16'b00000_111111_00000; 
           else pixel_data = 16'hffff; 
        end
    
        else if (y >= 54 && y < 62 && x >= 12 && x < (12 + 9 * 8)) begin
            if (bulbasaur[(x - 12) / 8][(y - 54)] & (1 << (7 - ((x - 12) % 8))))
                pixel_data = 16'hffff;
        end
    end

endmodule
