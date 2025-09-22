`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 10:53:25
// Design Name: 
// Module Name: bot
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


module bot(input clk, input currPlyr, input reset, input [4:0] bot_hp, input [3:0] bot_sp, input [5:0] current_round, 
           output reg [2:0] selected_skill);

    localparam IDLE = 3'b000;
    localparam TACKLE = 3'b001;
    localparam SPECIAL = 3'b010;
    localparam HEAL = 3'b011;
    localparam PASS = 3'b100;

    localparam AGGRESSIVE = 2'b00;
    localparam DEFENSIVE = 2'b01;
    localparam CAUTIOUS = 2'b10;
    localparam OPPORTUNIST = 2'b11;
    
    reg [1:0] personality = 0;

    always @ (posedge clk) begin
        if (reset == 1) begin
            personality <= personality + 1'b1;
        end
    
        if (currPlyr == 0) selected_skill = IDLE;
        else begin
            case (personality)
                AGGRESSIVE: begin
                    if (bot_hp <= 6 && bot_sp >= 5)
                        selected_skill = HEAL; // Emergency heal to stay in the fight
                    else if (bot_sp >= 5 && bot_hp > 6)
                        selected_skill = SPECIAL; // Big damage when safe
                    else if (bot_sp >= 1 && bot_hp > 8 && current_round[0])
                        selected_skill = TACKLE; // Light poke if healthy
                    else
                        selected_skill = PASS; // Otherwise save SP
                end
            
                DEFENSIVE: begin
                    if (bot_hp <= 8)
                        selected_skill = (bot_sp >= 5) ? HEAL : PASS; // Prioritize healing when low
                    else if (bot_sp >= 1 && current_round[0])
                        selected_skill = TACKLE; // Opportunistic strike
                    else
                        selected_skill = PASS;
                end
            
                CAUTIOUS: begin
                    if (bot_hp <= 4 && bot_sp >= 5)
                        selected_skill = HEAL; // Heal only if in danger and affordable
                    else if (bot_sp >= 5 && bot_hp > 4)
                        selected_skill = SPECIAL; // Strategic power hit
                    else
                        selected_skill = PASS; // Rarely attacks otherwise
                end
            
                OPPORTUNIST: begin
                    if (bot_sp >= 5 && (bot_hp > 4 || current_round[0]))
                        selected_skill = SPECIAL; // Use SP early when safer
                    else if (bot_hp <= 6 && bot_sp >= 5)
                        selected_skill = HEAL; // Heal when low
                    else if (bot_sp >= 1 && bot_hp > 10 && current_round[0])
                        selected_skill = TACKLE; // Only tackle when very healthy
                    else
                        selected_skill = PASS;
                end
            endcase
        end        
    end
    
endmodule
