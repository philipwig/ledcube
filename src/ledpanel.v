

/**
    TODO:
        Zigzag scanning
        gamma correction
    
    DONE:
        LSB of each row needs to be latched in on the last blank cycle of the previous row

*/

`timescale 1 ns / 10 ps

`default_nettype none
module ledpanel #(
    parameter N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 256, // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel
    parameter LSB_BLANK_MAX = 200,

    parameter CTRL_WIDTH = 32, // Width of ctrl reg

    // ******** Calculated parameters, DO NOT CHANGE ********
    parameter MEM_DEPTH = N_ROWS_MAX * N_COLS_MAX, // Number of configured pixels
    parameter R_MEM_ADDR_WIDTH = $clog2(MEM_DEPTH) - 1, // Half of total frame width since top/bottom
    parameter R_MEM_DATA_WIDTH = 6 // R0, G0, B0, R1, G1, G1 -> 6 total
) (
    input wire clk, // Global clock
    
    input wire ctrl_en, // Enable or disable module
    input wire ctrl_rst, // Reset module

    // Current configuration, these are not latched
    input wire unsigned [31:0] ctrl_n_rows,
    input wire unsigned [31:0] ctrl_n_cols,
    input wire unsigned [31:0] ctrl_bitdepth,
    input wire unsigned [31:0] ctrl_lsb_blank,


    // BRAM interface
    output wire mem_clk,
    output wire mem_en,
    output wire mem_buffer,
    output wire [R_MEM_ADDR_WIDTH-1:0] mem_addr,
    output wire [$clog2(BITDEPTH_MAX)-1:0] mem_bit,
    input wire [R_MEM_DATA_WIDTH-1:0] mem_din,

    // Display interface
    output reg disp_clk,
    output wire disp_blank,
    output reg disp_latch,
    output wire [4:0] disp_addr,
    output wire disp_r0, disp_g0, disp_b0,
    output wire disp_r1, disp_g1, disp_b1
);

    reg cnt_buffer;
    reg [$clog2(N_COLS_MAX)-1:0] cnt_col;
    reg [$clog2(N_ROWS_MAX)-1:0] cnt_row;
    reg [$clog2(BITDEPTH_MAX)-1:0] cnt_bit;


    // Control reg
    reg bcm_en, bcm_rdy;
    reg blank_en, blank_rdy;


    // ****************
    // * Main Control *
    // ****************
    localparam integer MAIN_STATES = $clog2(4);
    localparam [MAIN_STATES-1:0]
        startup = 0,
        idle = 1,
        unlatch = 2,
        wait_reset = 3;
    reg [MAIN_STATES-1:0] main_state;
    
    reg [$clog2(N_ROWS_MAX)-1:0] disp_row;
    assign disp_addr = disp_row;

    always @(posedge clk) begin
        if (ctrl_rst) begin
            main_state <= startup;
        end else if (ctrl_en) begin
            case (main_state)
                startup: begin
                    main_state <= wait_reset;

                    cnt_buffer <= 1'b0;
                    cnt_row <= 0;
                    cnt_bit <= 0;
                    disp_row <= ctrl_n_rows - 1;

                    disp_latch <= 1'b0;
                    blank_en <= 1'b1; // Start blanking
                    bcm_en <= 1'b1; // Start bcm shifting
                end

                idle: begin
                    if (blank_rdy && bcm_rdy) begin
                        main_state <= unlatch;
                        disp_latch <= 1'b1; // Latch
                    end

                end
                
                unlatch: begin
                    main_state <= wait_reset;

                    disp_latch <= 1'b0; // Unlatch
                    blank_en <= 1'b1; // Start blanking
                    bcm_en <= 1'b1; // Start bcm shifting

                    if (cnt_bit < ctrl_bitdepth - 1) begin
                        cnt_bit <= cnt_bit + 1;
                        disp_row <= cnt_row;
                    end else begin
                        cnt_bit <= 0;

                        // Increment row (FUTURE: implement ZIGZAG scanning)
                        if (cnt_row < ctrl_n_rows - 1) begin
                            cnt_row <= cnt_row + 1;
                        end else begin
                            cnt_row <= 0;
                            cnt_buffer <= ~cnt_buffer;
                        end
                    end

                end

                wait_reset: begin
                    if (!blank_rdy && !bcm_rdy) begin
                        main_state <= idle;

                        blank_en <= 1'b0;
                        bcm_en <= 1'b0;
                    end
                end

                default:
                    main_state <= startup;
            endcase
        end else begin
            main_state <= startup;
        end
    end


    // ***************
    // * BCM Shifter *
    // ***************
    localparam integer BCM_STATES = $clog2(3);
    localparam
        bcm_idle = 1,
        bcm_shift1 = 2,
        bcm_shift2 = 3;
    reg [BCM_STATES-1:0] bcm_state;

    assign mem_clk = clk;
    // assign mem_en = ~bcm_rdy;
    assign mem_en = 1'b1;
    assign mem_buffer = cnt_buffer;
    assign mem_addr = (cnt_row * ctrl_n_cols) + cnt_col;
    assign mem_bit = cnt_bit;

    assign {disp_r0, disp_g0, disp_b0, disp_r1, disp_g1, disp_b1} = mem_din;

    always @(posedge clk) begin
        if (ctrl_rst) begin
            bcm_state <= bcm_idle;

            cnt_col <= 0;
            bcm_rdy <= 1'b1;

            disp_clk <= 1'b0;
        end else begin
            case (bcm_state)
                bcm_idle: begin
                    disp_clk <= 1'b0;

                    if (bcm_en) begin
                        bcm_state <= bcm_shift2;
                        bcm_rdy <= 1'b0;
                    end
                end

                bcm_shift1: begin
                    bcm_state <= bcm_shift2;
                    disp_clk <= 1'b0;
                end

                bcm_shift2: begin
                    disp_clk <= 1'b1;

                    if (cnt_col < ctrl_n_cols - 1) begin
                        cnt_col <= cnt_col + 1;
                        bcm_state <= bcm_shift1;
                    end else begin
                        cnt_col <= 0;
                        bcm_state <= bcm_idle;
                        bcm_rdy <= 1'b1;
                    end
                end

                default:
                    bcm_state <= bcm_idle;
            endcase
        end
    end


    // ************
    // * Blanking *
    // ************
    localparam BLANK_MAX = 2 * (2**(BITDEPTH_MAX-1)) * LSB_BLANK_MAX;
    reg [$clog2(BLANK_MAX):0] blank_counter;

    reg [$clog2(BITDEPTH_MAX):0] blank_bit;

    // disp_blank <= 1'b0; // Display on
    // disp_blank <= 1'b1; // Display off
    assign disp_blank = blank_rdy;

    always @(posedge clk) begin
        if (ctrl_rst) begin
            blank_bit = ctrl_bitdepth - 2; // Start with longest BCM bit so next pixel can be shifted in
            blank_counter <= 0;

            blank_rdy <= 1'b1;
        end else if (blank_en && blank_rdy) begin
            // Start blanking
            blank_rdy <= 1'b0;

            // Increment current bit number
            if (blank_bit < ctrl_bitdepth - 1) blank_bit = blank_bit + 1;
            else blank_bit = 0;

            // Calculate blank_counter
            blank_counter <= 2 * (1<<blank_bit) * ctrl_lsb_blank - 1;
        end else begin
            if (blank_counter > 0) blank_counter <= blank_counter - 1; // Decrement blank counter
            else blank_rdy <= 1'b1; // Blanking done
        end
    end
endmodule