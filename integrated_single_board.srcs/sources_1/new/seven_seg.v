`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 14:08:52
// Design Name: 
// Module Name: seven_seg
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


module seven_seg(input clk, currPlyr, output reg [3:0] an = 4'b0111, output reg [7:0] seg);
    
    wire clk500hz;
    flex_clk clk1 (.clk(clk), .N(99999), .slow_clk(clk500hz));
    
    always @ (posedge clk500hz) begin
        an = {an[0], an[3:1]};        
        case(currPlyr)
            0: 
            begin
                case(an)
                    4'b0111: seg = 8'b11111111;
                    4'b1011: seg = 8'b11111111;
                    4'b1101: seg = 8'b10001100;
                    4'b1110: seg = 8'b11111001;
                endcase
            end
            1:
            begin
                case(an)
                    4'b0111: seg = 8'b11111111;
                    4'b1011: seg = 8'b11111111;
                    4'b1101: seg = 8'b10001100;
                    4'b1110: seg = 8'b10100100;
                endcase
            end
        endcase    
    end

endmodule
