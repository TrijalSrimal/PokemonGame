`timescale 1ns / 1ps
module debouncer(input clk, input btn_in, output reg btn_out);

    reg [17:0] counter = 0;  
    reg stable_state = 0;   
    reg btn_last = 0;       

    always @(posedge clk) begin
        if (btn_in == stable_state) begin
            counter <= 0; 
        end else begin
            counter <= counter + 1;
            if (counter >= 100000) begin //1ms
                stable_state <= btn_in;  
                counter <= 0;
            end
        end
    end

    always @(posedge clk) begin
        btn_out <= (stable_state && !btn_last); 
        btn_last <= stable_state;
    end
    
endmodule
