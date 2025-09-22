`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 22:03:50
// Design Name: 
// Module Name: picopixel_LUT
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


module picopixel_LUT(
    input [31:0] ASCII,
    input [2:0] Current_Row,          // Changed to 3 bits (0-7 is enough for a 5-row font)
    output reg [2:0] row_pattern = 0    // Changed to 3 bits as our pattern is 3 bits wide
);
                     
    always @(*) begin
        case(ASCII)
            32'd72: begin  // ASCII for 'H'
                case(Current_Row)
                    3'd0: row_pattern = 3'b101;
                    3'd1: row_pattern = 3'b101;
                    3'd2: row_pattern = 3'b111;
                    3'd3: row_pattern = 3'b101;
                    3'd4: row_pattern = 3'b101;
                    default: row_pattern = 3'b000;
                endcase
            end
            
            //ASCII for P
            32'd80: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b110;
                    3'd1: row_pattern = 3'b101;
                    3'd2: row_pattern = 3'b110;
                    3'd3: row_pattern = 3'b100;
                    3'd4: row_pattern = 3'b100;
                    default: row_pattern = 3'b000;   
                endcase
            end
            
            //ASCII for 1
            32'd49: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b001;
                    3'd1: row_pattern = 3'b011;
                    3'd2: row_pattern = 3'b001;
                    3'd3: row_pattern = 3'b001;
                    3'd4: row_pattern = 3'b001;
                    default: row_pattern = 3'b000;   
                endcase
            end

            //ASCII for 6
            32'd54: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b010;
                    3'd1: row_pattern = 3'b100;
                    3'd2: row_pattern = 3'b110;
                    3'd3: row_pattern = 3'b101;
                    3'd4: row_pattern = 3'b010;
                    default: row_pattern = 3'b000;   
                endcase
            end
            
            //ASCII for slash
            32'd47: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b001;
                    3'd1: row_pattern = 3'b001;
                    3'd2: row_pattern = 3'b010;
                    3'd3: row_pattern = 3'b100;
                    3'd4: row_pattern = 3'b100;
                    default: row_pattern = 3'b000;   
                endcase
            end
            
            //ASCII for S
            32'd83: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b011;
                    3'd1: row_pattern = 3'b100;
                    3'd2: row_pattern = 3'b010;
                    3'd3: row_pattern = 3'b001;
                    3'd4: row_pattern = 3'b110;
                    default: row_pattern = 3'b000;   
                endcase
            end 
            
            //ASCII for 0
            32'd48: begin
                case(Current_Row)
                    3'd0: row_pattern = 3'b010;
                    3'd1: row_pattern = 3'b101;
                    3'd2: row_pattern = 3'b101;
                    3'd3: row_pattern = 3'b101;
                    3'd4: row_pattern = 3'b010;
                    default: row_pattern = 3'b000;   
                endcase
            end 
            
         // ASCII for '2' = 32'd50
            32'd50: begin  // '2'
                case (Current_Row)
                    3'd0: row_pattern = 3'b011; // row0 = center+right 
                    3'd1: row_pattern = 3'b001; // row1 = right 
                    3'd2: row_pattern = 3'b010; // row2 = center 
                    3'd3: row_pattern = 3'b100; // row3 = left 
                    3'd4: row_pattern = 3'b111; // row4 = left+center+right
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '3' = 32'd51
            32'd51: begin  // '3'
                case (Current_Row)
                    3'd0: row_pattern = 3'b011; // row0 = center+right
                    3'd1: row_pattern = 3'b001; // row1 = right
                    3'd2: row_pattern = 3'b011; // row2 = center+right
                    3'd3: row_pattern = 3'b001; // row3 = right
                    3'd4: row_pattern = 3'b011; // row4 = center+right
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '4' = 32'd52
            32'd52: begin  // '4'
                case (Current_Row)
                    3'd0: row_pattern = 3'b101; // row0 = left+right
                    3'd1: row_pattern = 3'b101; // row1 = left+right
                    3'd2: row_pattern = 3'b111; // row2 = left+center+right
                    3'd3: row_pattern = 3'b001; // row3 = right
                    3'd4: row_pattern = 3'b001; // row4 = right
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '5' = 32'd53
            32'd53: begin  // '5'
                case (Current_Row)
                    3'd0: row_pattern = 3'b111; // row0 = left+center+right
                    3'd1: row_pattern = 3'b100; // row1 = left
                    3'd2: row_pattern = 3'b110; // row2 = left+center
                    3'd3: row_pattern = 3'b001; // row3 = right
                    3'd4: row_pattern = 3'b110; // row4 = left+center
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '7' = 32'd55
            32'd55: begin  // '7'
                case (Current_Row)
                    3'd0: row_pattern = 3'b111; // row0 = left+center+right
                    3'd1: row_pattern = 3'b001; // row1 = right
                    3'd2: row_pattern = 3'b001; // row2 = right
                    3'd3: row_pattern = 3'b001; // row3 = right
                    3'd4: row_pattern = 3'b001; // row4 = right
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '8' = 32'd56
            32'd56: begin  // '8'
                case (Current_Row)
                    3'd0: row_pattern = 3'b010; // row0 = center
                    3'd1: row_pattern = 3'b101; // row1 = left+right
                    3'd2: row_pattern = 3'b111; // row2 = left+center+right
                    3'd3: row_pattern = 3'b101; // row3 = left+right
                    3'd4: row_pattern = 3'b010; // row4 = center
                    default: row_pattern = 3'b000;
                endcase
            end
            
            // ASCII for '9' = 32'd57
            32'd57: begin  // '9'
                case (Current_Row)
                    3'd0: row_pattern = 3'b010; // row0 = center
                    3'd1: row_pattern = 3'b101; // row1 = left+right
                    3'd2: row_pattern = 3'b011; // row2 = center+right
                    3'd3: row_pattern = 3'b001; // row3 = right
                    3'd4: row_pattern = 3'b010; // row4 = center
                    default: row_pattern = 3'b000;
                endcase
            end
                                
            default: begin
                row_pattern = 3'b000;  // Default for characters not defined
            end
        endcase
    end
endmodule
