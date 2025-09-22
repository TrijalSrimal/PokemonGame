`timescale 1ns / 1ps
module slave_receive_hp_sp(
    input  basys_clk,
    input  btnU,btnD,btnC,btnR,btnL,
    input  [3:0] JB, //SPI SLAVE 
    output MISO, //data output from slave JB[4]
    output [7:0] JC, //For diplaying of player status 1
    output [7:0] JXADC // For displaying of player status 2
    //output [7:0] JC // SPI MASTER
    );

    // debounced buttons
    wire debounced_btnU, debounced_btnD,debounced_btnR, debounced_btnL;
    debouncer my_debounce_btnU (.clk(basys_clk),
                               .btn_in(btnU),
                               .btn_out(debounced_btnU));
                               
    debouncer my_debounce_btnD (.clk(basys_clk),
                               .btn_in(btnD),
                               .btn_out(debounced_btnD));
                               
    debouncer my_debounce_btnR (.clk(basys_clk),
                              .btn_in(btnR),
                              .btn_out(debounced_btnR));
                              
   debouncer my_debounce_btnL (.clk(basys_clk),
                              .btn_in(btnL),
                              .btn_out(debounced_btnL));
                              
    wire [15:0] final_pixel_data;

    // Generate 6.25 MHz clock for OLED
    wire clk_6pt25MHZ;
    wire [2:0] m = 7;
    flex_clk my_6pt25MHZ_clk (
        .basys_clk(basys_clk),
        .m(m),
        .clock_ouput(clk_6pt25MHZ)
    );

    // Signals from Oled_Display
    wire reset = 0;
    wire fb;
    wire sending_pixels;
    wire sample_pixel;
    wire [15:0] pixel_index;
    
    wire reset2 = 0;
    wire fb2;
    wire sending_pixels2;
    wire sample_pixel2;
    wire [15:0] pixel_index2;

    // Coordinates
    wire [7:0] x_8bit, y_8bit;
    coord coordinates(
        .pixel_index(pixel_index),
        .x(x_8bit),
        .y(y_8bit)
    );

    // Coordinates
    wire [7:0] x_8bit2, y_8bit2;
    coord coordinates2(
        .pixel_index(pixel_index2),
        .x(x_8bit2),
        .y(y_8bit2)
    );
    
    // SPI Master (transmits HP & SP alternately)
//    reg [7:0] data_in = 0;
    wire done;
//    reg start = 0;

//    SPI_Master my_spi_master(
//        .clk(basys_clk),
//        .start(start),
//        .data_in(data_in),
//        .MOSI(JC[0]),
//        .SCLK(JC[1]),
//        .SS(JC[2]),
//        .done(done)
//    );
    assign done = JB[3]; // for debugging

//    // HP & SP logic
//    wire [3:0] HP_Level;
//    wire [3:0] SP_Level;
//    HP_AND_SKILL hp_control(
//        .clk   (basys_clk),
//        .btnU  (btnU),
//        .btnD  (btnD),
//        .btnR  (btnR),
//        .btnL  (btnL),
//        .reset (btnC),
//        .NEW_HP(HP_Level),
//        .NEW_SP(SP_Level)
//    );

    // Data frames: top nibble indicates HP or SP, bottom nibble is level
//    wire [7:0] hp_frame = {4'b0000, HP_Level};
//    wire [7:0] sp_frame = {4'b0001, SP_Level};  

//    // Simple FSM to send HP, then SP, repeatedly
//    reg [2:0] spi_state = 0;
//    always @(posedge basys_clk) begin
//        start <= 0; // default
//        case (spi_state)
//            3'd0: begin
//                data_in <= hp_frame;
//                start   <= 1;
//                spi_state <= 1;
//            end
//            3'd1: if (done) spi_state <= 2;
//            3'd2: begin
//                data_in <= sp_frame;
//                start   <= 1;
//                spi_state <= 3;
//            end
//            3'd3: if (done) spi_state <= 0;
//        endcase
//    end

    // SPI Slave
    wire [17:0] data_out;
    spi_slave my_SPI_Slave(
        .SCLK(JB[1]),
        .SS(JB[2]),
        .MOSI(JB[0]),
        .data_out(data_out),
        .MISO(MISO),
        .btnC(btnC),
        .btnD(btnD),
        .btnR(btnR),
        .btnL(btnL),
        .btnU(btnU)
    );
    
    reg[4:0] HP_Level_SPI1 = 0;
    reg[4:0] SP_Level_SPI1 = 0;
    reg[4:0] HP_Level_SPI2 = 0;
    reg[4:0] SP_Level_SPI2 = 0;
    
    reg [15:0] pixel_data_1 = 0;
    always @(*) begin
        if (done)begin
            if (data_out[17:8] == 10'd0)begin
                HP_Level_SPI1 = data_out[3:0];
                HP_Level_SPI2 = data_out[7:4];
            end else if (data_out[17:8] == 10'd1)begin
                SP_Level_SPI1 = data_out[3:0];
                SP_Level_SPI2 = data_out[7:0];
            end 
        end
    end

    // Normal HP/SP screen logic
    wire [15:0] my_HP_SP_Status_Screen_Pixel_data1;
    HP_SP_Status_Screen_SPI my_HP_SP_Status_Screen1(
        .basys_clk(basys_clk),
        .x_8bit(x_8bit),
        .y_8bit(y_8bit),
        .done(done),
        .btnU(btnU),
        .btnD(btnD),
        .btnC(btnC),
        .btnR(btnR),
        .btnL(btnL),
        .data_out(data_out),
        .pixel_data_output(my_HP_SP_Status_Screen_Pixel_data1)
    );
    
    

    // Low Health screen
    wire [15:0] Low_Health_Warning_Pixel_data;
    Low_Health_Status_Screen my_Low_Health_Status_Screen(
        .basys_clk(basys_clk),
        .x_8bit(x_8bit), 
        .y_8bit(y_8bit),
        .pixel_data_output(Low_Health_Warning_Pixel_data)
    );

    // Normal HP/SP screen logic
    wire [15:0] my_HP_SP_Status_Screen_Pixel_data2;
    HP_SP_Status_Screen_SPI my_HP_SP_Status_Screen2(
        .basys_clk(basys_clk),
        .x_8bit(x_8bit2),
        .y_8bit(y_8bit2),
        .done(done),
        .btnU(btnU),
        .btnD(btnD),
        .btnC(btnC),
        .btnR(btnR),
        .btnL(btnL),
        .data_out(data_out),
        .pixel_data_output(my_HP_SP_Status_Screen_Pixel_data2)
    );

    // 2Hz BLINK for 5s if HP<3 (i.e., <20% of 15)
    localparam HP_THRESHOLD = 5;  // 20% of 15 => 3

    // Count edges to produce 2Hz toggling
    // basys_clk is 100MHz 
    localparam integer TOGGLE_MAX = 25_000_000; 
    reg [31:0] toggle_counter = 0;
    reg blink_on = 0;

    // We'll have an FSM that does 5s => 5s * 2 toggles per second => 10 toggles
    localparam integer TOTAL_TOGGLES = 2 * 5; // 10 toggles for 5 seconds

    reg [3:0] blink_toggle_count = 0; 

    // States
    localparam S_NORMAL = 0;
    localparam S_BLINK  = 1;
    localparam S_DONE   = 2;
    //reg blinked_once = 0;
               
    reg [3:0] blink_state = S_NORMAL;


always @(posedge basys_clk) begin
    case(blink_state)
        S_NORMAL: begin
            blink_on <= 0;
            if (HP_Level_SPI1 < HP_THRESHOLD ) begin
                blink_state <= S_BLINK;
                blink_toggle_count <= 0;
                toggle_counter <= 0;
                blink_on <= 1;
            end
        end
        
        S_BLINK: begin
            if (toggle_counter < TOGGLE_MAX) begin
                toggle_counter <= toggle_counter + 1;
                end 
            else begin
                toggle_counter <= 0;
                blink_on <= ~blink_on;
                blink_toggle_count <= blink_toggle_count + 1;
                if (blink_toggle_count == (TOTAL_TOGGLES - 1)) begin
                    // Done blinking once
                    blink_state <= S_DONE;
                    blink_on <= 0;
                end
            end
        end
        
        S_DONE: begin
            // If HP still <3, remain here, no more blinking
            // If HP recovers >=3, go back to NORMAL
            if (HP_Level_SPI1 >= HP_THRESHOLD) begin
               blink_state <= S_NORMAL;
            end else if (HP_Level_SPI1 < HP_THRESHOLD)begin
                blink_state <= S_DONE;
            end
            
        end
    endcase
end

    // If in BLINK state, show Low_Health_Warning at 2Hz
    // if blink_on=1 => show "LOW HEALTH!!", else show black or HP screen
    // We'll choose to show "LOW HEALTH" only when blink_on=1, else show normal HP bars

    reg [15:0] pixel_data_reg;
    always @(*) begin
        if (blink_state == S_BLINK) begin
            if (blink_on) 
                pixel_data_reg = Low_Health_Warning_Pixel_data;
            else 
                pixel_data_reg = 16'h0000; // or HP_SP if you prefer
        end
        else begin
            // normal
            pixel_data_reg = my_HP_SP_Status_Screen_Pixel_data1;
        end
    end

    assign final_pixel_data = pixel_data_reg;

    // Oled driver 1
    Oled_Display led1 (
        .clk(clk_6pt25MHZ),
        .reset(reset),
        .frame_begin(fb),
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data( pixel_data_1),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
   //oled driver 2
       // Oled driver
   Oled_Display led2 (
       .clk(clk_6pt25MHZ),
       .reset(reset2),
       .frame_begin(fb2),
       .sending_pixels(sending_pixels2),
       .sample_pixel(sample_pixel2),
       .pixel_index(pixel_index2),
       .pixel_data(final_pixel_data),
       .cs(JXADC[0]),
       .sdin(JXADC[1]),
       .sclk(JXADC[3]),
       .d_cn(JXADC[4]),
       .resn(JXADC[5]),
       .vccen(JXADC[6]),
       .pmoden(JXADC[7])
   );     
             

endmodule
