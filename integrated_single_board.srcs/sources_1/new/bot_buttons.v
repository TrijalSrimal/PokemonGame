`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 10:57:52
// Design Name: 
// Module Name: bot_buttons
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


module bot_buttons(input clk, currPlyr, input [2:0] skill, output reg btnU, btnD, btnL, btnR, btnC);

    reg [31:0] count_2hz = 0;
    reg [3:0] count = 0;
    always @ (posedge clk) begin
        btnU <= 0;
        btnD <= 0;
        btnL <= 0;
        btnR <= 0;
        btnC <= 0;
        
        count_2hz = (count_2hz == 49999999) ? 0 : count_2hz + 1;
        
        if (currPlyr == 1 && count_2hz == 0) begin
            case(skill)
                3'b000:;
                
                3'b001:
                begin
                    count <= count + 1;
                    if (count == 1) btnD <= 1;
                    else if (count == 2) begin
                        btnD <= 0;
                        btnC <= 1;
                    end
                    else if (count == 3) begin
                        btnC <= 0;
                        btnD <= 1;
                    end
                    else if (count == 4) begin
                        btnD <= 0;
                        btnC <= 1;
                        count <= 0;
                    end
                end
                
                3'b010:
                begin
                    count <= count + 1;
                    if (count == 1 || count == 2) btnD <= 1;
                    else if (count == 3) begin
                        btnD <= 0;
                        btnC <= 1;
                    end  
                    else if (count == 4) begin
                        btnC <= 0;
                        btnD <= 1;
                    end
                    else if (count == 5) begin
                        btnD <= 0;
                        btnC <= 1;
                        count <= 0;
                    end
                end
                
                3'b011:
                begin
                    count <= count + 1;
                    if (count == 1) btnD <= 1;
                    else if (count == 2) begin
                        btnD <= 0;
                        btnR <= 1;
                    end
                    else if (count == 3) begin
                        btnR <= 0;
                        btnC <= 1;
                    end
                    else if (count == 4) begin
                        btnC <= 0;
                        btnD <= 1;
                    end
                    else if (count == 5) begin
                        btnD <= 0;
                        btnC <= 1;
                        count <= 0;
                    end
                end
                
                3'b100:
                begin
                    count <= count + 1;
                    if (count == 1) btnD <= 1;
                    else if (count == 2) begin
                        btnD <= 0;
                        btnR <= 1;
                    end
                    else if (count == 3) begin
                        btnR <= 0;
                        btnD <= 1;
                    end
                    else if (count == 4) begin
                        btnD <= 0;
                        btnC <= 1;
                    end
                    else if (count == 5) begin
                        btnC <= 0;
                        btnD <= 1;
                    end
                    else if (count == 6) begin
                        btnD <= 0;
                        btnC <= 1;
                        count <= 0;
                    end
                end
            endcase
        end
    end

endmodule
