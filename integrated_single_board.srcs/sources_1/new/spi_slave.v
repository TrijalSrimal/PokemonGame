`timescale 1ns / 1ps
module spi_slave #(
    parameter BITS = 18
)(
    input  wire        SCLK,    // SPI clock (from master)
    input  wire        SS,      // Slave Select, active low
    input  wire        MOSI,    // Master Out, Slave In
    input  wire        btnU,btnD,btnC,btnR,btnL,
    output reg         MISO,    // Master In, Slave Out
    output reg  [BITS-1:0]  data_out // Latches received bits
);


// For an 8-bit shift
reg [BITS-1:0] shift_reg_in = 0;
reg [BITS-1:0] shift_reg_out = 0; //Register hold value that is going to be sent through MISO
//reg [BITS-1:0] shift_reg_out_intermediary = 0; //Register hold value that is going to be sent through MISO
reg [5:0] bit_count = 0;  // counts 0..7

reg first_rising_edge = 0;

always @(posedge SCLK or posedge SS) begin
    if (SS) begin
        // When SS goes high, reset bit_count
        // and we could also latch final data if needed
        bit_count  <= 0;
        shift_reg_in <= 0;
        first_rising_edge <= 0;
        MISO <= 0;
        //shift_reg_out <= shift_reg_out_intermediary;
        //data_out <= 0; //To prevent latch warning     
    end
    else begin
        // CPOL=0, CPHA=0 => sample MOSI on rising edge
        //Slave is selected here by the master
        // BITS - 2 = 6
        //Receving the MSB first and then shifting it down the order
        // MOSI goes into LSB
        
        //Ignore first rising edge
        first_rising_edge <= 1;
        
        if (first_rising_edge) begin
           shift_reg_in <= {shift_reg_in[BITS-2: 0],MOSI};
           bit_count <= bit_count + 1;
           
           MISO <= shift_reg_out[BITS - 1];
           shift_reg_out <= {shift_reg_out[BITS - 2:0],1'b0};
           
        end else begin
           shift_reg_out <= {btnU,btnD,btnR,btnL,btnC,13'd0};  
        end
           

        
        

        if (bit_count == (BITS)) begin
            // Once we've received 8 bits, store in data_out
            data_out <= shift_reg_in;
        end
        
    end
end

//    always@(negedge SS) begin
//        shift_reg_out <= {btnU,btnD,btnR,btnL,btnC,3'b000};
//    end

//    always@(*) begin
//        shift_reg_out <= {btnU,btnD,btnR,btnL,btnC,3'b000};
//    end

endmodule

