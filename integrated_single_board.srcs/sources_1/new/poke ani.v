module pokemon_animation (
    input wire clk_100MHz,    
    input wire [2:0] skill,     
    input wire [12:0] pixel_index,  
    output reg [15:0] pixel_out,
    input wire [1:0] choice1,
    input wire [1:0] choice2,
    input start_turn,
    output reg end_animation = 0,
    output start_ani
    
);
   
    
    wire my_skill_A, my_skill_B,my_heal,my_pass;
        assign my_skill_A = (3'b001 == skill); //tackle 
        assign my_skill_B = (3'b010 == skill); //special
        assign my_heal = (3'b011 == skill); //sheal
        assign my_pass = (3'b100 == skill); //special
    // Clock dividers
    reg [21:0] frame_counter = 0;
    reg frame_tick = 0;
    wire [15:0]pixel_data_splash_screen;
    wire [15:0]pixel_data_splash_screenplayer1;
    // Compute Flipped OLED coordinates
    wire [6:0] oled_x = 95 - pixel_index % 96;
    wire [6:0] oled_y = 63 - pixel_index / 96;
//    // Compute  OLED coordinates
//    wire [6:0] oled_x = pixel_index % 96;
//    wire [6:0] oled_y =  pixel_index / 96;
    splash_screen(.x(oled_x),   // OLED X coordinate (0-95)
        .y(oled_y),   // OLED Y coordinate (0-63)
        .pixel_out(pixel_data_splash_screen)
    );
    splash_screen_player1(.x(oled_x),   // OLED X coordinate (0-95)
            .y(oled_y),   // OLED Y coordinate (0-63)
            .pixel_out(pixel_data_splash_screenplayer1)
        );
    // Pok mon positions
    reg [6:0] p1_x = 5;   // Pok mon 1 at bottom-left
    reg [6:0] p1_y = 60;
    reg [6:0] p2_x = 64;  // Pok mon 2 at top-right
    reg [6:0] p2_y = 5;


    reg animation_active = 0;
    reg moving_forward = 1;
    reg counter = 0;
    reg prev_skillA =0;
    reg prev_skillB= 0;
    reg prev_heal= 0;
    reg prev_pass= 0;


    // A flag to indicate if we want to change turn once the triggered animation finishes
    reg turn_change_pending = 0;

    // Sprites
    reg [5:0] sprite_x, sprite_y;
    reg [4:0] sprite_x2, sprite_y2;
    wire [15:0] sprite_pixel;
    wire [15:0] sprite_pixel2;
    wire [15:0] sprite_pixel3;
    wire [15:0] sprite_pixel4;
    wire [15:0] sprite_pixel5;
    wire [15:0] sprite_pixel6;
    

    // Special attack line
    reg special_animation_active = 0;
    reg special_extending = 0;        // extend or retract
    reg [7:0] line_progress = 0;      // 0..LINE_MAX
    localparam LINE_MAX = 60;         // adjust as needed

    // BLINK logic when p2 is "hit"
    reg blink_active = 0;            // when 1, p2 will blink
    reg [7:0] blink_timer = 0;       // frames counted at 40Hz
    reg blink_state = 0;             // toggles on/off
    // We'll blink for ~3s => ~120 frames at 40Hz
    localparam BLINK_3SEC = 120;

    // ------------------------------
    // Splash screen logic
    // ------------------------------
    reg splash_active = 0;
    reg [7:0] splash_timer = 0;
    localparam SPLASH_DURATION = 80; // ~2 seconds at ~40Hz
    reg heal_animation_active = 0; 
    reg [7:0] heal_timer = 0;     
    localparam HEAL_DURATION = 120;
    // ------------------------------
    // Declarations for line drawing outside always blocks
    // ------------------------------
    // We'll move integers and regs used for loops and thickness out here.

    integer t;         // loop index for line drawing
    integer thick;     // thickness calculation
    reg [7:0] calc_x;  // calculated X along the line
    reg [7:0] calc_y;  // calculated Y along the line
    reg on_line;       // flag set if current (oled_x, oled_y) is on the beam


    // Pok mon sprites

    squirtle_big sprite_rom (
       .x(sprite_x),
       .y(sprite_y),
       .color(sprite_pixel)
    );
    charmander_big sprite_rom2 (
       .x(sprite_x),
       .y(sprite_y),
       .color(sprite_pixel2)
    );
    bulbasaur_big sprite_rom3 (
           .x(sprite_x),
           .y(sprite_y),
           .color(sprite_pixel3)
        );
    squirtle_small sprite_rom4 (
       .x(sprite_x2),
       .y(sprite_y2),
       .color(sprite_pixel4)
    );
    charmander_small sprite_rom5 (
       .x(sprite_x2),
       .y(sprite_y2),
       .color(sprite_pixel5)
    );
    bulbasaur_small sprite_rom6 (
       .x(sprite_x2),
       .y(sprite_y2),
       .color(sprite_pixel6)
    );
    ///////////////////////////////////
    // cpok1 assignment
    ///////////////////////////////////
    // If turn == 0 -> use choice1
    //    choice1 == 0 -> sprite_pixel4
    //    choice1 == 1 -> sprite_pixel5
    //    otherwise    -> sprite_pixel6
    // If turn == 1 -> use choice2
    //    choice2 == 0 -> sprite_pixel4
    //    choice2 == 1 -> sprite_pixel5
    //    otherwise    -> sprite_pixel6

    wire [15:0] cpok1 = (start_turn == 1'b0)
                   ? ((choice1 == 2'b00) ? sprite_pixel :
                      (choice1 == 2'b01) ? sprite_pixel2 :
                                           sprite_pixel3)
                   : ((choice2 == 2'b00) ? sprite_pixel :
                      (choice2 == 2'b01) ? sprite_pixel2 :
                                           sprite_pixel3);
    
    ///////////////////////////////////
    // cpok2 assignment
    ///////////////////////////////////
    // If turn == 0 -> use choice2
    //    choice2 == 0 -> sprite_pixel1
    //    choice2 == 1 -> sprite_pixel2
    //    otherwise    -> sprite_pixel3
    // If turn == 1 -> use choice1
    //    choice1 == 0 -> sprite_pixel1
    //    choice1 == 1 -> sprite_pixel2
    //    otherwise    -> sprite_pixel3

    wire [15:0] cpok2 = (start_turn == 1'b0)
                   ? ((choice2 == 2'b00) ? sprite_pixel4 :
                      (choice2 == 2'b01) ? sprite_pixel5 :
                                           sprite_pixel6)
                   : ((choice1 == 2'b00) ? sprite_pixel4 :
                      (choice1 == 2'b01) ? sprite_pixel5 :
                                           sprite_pixel6);
                                           
   wire [15:0] color_beam = (start_turn == 1'b0)
                  ? ((choice1 == 2'b00) ? 16'h77DF :
                     (choice1 == 2'b01) ? 16'hFA20 :
                                          16'h2464)
                  : ((choice2 == 2'b00) ? 16'h77DF :
                     (choice2 == 2'b01) ? 16'hFA20 :
                                          16'h2464);
                                          
    // Generate ~40Hz frame tick
    always @(posedge clk_100MHz) begin
        frame_counter <= frame_counter + 1;
        if (frame_counter >= 1900000) begin // ~40Hz
            frame_tick <= 1;
            frame_counter <= 0;
        end else begin
            frame_tick <= 0;
        end
    end
    // ------------------------------
    // Button handling & movement, blinking, turn change, splash
    // ------------------------------
    assign start_ani = heal_animation_active || animation_active || special_animation_active;
    always @(posedge clk_100MHz) begin
    
        if (end_animation) begin
        
        end_animation <= 0;
        end
        if (my_heal && !prev_heal) begin
            heal_animation_active <= 1;
            heal_timer <= 0;
            turn_change_pending <= 1;
            end_animation <= 0;
        end
        prev_heal <= my_heal;
        if (my_pass && !prev_pass) begin
            turn_change_pending <= 1;
            end_animation <= 0;
        end
        prev_pass <= my_pass;
        // Movement button
        if (my_skill_A && !prev_skillA) begin //tackle
            animation_active <= 1;
            moving_forward <= 1;
            p1_x <= 5;
            p1_y <= 60;
            turn_change_pending <= 1; // Mark that we want to update turn after this animation
            end_animation <= 0;
        end
        prev_skillA <= my_skill_A;

        // Special attack button
        if (my_skill_B && !prev_skillB) begin
            special_animation_active <= 1;
            special_extending <= 1;  // start by extending
            line_progress <= 0;
            turn_change_pending <= 1; // Mark that we want to update turn after this animation
            end_animation <= 0;
        end
        prev_skillB <= my_skill_B;

        // Move Pok mon 1 if animation_active
        if (frame_tick && heal_animation_active) begin
            heal_timer <= heal_timer + 1;
            if (heal_timer >= HEAL_DURATION) begin
                heal_animation_active <= 0;
            end
        end
        if (frame_tick && animation_active) begin
            counter <= counter + 1;
            if (moving_forward) begin
                // heading toward p2
                if ((p1_x >= p2_x - 40) && (p1_y <= p2_y + 40)) begin
                    moving_forward <= 0; // reverse
                end else begin
                    if (p1_x < p2_x - 40) p1_x <= p1_x + 1;
                    if (p1_y > p2_y + 40 && counter != 2) p1_y <= p1_y - 1;
                    if (counter == 2) counter <= 0;
                end
            end else begin
                // returning to start
                if ((p1_x > 5) || (p1_y < 60)) begin
                    if (p1_x > 5) p1_x <= p1_x - 1;
                    if (p1_y < 60 && counter != 2) p1_y <= p1_y + 1;
                    if (counter == 2) counter <= 0;
                end else begin
                    animation_active <= 0;
                end
            end
        end

        // Update special line animation if active
        if (frame_tick && special_animation_active) begin
            if (special_extending) begin
                // extending out
                if (line_progress < LINE_MAX) begin
                    line_progress <= line_progress + 1;
                end else begin
                    // Once we've fully extended => 'hit' p2
                    if (!blink_active) begin
                        blink_active <= 1;
                        blink_timer <= 0;
                        blink_state <= 0;
                    end
                    // start retracting
                    special_extending <= 0;
                end
            end else begin
                // retracting
                if (line_progress > 0) begin
                    line_progress <= line_progress - 1;
                end else begin
                    special_animation_active <= 0; // done
                end
            end
        end

        // Blink logic for 3 seconds once p2 is hit
        if (frame_tick && blink_active) begin
            blink_timer <= blink_timer + 1;

            // toggle blink_state every 5 frames (~8Hz blink)
            if (blink_timer[2] == 1'b1) begin
                blink_state <= ~blink_state;
            end

            // end blinking after ~3s
            if (blink_timer >= BLINK_3SEC) begin
                blink_active <= 0;
            end
        end
         
        // Only update turn once if a button was pressed, after the animations end
        if (turn_change_pending && !animation_active && !special_animation_active && !blink_active && !heal_animation_active) begin
//            turn <= ~turn;      // 0->1 or 1->0
//            end_animation <= 1;
            turn_change_pending <= 0;
            // Activate splash after turn change
            splash_active <= 1;
            splash_timer <= 0;
        end

        // Splash timer
        if (frame_tick && splash_active) begin
            splash_timer <= splash_timer + 1;
            if (splash_timer >= SPLASH_DURATION) begin
                splash_active <= 0;
                end_animation <= 1;
            end
        end
    end


    // ------------------------------
    // Wavy line coordinate computations
    // ------------------------------

    // Start and end points
    wire [7:0] start_x = p1_x + 35; // top-center of p1
    wire [7:0] start_y = (p1_y > 39) ? (p1_y - 30) : 0;
    wire [7:0] end_x   = p2_x + 15; // top-center of p2
    wire [7:0] end_y   = p2_y;

    // dx, dy for param
    reg [7:0] dx, dy;
    always @* begin
        dx = (end_x > start_x) ? (end_x - start_x) : (start_x - end_x);
        dy = (end_y > start_y) ? (end_y - start_y) : (start_y - end_y);
    end

    // Wavy offset function
    function integer wave_offset;
        input integer t_idx;
        integer mod8;
        begin
            mod8 = t_idx % 8; // repeats every 8
            if (mod8 < 4)
                wave_offset = mod8;  // 0..3
            else
                wave_offset = 8 - mod8; // 4..1
        end
    endfunction

    // Beam thickness function
    function integer beam_thickness;
        input integer t_idx;
        integer val;
        begin
            // linear from 1..4 across the entire path
            val = 1 + (3 * t_idx) / (LINE_MAX - 1); // 1..4
            beam_thickness = val;
        end
    endfunction

    // ------------------------------
    // OLED Display logic
    // ------------------------------
    always @(posedge clk_100MHz) begin

        // If the splash screen is active, show the splash instead.
        if (splash_active) begin
            // Example: fill the screen with a color
            
            pixel_out = (start_turn==0)? pixel_data_splash_screen : pixel_data_splash_screenplayer1; // e.g. some distinct color
        end else begin
            // Normal background
            pixel_out = 16'hFFFF;

            // Draw Pok mon 1
            if ((oled_x >= p1_x) && (oled_x < (p1_x + 40)) &&
                (oled_y <= p1_y) && (oled_y > p1_y - 40)) begin
                sprite_x = oled_x - p1_x;
                sprite_y = oled_y - (p1_y - 39);
                if (heal_animation_active && heal_timer[2]) begin
                        // Flicker color (e.g., bright pink)
                        pixel_out = 16'h07E0;
                    end 
                    else begin
                        // Normal sprite color
                        pixel_out = cpok1;
                    end
            end
            // Draw Pok mon 2 (blink logic)
            else if ((oled_x >= p2_x) && (oled_x < (p2_x + 30)) &&
                     (oled_y >= p2_y) && (oled_y < p2_y + 30)) begin
                // if blink_active==1 and blink_state==1, skip drawing
                if (!(blink_active && blink_state)) begin
                    sprite_x2 = oled_x - p2_x;
                    sprite_y2 = oled_y - p2_y;
                    pixel_out = cpok2;
                end
            end

            // Draw the wavy special attack line with widening thickness
            if (special_animation_active) begin
                on_line = 0; // default
                for (t = 0; t < LINE_MAX; t = t + 1) begin
                    if (t < line_progress) begin
                        // base param for the line
                        calc_x = start_x + ((end_x >= start_x) ? ((dx * t) / LINE_MAX)
                                                               : -((dx * t) / LINE_MAX));
                        calc_y = start_y + ((end_y >= start_y) ? ((dy * t) / LINE_MAX)
                                                               : -((dy * t) / LINE_MAX));
                        // add wave offset
                        calc_y = calc_y + (wave_offset(t) - 2);

                        // compute thickness
                        thick = beam_thickness(t);

                        // bounding box check
                        if ((oled_x >= calc_x - thick) && (oled_x <= calc_x + thick) &&
                            (oled_y >= calc_y - thick) && (oled_y <= calc_y + thick)) begin
                            on_line = 1;
                        end
                    end
                end

                if (on_line) begin
                    pixel_out = color_beam;
                end
            end
        end // end splash else
    end

endmodule
