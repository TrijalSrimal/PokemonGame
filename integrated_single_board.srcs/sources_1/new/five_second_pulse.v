`timescale 1ns / 1ps
module five_second_pulse (
    input  wire clk,   // 100 MHz clock
    input  wire rst,   // Synchronous reset
    output reg  pulse  // Goes high for 1 cycle every 5 seconds
);

    // 5 seconds × 100,000,000 (100 MHz) = 500,000,000 cycles
    // We'll count from 0 to 499,999,999 => total of 500,000,000 counts
    localparam integer MAX_COUNT = 500_000_000 - 1; // = 499,999,999

    // Enough bits to count up to ~500 million. 29 bits covers up to ~536 million.
    reg [28:0] count = 0;

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            pulse <= 0;
        end
        else begin
            if (count < MAX_COUNT) begin
                count <= count + 1;
                pulse <= 0;
            end
            else begin
                // Produce a single-cycle pulse
                pulse <= 1;

                // Reset the counter to restart the 5s interval
                count <= 0;
            end
        end
    end

endmodule
