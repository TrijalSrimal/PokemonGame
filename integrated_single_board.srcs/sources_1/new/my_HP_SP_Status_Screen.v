`timescale 1ns / 1ps
module HP_SP_Status_Screen(
    input basys_clk,
    input done,
    input [7:0] x_8bit, y_8bit,
    input btnU,btnD,btnC,btnR,btnL,
    input [7:0] data_out,
    input [7:0] HP_Level,
    input [7:0] SP_Level,
    output [15:0] pixel_data_output
);
    
    // Rectangle generator output
    wire [15:0] rect_1_pixel_data;

    // Instantiate rectangle generator for upper left edge (top)
    rectangle_generator rect1__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(8),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(16'h0000), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_1_pixel_data)
    );
    

    
    reg [3:0] SP_LEVEL_SPI = 0;                      
    reg [3:0] HP_LEVEL_SPI = 0;
    
    always @(posedge basys_clk) begin
        //if (done) begin
            //if (data_out[7:4] == 4'b0000) begin
                //HP_LEVEL_SPI <= data_out[3:0];
            //end 
            //else if (data_out[7:4] == 4'b0001) begin
                //SP_LEVEL_SPI <= data_out[3:0];
            //end
        //end
        HP_LEVEL_SPI = HP_Level;
        SP_LEVEL_SPI = SP_Level;
    end                                                                       
                            
    wire [5:0] HP_WIDTH, SP_WIDTH;
    //assign HP_WIDTH = (HP_Level/15) * 59; This doesn't work because you cannot do float division for some reason
    assign HP_WIDTH = (HP_LEVEL_SPI * 59) / 15;
    assign SP_WIDTH = (SP_LEVEL_SPI * 48) / 10;
    
    reg [3:0] hp_display_reg = 4'd15;
    reg [3:0] old_hp = 4'd15;
    wire [3:0] real_hp = HP_LEVEL_SPI;
    reg [4:0] damage_amount = 0;
    reg [4:0] heal_amount = 0;
    reg animation_start = 0;
    wire reset = btnC;
        
    // Compare old_hp vs. real_hp
    always @(posedge basys_clk) begin
            if (real_hp < old_hp) begin
                // HP decreased => start animation from old_hp down to real_hp
                animation_start <= 1;
                damage_amount   <= old_hp - real_hp; 
                // We'll track how many HP lost
            end
            else if (real_hp > old_hp) begin
                // HP increased =>  want an upward animation, do similarly
                animation_start <= 1;
                heal_amount <= real_hp - old_hp;
            end
    
            old_hp <= real_hp; // update
    end
    
    
    localparam integer HP_STEP_TIME = 80_000_000; // half second at 100 MHz
    reg [31:0] anim_counter = 0;
    reg [3:0] anim_hp_target = 0;  // final HP we want to reach
    reg anim_active = 0;
    
    always @(posedge basys_clk) begin
            if (animation_start) begin
                // We know we lost 'damage_amount' HP
                anim_active <= 1;
                anim_hp_target <= real_hp;  // The new, lower HP
            end
    
            if (anim_active) begin
                // Count up to HP_STEP_TIME, then reduce hp_display_reg by 1
                // Repeat until hp_display_reg == anim_hp_target
                if (anim_counter < HP_STEP_TIME) begin
                    anim_counter <= anim_counter + 1;
                end
                else begin
                    anim_counter <= 0;
                    if (hp_display_reg > anim_hp_target) begin
                        hp_display_reg <= hp_display_reg - 1;
                    end else if (hp_display_reg < anim_hp_target) begin
                        hp_display_reg <= hp_display_reg + 1;
                    end
                    else begin
                        // done
                        anim_active <= 0;
                    end
                end
            end
            else begin
                // no animation => match real HP unless you want to keep them separate
                hp_display_reg <= real_hp;
            end
    end 
    
       
    
   //Calculation of the second and the first digit of 16/16 HP
    wire [31:0] first_digit_HP_level;
    wire [31:0] second_digit_HP_level;
    wire [31:0] first_digit_HP_level_ASCII;
    wire [31:0] second_digit_HP_level_ASCII;
    
    assign first_digit_HP_level =  HP_LEVEL_SPI / 10;
    assign second_digit_HP_level = HP_LEVEL_SPI % 10;
    
    assign  first_digit_HP_level_ASCII = first_digit_HP_level + 48;
    assign  second_digit_HP_level_ASCII = second_digit_HP_level + 48;
    
   //Calculation of the second and the first digit of 16/16 SP
     wire [31:0] first_digit_SP_level;
     wire [31:0] second_digit_SP_level;
     wire [31:0] first_digit_SP_level_ASCII;
     wire [31:0] second_digit_SP_level_ASCII;
     
     assign first_digit_SP_level =  SP_LEVEL_SPI / 10;
     assign second_digit_SP_level = SP_LEVEL_SPI % 10;
     
     assign  first_digit_SP_level_ASCII = first_digit_SP_level + 48;
     assign  second_digit_SP_level_ASCII = second_digit_SP_level + 48;    
    
        
    // Rectangle generator output
    wire [15:0] rect_2_pixel_data;

//    // Instantiate rectangle generator HP
//    rectangle_generator rect2_inst (
//        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
//        .X(x_8bit[6:0]),
//        .Y(y_8bit[6:0]),

//        // Rectangle geometry
//        .OriginX(2),   // example top-left corner X
//        .OriginY(10),   // example top-left corner Y
//        .height(7),    // example height
//        .width(HP_WIDTH),     // example width

//        // Colors
//        .rect_color(15'hFFFF),       // e.g., bright color
//        .current_pixel_color(rect_1_pixel_data), // black for outside
       
//        // Output goes to rect_pixel_data
//        .pixel_data(rect_2_pixel_data)
//    );

    wire [5:0] final_hp_width   = (real_hp       * 59) / 15;
    wire [5:0] display_hp_width = (hp_display_reg * 59) / 15;
    wire [15:0] hp_rect_pixel;

     // 1) The normal HP bar for 'display_hp_width'
    rectangle_generator hp_rect_display (
        .X(x_8bit), .Y(y_8bit),
        .OriginX(2),
        .OriginY(10),
        .width(display_hp_width),
        .height(7),
        .rect_color(16'hFFFF), 
        .current_pixel_color(rect_1_pixel_data),
        .pixel_data(hp_rect_pixel)
    );

    // 2) The "damage" portion in red if display width is more than final width

    reg [5:0] damage_heal_width = 5'd0;
    reg [15:0] color = 16'd0;
    reg [15:0] OriginX = 0;
    always @(*) begin
        if (display_hp_width > final_hp_width) begin
            damage_heal_width = display_hp_width - final_hp_width;
            color = 16'hF800;
            OriginX = 2 + final_hp_width;
        end else if (display_hp_width < final_hp_width) begin
            damage_heal_width = final_hp_width - display_hp_width;
            color = 16'h07E0;
            OriginX = 2 + display_hp_width;
        end
    end
    rectangle_generator hp_rect_damage (
        .X(x_8bit), .Y(y_8bit),
        .OriginX(OriginX), // start from final HP boundary
        .OriginY(10),
        .width(damage_heal_width),
        .height(7),
        .rect_color(color), // red or green
        .current_pixel_color(hp_rect_pixel), 
        .pixel_data(rect_2_pixel_data)
    );
 
 

    
    // Rectangle generator output
    wire [15:0] rect_3_pixel_data;

    // Instantiate rectangle generator SP
    rectangle_generator rect3_inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(2),   // example top-left corner X
        .OriginY(30),   // example top-left corner Y
        .height(7),    // example height
        .width(SP_WIDTH),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_2_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_3_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_4_pixel_data;

    // Instantiate rectangle generator for upper left edge (top)
    rectangle_generator rect4__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(8),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_3_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_4_pixel_data)
    );

    // Rectangle generator output
    wire [15:0] rect_5_pixel_data;

    // Instantiate rectangle generator for upper left edge (bottom)
    rectangle_generator rect5__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(18),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_4_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_5_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_6_pixel_data;

    // Instantiate rectangle generator for upper left edge (bottom)
    rectangle_generator rect6__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(17),   // example top-left corner Y
        .height(1),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_5_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_6_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_7_pixel_data;

    // Instantiate rectangle generator for upper right edge (top)
    rectangle_generator rect7__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(59),   // example top-left corner X
        .OriginY(8),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_6_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_7_pixel_data)
    );
    // Rectangle generator output
    wire [15:0] rect_8_pixel_data;
    
    // Instantiate rectangle generator for upper right edge (top)
    rectangle_generator rect8__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(61),   // example top-left corner X
        .OriginY(8),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_7_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_8_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_9_pixel_data;
    
    // Instantiate rectangle generator for upper right edge (bottom)
    rectangle_generator rect9__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(59),   // example top-left corner X
        .OriginY(18),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_8_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_9_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_10_pixel_data;
    // Instantiate rectangle generator for upper right edge (bottom)
    rectangle_generator rect10__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(61),   // example top-left corner X
        .OriginY(17),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_9_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_10_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_11_pixel_data;

    // Instantiate rectangle generator for lower left edge (top)
    rectangle_generator rect11__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(28),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_10_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_11_pixel_data)
    );

    // Rectangle generator output
    wire [15:0] rect_12_pixel_data;

    // Instantiate rectangle generator for lower left edge (top)
    rectangle_generator rect12__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(28),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_11_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_12_pixel_data)
    );
    
    
    // Rectangle generator output
    wire [15:0] rect_13_pixel_data;
    
     // Instantiate rectangle generator for lower left edge (bottom)
    rectangle_generator rect13__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(38),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_12_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_13_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_14_pixel_data;
    
     // Instantiate rectangle generator for lower left edge (bottom)
    rectangle_generator rect14__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(1),   // example top-left corner X
        .OriginY(37),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_13_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_14_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_15_pixel_data;
    
     // Instantiate rectangle generator for lower right edge (top)
    rectangle_generator rect15__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(50),   // example top-left corner X
        .OriginY(28),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_14_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_15_pixel_data)
    );

    // Rectangle generator output
    wire [15:0] rect_16_pixel_data;
    
     // Instantiate rectangle generator for lower right edge (top)
    rectangle_generator rect16__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(48),   // example top-left corner X
        .OriginY(28),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_15_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_16_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_17_pixel_data;
    
     // Instantiate rectangle generator for lower right edge (bottom)
    rectangle_generator rect17__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(48),   // example top-left corner X
        .OriginY(38),   // example top-left corner Y
        .height(1),    // example height
        .width(3),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_16_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_17_pixel_data)
    );
    
    // Rectangle generator output
    wire [15:0] rect_18_pixel_data;
    
     // Instantiate rectangle generator for lower right edge (bottom)
    rectangle_generator rect18__inst (
        // Truncate 8-bit X,Y to 7 bits, since your rectangle_generator expects [6:0]
        .X(x_8bit[6:0]),
        .Y(y_8bit[6:0]),

        // Rectangle geometry
        .OriginX(50),   // example top-left corner X
        .OriginY(37),   // example top-left corner Y
        .height(2),    // example height
        .width(1),     // example width

        // Colors
        .rect_color(16'hFFFF),       // e.g., bright color
        .current_pixel_color(rect_17_pixel_data), // black for outside
       
        // Output goes to rect_pixel_data
        .pixel_data(rect_18_pixel_data)
    );
    
    wire [15:0] pixel_data_H_Character;
    
    picopixel my_picopixel_H(.X(x_8bit[6:0]),
                               .Y(y_8bit[6:0]),
                               .PosX(2'd2),
                               .PosY(2'd2),
                               .ASCII(32'd72),
                               .Current_Color(rect_18_pixel_data),
                               .Character_Color(16'hffff),
                               .Pixel_data(pixel_data_H_Character));
                               
   wire [15:0] pixel_data_P_Character;
   
                                      
   picopixel my_picopixel_P(.X(x_8bit[6:0]),
                              .Y(y_8bit[6:0]),
                              .PosX(3'd6),
                              .PosY(3'd2),
                              .ASCII(32'd80),
                              .Current_Color(pixel_data_H_Character),
                              .Character_Color(16'hffff),
                              .Pixel_data(pixel_data_P_Character));
                              
      wire [15:0] pixel_data_1_Character;
                                                          
      picopixel my_picopixel_1(.X(x_8bit[6:0]),
                                 .Y(y_8bit[6:0]),
                                 .PosX(4'd11),
                                 .PosY(4'd2),
                                 .ASCII(first_digit_HP_level_ASCII),
                                 .Current_Color(pixel_data_P_Character),
                                 .Character_Color(16'hffff),
                                 .Pixel_data(pixel_data_1_Character)); 
                                 
     wire [15:0] pixel_data_6_Character;
                                                                                     
     picopixel my_picopixel_6(.X(x_8bit[6:0]),
                                .Y(y_8bit[6:0]),
                                .PosX(4'd15),
                                .PosY(4'd2),
                                .ASCII(second_digit_HP_level_ASCII),
                                .Current_Color(pixel_data_1_Character),
                                .Character_Color(16'hffff),
                                .Pixel_data(pixel_data_6_Character));
                                
    wire [15:0] pixel_data_slash_Character;
                                                                                    
    picopixel my_picopixel_slash(.X(x_8bit[6:0]),
                               .Y(y_8bit[6:0]),
                               .PosX(5'd19),
                               .PosY(5'd2),
                               .ASCII(32'd47),
                               .Current_Color(pixel_data_6_Character),
                               .Character_Color(16'hffff),
                               .Pixel_data(pixel_data_slash_Character));
                               
   wire [15:0] pixel_data_second_1_Character;
                                                                                   
   picopixel my_picopixel_second_1(.X(x_8bit[6:0]),
                              .Y(y_8bit[6:0]),
                              .PosX(5'd22),
                              .PosY(5'd2),
                              .ASCII(32'd49),
                              .Current_Color(pixel_data_slash_Character),
                              .Character_Color(16'hffff),
                              .Pixel_data(pixel_data_second_1_Character));
                              
      wire [15:0] pixel_data_second_6_Character;
                                                                                                              
      picopixel my_picopixel_second_6(.X(x_8bit[6:0]),
                                 .Y(y_8bit[6:0]),
                                 .PosX(5'd26),
                                 .PosY(5'd2),
                                 .ASCII(32'd53),
                                 .Current_Color(pixel_data_second_1_Character),
                                 .Character_Color(16'hffff),
                                 .Pixel_data(pixel_data_second_6_Character));
                                 
     wire [15:0] pixel_data_S_Character;
                                                                                                                                 
     picopixel my_picopixel_S(.X(x_8bit[6:0]),
                                .Y(y_8bit[6:0]),
                                .PosX(5'd2),
                                .PosY(5'd21),
                                .ASCII(32'd83),
                                .Current_Color(pixel_data_second_6_Character),
                                .Character_Color(16'hffff),
                                .Pixel_data(pixel_data_S_Character));
                                                                                                                                               
     wire [15:0] pixel_data_Second_P_Character;
                                                                                                                                                            
    picopixel my_picopixel_Second_P(.X(x_8bit[6:0]),
                               .Y(y_8bit[6:0]),
                               .PosX(5'd6),
                               .PosY(5'd21),
                               .ASCII(32'd80),
                               .Current_Color(pixel_data_S_Character),
                               .Character_Color(16'hffff),
                               .Pixel_data(pixel_data_Second_P_Character));
                               
  wire [15:0] pixel_data_third_1_Character;
                                                                                                                                                                                      
  picopixel my_picopixel_third_1(.X(x_8bit[6:0]),
                             .Y(y_8bit[6:0]),
                             .PosX(5'd11),
                             .PosY(5'd21),
                             .ASCII(first_digit_SP_level_ASCII),
                             .Current_Color(pixel_data_Second_P_Character),
                             .Character_Color(16'hffff),
                             .Pixel_data(pixel_data_third_1_Character));

  wire [15:0] pixel_data_zero_Character;
                                                                                                                                                                                      
  picopixel my_picopixel_zero(.X(x_8bit[6:0]),
                             .Y(y_8bit[6:0]),
                             .PosX(5'd15),
                             .PosY(5'd21),
                             .ASCII(second_digit_SP_level_ASCII),
                             .Current_Color(pixel_data_third_1_Character),
                             .Character_Color(16'hffff),
                             .Pixel_data(pixel_data_zero_Character));
                             
    wire [15:0] pixel_data_second_slash_Character;
                                                                                                             
     picopixel my_picopixel_second_slash(.X(x_8bit[6:0]),
                                .Y(y_8bit[6:0]),
                                .PosX(5'd19),
                                .PosY(5'd21),
                                .ASCII(32'd47),
                                .Current_Color(pixel_data_zero_Character),
                                .Character_Color(16'hffff),
                                .Pixel_data(pixel_data_second_slash_Character)); 
                                
       wire [15:0] pixel_data_fourth_1_Character;
                                                                                                                
        picopixel my_picopixel_fourth_1(.X(x_8bit[6:0]),
                                   .Y(y_8bit[6:0]),
                                   .PosX(5'd22),
                                   .PosY(5'd21),
                                   .ASCII(32'd49),
                                   .Current_Color(pixel_data_second_slash_Character),
                                   .Character_Color(16'hffff),
                                   .Pixel_data(pixel_data_fourth_1_Character));
                                   
      wire [15:0] pixel_data_second_zero_Character;
                                                                                                                                           
       picopixel my_picopixel_second_zero(.X(x_8bit[6:0]),
                                  .Y(y_8bit[6:0]),
                                  .PosX(5'd26),
                                  .PosY(5'd21),
                                  .ASCII(32'd48),
                                  .Current_Color(pixel_data_fourth_1_Character),
                                  .Character_Color(16'hffff),
                                  .Pixel_data(pixel_data_second_zero_Character));
                                  
                                  
    assign pixel_data_output = pixel_data_second_zero_Character;                                                          
                                                                                                                       

endmodule
