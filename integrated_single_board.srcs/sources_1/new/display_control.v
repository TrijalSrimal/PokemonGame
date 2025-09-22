`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 11:04:48
// Design Name: 
// Module Name: display_control
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


module display_control(input clk, btnU, btnD, btnL, btnR, btnC, plyrIndex, currPlyr, 
                       game_start, input [1:0] pokemon, input [3:0] SP, input [6:0] x, y, 
                       output reg [15:0] pixel_data, output reg [2:0] skill = 0, 
                       output reg reset = 0, endTurn = 0, output reg valid_states, 
                       output reg [4:0] state = 0,
                       input end_animation);

    reg [50:0] skill_a [0:4];
    reg [50:0] skill_a_enlarged [0:6];
    reg [50:0] skill_b [0:4];
    reg [50:0] skill_b_enlarged [0:6];
    reg [22:0] heal [0:4];
    reg [22:0] heal_enlarged [0:6];
    reg [22:0] pass [0:4];
    reg [22:0] pass_enlarged [0:6];
    reg [4:0] pause;
    reg [7:0] pause_enlarged;
    reg [30:0] confirm [0:4];
    reg [6:0] tick [0:4];
    reg [4:0] cross [0:2];
    reg [14:0] resume_icon [0:7];
    reg [10:0] restart_icon [0:7];
    reg [24:0] resume [0:4];
    reg [26:0] restart [0:4];
    reg [40:0] restart_enlarged [0:6];
    reg [49:0] no_sp [0:6];
    reg [38:0] timeout [0:6];
    reg [14:0] info_icon [0:7];
    reg [55:0] guide [0:4];
    reg [81:0] type_adv [0:4];
    reg [20:0] fire [0:6];
    reg [28:0] grass [0:6];
    reg [28:0] water [0:6];
    reg [7:0] arrow_R [0:4];
    reg [4:0] arrow_U [0:5];
    reg [4:0] arrow_D [0:5];
    reg [4:0] down_btn [0:2];
    reg [8:0] down_btn_enlarged [0:4];
    reg [2:0] cancel [0:1];
    reg [4:0] cancel_enlarged [0:2];
    reg [18:0] stats [0:4];
    reg [66:0] time_per_turn [0:4];
    reg [62:0] basic [0:4];
    reg [80:0] special [0:4];
    reg [52:0] heal_stats [0:4];
    reg [4:0] up_btn [0:2];
    reg [8:0] up_btn_enlarged [0:4];
    
    initial begin                
        skill_a[0] = {23'b11100100011010101000111, 28'b0};
        skill_a[1] = {23'b01001010100011001000100, 28'b0};
        skill_a[2] = {23'b01001110100011001000111, 28'b0};
        skill_a[3] = {23'b01001010100010101000100, 28'b0};
        skill_a[4] = {23'b01001010011010101110111, 28'b0};
        
        skill_a_enlarged[0] = {35'b11111000100001110010001010000011111, 16'b0};
        skill_a_enlarged[1] = {35'b10101001010010001010010010000010000, 16'b0};
        skill_a_enlarged[2] = {35'b00100010001010000010100010000010000, 16'b0};
        skill_a_enlarged[3] = {35'b00100010001010000011000010000011110, 16'b0};
        skill_a_enlarged[4] = {35'b00100011111010000010100010000010000, 16'b0}; 
        skill_a_enlarged[5] = {35'b00100010001010001010010010000010000, 16'b0};
        skill_a_enlarged[6] = {35'b00100010001001110010001011111011111, 16'b0};
    
        heal[0] = {15'b101011100100100, 8'b0};
        heal[1] = {15'b101010001010100, 8'b0};
        heal[2] = {15'b111011101110100, 8'b0};
        heal[3] = {15'b101010001010100, 8'b0};
        heal[4] = {15'b101011101010111, 8'b0};
    
        heal_enlarged[0] = 23'b10001011111000100010000;
        heal_enlarged[1] = 23'b10001010000001010010000;
        heal_enlarged[2] = 23'b10001010000010001010000;
        heal_enlarged[3] = 23'b11111011110010001010000;
        heal_enlarged[4] = 23'b10001010000011111010000;
        heal_enlarged[5] = 23'b10001010000010001010000;
        heal_enlarged[6] = 23'b10001011111010001011111;
            
        pass[0] = {15'b110001000110011, 8'b0};
        pass[1] = {15'b101010101000100, 8'b0};
        pass[2] = {15'b110011100100010, 8'b0};
        pass[3] = {15'b100010100010001, 8'b0};
        pass[4] = {15'b100010101100110, 8'b0};
        
        pass_enlarged[0] = 23'b11110000100001110001110;
        pass_enlarged[1] = 23'b10001001010010001010001;
        pass_enlarged[2] = 23'b10001010001010000010000;
        pass_enlarged[3] = 23'b11110010001001110001110;
        pass_enlarged[4] = 23'b10000011111000001000001;
        pass_enlarged[5] = 23'b10000010001010001010001;
        pass_enlarged[6] = 23'b10000010001001110001110;

        pause = 5'b11011;
        pause_enlarged = 8'b11100111;
        
        confirm[0] = 31'b0110011001001011101110110010001;
        confirm[1] = 31'b1000100101101010000100101011011;
        confirm[2] = 31'b1000100101011011000100110010101;
        confirm[3] = 31'b1000100101001010000100101010101;
        confirm[4] = 31'b0110011001001010001110101010001;
        
        tick[0] = 7'b0000001;
        tick[1] = 7'b0000010;
        tick[2] = 7'b1000100;
        tick[3] = 7'b0101000;
        tick[4] = 7'b0010000;
        
        cross[0] = 5'b10001;
        cross[1] = 5'b01010;
        cross[2] = 5'b00100;
        
        resume_icon[0] = 15'b110000000000000;
        resume_icon[1] = 15'b111000000000000;
        resume_icon[2] = 15'b100110000000000;
        resume_icon[3] = 15'b100001100000000;
        resume_icon[4] = 15'b100000011000000;
        resume_icon[5] = 15'b100000000110000;
        resume_icon[6] = 15'b100000000001100;
        resume_icon[7] = 15'b100000000000011;
        
        restart_icon[0] = 11'b00011001111;
        restart_icon[1] = 11'b00100001110;
        restart_icon[2] = 11'b01000001110;
        restart_icon[3] = 11'b10000001001;
        restart_icon[4] = 11'b10000000001;
        restart_icon[5] = 11'b01000000010;
        restart_icon[6] = 11'b00100000100;
        restart_icon[7] = 11'b00011111000;
        
        resume[0] = 25'b1100111001101010100010111;
        resume[1] = 25'b1010100010001010110110100;
        resume[2] = 25'b1100111001001010101010111;
        resume[3] = 25'b1010100000101010101010100;
        resume[4] = 25'b1010111011000100100010111;
        
        restart[0] = 27'b110011100110111001001100111;
        restart[1] = 27'b101010001000010010101010010;
        restart[2] = 27'b110011100100010011101100010;
        restart[3] = 27'b101010000010010010101010010;
        restart[4] = 27'b101011101100010010101010010;
        
        restart_enlarged[0] = 41'b11110011111001110011111000100011110011111;
        restart_enlarged[1] = 41'b10001010000010001010101001010010001010101;
        restart_enlarged[2] = 41'b10001010000010000000100010001010001000100;
        restart_enlarged[3] = 41'b11110011110001110000100010001011110000100;
        restart_enlarged[4] = 41'b10100010000000001000100011111010100000100;
        restart_enlarged[5] = 41'b10010010000010001000100010001010010000100;
        restart_enlarged[6] = 41'b10001011111001110000100010001010001000100;
        
        no_sp[0] = 50'b01110011110000010001011111011111011110011111011110;
        no_sp[1] = 50'b10001010001000010001010000010000010001010000010001;
        no_sp[2] = 50'b10000010001000011001010000010000010001010000010001;
        no_sp[3] = 50'b01110011110000010101011110011110010001011110010001;
        no_sp[4] = 50'b00001010000000010011010000010000010001010000010001;
        no_sp[5] = 50'b10001010000000010001010000010000010001010000010001;
        no_sp[6] = 50'b01110010000000010001011111011111011110011111011110;
        
        timeout[0] = 39'b111110111010001011111001110010001011111;
        timeout[1] = 39'b101010010011011010000010001010001010101;
        timeout[2] = 39'b001000010010101010000010001010001000100;
        timeout[3] = 39'b001000010010101011110010001010001000100;
        timeout[4] = 39'b001000010010101010000010001010001000100;
        timeout[5] = 39'b001000010010001010000010001010001000100;
        timeout[6] = 39'b001000111010001011111001110001110000100;
        
        info_icon[0] = 15'b000001111100000;
        info_icon[1] = 15'b000110000011000;
        info_icon[2] = 15'b001000000000100;
        info_icon[3] = 15'b010000110000010;
        info_icon[4] = 15'b100000000000001;
        info_icon[5] = 15'b100000111000001;
        info_icon[6] = 15'b100000110000001;
        info_icon[7] = 15'b010000111000010;
        
        guide[0] = 56'b11101100010011101001011101100100110000110101011101100111;
        guide[1] = 56'b01001010101001001101010001010101000001000101001001010100;
        guide[2] = 56'b01001100111001001011011101100000100001010101001001010111;
        guide[3] = 56'b01001010101001001001010001010000010001010101001001010100;
        guide[4] = 56'b01001010101011101001011101010001100000100010011101100111;
        
        type_adv[0] = 82'b1110101011001110000100110010100100100101110010001101110000000000110001100100010011;
        type_adv[1] = 82'b0100101010101000001010101010101010110100100101010001000100001000010001010110110100;
        type_adv[2] = 82'b0100010011001110001110101010101110101100100111010101110000011100010001010101010101;
        type_adv[3] = 82'b0100010010001000001010101001001010100100100101010101000100001000010001010101010101;
        type_adv[4] = 82'b0100010010001110001010110001001010100100100101001001110000000000111001100100010010;
        
        fire[0] = 21'b111110111011110011111;
        fire[1] = 21'b100000010010001010000;
        fire[2] = 21'b100000010010001010000;
        fire[3] = 21'b111100010011110011110;
        fire[4] = 21'b100000010010100010000;
        fire[5] = 21'b100000010010010010000;
        fire[6] = 21'b100000111010001011111;
        
        grass[0] = 29'b01111011110000100001110001110;
        grass[1] = 29'b10001010001001010010001010001;
        grass[2] = 29'b10000010001010001010000010000;
        grass[3] = 29'b10000011110010001001110001110;
        grass[4] = 29'b10011010100011111000001000001;
        grass[5] = 29'b10001010010010001010001010001;
        grass[6] = 29'b01111010001010001001110001110;
        
        water[0] = 29'b10001000100011111011111011110;
        water[1] = 29'b10001001010010101010000010001;
        water[2] = 29'b10001010001000100010000010001;
        water[3] = 29'b10101010001000100011110011110;
        water[4] = 29'b10101011111000100010000010100;
        water[5] = 29'b10101010001000100010000010010;
        water[6] = 29'b01010010001000100011111010001;
        
        arrow_R[0] = 8'b00011000;
        arrow_R[1] = 8'b01111101;
        arrow_R[2] = 8'b10001111;
        arrow_R[3] = 8'b00000111;
        arrow_R[4] = 8'b00001111;
        
        arrow_U[0] = 5'b01111;
        arrow_U[1] = 5'b00111;
        arrow_U[2] = 5'b11101;
        arrow_U[3] = 5'b11000;
        arrow_U[4] = 5'b01000;
        arrow_U[5] = 5'b00100;
        
        arrow_D[0] = 5'b00100;
        arrow_D[1] = 5'b00010;
        arrow_D[2] = 5'b00011;
        arrow_D[3] = 5'b10111;
        arrow_D[4] = 5'b11110;
        arrow_D[5] = 5'b11100;
        
        down_btn[0] = 5'b11111;
        down_btn[1] = 5'b01110;
        down_btn[2] = 5'b00100;
        
        down_btn_enlarged[0] = 9'b111111111;
        down_btn_enlarged[1] = 9'b011111110;
        down_btn_enlarged[2] = 9'b001111100;
        down_btn_enlarged[3] = 9'b000111000;
        down_btn_enlarged[4] = 9'b000010000;
        
        cancel[0] = 3'b101;
        cancel[1] = 3'b010;
        
        cancel_enlarged[0] = 5'b10001;
        cancel_enlarged[1] = 5'b01010;
        cancel_enlarged[2] = 5'b00100;
        
        stats[0] = 19'b0110111001001110011;
        stats[1] = 19'b1000010010100100100;
        stats[2] = 19'b0100010011100100010;
        stats[3] = 19'b0010010010100100001;
        stats[4] = 19'b1100010010100100110;
        
        time_per_turn[0] = 67'b1110111010001011100011001110110000111010101100100100000110011100011;
        time_per_turn[1] = 67'b0100010011011010000010101000101000010010101010110101000010010100100;
        time_per_turn[2] = 67'b0100010010101011100011001110110000010010101100101100000010010100010;
        time_per_turn[3] = 67'b0100010010101010000010001000101000010010101010100101000010010100001;
        time_per_turn[4] = 67'b0100111010001011100010001110101000010001001010100100000111011100110; 
        
        basic[0] = 63'b110001000110111001100000110001100100010011000000100110000110110;
        basic[1] = 63'b101010101000010010001000010001010110110100000001000010001000101;
        basic[2] = 63'b110011100100010010000000010001010101010101000010000010000100110;
        basic[3] = 63'b101010100010010010001000010001010101010101000100000010000010100;
        basic[4] = 63'b110010101100111001100000111001100100010010001000000111001100100;
        
        special[0] = 81'b011011001110011011100100100000001110000100111001100100010011000000100111000110110;
        special[1] = 81'b100010101000100001001010100010000010000100001001010110110100000001000001001000101;
        special[2] = 81'b010011001110100001001110100000001110001000111001010101010101000010000111000100110;
        special[3] = 81'b001010001000100001001010100010001000010000001001010101010101000100000100000010100;
        special[4] = 81'b110010001110011011101010111000001110010000111001100100010010001000000111001100100;
        
        heal_stats[0] = 53'b10101110010010000000111001010110000000100111000110110;
        heal_stats[1] = 53'b10101000101010001000100001010101000001000100001000101;
        heal_stats[2] = 53'b11101110111010000000111001110110000010000111000100110;
        heal_stats[3] = 53'b10101000101010001000001001010100000100000001000010100;
        heal_stats[4] = 53'b10101110101011100000111001010100001000000111001100100;
        
        up_btn[0] = 5'b00100;
        up_btn[1] = 5'b01110;
        up_btn[2] = 5'b11111;
        
        up_btn_enlarged[0] = 9'b000010000;
        up_btn_enlarged[1] = 9'b000111000;
        up_btn_enlarged[2] = 9'b001111100;
        up_btn_enlarged[3] = 9'b011111110;
        up_btn_enlarged[4] = 9'b111111111;
    end
    
    localparam [1:0] SQUIRTLE = 2'b00, CHARMANDER = 2'b01, BULBASAUR = 2'b10;
    
    always @ (*) begin
        case (pokemon)
            SQUIRTLE: 
            begin
                skill_b[0] = {36'b100010010011101110110000011010101001, 15'b0};
                skill_b[1] = {36'b100010101001001000101000100010101101, 15'b0};
                skill_b[2] = {36'b101010111001001110110000101010101011, 15'b0};
                skill_b[3] = {36'b101010101001001000101000101010101001, 15'b0};
                skill_b[4] = {36'b010100101001001110101000010001001001, 15'b0};
                
                skill_b_enlarged[0] = 51'b100010001000111110111110111100000001111010001010001;
                skill_b_enlarged[1] = 51'b100010010100101010100000100010000010001010001010001;
                skill_b_enlarged[2] = 51'b100010100010001000100000100010000010000010001011001;
                skill_b_enlarged[3] = 51'b101010100010001000111100111100000010000010001010101;
                skill_b_enlarged[4] = 51'b101010111110001000100000101000000010011010001010011;
                skill_b_enlarged[5] = 51'b101010100010001000100000100100000010001010001010001;
                skill_b_enlarged[6] = 51'b010100100010001000111110100010000001111001110010001;               
            end
            
            CHARMANDER:
            begin
                skill_b[0] = {21'b111010001011001110110, 30'b0};
                skill_b[1] = {21'b100011011010101000101, 30'b0};
                skill_b[2] = {21'b111010101011001110110, 30'b0};
                skill_b[3] = {21'b100010101010101000101, 30'b0};
                skill_b[4] = {21'b111010001011001110101, 30'b0};  
                
                skill_b_enlarged[0] = {29'b11111010001011110011111011110, 22'b0};
                skill_b_enlarged[1] = {29'b10000011011010001010000010001, 22'b0};
                skill_b_enlarged[2] = {29'b10000010101010001010000010001, 22'b0};
                skill_b_enlarged[3] = {29'b11110010101011110011110011110, 22'b0};
                skill_b_enlarged[4] = {29'b10000010101010001010000010100, 22'b0};
                skill_b_enlarged[5] = {29'b10000010001010001010000010010, 22'b0};
                skill_b_enlarged[6] = {29'b11111010001011110011111010001, 22'b0};                                         
            end
            
            BULBASAUR:
            begin
                skill_b[0] = {32'b10101010010111000100010101010110, 19'b0};
                skill_b[1] = {32'b10101011010100000100010101010101, 19'b0};
                skill_b[2] = {32'b10101010110111000101010111010110, 19'b0};
                skill_b[3] = {32'b01001010010100000101010101010100, 19'b0};
                skill_b[4] = {32'b01001010010111000010100101010100, 19'b0};
                
                skill_b_enlarged[0] = 51'b100010011100100010111110000010001010001001110011110;
                skill_b_enlarged[1] = 51'b100010001000100010100000000010001010001000100010001;
                skill_b_enlarged[2] = 51'b100010001000110010100000000010001010001000100010001;
                skill_b_enlarged[3] = 51'b100010001000101010111100000010101011111000100011110;
                skill_b_enlarged[4] = 51'b100010001000100110100000000010101010001000100010000;
                skill_b_enlarged[5] = 51'b010100001000100010100000000010101010001000100010000;
                skill_b_enlarged[6] = 51'b001000011100100010111110000001010010001001110010000;                                          
            end
        endcase
    end
    
    localparam [6:0] x_left = 7, x_right = 65, y_pos = 45;
    localparam [5:0] left_len = 50, right_len = 22;         
    
    localparam [4:0] idle = 5'b00000, selectA = 5'b00001, selectB = 5'b00010, selectH = 5'b00011, selectP = 5'b00100, 
    selectPause = 5'b00101, confirmScreen = 5'b00110, selectYes = 5'b00111, selectNo = 5'b01000, pauseScreen = 5'b01001, 
    selectInfo = 5'b01010, selectResume = 5'b01011, selectRestart = 5'b01100, confirmRestart = 5'b01101, noSP = 5'b01110, 
    confirmNoSP = 5'b01111, noTime = 5'b10000, info1 = 5'b10001, info2 = 5'b10010, selectDown = 5'b10011, selectUp = 5'b10100, 
    selectCancel = 5'b10101;
        
    reg [5:0] prev_state = {1'b0, idle};
    reg [31:0] count = 32'b0;
    
    localparam SP_FOR_TACKLE = 1;
    localparam SP_FOR_SPECIAL = 2;
    localparam SP_FOR_HEAL = 5;
    
    always @ (posedge clk)
    begin
        if ((currPlyr == plyrIndex) && (state == idle || state == selectA || state == selectB || state == selectH || 
             state == selectP || state == noTime || state == selectPause)) begin 
            
            count <= (end_animation==0 && endTurn==1)? count : count + 1;
            
            valid_states <= 1;
            if (count == 999999999) begin
                state = noTime;
                skill = 3'b100;
                count = 0;
            end
                        
            else if (end_animation == 1) begin
                endTurn <= 1;
                
            end
            else skill=0;
        end
        else valid_states <= 0;
        
        pixel_data = 0;
        if (game_start == 0 || (endTurn == 1 && currPlyr != plyrIndex) || reset == 1) begin
            endTurn = 0;
            skill = 0;
            state = idle;
            count <= 0;
        end
        
        if (currPlyr == plyrIndex) begin
            case (state)
                idle:
                begin     
                    if (x > 89 && x <= 94 && y >= 3 && y <= 8) begin
                        pixel_data = pause[4 - (x - 90)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = skill_a[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = skill_b[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = heal[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = pass[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass[4][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    reset <= 0;
                    if(!endTurn) state <= btnU ? selectB : (btnD ? selectA : ((btnL || btnR) ? selectH : state));
                end
                
                selectA:
                begin
                    if (x > 89 && x <= 94 && y >= 3 && y <= 8) begin
                        pixel_data = pause[4 - (x - 90)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos - 2 && y <= y_pos + 13) begin
                        case(y)
                            43: pixel_data = skill_a_enlarged[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            44: pixel_data = skill_a_enlarged[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            45: pixel_data = skill_a_enlarged[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a_enlarged[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a_enlarged[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a_enlarged[5][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a_enlarged[6][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = skill_b[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = heal[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = pass[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass[4][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    state <= btnC ? (SP >= SP_FOR_TACKLE ? confirmScreen : noSP) : ((btnU || btnD) ? selectB : ((btnL || btnR) ? selectH : state));
                    prev_state <= {1'b0, state};
                end
                
                selectB:
                begin
                    if (x > 89 && x <= 94 && y >= 3 && y <= 8) begin
                        pixel_data = pause[4 - (x - 90)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos && y <= y_pos + 15) begin
                        case(y)
                            45: pixel_data = skill_a[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = skill_b_enlarged[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b_enlarged[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b_enlarged[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b_enlarged[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b_enlarged[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            59: pixel_data = skill_b_enlarged[5][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            60: pixel_data = skill_b_enlarged[6][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = heal[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = pass[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass[4][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    state <= btnC ? (SP >= SP_FOR_SPECIAL ? confirmScreen : noSP) : ((btnU || btnD) ? selectA : ((btnL || btnR) ? selectP : state));
                    prev_state <= {1'b0, state};
                end
                
                selectH:
                begin
                    if (x > 89 && x <= 94 && y >= 3 && y <= 8) begin
                        pixel_data = pause[4 - (x - 90)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = skill_a[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
        
                            54: pixel_data = skill_b[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos - 2 && y <= y_pos + 13) begin
                        case(y)
                            43: pixel_data = heal_enlarged[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            44: pixel_data = heal_enlarged[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            45: pixel_data = heal_enlarged[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal_enlarged[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal_enlarged[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal_enlarged[5][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal_enlarged[6][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
        
                            54: pixel_data = pass[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass[4][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    state <= btnC ? (SP >= SP_FOR_HEAL ? confirmScreen : noSP) : (btnU ? selectPause : (btnD ? selectP : ((btnL || btnR) ? selectA : state)));
                    prev_state <= {1'b0, state};
                end
                
                selectP:
                begin
                    if (x > 89 && x <= 94 && y >= 3 && y <= 8) begin
                        pixel_data = pause[4 - (x - 90)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = skill_a[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = skill_b[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos && y <= y_pos + 15) begin
                        case(y)
                            45: pixel_data = heal[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = pass_enlarged[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass_enlarged[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass_enlarged[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass_enlarged[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass_enlarged[4][right_len - (x - x_right)] ? 16'hffff : 0;
                            59: pixel_data = pass_enlarged[5][right_len - (x - x_right)] ? 16'hffff : 0;
                            60: pixel_data = pass_enlarged[6][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    state <= btnC ? confirmScreen : (btnU ? selectH : (btnD ? selectPause : ((btnL || btnR) ? selectB : state)));
                    prev_state <= {1'b0, state};
                end
                
                selectPause:
                begin
                    if (x > 86 && x <= 94 && y >= 3 && y <= 10) begin
                        pixel_data = pause_enlarged[7 - (x - 87)] ? 16'hffff : 0;
                    end
                    else if (x >= x_left && x <= x_left + left_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = skill_a[0][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = skill_a[1][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = skill_a[2][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = skill_a[3][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = skill_a[4][left_len - (x - x_left)] ? (SP >= SP_FOR_TACKLE ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = skill_b[0][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            55: pixel_data = skill_b[1][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            56: pixel_data = skill_b[2][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            57: pixel_data = skill_b[3][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                            58: pixel_data = skill_b[4][left_len - (x - x_left)] ? (SP >= SP_FOR_SPECIAL ? 16'hffff : 16'h2084) : 0;
                        endcase
                    end
                    else if (x >= x_right && x <= x_right + right_len && y >= y_pos && y <= y_pos + 13) begin
                        case(y)
                            45: pixel_data = heal[0][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            46: pixel_data = heal[1][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            47: pixel_data = heal[2][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            48: pixel_data = heal[3][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
                            49: pixel_data = heal[4][right_len - (x - x_right)] ? (SP >= SP_FOR_HEAL ? 16'hffff : 16'h2084) : 0;
    
                            54: pixel_data = pass[0][right_len - (x - x_right)] ? 16'hffff : 0;
                            55: pixel_data = pass[1][right_len - (x - x_right)] ? 16'hffff : 0;
                            56: pixel_data = pass[2][right_len - (x - x_right)] ? 16'hffff : 0;
                            57: pixel_data = pass[3][right_len - (x - x_right)] ? 16'hffff : 0;
                            58: pixel_data = pass[4][right_len - (x - x_right)] ? 16'hffff : 0;
                        endcase
                    end
                    state <= btnC ? pauseScreen : (btnU ? selectP : (btnD ? selectH : ((btnL || btnR) ? selectA : state)));
                end
                
                confirmScreen:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 21 && x <= 51 && y >= 15 && y <= 19) begin
                        case (y)
                            15: pixel_data = confirm[0][30 - (x - 21)] ? 0 : 16'hffff;
                            16: pixel_data = confirm[1][30 - (x - 21)] ? 0 : 16'hffff;
                            17: pixel_data = confirm[2][30 - (x - 21)] ? 0 : 16'hffff;
                            18: pixel_data = confirm[3][30 - (x - 21)] ? 0 : 16'hffff;
                            19: pixel_data = confirm[4][30 - (x - 21)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (prev_state[5] == 1) begin
                        if (x >= 21 && x <= 61 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = restart_enlarged[0][40 - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = restart_enlarged[1][40 - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = restart_enlarged[2][40 - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = restart_enlarged[3][40 - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = restart_enlarged[4][40 - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = restart_enlarged[5][40 - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = restart_enlarged[6][40 - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectA) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_a_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_a_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_a_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_a_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_a_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_a_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_a_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectB) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_b_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_b_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_b_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_b_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_b_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_b_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_b_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectH) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = heal_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = heal_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = heal_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = heal_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = heal_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = heal_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = heal_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectP) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = pass_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = pass_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = pass_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = pass_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = pass_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = pass_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = pass_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    
                    if (x >= 28 && x <= 34 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = tick[0][6 - (x - 28)] ? 0 : 16'hffff;
                            40: pixel_data = tick[1][6 - (x - 28)] ? 0 : 16'hffff;
                            41: pixel_data = tick[2][6 - (x - 28)] ? 0 : 16'hffff;
                            42: pixel_data = tick[3][6 - (x - 28)] ? 0 : 16'hffff;
                            43: pixel_data = tick[4][6 - (x - 28)] ? 0 : 16'hffff;
                        endcase
                    end
                   
                    if (x >= 62 && x <= 66 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                            40: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            41: pixel_data = cross[2][4 - (x - 62)] ? 0 : 16'hffff;
                            42: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            43: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= (btnU || btnD || btnL || btnR) ? selectYes : state;
                end
                
                selectYes:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 35 || y == 47) && x >= 25 && x <= 37) || ((x == 25 || x == 37) && y >= 35 && y <= 47)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 21 && x <= 51 && y >= 15 && y <= 19) begin
                        case (y)
                            15: pixel_data = confirm[0][30 - (x - 21)] ? 0 : 16'hffff;
                            16: pixel_data = confirm[1][30 - (x - 21)] ? 0 : 16'hffff;
                            17: pixel_data = confirm[2][30 - (x - 21)] ? 0 : 16'hffff;
                            18: pixel_data = confirm[3][30 - (x - 21)] ? 0 : 16'hffff;
                            19: pixel_data = confirm[4][30 - (x - 21)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (prev_state[5] == 1) begin
                        if (x >= 21 && x <= 61 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = restart_enlarged[0][40 - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = restart_enlarged[1][40 - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = restart_enlarged[2][40 - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = restart_enlarged[3][40 - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = restart_enlarged[4][40 - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = restart_enlarged[5][40 - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = restart_enlarged[6][40 - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectA) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_a_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_a_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_a_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_a_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_a_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_a_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_a_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectB) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_b_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_b_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_b_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_b_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_b_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_b_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_b_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectH) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = heal_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = heal_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = heal_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = heal_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = heal_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = heal_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = heal_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectP) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = pass_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = pass_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = pass_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = pass_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = pass_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = pass_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = pass_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    
                    if (x >= 28 && x <= 34 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = tick[0][6 - (x - 28)] ? 0 : 16'hffff;
                            40: pixel_data = tick[1][6 - (x - 28)] ? 0 : 16'hffff;
                            41: pixel_data = tick[2][6 - (x - 28)] ? 0 : 16'hffff;
                            42: pixel_data = tick[3][6 - (x - 28)] ? 0 : 16'hffff;
                            43: pixel_data = tick[4][6 - (x - 28)] ? 0 : 16'hffff;
                        endcase
                    end
                   
                    if (x >= 62 && x <= 66 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                            40: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            41: pixel_data = cross[2][4 - (x - 62)] ? 0 : 16'hffff;
                            42: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            43: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    if (btnC) begin
                        if (prev_state[5] == 1) reset <= 1;
                        else begin
                            endTurn <= 1;
                            case(prev_state)                    
                                {1'b0, selectA}: skill <= 3'b001;
                                {1'b0, selectB}: skill <= 3'b010;
                                {1'b0, selectH}: skill <= 3'b011;
                                {1'b0, selectP}: skill <= 3'b100;
                            endcase
                        end
                    end
                    state <= btnC ? idle : ((btnL || btnR) ? selectNo : state);
                end
                
                selectNo:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 35 || y == 47) && x >= 58 && x <= 70) || ((x == 58 || x == 70) && y >= 35 && y <= 47)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 21 && x <= 51 && y >= 15 && y <= 19) begin
                        case (y)
                            15: pixel_data = confirm[0][30 - (x - 21)] ? 0 : 16'hffff;
                            16: pixel_data = confirm[1][30 - (x - 21)] ? 0 : 16'hffff;
                            17: pixel_data = confirm[2][30 - (x - 21)] ? 0 : 16'hffff;
                            18: pixel_data = confirm[3][30 - (x - 21)] ? 0 : 16'hffff;
                            19: pixel_data = confirm[4][30 - (x - 21)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (prev_state[5] == 1) begin
                        if (x >= 21 && x <= 61 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = restart_enlarged[0][40 - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = restart_enlarged[1][40 - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = restart_enlarged[2][40 - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = restart_enlarged[3][40 - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = restart_enlarged[4][40 - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = restart_enlarged[5][40 - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = restart_enlarged[6][40 - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectA) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_a_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_a_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_a_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_a_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_a_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_a_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_a_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectB) begin
                        if (x >= 21 && x <= 71 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = skill_b_enlarged[0][left_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = skill_b_enlarged[1][left_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = skill_b_enlarged[2][left_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = skill_b_enlarged[3][left_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = skill_b_enlarged[4][left_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = skill_b_enlarged[5][left_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = skill_b_enlarged[6][left_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectH) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = heal_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = heal_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = heal_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = heal_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = heal_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = heal_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = heal_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    else if (prev_state[4:0] == selectP) begin
                        if (x >= 21 && x <= 43 && y >= 23 && y <= 29) begin
                            case(y)
                                23: pixel_data = pass_enlarged[0][right_len - (x - 21)] ? 0 : 16'hffff;
                                24: pixel_data = pass_enlarged[1][right_len - (x - 21)] ? 0 : 16'hffff;
                                25: pixel_data = pass_enlarged[2][right_len - (x - 21)] ? 0 : 16'hffff;
                                26: pixel_data = pass_enlarged[3][right_len - (x - 21)] ? 0 : 16'hffff;
                                27: pixel_data = pass_enlarged[4][right_len - (x - 21)] ? 0 : 16'hffff;
                                28: pixel_data = pass_enlarged[5][right_len - (x - 21)] ? 0 : 16'hffff;
                                29: pixel_data = pass_enlarged[6][right_len - (x - 21)] ? 0 : 16'hffff;
                            endcase
                        end
                    end
                    
                    if (x >= 28 && x <= 34 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = tick[0][6 - (x - 28)] ? 0 : 16'hffff;
                            40: pixel_data = tick[1][6 - (x - 28)] ? 0 : 16'hffff;
                            41: pixel_data = tick[2][6 - (x - 28)] ? 0 : 16'hffff;
                            42: pixel_data = tick[3][6 - (x - 28)] ? 0 : 16'hffff;
                            43: pixel_data = tick[4][6 - (x - 28)] ? 0 : 16'hffff;
                        endcase
                    end
                   
                    if (x >= 62 && x <= 66 && y >= 39 && y <= 43) begin
                        case(y)
                            39: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                            40: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            41: pixel_data = cross[2][4 - (x - 62)] ? 0 : 16'hffff;
                            42: pixel_data = cross[1][4 - (x - 62)] ? 0 : 16'hffff;
                            43: pixel_data = cross[0][4 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    if (prev_state[5] == 0) begin
                        state <= btnC ? prev_state[4:0] : ((btnL || btnR) ? selectYes : state);
                    end
                    else begin
                        state <= btnC ? selectRestart : ((btnL || btnR) ? selectNo : state);
                        prev_state[5] <= btnC ? 0 : 1;
                    end
                end
                
                pauseScreen:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 22 && x <= 36 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                            23: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            24: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            25: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            26: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            27: pixel_data = info_icon[4][14 - (x - 22)] ? 0 : 16'hffff;
                            28: pixel_data = info_icon[5][14 - (x - 22)] ? 0 : 16'hffff;
                            29: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            30: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            31: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            32: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            33: pixel_data = info_icon[7][14 - (x - 22)] ? 0 : 16'hffff;
                            34: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            35: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            36: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 42 && x <= 56 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                            23: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            24: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            25: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            26: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            27: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            28: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            29: pixel_data = resume_icon[7][14 - (x - 42)] ? 0 : 16'hffff;
                            30: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            31: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            32: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            33: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            34: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            35: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            36: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 62 && x <= 72 && y >= 24 && y <= 34) begin
                        case(y)
                            24: pixel_data = restart_icon[0][10 - (x - 62)] ? 0 : 16'hffff;
                            25: pixel_data = restart_icon[1][10 - (x - 62)] ? 0 : 16'hffff;
                            26: pixel_data = restart_icon[2][10 - (x - 62)] ? 0 : 16'hffff;
                            27: pixel_data = restart_icon[3][10 - (x - 62)] ? 0 : 16'hffff;
                            28: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            29: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            30: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            31: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            32: pixel_data = restart_icon[5][10 - (x - 62)] ? 0 : 16'hffff;
                            33: pixel_data = restart_icon[6][10 - (x - 62)] ? 0 : 16'hffff;
                            34: pixel_data = restart_icon[7][10 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= (btnU || btnL || btnR || btnD) ? selectInfo : state;
                end
                
                selectInfo:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 20 || y == 38) && x >= 20 && x <= 38) || ((x == 20 || x == 38) && y >= 20 && y <= 38)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 22 && x <= 36 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                            23: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            24: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            25: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            26: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            27: pixel_data = info_icon[4][14 - (x - 22)] ? 0 : 16'hffff;
                            28: pixel_data = info_icon[5][14 - (x - 22)] ? 0 : 16'hffff;
                            29: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            30: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            31: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            32: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            33: pixel_data = info_icon[7][14 - (x - 22)] ? 0 : 16'hffff;
                            34: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            35: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            36: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 42 && x <= 56 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                            23: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            24: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            25: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            26: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            27: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            28: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            29: pixel_data = resume_icon[7][14 - (x - 42)] ? 0 : 16'hffff;
                            30: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            31: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            32: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            33: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            34: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            35: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            36: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 62 && x <= 72 && y >= 24 && y <= 34) begin
                        case(y)
                            24: pixel_data = restart_icon[0][10 - (x - 62)] ? 0 : 16'hffff;
                            25: pixel_data = restart_icon[1][10 - (x - 62)] ? 0 : 16'hffff;
                            26: pixel_data = restart_icon[2][10 - (x - 62)] ? 0 : 16'hffff;
                            27: pixel_data = restart_icon[3][10 - (x - 62)] ? 0 : 16'hffff;
                            28: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            29: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            30: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            31: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            32: pixel_data = restart_icon[5][10 - (x - 62)] ? 0 : 16'hffff;
                            33: pixel_data = restart_icon[6][10 - (x - 62)] ? 0 : 16'hffff;
                            34: pixel_data = restart_icon[7][10 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 20 && x <= 75 && y >= 43 && y <= 47) begin
                        case(y)
                            43: pixel_data = guide[0][55 - (x - 20)] ? 0 : 16'hffff;
                            44: pixel_data = guide[1][55 - (x - 20)] ? 0 : 16'hffff;
                            45: pixel_data = guide[2][55 - (x - 20)] ? 0 : 16'hffff;
                            46: pixel_data = guide[3][55 - (x - 20)] ? 0 : 16'hffff;
                            47: pixel_data = guide[4][55 - (x - 20)] ? 0 : 16'hffff;
                        endcase
                    end
                state <= btnC ? info1 : (btnL ? selectRestart : (btnR ? selectResume : state));
                end
                
                selectResume:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 20 || y == 38) && x >= 40 && x <= 58) || ((x == 40 || x == 58) && y >= 20 && y <= 38)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 22 && x <= 36 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                            23: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            24: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            25: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            26: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            27: pixel_data = info_icon[4][14 - (x - 22)] ? 0 : 16'hffff;
                            28: pixel_data = info_icon[5][14 - (x - 22)] ? 0 : 16'hffff;
                            29: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            30: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            31: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            32: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            33: pixel_data = info_icon[7][14 - (x - 22)] ? 0 : 16'hffff;
                            34: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            35: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            36: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 42 && x <= 56 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                            23: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            24: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            25: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            26: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            27: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            28: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            29: pixel_data = resume_icon[7][14 - (x - 42)] ? 0 : 16'hffff;
                            30: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            31: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            32: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            33: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            34: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            35: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            36: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 62 && x <= 72 && y >= 24 && y <= 34) begin
                        case(y)
                            24: pixel_data = restart_icon[0][10 - (x - 62)] ? 0 : 16'hffff;
                            25: pixel_data = restart_icon[1][10 - (x - 62)] ? 0 : 16'hffff;
                            26: pixel_data = restart_icon[2][10 - (x - 62)] ? 0 : 16'hffff;
                            27: pixel_data = restart_icon[3][10 - (x - 62)] ? 0 : 16'hffff;
                            28: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            29: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            30: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            31: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            32: pixel_data = restart_icon[5][10 - (x - 62)] ? 0 : 16'hffff;
                            33: pixel_data = restart_icon[6][10 - (x - 62)] ? 0 : 16'hffff;
                            34: pixel_data = restart_icon[7][10 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 36 && x <= 60 && y >= 43 && y <= 47) begin
                        case(y)
                            43: pixel_data = resume[0][24 - (x - 36)] ? 0 : 16'hffff;
                            44: pixel_data = resume[1][24 - (x - 36)] ? 0 : 16'hffff;
                            45: pixel_data = resume[2][24 - (x - 36)] ? 0 : 16'hffff;
                            46: pixel_data = resume[3][24 - (x - 36)] ? 0 : 16'hffff;
                            47: pixel_data = resume[4][24 - (x - 36)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? selectPause : (btnL ? selectInfo : (btnR ? selectRestart : state));
                end
                
                selectRestart:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 20 || y == 38) && x >= 58 && x <= 76) || ((x == 58 || x == 76) && y >= 20 && y <= 38)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 22 && x <= 36 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                            23: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            24: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            25: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            26: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            27: pixel_data = info_icon[4][14 - (x - 22)] ? 0 : 16'hffff;
                            28: pixel_data = info_icon[5][14 - (x - 22)] ? 0 : 16'hffff;
                            29: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            30: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            31: pixel_data = info_icon[6][14 - (x - 22)] ? 0 : 16'hffff;
                            32: pixel_data = info_icon[3][14 - (x - 22)] ? 0 : 16'hffff;
                            33: pixel_data = info_icon[7][14 - (x - 22)] ? 0 : 16'hffff;
                            34: pixel_data = info_icon[2][14 - (x - 22)] ? 0 : 16'hffff;
                            35: pixel_data = info_icon[1][14 - (x - 22)] ? 0 : 16'hffff;
                            36: pixel_data = info_icon[0][14 - (x - 22)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 42 && x <= 56 && y >= 22 && y <= 36) begin
                        case(y)
                            22: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                            23: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            24: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            25: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            26: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            27: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            28: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            29: pixel_data = resume_icon[7][14 - (x - 42)] ? 0 : 16'hffff;
                            30: pixel_data = resume_icon[6][14 - (x - 42)] ? 0 : 16'hffff;
                            31: pixel_data = resume_icon[5][14 - (x - 42)] ? 0 : 16'hffff;
                            32: pixel_data = resume_icon[4][14 - (x - 42)] ? 0 : 16'hffff;
                            33: pixel_data = resume_icon[3][14 - (x - 42)] ? 0 : 16'hffff;
                            34: pixel_data = resume_icon[2][14 - (x - 42)] ? 0 : 16'hffff;
                            35: pixel_data = resume_icon[1][14 - (x - 42)] ? 0 : 16'hffff;
                            36: pixel_data = resume_icon[0][14 - (x - 42)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 62 && x <= 72 && y >= 24 && y <= 34) begin
                        case(y)
                            24: pixel_data = restart_icon[0][10 - (x - 62)] ? 0 : 16'hffff;
                            25: pixel_data = restart_icon[1][10 - (x - 62)] ? 0 : 16'hffff;
                            26: pixel_data = restart_icon[2][10 - (x - 62)] ? 0 : 16'hffff;
                            27: pixel_data = restart_icon[3][10 - (x - 62)] ? 0 : 16'hffff;
                            28: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            29: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            30: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            31: pixel_data = restart_icon[4][10 - (x - 62)] ? 0 : 16'hffff;
                            32: pixel_data = restart_icon[5][10 - (x - 62)] ? 0 : 16'hffff;
                            33: pixel_data = restart_icon[6][10 - (x - 62)] ? 0 : 16'hffff;
                            34: pixel_data = restart_icon[7][10 - (x - 62)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 35 && x <= 61 && y >= 43 && y <= 47) begin
                        case(y)
                            43: pixel_data = restart[0][26 - (x - 35)] ? 0 : 16'hffff;
                            44: pixel_data = restart[1][26 - (x - 35)] ? 0 : 16'hffff;
                            45: pixel_data = restart[2][26 - (x - 35)] ? 0 : 16'hffff;
                            46: pixel_data = restart[3][26 - (x - 35)] ? 0 : 16'hffff;
                            47: pixel_data = restart[4][26 - (x - 35)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? confirmScreen : (btnL ? selectResume : (btnR ? selectInfo : state));
                    prev_state[5] <= btnC ? 1 : 0;
                end
                
                noSP:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 23 && x <= 72 && y >= 19 && y <= 25) begin
                        case(y)
                            19: pixel_data = no_sp[0][49 - (x - 23)] ? 0 : 16'hffff;
                            20: pixel_data = no_sp[1][49 - (x - 23)] ? 0 : 16'hffff;
                            21: pixel_data = no_sp[2][49 - (x - 23)] ? 0 : 16'hffff;
                            22: pixel_data = no_sp[3][49 - (x - 23)] ? 0 : 16'hffff;
                            23: pixel_data = no_sp[4][49 - (x - 23)] ? 0 : 16'hffff;
                            24: pixel_data = no_sp[5][49 - (x - 23)] ? 0 : 16'hffff;
                            25: pixel_data = no_sp[6][49 - (x - 23)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 45 && x <= 51 && y >= 37 && y <= 41) begin
                        case(y)
                            37: pixel_data = tick[0][6 - (x - 45)] ? 0 : 16'hffff;
                            38: pixel_data = tick[1][6 - (x - 45)] ? 0 : 16'hffff;
                            39: pixel_data = tick[2][6 - (x - 45)] ? 0 : 16'hffff;
                            40: pixel_data = tick[3][6 - (x - 45)] ? 0 : 16'hffff;
                            41: pixel_data = tick[4][6 - (x - 45)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= (btnU || btnL || btnR || btnD) ? confirmNoSP : state;
                end
                
                confirmNoSP:
                begin
                    if (x >= 15 && x <= 80 && y >= 9 && y <= 54) begin
                        if (((y == 11 || y == 52) && x >= 17 && x <= 78) || ((x == 17 || x == 78) && y >= 11 && y <= 52)) pixel_data = 0;
                        else if (((y == 33 || y == 45) && x >= 42 && x <= 54) || ((x == 42 || x == 54) && y >= 33 && y <= 45)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 23 && x <= 72 && y >= 19 && y <= 25) begin
                        case(y)
                            19: pixel_data = no_sp[0][49 - (x - 23)] ? 0 : 16'hffff;
                            20: pixel_data = no_sp[1][49 - (x - 23)] ? 0 : 16'hffff;
                            21: pixel_data = no_sp[2][49 - (x - 23)] ? 0 : 16'hffff;
                            22: pixel_data = no_sp[3][49 - (x - 23)] ? 0 : 16'hffff;
                            23: pixel_data = no_sp[4][49 - (x - 23)] ? 0 : 16'hffff;
                            24: pixel_data = no_sp[5][49 - (x - 23)] ? 0 : 16'hffff;
                            25: pixel_data = no_sp[6][49 - (x - 23)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 45 && x <= 51 && y >= 37 && y <= 41) begin
                        case(y)
                            37: pixel_data = tick[0][6 - (x - 45)] ? 0 : 16'hffff;
                            38: pixel_data = tick[1][6 - (x - 45)] ? 0 : 16'hffff;
                            39: pixel_data = tick[2][6 - (x - 45)] ? 0 : 16'hffff;
                            40: pixel_data = tick[3][6 - (x - 45)] ? 0 : 16'hffff;
                            41: pixel_data = tick[4][6 - (x - 45)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? prev_state : state;
                end
                
                noTime:
                begin
                    if (x >= 21 && x <= 74 && y >= 17 && y <= 46) begin
                        if (((y == 19 || y == 44) && x >= 23 && x <= 72) || ((x == 23 || x == 72) && y >= 19 && y <= 44)) pixel_data = 0;
                        else pixel_data = 16'hffff;                        
                    end
                    
                    if (x >= 28 && x <= 66 && y >= 28 && y <= 34) begin
                        case(y)
                            28: pixel_data = timeout[0][38 - (x - 28)] ? 0 : 16'hffff;
                            29: pixel_data = timeout[1][38 - (x - 28)] ? 0 : 16'hffff;
                            30: pixel_data = timeout[2][38 - (x - 28)] ? 0 : 16'hffff;
                            31: pixel_data = timeout[3][38 - (x - 28)] ? 0 : 16'hffff;
                            32: pixel_data = timeout[4][38 - (x - 28)] ? 0 : 16'hffff;
                            33: pixel_data = timeout[5][38 - (x - 28)] ? 0 : 16'hffff;
                            34: pixel_data = timeout[6][38 - (x - 28)] ? 0 : 16'hffff;
                        endcase
                    end
                end
                
                info1:
                begin
                    if (((y == 2 || y == 61) && x >= 2 && x <= 92) || ((x == 2 || x == 92) && y >= 2 && y <= 61)) pixel_data = 0;
                    else pixel_data = 16'hffff;
                    
                    if (x >= 6 && x <= 61 && y >= 11 && y <= 15) begin
                        case(y)
                            11: pixel_data = guide[0][55 - (x - 6)] ? 0 : 16'hffff;
                            12: pixel_data = guide[1][55 - (x - 6)] ? 0 : 16'hffff;
                            13: pixel_data = guide[2][55 - (x - 6)] ? 0 : 16'hffff;
                            14: pixel_data = guide[3][55 - (x - 6)] ? 0 : 16'hffff;
                            15: pixel_data = guide[4][55 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 87 && y >= 18 && y <= 22) begin
                        case(y)
                            18: pixel_data = type_adv[0][81 - (x - 6)] ? 0 : 16'hffff;
                            19: pixel_data = type_adv[1][81 - (x - 6)] ? 0 : 16'hffff;
                            20: pixel_data = type_adv[2][81 - (x - 6)] ? 0 : 16'hffff;
                            21: pixel_data = type_adv[3][81 - (x - 6)] ? 0 : 16'hffff;
                            22: pixel_data = type_adv[4][81 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 13 && x <= 33 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = fire[0][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            28: pixel_data = fire[1][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            29: pixel_data = fire[2][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            30: pixel_data = fire[3][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            31: pixel_data = fire[4][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            32: pixel_data = fire[5][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            33: pixel_data = fire[6][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 59 && x <= 87 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = grass[0][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            28: pixel_data = grass[1][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            29: pixel_data = grass[2][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            30: pixel_data = grass[3][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            31: pixel_data = grass[4][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            32: pixel_data = grass[5][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            33: pixel_data = grass[6][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 33 && x <= 61 && y >= 42 && y <= 48) begin
                        case(y)
                            42: pixel_data = water[0][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            43: pixel_data = water[1][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            44: pixel_data = water[2][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            45: pixel_data = water[3][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            46: pixel_data = water[4][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            47: pixel_data = water[5][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            48: pixel_data = water[6][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 44 && x <= 51 && y >= 28 && y <= 32) begin
                        case(y)
                            28: pixel_data = arrow_R[0][7 - (x - 44)] ? 0 : 16'hffff;
                            29: pixel_data = arrow_R[1][7 - (x - 44)] ? 0 : 16'hffff;
                            30: pixel_data = arrow_R[2][7 - (x - 44)] ? 0 : 16'hffff;
                            31: pixel_data = arrow_R[3][7 - (x - 44)] ? 0 : 16'hffff;
                            32: pixel_data = arrow_R[4][7 - (x - 44)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 18 && x <= 22 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_U[1][4 - (x - 18)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_U[2][4 - (x - 18)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_U[3][4 - (x - 18)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_U[5][4 - (x - 18)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 73 && x <= 77 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_D[0][4 - (x - 73)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_D[2][4 - (x - 73)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_D[3][4 - (x - 73)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_D[5][4 - (x - 73)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 45 && x <= 49 && y >= 56 & y <= 58) begin
                        case(y)
                            56: pixel_data = down_btn[0][4 - (x - 45)] ? 0 : 16'hffff;
                            57: pixel_data = down_btn[1][4 - (x - 45)] ? 0 : 16'hffff;
                            58: pixel_data = down_btn[2][4 - (x - 45)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 86 && x <= 88 && y >= 7 && y <= 9) begin
                        case(y)
                            7: pixel_data = cancel[0][2 - (x - 86)] ? 0 : 16'hffff;
                            8: pixel_data = cancel[1][2 - (x - 86)] ? 0 : 16'hffff;
                            9: pixel_data = cancel[0][2 - (x - 86)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnU ? selectCancel : (btnD ? selectDown : state);
                end
                
                info2:
                begin
                    if (((y == 2 || y == 61) && x >= 2 && x <= 92) || ((x == 2 || x == 92) && y >= 2 && y <= 61)) pixel_data = 0;
                    else pixel_data = 16'hffff;
                    
                    if (x >= 6 && x <= 61 && y >= 11 && y <= 15) begin
                        case(y)
                            11: pixel_data = guide[0][55 - (x - 6)] ? 0 : 16'hffff;
                            12: pixel_data = guide[1][55 - (x - 6)] ? 0 : 16'hffff;
                            13: pixel_data = guide[2][55 - (x - 6)] ? 0 : 16'hffff;
                            14: pixel_data = guide[3][55 - (x - 6)] ? 0 : 16'hffff;
                            15: pixel_data = guide[4][55 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 24 && y >= 18 && y <= 22) begin
                        case(y)
                            18: pixel_data = stats[0][18 - (x - 6)] ? 0 : 16'hffff;
                            19: pixel_data = stats[1][18 - (x - 6)] ? 0 : 16'hffff;
                            20: pixel_data = stats[2][18 - (x - 6)] ? 0 : 16'hffff;
                            21: pixel_data = stats[3][18 - (x - 6)] ? 0 : 16'hffff;
                            22: pixel_data = stats[4][18 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 72 && y >= 29 && y <= 33) begin
                        case(y)
                            29: pixel_data = time_per_turn[0][66 - (x - 6)] ? 0 : 16'hffff;
                            30: pixel_data = time_per_turn[1][66 - (x - 6)] ? 0 : 16'hffff;
                            31: pixel_data = time_per_turn[2][66 - (x - 6)] ? 0 : 16'hffff;
                            32: pixel_data = time_per_turn[3][66 - (x - 6)] ? 0 : 16'hffff;
                            33: pixel_data = time_per_turn[4][66 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 68 && y >= 37 && y <= 41) begin
                        case(y)
                            37: pixel_data = basic[0][62 - (x - 6)] ? 0 : 16'hffff;
                            38: pixel_data = basic[1][62 - (x - 6)] ? 0 : 16'hffff;
                            39: pixel_data = basic[2][62 - (x - 6)] ? 0 : 16'hffff;
                            40: pixel_data = basic[3][62 - (x - 6)] ? 0 : 16'hffff;
                            41: pixel_data = basic[4][62 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 86 && y >= 45 && y <= 49) begin
                        case(y)
                            45: pixel_data = special[0][80 - (x - 6)] ? 0 : 16'hffff;
                            46: pixel_data = special[1][80 - (x - 6)] ? 0 : 16'hffff;
                            47: pixel_data = special[2][80 - (x - 6)] ? 0 : 16'hffff;
                            48: pixel_data = special[3][80 - (x - 6)] ? 0 : 16'hffff;
                            49: pixel_data = special[4][80 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 58 && y >= 53 && y <= 57) begin
                        case(y)
                            53: pixel_data = heal_stats[0][52 - (x - 6)] ? 0 : 16'hffff;
                            54: pixel_data = heal_stats[1][52 - (x - 6)] ? 0 : 16'hffff;
                            55: pixel_data = heal_stats[2][52 - (x - 6)] ? 0 : 16'hffff;
                            56: pixel_data = heal_stats[3][52 - (x - 6)] ? 0 : 16'hffff;
                            57: pixel_data = heal_stats[4][52 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 45 && x <= 49 && y >= 4 && y <= 6) begin
                        case(y)
                            4: pixel_data = up_btn[0][4 - (x - 45)] ? 0 : 16'hffff;
                            5: pixel_data = up_btn[1][4 - (x - 45)] ? 0 : 16'hffff;
                            6: pixel_data = up_btn[1][4 - (x - 45)] ? 0 : 16'hffff;
                        endcase
                    end           
                    state <= (btnU || btnD) ? selectUp : state;
                end
                
                selectUp:
                begin
                    if (((y == 2 || y == 61) && x >= 2 && x <= 92) || ((x == 2 || x == 92) && y >= 2 && y <= 61)) pixel_data = 0;
                    else pixel_data = 16'hffff;
                    
                    if (x >= 6 && x <= 61 && y >= 11 && y <= 15) begin
                        case(y)
                            11: pixel_data = guide[0][55 - (x - 6)] ? 0 : 16'hffff;
                            12: pixel_data = guide[1][55 - (x - 6)] ? 0 : 16'hffff;
                            13: pixel_data = guide[2][55 - (x - 6)] ? 0 : 16'hffff;
                            14: pixel_data = guide[3][55 - (x - 6)] ? 0 : 16'hffff;
                            15: pixel_data = guide[4][55 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 24 && y >= 18 && y <= 22) begin
                        case(y)
                            18: pixel_data = stats[0][18 - (x - 6)] ? 0 : 16'hffff;
                            19: pixel_data = stats[1][18 - (x - 6)] ? 0 : 16'hffff;
                            20: pixel_data = stats[2][18 - (x - 6)] ? 0 : 16'hffff;
                            21: pixel_data = stats[3][18 - (x - 6)] ? 0 : 16'hffff;
                            22: pixel_data = stats[4][18 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 72 && y >= 29 && y <= 33) begin
                        case(y)
                            29: pixel_data = time_per_turn[0][66 - (x - 6)] ? 0 : 16'hffff;
                            30: pixel_data = time_per_turn[1][66 - (x - 6)] ? 0 : 16'hffff;
                            31: pixel_data = time_per_turn[2][66 - (x - 6)] ? 0 : 16'hffff;
                            32: pixel_data = time_per_turn[3][66 - (x - 6)] ? 0 : 16'hffff;
                            33: pixel_data = time_per_turn[4][66 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 68 && y >= 37 && y <= 41) begin
                        case(y)
                            37: pixel_data = basic[0][62 - (x - 6)] ? 0 : 16'hffff;
                            38: pixel_data = basic[1][62 - (x - 6)] ? 0 : 16'hffff;
                            39: pixel_data = basic[2][62 - (x - 6)] ? 0 : 16'hffff;
                            40: pixel_data = basic[3][62 - (x - 6)] ? 0 : 16'hffff;
                            41: pixel_data = basic[4][62 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 86 && y >= 45 && y <= 49) begin
                        case(y)
                            45: pixel_data = special[0][80 - (x - 6)] ? 0 : 16'hffff;
                            46: pixel_data = special[1][80 - (x - 6)] ? 0 : 16'hffff;
                            47: pixel_data = special[2][80 - (x - 6)] ? 0 : 16'hffff;
                            48: pixel_data = special[3][80 - (x - 6)] ? 0 : 16'hffff;
                            49: pixel_data = special[4][80 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 58 && y >= 53 && y <= 57) begin
                        case(y)
                            53: pixel_data = heal_stats[0][52 - (x - 6)] ? 0 : 16'hffff;
                            54: pixel_data = heal_stats[1][52 - (x - 6)] ? 0 : 16'hffff;
                            55: pixel_data = heal_stats[2][52 - (x - 6)] ? 0 : 16'hffff;
                            56: pixel_data = heal_stats[3][52 - (x - 6)] ? 0 : 16'hffff;
                            57: pixel_data = heal_stats[4][52 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 43 && x <= 51 && y >= 4 && y <= 8) begin
                        case(y)
                            4: pixel_data = up_btn_enlarged[0][8 - (x - 43)] ? 0 : 16'hffff;
                            5: pixel_data = up_btn_enlarged[1][8 - (x - 43)] ? 0 : 16'hffff;
                            6: pixel_data = up_btn_enlarged[2][8 - (x - 43)] ? 0 : 16'hffff;
                            7: pixel_data = up_btn_enlarged[3][8 - (x - 43)] ? 0 : 16'hffff;
                            8: pixel_data = up_btn_enlarged[4][8 - (x - 43)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? info1 : state;
                end
                
                selectDown:
                begin
                    if (((y == 2 || y == 61) && x >= 2 && x <= 92) || ((x == 2 || x == 92) && y >= 2 && y <= 61)) pixel_data = 0;
                    else pixel_data = 16'hffff;
                    
                    if (x >= 6 && x <= 61 && y >= 11 && y <= 15) begin
                        case(y)
                            11: pixel_data = guide[0][55 - (x - 6)] ? 0 : 16'hffff;
                            12: pixel_data = guide[1][55 - (x - 6)] ? 0 : 16'hffff;
                            13: pixel_data = guide[2][55 - (x - 6)] ? 0 : 16'hffff;
                            14: pixel_data = guide[3][55 - (x - 6)] ? 0 : 16'hffff;
                            15: pixel_data = guide[4][55 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 87 && y >= 18 && y <= 22) begin
                        case(y)
                            18: pixel_data = type_adv[0][81 - (x - 6)] ? 0 : 16'hffff;
                            19: pixel_data = type_adv[1][81 - (x - 6)] ? 0 : 16'hffff;
                            20: pixel_data = type_adv[2][81 - (x - 6)] ? 0 : 16'hffff;
                            21: pixel_data = type_adv[3][81 - (x - 6)] ? 0 : 16'hffff;
                            22: pixel_data = type_adv[4][81 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 13 && x <= 33 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = fire[0][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            28: pixel_data = fire[1][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            29: pixel_data = fire[2][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            30: pixel_data = fire[3][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            31: pixel_data = fire[4][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            32: pixel_data = fire[5][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            33: pixel_data = fire[6][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 59 && x <= 87 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = grass[0][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            28: pixel_data = grass[1][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            29: pixel_data = grass[2][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            30: pixel_data = grass[3][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            31: pixel_data = grass[4][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            32: pixel_data = grass[5][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            33: pixel_data = grass[6][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 33 && x <= 61 && y >= 42 && y <= 48) begin
                        case(y)
                            42: pixel_data = water[0][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            43: pixel_data = water[1][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            44: pixel_data = water[2][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            45: pixel_data = water[3][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            46: pixel_data = water[4][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            47: pixel_data = water[5][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            48: pixel_data = water[6][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 44 && x <= 51 && y >= 28 && y <= 32) begin
                        case(y)
                            28: pixel_data = arrow_R[0][7 - (x - 44)] ? 0 : 16'hffff;
                            29: pixel_data = arrow_R[1][7 - (x - 44)] ? 0 : 16'hffff;
                            30: pixel_data = arrow_R[2][7 - (x - 44)] ? 0 : 16'hffff;
                            31: pixel_data = arrow_R[3][7 - (x - 44)] ? 0 : 16'hffff;
                            32: pixel_data = arrow_R[4][7 - (x - 44)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 18 && x <= 22 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_U[1][4 - (x - 18)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_U[2][4 - (x - 18)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_U[3][4 - (x - 18)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_U[5][4 - (x - 18)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 73 && x <= 77 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_D[0][4 - (x - 73)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_D[2][4 - (x - 73)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_D[3][4 - (x - 73)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_D[5][4 - (x - 73)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 43 && x <= 51 && y >= 54 & y <= 58) begin
                        case(y)
                            54: pixel_data = down_btn_enlarged[0][8 - (x - 43)] ? 0 : 16'hffff;
                            55: pixel_data = down_btn_enlarged[1][8 - (x - 43)] ? 0 : 16'hffff;
                            56: pixel_data = down_btn_enlarged[2][8 - (x - 43)] ? 0 : 16'hffff;
                            57: pixel_data = down_btn_enlarged[3][8 - (x - 43)] ? 0 : 16'hffff;
                            58: pixel_data = down_btn_enlarged[4][8 - (x - 43)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 86 && x <= 88 && y >= 7 && y <= 9) begin
                        case(y)
                            7: pixel_data = cancel[0][2 - (x - 86)] ? 0 : 16'hffff;
                            8: pixel_data = cancel[1][2 - (x - 86)] ? 0 : 16'hffff;
                            9: pixel_data = cancel[0][2 - (x - 86)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? info2 : ((btnD || btnU) ? selectCancel : state);
                end
                
                selectCancel:
                begin
                    if (((y == 2 || y == 61) && x >= 2 && x <= 92) || ((x == 2 || x == 92) && y >= 2 && y <= 61)) pixel_data = 0;
                    else pixel_data = 16'hffff;
                    
                    if (x >= 6 && x <= 61 && y >= 11 && y <= 15) begin
                        case(y)
                            11: pixel_data = guide[0][55 - (x - 6)] ? 0 : 16'hffff;
                            12: pixel_data = guide[1][55 - (x - 6)] ? 0 : 16'hffff;
                            13: pixel_data = guide[2][55 - (x - 6)] ? 0 : 16'hffff;
                            14: pixel_data = guide[3][55 - (x - 6)] ? 0 : 16'hffff;
                            15: pixel_data = guide[4][55 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 6 && x <= 87 && y >= 18 && y <= 22) begin
                        case(y)
                            18: pixel_data = type_adv[0][81 - (x - 6)] ? 0 : 16'hffff;
                            19: pixel_data = type_adv[1][81 - (x - 6)] ? 0 : 16'hffff;
                            20: pixel_data = type_adv[2][81 - (x - 6)] ? 0 : 16'hffff;
                            21: pixel_data = type_adv[3][81 - (x - 6)] ? 0 : 16'hffff;
                            22: pixel_data = type_adv[4][81 - (x - 6)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 13 && x <= 33 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = fire[0][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            28: pixel_data = fire[1][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            29: pixel_data = fire[2][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            30: pixel_data = fire[3][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            31: pixel_data = fire[4][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            32: pixel_data = fire[5][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                            33: pixel_data = fire[6][20 - (x - 13)] ? 16'hd8a2 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 59 && x <= 87 && y >= 27 && y <= 33) begin
                        case(y)
                            27: pixel_data = grass[0][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            28: pixel_data = grass[1][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            29: pixel_data = grass[2][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            30: pixel_data = grass[3][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            31: pixel_data = grass[4][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            32: pixel_data = grass[5][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                            33: pixel_data = grass[6][28 - (x - 59)] ? 16'h1602 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 33 && x <= 61 && y >= 42 && y <= 48) begin
                        case(y)
                            42: pixel_data = water[0][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            43: pixel_data = water[1][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            44: pixel_data = water[2][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            45: pixel_data = water[3][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            46: pixel_data = water[4][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            47: pixel_data = water[5][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                            48: pixel_data = water[6][28 - (x - 33)] ? 16'h0c3a : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 44 && x <= 51 && y >= 28 && y <= 32) begin
                        case(y)
                            28: pixel_data = arrow_R[0][7 - (x - 44)] ? 0 : 16'hffff;
                            29: pixel_data = arrow_R[1][7 - (x - 44)] ? 0 : 16'hffff;
                            30: pixel_data = arrow_R[2][7 - (x - 44)] ? 0 : 16'hffff;
                            31: pixel_data = arrow_R[3][7 - (x - 44)] ? 0 : 16'hffff;
                            32: pixel_data = arrow_R[4][7 - (x - 44)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 18 && x <= 22 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_U[1][4 - (x - 18)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_U[0][4 - (x - 18)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_U[2][4 - (x - 18)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_U[3][4 - (x - 18)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_U[4][4 - (x - 18)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_U[5][4 - (x - 18)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 73 && x <= 77 && y >= 38 && y <= 45) begin
                        case(y)
                            38: pixel_data = arrow_D[0][4 - (x - 73)] ? 0 : 16'hffff;
                            39: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            40: pixel_data = arrow_D[1][4 - (x - 73)] ? 0 : 16'hffff;
                            41: pixel_data = arrow_D[2][4 - (x - 73)] ? 0 : 16'hffff;
                            42: pixel_data = arrow_D[3][4 - (x - 73)] ? 0 : 16'hffff;
                            43: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                            44: pixel_data = arrow_D[5][4 - (x - 73)] ? 0 : 16'hffff;
                            45: pixel_data = arrow_D[4][4 - (x - 73)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 45 && x <= 49 && y >= 56 & y <= 58) begin
                        case(y)
                            56: pixel_data = down_btn[0][4 - (x - 45)] ? 0 : 16'hffff;
                            57: pixel_data = down_btn[1][4 - (x - 45)] ? 0 : 16'hffff;
                            58: pixel_data = down_btn[2][4 - (x - 45)] ? 0 : 16'hffff;
                        endcase
                    end
                    
                    if (x >= 85 && x <= 89 && y >= 6 && y <= 10) begin
                        case(y)
                            6: pixel_data = cancel_enlarged[0][4 - (x - 85)] ? 0 : 16'hffff;
                            7: pixel_data = cancel_enlarged[1][4 - (x - 85)] ? 0 : 16'hffff;
                            8: pixel_data = cancel_enlarged[2][4 - (x - 85)] ? 0 : 16'hffff;
                            9: pixel_data = cancel_enlarged[1][4 - (x - 85)] ? 0 : 16'hffff;
                            10: pixel_data = cancel_enlarged[0][4 - (x - 85)] ? 0 : 16'hffff;
                        endcase
                    end
                    state <= btnC ? selectInfo : ((btnD || btnU) ? selectDown : state);
                end
            endcase
        end
    end

endmodule