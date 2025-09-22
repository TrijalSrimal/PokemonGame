`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 09:59:15
// Design Name: 
// Module Name: player_interface
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

//edit clk counts for all modules
//edit seven_seg
module player_interface(input clk, btnU, btnD, btnL, btnR, btnC, game_start, input [1:0] pokemon_p1, pokemon_p2, player_option, 
                        input [3:0] hp_p2, SP_p1, SP_p2, input [6:0] x, y, output reg currPlyr = 0, output reg [15:0] pixel_data_2, output reg reset = 0,
                        output [2:0] skill_p1, skill_p2, output reg [4:0] state, output reg valid_states = 0, input end_animation);            
    
    wire reset_p1, reset_p2, endTurn_p1, endTurn_p2;
    wire [15:0] pixel_data_p1, pixel_data_p2;
    localparam P1 = 0, P2 = 1;
    
    wire btnU_bot, btnD_bot, btnL_bot, btnR_bot, btnC_bot;
    reg [5:0] curr_round = 1;
    wire [2:0] selected_skill;
    bot p2 (.clk(clk), .currPlyr(currPlyr), .reset(reset), .bot_hp(hp_p2), .bot_sp(SP_p2), .current_round(curr_round), 
            .selected_skill(selected_skill));   
                           
    bot_buttons buttons (.clk(clk), .currPlyr(currPlyr), .skill(selected_skill), .btnU(btnU_bot), .btnD(btnD_bot), 
                         .btnL(btnL_bot), .btnR(btnR_bot), .btnC(btnC_bot));
    
    wire [4:0] state_p1, state_p2;
    wire valid_states_p1, valid_states_p2;
    
    wire btnU_p2, btnD_p2, btnL_p2, btnR_p2, btnC_p2;
    
    assign btnU_p2 = (player_option == 2'b01) ? btnU : btnU_bot;
    assign btnD_p2 = (player_option == 2'b01) ? btnD : btnD_bot;
    assign btnL_p2 = (player_option == 2'b01) ? btnL : btnL_bot;
    assign btnR_p2 = (player_option == 2'b01) ? btnR : btnR_bot;
    assign btnC_p2 = (player_option == 2'b01) ? btnC : btnC_bot;
    

    
    display_control player1 (.clk(clk), .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR), .btnC(btnC), .plyrIndex(P1), 
                             .currPlyr(currPlyr), .game_start(game_start), .pokemon(pokemon_p1), .SP(SP_p1), .x(x), .y(y), 
                             .pixel_data(pixel_data_p1), .skill(skill_p1), .reset(reset_p1), .endTurn(endTurn_p1), 
                             .valid_states(valid_states_p1), .state(state_p1),.end_animation(end_animation));
    
    display_control player2 (.clk(clk), .btnU(btnU_p2), .btnD(btnD_p2), .btnL(btnL_p2), .btnR(btnR_p2), .btnC(btnC_p2), 
                             .plyrIndex(P2), .currPlyr(currPlyr), .game_start(game_start), .pokemon(pokemon_p2), .SP(SP_p2), 
                             .x(x), .y(y), .pixel_data(pixel_data_p2), .skill(skill_p2), .reset(reset_p2), .endTurn(endTurn_p2), 
                             .valid_states(valid_states_p2), .state(state_p2),.end_animation(end_animation));

    reg endTurn = 0;
    reg prev_endTurn_p2 = 0, prev_endTurn_p1 = 0;
    
    always @ (posedge clk) 
    begin
        if (reset || (game_start==0) ) begin
            currPlyr <= 0;
            curr_round <= 1;
            reset <= 0; 
        end
        if (end_animation&&currPlyr==0) begin 
            currPlyr <= 1;
        end 
        else if (end_animation) begin
            currPlyr <= 0;
            curr_round <= curr_round + 1;
        end
        
        if (currPlyr == 0) begin
            pixel_data_2 <= pixel_data_p1;
            reset <= reset_p1;
            endTurn <= endTurn_p1;
            state <= state_p1;
            valid_states <= valid_states_p1;
        end
        else begin
            pixel_data_2 <= pixel_data_p2;
            reset <= reset_p2;
            endTurn <= endTurn_p2;
            state <= state_p2;
            valid_states <= valid_states_p2;
        end
        
        prev_endTurn_p1 <= endTurn_p1;
        prev_endTurn_p2 <= endTurn_p2;
    end
    
endmodule
