`timescale 1ns / 1ps
module main(input clk, btnC, btnU, btnL, btnR, btnD, input sw, sw_hp_sp, output reg [15:0] led, output reg [7:0] seg = 8'hff, 
            output reg [3:0] an = 4'hf, output [7:0] JA, JB);

    
    reg [15:0] pixel_data_1, pixel_data_2;
    wire fb_1, fb_2, sending_pixels_1, sending_pixels_2, sample_pixel_1, sample_pixel_2;    
    wire [12:0] pixel_index_1, pixel_index_2;
    wire [6:0]  x_2, y_2;
    
    wire clk6p25mhz;
    wire clk1mhz;
    flex_clk clk1 (.clk(clk),
                   .N(7),
                   .slow_clk(clk6p25mhz));
   flex_clk clk2 (.clk(clk),
                  .N(49),
                  .slow_clk(clk1mhz));
    
    Oled_Display oled1 (.clk(clk6p25mhz),
                        .reset(0),
                        .frame_begin(fb_1),
                        .sending_pixels(sending_pixels_1),
                        .sample_pixel(sample_pixel_1), 
                        .pixel_index(pixel_index_1),
                        .pixel_data(pixel_data_1),
                        .cs(JA[0]), 
                        .sdin(JA[1]),
                        .sclk(JA[3]), 
                        .d_cn(JA[4]),
                        .resn(JA[5]), 
                        .vccen(JA[6]), 
                        .pmoden(JA[7]));
    
    Oled_Display oled2 (.clk(clk6p25mhz),
                        .reset(0),
                        .frame_begin(fb_2),
                        .sending_pixels(sending_pixels_2),
                        .sample_pixel(sample_pixel_2),
                        .pixel_index(pixel_index_2), 
                        .pixel_data(pixel_data_2),
                        .cs(JB[0]), 
                        .sdin(JB[1]), 
                        .sclk(JB[3]), 
                        .d_cn(JB[4]), 
                        .resn(JB[5]), 
                        .vccen(JB[6]), 
                        .pmoden(JB[7]));

    coord coordinates_2 (.pixel_index(pixel_index_2),
                         .x(x_2),
                         .y(y_2));

    wire debounced_btnC, 
         debounced_btnU, 
         debounced_btnL, 
         debounced_btnR, 
         debounced_btnD;
    
    debouncer d1 (.clk(clk), .btn_in(btnC), .btn_out(debounced_btnC));
    debouncer d2 (.clk(clk), .btn_in(btnU), .btn_out(debounced_btnU));
    debouncer d3 (.clk(clk), .btn_in(btnL), .btn_out(debounced_btnL));
    debouncer d4 (.clk(clk), .btn_in(btnR), .btn_out(debounced_btnR));
    debouncer d5 (.clk(clk), .btn_in(btnD), .btn_out(debounced_btnD));
    
    wire reset, game_start;
    wire [15:0] pixel_data_init,pixel_data_pokichoice,pixel_data_animations;
    wire [1:0] p1_pokemon, p2_pokemon, player_option;
    reg game_end;
    
    initial_phase init (.clk(clk),
                        .btnU(debounced_btnU),
                        .btnD(debounced_btnD),
                        .btnC(debounced_btnC),
                        .btnL(debounced_btnL), 
                        .btnR(debounced_btnR),
                        .reset(reset), 
                        .game_end(game_end),
                        .x(x_2),
                        .y(y_2),
                        .pixel_data(pixel_data_init), 
                        .pixel_data2(pixel_data_pokichoice),
                        .p1_pokemon(p1_pokemon),
                        .p2_pokemon(p2_pokemon),
                        .player_option(player_option),
                        .game_start(game_start),
                        .pixel_index_ani(pixel_index_1));
    
    wire [3:0] hp_p1, SP_p1, hp_p2, SP_p2;
    wire [15:0] led_battle;
    wire [3:0] an_battle;
    wire [7:0] seg_battle;
    wire [2:0] skill_p1, skill_p2;
    wire currPlyr;
    wire [15:0] pixel_data_interface;
    wire [4:0] interface_state;
    wire valid_states;
    wire end_battle_animations;
    player_interface menu (.clk(clk),
                           .btnU(debounced_btnU),
                           .btnD(debounced_btnD), 
                           .btnL(debounced_btnL), 
                           .btnR(debounced_btnR), 
                           .btnC(debounced_btnC),
                           .game_start(game_start), 
                           .pokemon_p1(p1_pokemon), 
                           .pokemon_p2(p2_pokemon), 
                           .player_option(player_option), 
                           .hp_p2(hp_p2), 
                           .SP_p1(SP_p1), 
                           .SP_p2(SP_p2), 
                           .x(x_2), 
                           .y(y_2), 
                           .currPlyr(currPlyr), 
                           .pixel_data_2(pixel_data_interface), 
                           .reset(reset), 
                           .skill_p1(skill_p1), 
                           .skill_p2(skill_p2), 
                           .state(interface_state), 
                           .valid_states(valid_states),
                           .end_animation(end_battle_animations));
                     
    wire [15:0] pixel_data_hp_sp_status1, pixel_data_hp_sp_status2;
    wire end_game_p1, end_game_p2, skill_B_available_p1, skill_B_available_p2, opp_skill_B_available_p1, opp_skill_B_available_p2;
    wire resetV2 = (game_start==0) || reset;
    hp_sp_status player1 (.basys_clk(clk), 
                          .my_skill(skill_p1), 
                          .opp_skill(skill_p2), 
                          .reset(resetV2), 
                          .x(x_2), 
                          .y(y_2), 
                          .final_pixel_data(pixel_data_hp_sp_status1),
                          .HP_Level(hp_p1), 
                          .SP_Level(SP_p1), 
                          .end_game(end_game_p1), 
                          .opp_end_game(end_game_p2),
                          .skill_B_available(skill_B_available_p1),
                          .opp_skill_B_available (opp_skill_B_available_p1),
                          .endanimations(end_battle_animations)); 
                          
                          
    hp_sp_status player2 (.basys_clk(clk), 
                          .my_skill(skill_p2), 
                          .opp_skill(skill_p1), 
                          .reset(resetV2), 
                          .x(x_2), 
                          .y(y_2), 
                          .final_pixel_data(pixel_data_hp_sp_status2),
                          .HP_Level(hp_p2), 
                          .SP_Level(SP_p2), 
                          .end_game(end_game_p2),
                          .opp_end_game(end_game_p1),
                          .skill_B_available(skill_B_available_p2),
                          .opp_skill_B_available (opp_skill_B_available_p2),.endanimations(end_battle_animations));                     
    
    //led to be debugged
    wire start_ani; 
    led_control led1 (.clk(clk), .reset(reset), .currPlyr(currPlyr), .valid_states(valid_states) ,.gamestart(game_start),.led(led_battle),.startani(start_ani));
    seven_seg seg1 (.clk(clk), 
                    .currPlyr(currPlyr), 
                    .an(an_battle), 
                    .seg(seg_battle));
    
    reg [2:0] skill;
    
    pokemon_animation player1_ani (.clk_100MHz(clk),   
                       .skill(skill),  
                       .pixel_index(pixel_index_1), 
                       .pixel_out(pixel_data_animations),
                       .choice1(p1_pokemon),
                       .choice2(p2_pokemon),
                       .start_turn(currPlyr),
                       .end_animation(end_battle_animations),
                       .start_ani(start_ani) ) ;
                       
                       wire [15:0]pixel_data_endscreen;
    end_screen(.clk(clk), .x(x_2), .y(y_2), .endgame_p1(end_game_p1), .endgame_p2(end_game_p2),.pixel_data(pixel_data_endscreen));
                       
                       

    
    //global fsm
    
    localparam [1:0] start = 2'b00, game = 2'b01, over = 2'b10;
    reg [1:0] state = 2'b00;
    reg [31:0] counter_endscreen = 0;
    localparam [31:0] countercounter = 32'd2999999999;
    always @ (posedge clk) begin
        
        if (reset) begin 
            state <= start;
            game_end <= 0;
            led <= 0;
            an <= 4'hf;
            seg <= 8'hff;
        end
        
        case (state)
            start: 
            begin 
                led <= 0 ;
                game_end <= 0;
                pixel_data_1 = pixel_data_pokichoice;
                pixel_data_2 = pixel_data_init;
                state <= game_start ? game : start;
            end
            game:
            begin
                pixel_data_1 = pixel_data_animations;
                if (!(interface_state == 5'b00000 || interface_state == 5'b00001 || interface_state == 5'b00010 || 
                    interface_state == 5'b00011 || interface_state == 5'b00100 || interface_state == 5'b00101)) pixel_data_2 = pixel_data_interface;
                else begin 
                    if (x_2 >= 0 && x_2 <= 75 && y_2 >= 0 && y_2 <= 40) begin
                        if ( (sw==0 && currPlyr == 0) || (sw==1&&currPlyr == 1) ) begin
                            pixel_data_2 = pixel_data_hp_sp_status1;
                        end else if ((sw==0 && currPlyr == 1) || (sw==1&&currPlyr == 0)) begin
                            pixel_data_2 = pixel_data_hp_sp_status2;
                        end
//                        pixel_data_2 = (sw_hp_sp == 0) ? pixel_data_hp_sp_status1 : pixel_data_hp_sp_status2;
                    end
                    else pixel_data_2 = pixel_data_interface;
                end
                if (currPlyr ==0) begin 
                    skill = skill_p1;
                end
                else if (currPlyr==1) begin
                    skill = skill_p2;
                end
               led <= led_battle;
                an <= an_battle;
                seg <= seg_battle;
//                state <=  ? end : state; // to include end logic
                
                state <= (end_game_p1 || end_game_p2) ? over : (reset ? start:state); 
            end
            over:
            begin
                pixel_data_2 = pixel_data_endscreen;
                if ( (counter_endscreen == countercounter) ||
                    ( debounced_btnU || debounced_btnC || debounced_btnD || debounced_btnL ||debounced_btnR) ) begin
                          state = start;
                          game_end <= 1;
                          counter_endscreen <=0;
                          pixel_data_2 = pixel_data_init;
                end
                counter_endscreen <= counter_endscreen +1;
                an <= 4'hf;
                seg <= 8'hff;
                led <= 0;
            end
        endcase
    end
    
endmodule


