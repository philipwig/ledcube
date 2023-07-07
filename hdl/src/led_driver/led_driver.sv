
/**
    TODO:
        Add condition to have to reset to load new ctrl values. Register the ctrl values so they do not change without a reset (or en low?)
        gamma correction
            LUT or some sort of polynomial approx. Can possibly use 3 cycles to perform lookup so only one LUT is needed
        Zigzag scanning
            Scan first row, then last row, then second row, then second to last
            For 64x64 panel with 1:32
            Ex: {0, 32}, {31, 63}, {1, 33}, {30, 62}, {2, 34}, {29, 61}, ...
        Make disp_clk an actual gated output clock in vivado to be able to apply timing constraints to it
    
    DONE:
        LSB of each row needs to be latched in on the last blank cycle of the previous row
        global dimming

*/


`define ZIGZAG

`timescale 1 ns / 10 ps

`default_nettype none
module led_driver #(
    parameter integer N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
    parameter integer N_COLS_MAX = 256, // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter integer BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel
    parameter integer LSB_BLANK_MAX = 200,

    parameter integer CTRL_REG_WIDTH = 32, // Width of ctrl reg

    // ********** Calculated parameters **********
    parameter integer MEM_R_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX) - 1, // Half of total frame width since top/bottom
    parameter integer MEM_R_DATA_WIDTH = 6 // R0, G0, B0, R1, G1, G1 -> 6 total
) (
    input wire clk, // Global clock

    (* mark_debug = "true" *) input wire ctrl_en, // Enable or disable module
    (* mark_debug = "true" *) input wire ctrl_rst, // Reset module

    // Current configuration, these are not latched
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_n_rows,
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_n_cols,
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_bitdepth,
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_lsb_blank, // Number of **Display** clock cycles to blank for
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_brightness, // Number of clock cycles to subtract off lsb_blank length. Higher number is less bright
    (* mark_debug = "true" *) input wire [CTRL_REG_WIDTH-1:0] ctrl_buffer, // Which buffer is being written to by linux

    // BRAM interface
    (* mark_debug = "true" *) output wire mem_clk,
    (* mark_debug = "true" *) output wire mem_en,
    (* mark_debug = "true" *) output wire mem_buffer,
    (* mark_debug = "true" *) output wire [MEM_R_ADDR_WIDTH-1:0] mem_addr,
    (* mark_debug = "true" *) output wire [$clog2(BITDEPTH_MAX)-1:0] mem_bit,
    (* mark_debug = "true" *) input wire [MEM_R_DATA_WIDTH-1:0] mem_din,


    // Display interface
    (* mark_debug = "true" *) output reg disp_clk,
    (* mark_debug = "true" *) output reg disp_blank,
    (* mark_debug = "true" *) output reg disp_latch,
    (* mark_debug = "true" *) output wire [4:0] disp_addr,
    (* mark_debug = "true" *) output wire disp_r0, disp_g0, disp_b0,
    (* mark_debug = "true" *) output wire disp_r1, disp_g1, disp_b1,

    // Display sync interrupt
    (* mark_debug = "true" *) output reg irq_disp_sync

);

    (* mark_debug = "true" *) reg cnt_buffer;
    (* mark_debug = "true" *) reg [$clog2(N_COLS_MAX)-1:0] cnt_col;
    (* mark_debug = "true" *) reg [$clog2(N_ROWS_MAX/2)-1:0] cnt_row;
    (* mark_debug = "true" *) reg [$clog2(BITDEPTH_MAX)-1:0] cnt_bit;


    // Control reg
    (* mark_debug = "true" *) reg bcm_en, bcm_rdy;
    (* mark_debug = "true" *) reg blank_en, blank_rdy;


    // ****************
    // * Main Control *
    // ****************
    localparam integer MAIN_STATES = $clog2(4);
    localparam [MAIN_STATES-1:0]
        startup = 0,
        idle = 1,
        unlatch = 2,
        wait_reset = 3;
    (* mark_debug = "true" *) reg [MAIN_STATES-1:0] main_state;

    (* mark_debug = "true" *) reg [$clog2(N_ROWS_MAX/2)-1:0] disp_row;
    assign disp_addr = disp_row;

    (* mark_debug = "true" *) reg [$clog2(BITDEPTH_MAX):0] blank_bit;

    (* mark_debug = "true" *) reg [$clog2(N_ROWS_MAX/2)-1:0] zig_row;


    initial begin
        main_state <= startup;
    end

    // Take the value of ctrl buffer immediately
    // TODO: Make a way to sync arm cores to device
    always @(*) begin
        // cnt_buffer = ~ctrl_buffer;
        cnt_buffer = 1'b0;
    end

    always @(posedge clk) begin
        if (ctrl_rst) begin
            main_state <= startup;
        end else if (ctrl_en) begin
            case (main_state)
                startup: begin
                    main_state <= wait_reset;

                    // cnt_buffer <= ~ctrl_buffer;
                    cnt_row <= 0;
                    zig_row = 0;
                    cnt_bit <= 0;
                    disp_row <= ctrl_n_rows - 1;
                    blank_bit <= ctrl_bitdepth - 1;

                    disp_latch <= 1'b0;
                    blank_en <= 1'b1; // Start blanking
                    bcm_en <= 1'b1; // Start bcm shifting

                    irq_disp_sync <= 1'b0;
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

                        `ifdef ZIGZAG
                        if (zig_row < ctrl_n_rows/2 - 1) begin

                            zig_row = zig_row + 1;

                            if (~zig_row[0]) begin// Even
                                cnt_row <= zig_row/2;
                            end else begin
                                cnt_row <= ctrl_n_rows/2 - zig_row/2 - 1;
                            end



                            // row <= ~(row + {LOG_N_ROWS{row[LOG_N_ROWS-1]}});
                            /**


                            if cnt even
                                cnt_row = cnt / 2   // use bitshift
                                cnt_row = cnt >> 1;
                            if cnt odd
                                cnt_row = ctrl_n_rows >> 1 - cnt >> 1 - 1;
                                cnt_row = ctrl_n_rows / 2 - 1 - cnt / 2;
                                cnt_row = 15 - cnt/2;

                            cnt = cnt + 1;


                            cnt_row = 0; cnt = 0;
                            cnt_row = 15; cnt = 1;
                            cnt_row = 1; cnt = 2;
                            cnt_row = 14; cnt = 3;
                            cnt_row = 2; cnt = 4;

                            cnt_row = 13; cnt = 5;
                            cnt_row = 3; cnt = 6;
                            cnt_row = 12; cnt = 7;
                            cnt_row = 4; cnt = 8;

                            cnt_row = 11; cnt = 9;
                            cnt_row = 5; cnt = 10;
                            cnt_row = 10; cnt = 11;
                            cnt_row = 6; cnt = 12;
                            cnt_row = 9; cnt = 13;
                            cnt_row = 7; cnt = 14;
                            cnt_row = 8; cnt = 15;

                            cnt_row + 1;

                            if cnt_row odd
                                cnt_row = ctrl_n_row/2 - cnt;
                            else
                                cnt_row = cnt
                            */
                        end else begin
                            // Flip buffers and start scanning new panel
                            irq_disp_sync <= 1'b1;
                            cnt_row <= 0;
                            zig_row = 0;
                            // cnt_buffer <= ~ctrl_buffer;
                            // cnt_buffer <= ~cnt_buffer;
                        end
                        `else
                        // Increment row (FUTURE: implement ZIGZAG scanning)
                        if (cnt_row < ctrl_n_rows/2 - 1) begin
                            cnt_row <= cnt_row + 1;
                        end else begin
                            // Flip buffers and start scanning new panel
                            irq_disp_sync <= 1'b1;
                            cnt_row <= 0;
                            // cnt_buffer <= ~ctrl_buffer;
                            // cnt_buffer <= ~cnt_buffer;
                        end
                        `endif
                    end

                    blank_bit <= cnt_bit;
                end

                wait_reset: begin
                    irq_disp_sync <= 1'b0;

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
    (* mark_debug = "true" *) reg [BCM_STATES-1:0] bcm_state;

    assign mem_clk = clk;
    // assign mem_en = ~bcm_rdy;
    assign mem_en = 1'b1;
    assign mem_buffer = cnt_buffer;
    assign mem_addr = (cnt_row * ctrl_n_cols) + cnt_col;
    assign mem_bit = cnt_bit;

    assign {disp_r0, disp_g0, disp_b0, disp_r1, disp_g1, disp_b1} = mem_din;

    initial begin
        bcm_state <= bcm_idle;
        cnt_col <= 0;
        bcm_rdy <= 1'b1;
        disp_clk <= 1'b0;
    end


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
    localparam integer BLANK_MAX = 2 * (2**(BITDEPTH_MAX-1)) * LSB_BLANK_MAX;
    (* mark_debug = "true" *) reg [$clog2(BLANK_MAX):0] blank_counter;

    (* mark_debug = "true" *) reg [$clog2(BLANK_MAX):0] bright_counter; 


    // disp_blank <= 1'b0; // Display on
    // disp_blank <= 1'b1; // Display off
    // assign disp_blank = blank_rdy;
    // assign disp_blank = disp_blank;

    initial begin
        // blank_bit <= ctrl_bitdepth - 2; // Start with longest BCM bit so next pixel can be shifted in
        blank_counter <= 0;

        bright_counter <= 0;
        disp_blank <= 1'b1;

        blank_rdy <= 1'b1;
    end

    always @(posedge clk) begin
        if (ctrl_rst) begin
            // blank_bit = ctrl_bitdepth - 2; // Start with longest BCM bit so next pixel can be shifted in
            blank_counter <= 0;

            bright_counter <= 0;
            disp_blank <= 1'b1;

            blank_rdy <= 1'b1;
        end else if (blank_en && blank_rdy) begin
            // Start blanking
            blank_rdy <= 1'b0;
            disp_blank <= 1'b0;

            // if (blank_bit < ctrl_bitdepth - 1) blank_bit = blank_bit + 1;
            // else blank_bit = 0;

            // Calculate blank_counter
            blank_counter <= 2 * (1<<blank_bit) * ctrl_lsb_blank - 1;
            bright_counter <= (2 * (1<<blank_bit) * (ctrl_lsb_blank - ctrl_brightness)) - 1;

        end else begin
            if (blank_counter > 0) begin
                blank_counter <= blank_counter - 1; // Decrement blank counter

                if (bright_counter > 0) bright_counter <= bright_counter - 1;
                else disp_blank <= 1'b1; // Display off early to adjust brightness

            end else begin
                blank_rdy <= 1'b1; // Blanking done
                disp_blank <= 1'b1; // Display off

                // Increment current bit number - WHY NOT JUST USE CNT_BIT????????
                // if (blank_bit < ctrl_bitdepth - 1) blank_bit <= blank_bit + 1;
                // else blank_bit <= 0;
            end
        end
    end
endmodule