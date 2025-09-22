`timescale 1ns / 1ps
//edit skill logic in sub modules
module hp_sp_status(input basys_clk,
    input [2:0] my_skill,
     opp_skill,
    input reset,
    input [6:0] x, y,
    input opp_end_game,
    input opp_skill_B_available,
    output [15:0] final_pixel_data,
    output [3:0] HP_Level,
    output [3:0] SP_Level,
    output end_game,
    output skill_B_available, input endanimations
    );
    
    wire my_skill_A, my_skill_B, my_heal, my_pass, opp_skill_A, opp_skill_B;
    assign my_skill_A = (3'b001 == my_skill); //tackle 
    assign my_skill_B = (3'b010 == my_skill); //special
    assign my_heal = (3'b011 == my_skill);
    assign my_pass = (3'b100 == my_skill);
     
    assign opp_skill_A = (3'b001 == opp_skill);
    assign opp_skill_B = (3'b010 == opp_skill);
     
    
    // HP & SP logic
    HP_AND_SKILL hp_control(
        .clk   (basys_clk),
        .my_heal  (my_heal),
        .my_skill_A  (my_skill_A),
        .my_skill_B  (my_skill_B),
        .my_pass  (my_pass),
        .opp_skill_A (opp_skill_A),
        .opp_skill_B (opp_skill_B),
        .reset (reset),
        .NEW_HP(HP_Level),
        .NEW_SP(SP_Level),
        .end_game(end_game),
        .opp_end_game(opp_end_game)
//        .skill_B_available(skill_B_available)
    );    

    // Normal HP/SP screen logic
    wire [15:0] my_HP_SP_Status_Screen_Pixel_data;
    HP_SP_Status_Screen my_HP_SP_Status_Screen(
        .basys_clk(basys_clk),
        .x_8bit(x),
        .y_8bit(y),
        .HP_Level(HP_Level),
        .SP_Level(SP_Level),
        .pixel_data_output(my_HP_SP_Status_Screen_Pixel_data)
    );

    // Low Health screen
    wire [15:0] Low_Health_Warning_Pixel_data;
    Low_Health_Status_Screen my_Low_Health_Status_Screen(
        .basys_clk(basys_clk),
        .x_8bit(x),
        .y_8bit(y),
        .pixel_data_output(Low_Health_Warning_Pixel_data)
    );

    // cooldown warning
    wire [15:0] cooldown_warning;
    skillB_cooldown_screen my_skillB_cooldown_Screen(
        .basys_clk(basys_clk),
        .x_8bit(x),
        .y_8bit(y),
        .pixel_data_output(cooldown_warning)
    );

    // 2Hz BLINK for 5s if HP<5
    localparam HP_THRESHOLD = 5;

    // Count edges to produce 2Hz toggling
    // basys_clk is 100MHz 
    localparam integer TOGGLE_MAX = 25_000_000; 
    reg [31:0] toggle_counter = 0;
    reg blink_on = 0;

    // We'll have an FSM that does 5s => 5s * 2 toggles per second => 10 toggles
    localparam integer TOTAL_TOGGLES = 2 * 3; // 10 toggles for 5 seconds

    reg [3:0] blink_toggle_count = 0; 

    // States
    localparam S_NORMAL = 0;
    localparam S_BLINK  = 1;
    localparam S_DONE   = 2;
    //reg blinked_once = 0;
               
    reg [3:0] blink_state = S_NORMAL;


always @(posedge basys_clk) begin
    case(blink_state)
        S_NORMAL: begin
            blink_on <= 0;
            if ((HP_Level < HP_THRESHOLD) && (endanimations ==1) ) begin
                blink_state <= S_BLINK;
                blink_toggle_count <= 0;
                toggle_counter <= 0;
                blink_on <= 1;
            end
        end
        
        S_BLINK: begin
            if (toggle_counter < TOGGLE_MAX) begin
                toggle_counter <= toggle_counter + 1;
                end 
            else begin
                toggle_counter <= 0;
                blink_on <= ~blink_on;
                blink_toggle_count <= blink_toggle_count + 1;
                if (blink_toggle_count == (TOTAL_TOGGLES - 1)) begin
                    // Done blinking once
                    blink_state <= S_DONE;
                    blink_on <= 0;
                end
            end
        end
        
        S_DONE: begin
            // If HP still <3, remain here, no more blinking
            // If HP recovers >=3, go back to NORMAL
            if (HP_Level >= HP_THRESHOLD) begin
               blink_state <= S_NORMAL;
            end else if (HP_Level < HP_THRESHOLD)begin
                blink_state <= S_DONE;
            end
            
        end
    endcase
end


//    // Count edges to produce 2Hz toggling
//    // basys_clk is 100MHz 
//    reg [31:0] toggle_counter_cooldown = 0;
//    reg blink_on_cooldown = 0;

//    // We'll have an FSM that does 5s => 5s * 2 toggles per second => 10 toggles
//    localparam integer TOTAL_TOGGLES_cooldown = 2 * 2; // 10 toggles for 5 seconds

//    reg [3:0] blink_toggle_count_cooldown = 0; 

//    // States
//    localparam S_NORMAL_cooldown = 0;
//    localparam S_BLINK_cooldown  = 1;
//    localparam S_DONE_cooldown   = 2;
//    //reg blinked_once = 0;
               
//    reg [3:0] blink_state_cooldown = S_NORMAL;


//always @(posedge basys_clk) begin
////    case(blink_state_cooldown)
////        S_NORMAL_cooldown: begin
////            blink_on_cooldown <= 0;
////            if (~skill_B_available && opp_skill_B) begin
////                blink_state_cooldown <= S_BLINK_cooldown;
////                blink_toggle_count_cooldown <= 0;
////                toggle_counter_cooldown <= 0;
////                blink_on_cooldown <= 1;
////            end
////        end
        
////        S_BLINK_cooldown: begin
////            if (toggle_counter_cooldown < TOGGLE_MAX) begin
////                toggle_counter_cooldown <= toggle_counter_cooldown + 1;
////                end 
////            else begin
////                toggle_counter_cooldown <= 0;
////                blink_on_cooldown <= ~blink_on_cooldown;
////                blink_toggle_count_cooldown <= blink_toggle_count_cooldown + 1;
////                if (blink_toggle_count_cooldown == (TOTAL_TOGGLES_cooldown - 1)) begin
////                    // Done blinking once
////                    blink_state_cooldown <= S_DONE_cooldown;
////                    blink_on_cooldown <= 0;
////                end
////            end
////        end
        
////        S_DONE_cooldown: begin
////            if (~opp_skill_B) begin
////                blink_state_cooldown <= S_NORMAL_cooldown;
////            end

            
////        end
////    endcase
//end

    // If in BLINK state, show Low_Health_Warning at 2Hz
    // if blink_on=1 => show "LOW HEALTH!!", else show black or HP screen
    // We'll choose to show "LOW HEALTH" only when blink_on=1, else show normal HP bars

    reg [15:0] pixel_data_reg;
    always @(*) begin
        if (blink_state == S_BLINK) begin
            if (blink_on) 
                pixel_data_reg = Low_Health_Warning_Pixel_data;
            else 
                pixel_data_reg = 16'h0000; // or HP_SP if you prefer
     end
// else if (blink_state_cooldown == S_BLINK_cooldown) begin
//            if (blink_on_cooldown) 
//                pixel_data_reg = cooldown_warning;
//            else begin
//                pixel_data_reg = 16'h0000; // or HP_SP if you prefer 
//            end                                 
//        end
        
        else begin
            // normal
            pixel_data_reg = my_HP_SP_Status_Screen_Pixel_data;
        end
    end

    assign final_pixel_data = pixel_data_reg;

endmodule
