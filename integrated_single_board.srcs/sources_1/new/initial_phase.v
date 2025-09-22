`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 22:21:40
// Design Name: 
// Module Name: initial_phase
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


module initial_phase(input clk, btnU, btnD, btnC, btnL, btnR, reset, game_end, input [6:0] x, y, input [12:0] pixel_index_ani,
                     output reg [15:0] pixel_data, output reg [15:0] pixel_data2,
                     output reg [1:0] p1_pokemon = 0, output reg [1:0] p2_pokemon = 0, output reg [1:0] player_option,
                     output reg game_start = 0);
                     
    localparam SCREEN_START = 3'b000, SCREEN_PLAYER_CHOICE = 3'b001, SCREEN_PLAYER1 = 3'b010, SCREEN_CONFIRM1 = 3'b011, 
               SCREEN_PLAYER2 = 3'b100, SCREEN_CONFIRM2 = 3'b101, IDLE = 3'b110;
                             
    localparam btnState0 = 2'b00, btnState1 = 2'b01, btnState2 = 2'b10;
    
    reg [2:0] screen_state = SCREEN_START;
    reg [1:0] btnState = btnState0;
    
    wire [1:0] btnState_in = btnState;
    
    wire [15:0] pixel_data_player_choice, pixel_data_start, pixel_data_player1, pixel_data_player2, 
                pixel_data_confirm_screen,pixel_data_pokeani;
                
    pokemon_selector poki_selector(.choice(btnState), .pixel_index(pixel_index_ani), .pixel_data(pixel_data_pokeani));
    
    start_screen screen_display (.clk(clk), .x(x), .y(y), .pixel_data(pixel_data_start));
        
    player_screen player_choice_display (.clk(clk), .x(x), .y(y), .pixel_data(pixel_data_player_choice), .btnU_in(btnU), .btnC_in(btnC), 
                                         .btnD_in(btnD), .btnState(btnState_in));
        
    player1 player1_inst (.clk(clk), .x(x), .y(y), .btnState(btnState_in), .pixel_data(pixel_data_player1));
    player2 player2_inst (.clk(clk), .x(x), .y(y), .btnState(btnState_in), .pixel_data(pixel_data_player2));
    
    reg highlight_tick = 1'b1;
    always @(posedge clk) begin
        if (btnL || btnR) highlight_tick <= ~highlight_tick;
        if (highlight_tick ==1'b1 && btnC) highlight_tick <= ~highlight_tick;
    end
    
    confirm_screen confirm_inst (.clk(clk), .x(x), .y(y), .btnState(btnState), .highlight_tick(highlight_tick), 
                                 .pixel_data(pixel_data_confirm_screen));
    
    reg screen_state_changed;
    reg [2:0] prev_screen_state = SCREEN_START;
    reg [1:0] player_option_inside;
    reg bot_choice = 0;
    reg checker=0;
   always @(posedge clk) begin
        if ( (reset || game_end ) && !checker) begin
            p1_pokemon = 2'b00;
            p2_pokemon = 2'b00;
            player_option = 2'b00;
            screen_state = SCREEN_START;
            bot_choice = ~bot_choice;
            game_start = 0;
            btnState <= 2'b00;  // Reset button state globally on reset/game_end
            checker <=1;
            
        end else begin
            case(screen_state)
                SCREEN_START: 
                begin
                    pixel_data2=0;
                    pixel_data = pixel_data_start;
                    if (btnU || btnD || btnC || btnL || btnR) begin
                        screen_state <= SCREEN_PLAYER_CHOICE;
                    end
                end
                
                SCREEN_PLAYER_CHOICE: 
                begin
                    pixel_data2 = 0;
                    pixel_data = pixel_data_player_choice;
                
                    // Handle selection movement
                    case (btnState)
                        btnState0: if (btnU) btnState <= btnState2;
                                   else if (btnD) btnState <= btnState1;
                        btnState1: if (btnU) btnState <= btnState0;
                                   else if (btnD) btnState <= btnState2;
                        btnState2: if (btnU) btnState <= btnState1;
                                   else if (btnD) btnState <= btnState0;
                    endcase
                    if (btnC) begin
                        if ((btnState == 2'b00) || (btnState == 2'b10)) begin
                            player_option <= 2'b00;  // Player vs Bot
                        end else begin
                            player_option <= 2'b01;  // Player vs Player
                        end
                        screen_state <= SCREEN_PLAYER1;
                        btnState <= 2'b00;  // Reset selection for Player 1
                    end
                end
                
                SCREEN_PLAYER1: 
                begin
                    pixel_data2 = pixel_data_pokeani;
                    pixel_data = pixel_data_player1;
                    if (btnC) begin
                        screen_state <= SCREEN_CONFIRM1;
                    end else begin
                        // Handle button state updates here
                        case (btnState)
                            btnState0: if (btnU) btnState <= btnState2;
                                       else if (btnD) btnState <= btnState1;
                            btnState1: if (btnU) btnState <= btnState0;
                                       else if (btnD) btnState <= btnState2;
                            btnState2: if (btnU) btnState <= btnState1;
                                       else if (btnD) btnState <= btnState0;
                        endcase
                    end
                end
                
                SCREEN_CONFIRM1: 
                begin
                    pixel_data2=pixel_data_pokeani;
                    pixel_data = pixel_data_confirm_screen;
                    if (btnC) begin
                        if (highlight_tick) begin
                            p1_pokemon <= btnState;
                            if (player_option == 2'b01) begin
                                screen_state <= SCREEN_PLAYER2;
                                btnState <= 2'b00;  // Reset for player 2
                            end else begin
                                if (bot_choice == 0) 
                                    p2_pokemon <= (btnState == 2'b10) ? 2'b00 : btnState + 1;
                                else 
                                    p2_pokemon <= (btnState == 2'b00) ? 2'b10 : btnState - 1;
                                
                                screen_state <= IDLE;
                                game_start = 1;
                            end
                        end else begin 
                            screen_state <= SCREEN_PLAYER1;
                        end
                    end
                end
               
                SCREEN_PLAYER2: 
                begin
                    pixel_data2 = pixel_data_pokeani;
                    pixel_data = pixel_data_player2;
                    if (btnC) begin
                        screen_state <= SCREEN_CONFIRM2;
                    end else begin
                        case (btnState)
                            btnState0: if (btnU) btnState <= btnState2;
                                       else if (btnD) btnState <= btnState1;
                            btnState1: if (btnU) btnState <= btnState0;
                                       else if (btnD) btnState <= btnState2;
                            btnState2: if (btnU) btnState <= btnState1;
                                       else if (btnD) btnState <= btnState0;
                        endcase
                    end
                end
                   
                SCREEN_CONFIRM2: begin
                    pixel_data2=pixel_data_pokeani;
                    pixel_data = pixel_data_confirm_screen;
                    if (btnC) begin
                        if (highlight_tick) begin
                            p2_pokemon <= btnState;
                            screen_state <= IDLE;
                            game_start <= 1;
                        end else begin 
                            screen_state <= SCREEN_PLAYER2;
                        end
                    end
                end
               
                IDLE:
                begin
                    pixel_data2=0;
                    pixel_data = 0;
                    checker = 0;
                end
            endcase
        end
    end


endmodule
