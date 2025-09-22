`timescale 1ns / 1ps
module spi_master(input clk, start,
                  input [17:0] data_in,
                  output reg MOSI = 0,
                  input wire MISO,
                  output SCLK,
                  output reg SS = 0,
                  output reg done = 0,
                  output reg [17:0] received_data = 17'd0 );
                  
                  
                  
                  reg [17:0] received_data_intermediary = 17'd0;
                  reg [17:0] bit_count = 0; // bit count is to keep track of number of bits sent serially on the MOSI line
                  reg [17:0] shift_reg = 0; // A register to hold the values that must be sent serially by converting them from parallel 
                  
                  wire enable;
                  reg [7:0] half_period = 2;
                  SCLK_generator my_SCLK (.clk(clk),
                                          .enable(enable),
                                          .half_period(half_period),
                                          .SCLK(SCLK));
                                          
                                                                                                              
                  /* Internal FSM
                  IDLE State: MOSI = 0, SCLK = 0 (CLP = 0)(CPHA = 0), SS = 1,
                  LOAD State (you can only transit to this state from idel): If you transit to Load state: 
                  1) change slave select to 0
                  2)load the data from data_in to shift register parallely
                  3) Set the bit count (the number of bits to be sent)
                  
                  You are good to proceed to next state
                  
                  SHIFT State: You can only proceed to this state after you have completed load state
                  
                  First enable the SCLK (Remember to instantiate the SCLK generator)
                  
                  You need to look for rising edge and falling edge of the SCLK. Data will be sampled on the falling edge, so you need to look for SCLK = 1 and then send the MSB bit at that time.
                  Otherwise, prepare for the next MSB bit
                  
                  
                  */
                  
                  //Detect SCLK edges
                  reg old_SCLK = 0;
                  always @(posedge clk) begin
                    old_SCLK <= SCLK; //Remembers the old state
                  end
                  
                  //Use Concurrent Assignment to check for changes in edge
                  wire rising_edge = (!old_SCLK && SCLK);
                  wire falling_edge = (old_SCLK && !SCLK);
                  
                  //FSM STARTS HERE
                  
                  localparam IDLE          = 3'd0;
                  localparam LOAD          = 3'd1;
                  localparam PRESHIFT      = 3'd2; //Preshift is to let first rising edge pass through
                  localparam SHIFT         = 3'd3; 
                  localparam POSTSHIFT     = 3'd4; // Post shift is to wait for final rising edge to happen
                  localparam DONE          = 3'd5;
                  
                  reg [3:0] states = 0;
                  
                  //Enabling SCLK whenver SHIFT state is reached
                  assign enable = ((states == PRESHIFT) | (states == SHIFT) | (states == POSTSHIFT))? 1: 0; 
                  
                  always @(posedge clk) begin
                    case(states)
                        IDLE: begin
                                SS   <= 1;
                                MOSI <= 0;
                                //SCLK <= 0; //Multi driven net error cause this output is being controlled by a module
                                done <= 0;
                                
                                //Condition to change to load staet
                                if (start) begin
                                    states <= LOAD;                                   
                                end
                                else if (~start) begin
                                    states <= IDLE;
                                end
                              end
                              
                        LOAD: begin
                                //Store the parallel data into shift register
                                shift_reg <= data_in;
                                
                                //Select the slave
                                SS <= 0;
                                
                                //Set the number of bits to be transferred
                                bit_count <= 17'd17;
                                
                                //Automatically change to next state
                                states <= PRESHIFT;
                                
                              end
                        
                       PRESHIFT:begin
                                    if (rising_edge) begin
                                        states <= SHIFT;
                                    end
                                end
                              
                       SHIFT: begin
                                //Enable the SCLK (already done at the combinational level)
                                //enable <= 1; //if you enable the clock here it will become a latch
                                
                                //Detect Rising Edge  and Falling edge
                                // When it is about to go falling edge, the SCLK is 1
                                
                                //if (SCLK == 1) begin // If you check for SCLK == 1 under posedge basys_clk, this condition maybe true for more than a cycle. So it will carry out the operations below repeatedly.
                                if (falling_edge) begin
                                    //Send MSB bit to MOSI and then concatenation rest of the bits
                                    MOSI <= shift_reg[17];
                                    received_data_intermediary <= {received_data_intermediary[16:0], MISO};
                                  
                                                                                                                                          
                                end 
                                
                                else if (rising_edge) begin
                                   bit_count <= bit_count - 1;        //Shift to the left by 1 bit for the new msb
                                   shift_reg <= shift_reg << 1'b1;
                                   
                                   //Condition for change in states
                                   states <= (bit_count == 0)? POSTSHIFT: SHIFT; 
                                end
                                  
                              end
                              
                              
                        POSTSHIFT: begin
                                     //Receiving the last bit from slave
                                     if (rising_edge) begin
                                        received_data_intermediary <= {received_data_intermediary[16:0], MISO};
                                        states <= DONE;
                                     end
                                   end  
                                        
                        DONE: begin
                                SS   <= 1;
                                MOSI <= 0;
                                done <= 1;
                                
                                //Change states
                                states <= (start == 1)? LOAD: IDLE;
                              end  
                              
                        default: states <= IDLE;         
                    endcase
                  end
                  
                  always @(posedge done) begin
                    received_data <= received_data_intermediary;
                  end  
endmodule