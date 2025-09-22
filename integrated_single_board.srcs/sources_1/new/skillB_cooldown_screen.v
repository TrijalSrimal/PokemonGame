`timescale 1ns / 1ps
module skillB_cooldown_screen(
    input  basys_clk,
    input  [7:0] x_8bit, 
    input  [7:0] y_8bit,
    output [15:0] pixel_data_output
);

    // "C" at (PosX=11, PosY=26)
    wire [15:0] letter_C;
    Font_5X7 letter_C_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd11),
        .PosY(6'd18),
        .ASCII(8'd67),          // 'C'
        .Current_Color(16'h0000),
        .Character_Color(16'h07FF),  // navy
        .Pixel_data(letter_C)
    );

    // "o" at (PosX=17, PosY=26)
    wire [15:0] letter_o1;
    Font_5X7 letter_o1_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd17),
        .PosY(6'd18),
        .ASCII(8'd79),        // 'o'
        .Current_Color(letter_C),
        .Character_Color(16'h07FF), // navy
        .Pixel_data(letter_o1)
    );

    // "o" at (PosX=23, PosY=26)
    wire [15:0] letter_o2;
    Font_5X7 letter_o2_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd23),
        .PosY(6'd18),
        .ASCII(8'd79),        // 'o'
        .Current_Color(letter_o1),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_o2)
    );

    // "l" at (PosX=29, PosY=26)
    wire [15:0] letter_l;
    Font_5X7 letter_l_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd29),
        .PosY(6'd18),
        .ASCII(8'd76),        // 'l'
        .Current_Color(letter_o2),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_l)
    );

    // "d" at (PosX=35, PosY=26)
    wire [15:0] letter_d;
    Font_5X7 letter_d_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd35),
        .PosY(6'd18),
        .ASCII(8'd68),        // 'd'
        .Current_Color(letter_l),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_d)
    );

    // "o" at (PosX=41, PosY=26)
    wire [15:0] letter_o3;
    Font_5X7 letter_o3_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd41),
        .PosY(6'd18),
        .ASCII(8'd79),        // 'o'
        .Current_Color(letter_d),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_o3)
    );

    // "w" at (PosX=47, PosY=26)
    wire [15:0] letter_w;
    Font_5X7 letter_w_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd47),
        .PosY(6'd18),
        .ASCII(8'd87),        // 'w'
        .Current_Color(letter_o3),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_w)
    );

    // "n" at (PosX=53, PosY=26)
    wire [15:0] letter_n;
    Font_5X7 letter_n_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd53),
        .PosY(6'd18),
        .ASCII(8'd78),        // 'n'
        .Current_Color(letter_w),
        .Character_Color(16'h07FF),
        .Pixel_data(letter_n)
    );

    // Merge all letters into one final pixel value
    assign pixel_data_output = letter_n;

endmodule
