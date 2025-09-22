`timescale 1ns / 1ps
module SCLK_generator(input clk,enable,
                      input [7:0] half_period,
                      output SCLK);
                      
                      
                      reg SCLK_C = 0;
                      assign SCLK = SCLK_C;
                      
                      reg [7:0] counter = 0;
                      
                      always @(posedge clk) begin
                        if (!enable) begin
                            SCLK_C <= 0;
                            counter <= 0;
                        end 
                        else if (enable) begin
                            if (counter >= half_period) begin
                                SCLK_C <= ~SCLK_C;
                                counter <= 0;
                            end
                            else if (counter < half_period ) begin
                                counter <= counter + 1;
                            end
                        end 
                      end
endmodule