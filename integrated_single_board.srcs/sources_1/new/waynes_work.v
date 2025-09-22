module pokemon_selector(
    input  wire [1:0] choice,         // 2-bit choice: 00=Bulbasaur, 01=Squirtle, 10=Charmander
    input  wire [12:0] pixel_index, 
  // 0..6143 for 96x64
    output reg  [15:0] pixel_data     // pixel color output
);

    // The screen resolution assumed is 96 (width) x 64 (height).
    // We'll place a 30x30 sprite in the center:
    //   x_center = (96 - 30)/2 = 33
    //   y_center = (64 - 30)/2 = 17

    // Compute Flipped OLED coordinates
    wire [6:0] x = 95 - pixel_index % 96;
    wire [6:0] y = 63 - pixel_index / 96;
    // Compute  OLED coordinates
//    wire [6:0] x = pixel_index % 96;
//    wire [6:0] y =  pixel_index / 96;

    // We'll define the bounding box for the sprite:
    localparam SPRITE_W = 30;
    localparam SPRITE_H = 30;
    localparam SPRITE_X_START = 33;  // center-left
    localparam SPRITE_Y_START = 17;  // center-top

    // The 3 small ROM modules. We'll instantiate all, but only select one's data.
    // Each expects sprite_x, sprite_y in 5 bits if size=32, but 30 fits in 5 bits too.

    wire [15:0] bulba_color;
    wire [15:0] squirtle_color;
    wire [15:0] charmander_color;

    // We'll track the local (sprite_x, sprite_y)
    reg [4:0] sprite_x;
    reg [4:0] sprite_y;

    // Bulbasaur small instance
    bulbasaur_small bulba_rom(
        .x(sprite_x),
        .y(sprite_y),
        .color(bulba_color)
    );

    // Squirtle small instance
    squirtle_small squirtle_rom(
        .x(sprite_x),
        .y(sprite_y),
        .color(squirtle_color)
    );

    // Charmander small instance
    charmander_small charmander_rom(
        .x(sprite_x),
        .y(sprite_y),
        .color(charmander_color)
    );

    // Combinational logic
    always @(*) begin
        // Default to white background
        pixel_data = 16'hFFFF;

        // Check if the pixel is within the 30x30 bounding box
        if ((x >= SPRITE_X_START) && (x < SPRITE_X_START + SPRITE_W) &&
            (y >= SPRITE_Y_START) && (y < SPRITE_Y_START + SPRITE_H))
        begin
            // Map (x,y) to local sprite coordinates
            sprite_x = x - SPRITE_X_START;  // 0..29
            sprite_y = y - SPRITE_Y_START;  // 0..29

            // Select the sprite color based on choice
            case (choice)
                2'b10: pixel_data = bulba_color;       // Bulbasaur
                2'b00: pixel_data = squirtle_color;    // Squirtle
                2'b01: pixel_data = charmander_color;  // Charmander
                default: pixel_data = squirtle_color;     // fallback
            endcase
        end
    end

endmodule
