`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 22:06:18
// Design Name: 
// Module Name: Font_5X7_LUT
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


module Font_5X7_LUT(
    input  [31:0] ASCII,
    input  [4:0] Current_Row,  // we only use 0..6 in practice
    output reg [4:0] row_pattern = 0
);
                     
    always @(*) begin
        case(ASCII)

            //--------------------------------
            // 'L' = ASCII 76 (already in your code)
            //--------------------------------
            32'd76: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b10000;
                    5'd1: row_pattern = 5'b10000;
                    5'd2: row_pattern = 5'b10000;
                    5'd3: row_pattern = 5'b10000;
                    5'd4: row_pattern = 5'b10000;
                    5'd5: row_pattern = 5'b10000;
                    5'd6: row_pattern = 5'b11111;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'O' = ASCII 79
            //  01110
            //  10001
            //  10001
            //  10001
            //  10001
            //  10001
            //  01110
            //--------------------------------
            32'd79: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b01110;
                    5'd1: row_pattern = 5'b10001;
                    5'd2: row_pattern = 5'b10001;
                    5'd3: row_pattern = 5'b10001;
                    5'd4: row_pattern = 5'b10001;
                    5'd5: row_pattern = 5'b10001;
                    5'd6: row_pattern = 5'b01110;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'W' = ASCII 87
            //  10001
            //  10001
            //  10001
            //  10101
            //  10101
            //  11011
            //  10001
            //--------------------------------
            32'd87: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b10001;
                    5'd1: row_pattern = 5'b10001;
                    5'd2: row_pattern = 5'b10001;
                    5'd3: row_pattern = 5'b10101;
                    5'd4: row_pattern = 5'b10101;
                    5'd5: row_pattern = 5'b11011;
                    5'd6: row_pattern = 5'b10001;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'H' = ASCII 72
            //  10001
            //  10001
            //  10001
            //  11111
            //  10001
            //  10001
            //  10001
            //--------------------------------
            32'd72: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b10001;
                    5'd1: row_pattern = 5'b10001;
                    5'd2: row_pattern = 5'b10001;
                    5'd3: row_pattern = 5'b11111;
                    5'd4: row_pattern = 5'b10001;
                    5'd5: row_pattern = 5'b10001;
                    5'd6: row_pattern = 5'b10001;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'E' = ASCII 69
            //  11111
            //  10000
            //  10000
            //  11110
            //  10000
            //  10000
            //  11111
            //--------------------------------
            32'd69: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b11111;
                    5'd1: row_pattern = 5'b10000;
                    5'd2: row_pattern = 5'b10000;
                    5'd3: row_pattern = 5'b11110;
                    5'd4: row_pattern = 5'b10000;
                    5'd5: row_pattern = 5'b10000;
                    5'd6: row_pattern = 5'b11111;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'A' = ASCII 65
            //  01110
            //  10001
            //  10001
            //  11111
            //  10001
            //  10001
            //  10001
            //--------------------------------
            32'd65: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b01110;
                    5'd1: row_pattern = 5'b10001;
                    5'd2: row_pattern = 5'b10001;
                    5'd3: row_pattern = 5'b11111;
                    5'd4: row_pattern = 5'b10001;
                    5'd5: row_pattern = 5'b10001;
                    5'd6: row_pattern = 5'b10001;
                    default: row_pattern = 5'b00000;
                endcase
            end

            //--------------------------------
            // 'T' = ASCII 84
            //  11111
            //  00100
            //  00100
            //  00100
            //  00100
            //  00100
            //  00100
            //--------------------------------
            32'd84: begin
                case(Current_Row)
                    5'd0: row_pattern = 5'b11111;
                    5'd1: row_pattern = 5'b00100;
                    5'd2: row_pattern = 5'b00100;
                    5'd3: row_pattern = 5'b00100;
                    5'd4: row_pattern = 5'b00100;
                    5'd5: row_pattern = 5'b00100;
                    5'd6: row_pattern = 5'b00100;
                    default: row_pattern = 5'b00000;
                endcase
            end

            32'd33: begin  // '!' 
              case (Current_Row)
                5'd0: row_pattern = 5'b00100;  // row 0
                5'd1: row_pattern = 5'b00100;
                5'd2: row_pattern = 5'b00100;
                5'd3: row_pattern = 5'b00100;
                5'd4: row_pattern = 5'b00100;
                5'd5: row_pattern = 5'b00000;
                5'd6: row_pattern = 5'b00100;
                default: row_pattern = 5'b00000;
               endcase
             end
             //--------------------------------
             // 'C' = ASCII 67
             //   01110
             //   10001
             //   10000
             //   10000
             //   10000
             //   10001
             //   01110
             //--------------------------------
             32'd67: begin
                 case(Current_Row)
                     5'd0: row_pattern = 5'b01110;
                     5'd1: row_pattern = 5'b10001;
                     5'd2: row_pattern = 5'b10000;
                     5'd3: row_pattern = 5'b10000;
                     5'd4: row_pattern = 5'b10000;
                     5'd5: row_pattern = 5'b10001;
                     5'd6: row_pattern = 5'b01110;
                     default: row_pattern = 5'b00000;
                 endcase
             end
             
             //--------------------------------
             // 'D' = ASCII 68
             //   11110
             //   10001
             //   10001
             //   10001
             //   10001
             //   10001
             //   11110
             //--------------------------------
             32'd68: begin
                 case(Current_Row)
                     5'd0: row_pattern = 5'b11110;
                     5'd1: row_pattern = 5'b10001;
                     5'd2: row_pattern = 5'b10001;
                     5'd3: row_pattern = 5'b10001;
                     5'd4: row_pattern = 5'b10001;
                     5'd5: row_pattern = 5'b10001;
                     5'd6: row_pattern = 5'b11110;
                     default: row_pattern = 5'b00000;
                 endcase
             end
             
             //--------------------------------
             // 'N' = ASCII 78
             //   10001
             //   11001
             //   10101
             //   10011
             //   10001
             //   10001
             //   10001
             //--------------------------------
             32'd78: begin
                 case(Current_Row)
                     5'd0: row_pattern = 5'b10001;
                     5'd1: row_pattern = 5'b11001;
                     5'd2: row_pattern = 5'b10101;
                     5'd3: row_pattern = 5'b10011;
                     5'd4: row_pattern = 5'b10001;
                     5'd5: row_pattern = 5'b10001;
                     5'd6: row_pattern = 5'b10001;
                     default: row_pattern = 5'b00000;
                 endcase
             end

            //--------------------------------
            // Default for chars not defined
            //--------------------------------
            default: begin
                row_pattern = 5'b00000;
            end
        endcase
    end
endmodule
