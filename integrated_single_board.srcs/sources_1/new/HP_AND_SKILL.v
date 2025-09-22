`timescale 1ns / 1ps
module HP_AND_SKILL(
    input clk,         // A clock input (e.g., 100 MHz from Basys)
    input my_heal,        // Increment HP (Heal)
    input my_skill_B,        // Decrement HP (SKill B/ Special skill) (required Damage probability)
    input reset,       // Synchronous reset
    input my_skill_A,        // Decrement HP (Skill A)
    input my_pass,
    input opp_skill_A,
    input opp_skill_B,
    input opp_end_game,
    output [3:0] NEW_HP, // 4-bit output (0 to 15)
    output [3:0] NEW_SP, //4-bit output (0 to 10)
    output reg end_game = 0
//    output skill_B_available
);
    reg my_skill_A_old = 0;
    reg opp_skill_A_old = 0;
    reg my_skill_B_old = 0;
    reg opp_skill_B_old = 0;
    reg my_pass_old = 0;
    reg my_heal_old = 0;
    reg [4:0] skill_B_cooldown = 0;
    
    reg [3:0] hp_reg = 4'd15;
    reg [3:0] sp_reg = 4'd2;

    assign NEW_HP = hp_reg;
    assign NEW_SP = sp_reg;
    
    //variable timer for cooldown
    reg start_skill_B_cooldown_countdown = 0;
    reg [15:0] seconds = 10;
//    variable_timer my_variable_timer(.clk(clk),
//                                     .start(start_skill_B_cooldown_countdown),
//                                     .seconds_in(seconds),
//                                     .done(skill_B_available));
                                                                
    //Linear Feedback Shift Register to produce Probability
    reg [3:0] LSFR = 4'b1010;
    reg feedback = 0;
    
    always @(posedge clk) begin
        feedback <= LSFR[0] ^ LSFR [1];
        LSFR <= {LSFR[3:0], feedback};
    end 
    
    //Five second pulse for SP increase
    wire sp_increase;
    five_second_pulse sp_increase_pulse(.clk(clk),
                                        .rst(0),
                                        .pulse(sp_increase));
                                                    
    //MAIN                                                        
    always @(posedge clk) begin
//        start_skill_B_cooldown_countdown <= 0; //default state of cooldown countdown
//        if (hp_reg <= 0 || opp_end_game) begin 
//            end_game <= 1; //Double ensuring end game is 1
//        end 
                       
        if (reset) begin
            hp_reg <= 4'd15;
            sp_reg <= 4'd2;
            end_game <= 0;
//            start_skill_B_cooldown_countdown <= 0;
        end 
        else begin          
            if (my_heal && (my_heal != my_heal_old)) begin
                if (hp_reg >= 10) begin
                    hp_reg <= 15;
                    sp_reg <= sp_reg - 5;
                end else if (hp_reg < 10) begin
                    hp_reg <= hp_reg + 5;
                    sp_reg <= sp_reg - 5;
                end
//                hp_reg <= (hp_reg >= 5) ? 15 : hp_reg + 5;
//                sp_reg <= (sp_reg <= 10) ? 0 : sp_reg - 5;
            end
            //Sp_reg increment by 1 in 5s
//            else if (sp_increase) begin
//                if (sp_reg < 10) begin
//                    sp_reg <= sp_reg + 1;
//                end else if (sp_reg >= 10) begin
//                    sp_reg <= 10;
//                end
//            end
            
            else if (my_skill_A && (my_skill_A != my_skill_A_old)) begin
                 sp_reg <= (sp_reg <= 1) ? 0 : sp_reg - 1;
            end
            else if (my_skill_B && (my_skill_B != my_skill_B_old)) begin 
                sp_reg <= (sp_reg <= 2) ? 0 : sp_reg - 2;
            end    
            //else if (my_pass) sp_reg = (sp_reg >= 9) ? 10 : sp_reg + 1;
            else if (opp_skill_B && opp_skill_B != opp_skill_B_old) begin
                //check for availability of skill B
//                if (skill_B_available) begin
                        //start counting for cooldown perod
//                        start_skill_B_cooldown_countdown <= 1;
                        //Check for Special Skill Damage
//                        start_skill_B_cooldown_countdown <= 1; //Indicate start of countdown
                        if (LSFR >= 3'd3) begin
                            // Deal 2HP
                            //Check if hp is less than 2
                            if (hp_reg <= 4'd2) begin
                                hp_reg <= 0;
                                end_game <= 1;
                                end
                            else begin
                                hp_reg <= hp_reg - 2;
                                end                    
                            end
                        else if (LSFR < 3'd3) begin
                            //Deal 4HP
                            //Check if hp is less than 4
                            if (hp_reg <= 4'd4) begin
                                hp_reg <= 0;
                                end_game <= 1;
                                end
                            else begin
                                hp_reg <= hp_reg - 4;
                                end                     
                                              
                end else begin
                    //do nothing
                end

            end
            else if (opp_skill_A && opp_skill_A != opp_skill_A_old)begin
                if (hp_reg <= 4'd1) begin
                    hp_reg <= 0;
                    end_game <= 1;
                    end
                else hp_reg <= hp_reg - 1;                
            end  
            if ( (my_skill_A==0 && my_skill_A_old != 0) ||
                  (my_skill_B==0 && my_skill_B_old != 0) ||
                  (my_pass==0 && my_pass_old != 0) ||
                  (my_heal==0 && my_heal_old != 0)  ) 
                  
                  sp_reg <= (sp_reg>=9)? 10: sp_reg + 1; 
             
             
                      
       end
        
       my_skill_A_old     <=  my_skill_A;
       opp_skill_A_old    <=  opp_skill_A;
       my_skill_B_old     <=  my_skill_B;
       opp_skill_B_old    <=  opp_skill_B;
       my_pass_old        <=  my_pass;
       my_heal_old        <=  my_heal;
    end      

endmodule
