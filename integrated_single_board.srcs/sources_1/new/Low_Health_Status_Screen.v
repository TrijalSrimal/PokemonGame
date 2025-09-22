`timescale 1ns / 1ps
module Low_Health_Status_Screen(
    input  basys_clk,
    input  [7:0] x_8bit, 
    input  [7:0] y_8bit,
    output [15:0] pixel_data_output
);

    //------------------------------------------------------------
    // "L" at (PosX=11, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_L;
    Font_5X7 letter_L_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(5'd11),
        .PosY(6'd18),
        .ASCII(8'd76),         // 'L'
        .Current_Color(16'h0000),
        .Character_Color(16'hF206),
        .Pixel_data(letter_L)
    );

    //------------------------------------------------------------
    // "O" at (PosX=17, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_O;
    Font_5X7 letter_O_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(5'd17),
        .PosY(6'd18),
        .ASCII(8'd79),         // 'O'
        .Current_Color(letter_L),    
        .Character_Color(16'hF206),
        .Pixel_data(letter_O)
    );

    //------------------------------------------------------------
    // "W" at (PosX=23, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_W;
    Font_5X7 letter_W_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(5'd23),
        .PosY(6'd18),
        .ASCII(8'd87),         // 'W'
        .Current_Color(letter_O),
        .Character_Color(16'hF206),
        .Pixel_data(letter_W)
    );

    //------------------------------------------------------------
    // Space at (PosX=29, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_space;
    Font_5X7 letter_space_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(5'd29),
        .PosY(6'd18),
        .ASCII(8'd32),         // ' ' (space)
        .Current_Color(letter_W),
        .Character_Color(16'hF206),
        .Pixel_data(letter_space)
    );

    //------------------------------------------------------------
    // "H" at (PosX=35, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_H;
    Font_5X7 letter_H_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd35),
        .PosY(6'd18),
        .ASCII(8'd72),         // 'H'
        .Current_Color(letter_space),
        .Character_Color(16'hF206),
        .Pixel_data(letter_H)
    );

    //------------------------------------------------------------
    // "E" at (PosX=41, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_E;
    Font_5X7 letter_E_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd41),
        .PosY(6'd18),
        .ASCII(8'd69),        // 'E'
        .Current_Color(letter_H),
        .Character_Color(16'hF206),
        .Pixel_data(letter_E)
    );

    //------------------------------------------------------------
    // "A" at (PosX=47, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_A;
    Font_5X7 letter_A_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd47),
        .PosY(6'd18),
        .ASCII(8'd65),        // 'A'
        .Current_Color(letter_E),
        .Character_Color(16'hF206),
        .Pixel_data(letter_A)
    );

    //------------------------------------------------------------
    // "L" at (PosX=53, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_L2;
    Font_5X7 letter_L2_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd53),
        .PosY(6'd18),
        .ASCII(8'd76),        // 'L'
        .Current_Color(letter_A),
        .Character_Color(16'hF206),
        .Pixel_data(letter_L2)
    );

    //------------------------------------------------------------
    // "T" at (PosX=59, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_T;
    Font_5X7 letter_T_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(6'd59),
        .PosY(6'd18),
        .ASCII(8'd84),       // 'T'
        .Current_Color(letter_L2),
        .Character_Color(16'hF206),
        .Pixel_data(letter_T)
    );

    //------------------------------------------------------------
    // "H" at (PosX=65, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_H2;
    Font_5X7 letter_H2_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(7'd65),
        .PosY(7'd18),
        .ASCII(8'd72),       // 'H'
        .Current_Color(letter_T),
        .Character_Color(16'hF206),
        .Pixel_data(letter_H2)
    );

    //------------------------------------------------------------
    // 11) "!" at (PosX=71, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_ex1;
    Font_5X7 letter_ex1_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(7'd71),
        .PosY(7'd18),
        .ASCII(8'd33),       // '!'
        .Current_Color(letter_H2),
        .Character_Color(16'hF206),
        .Pixel_data(letter_ex1)
    );

    //------------------------------------------------------------
    // 12) "!" at (PosX=77, PosY=26)
    //------------------------------------------------------------
    wire [15:0] letter_ex2;
    Font_5X7 letter_ex2_inst (
        .X(x_8bit),
        .Y(y_8bit),
        .PosX(7'd77),
        .PosY(7'd18),
        .ASCII(8'd33),       // '!'
        .Current_Color(letter_ex1),
        .Character_Color(16'hF206),
        .Pixel_data(letter_ex2)
    );

    //------------------------------------------------------------
    // Final output merges all letters
    //------------------------------------------------------------
    assign pixel_data_output = letter_ex2;

endmodule
