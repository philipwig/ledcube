

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

    input wire ctrl_disp_buffer, // Which framebuffer to read from

    // BRAM interface
    output reg mem_clk, mem_en, mem_buffer, mem_bit,
    output reg [R_MEM_ADDR_WIDTH-1:0] mem_addr,
    input wire [R_MEM_DATA_WIDTH-1:0] mem_dout,

    // Display interface
    output reg disp_clk, disp_blank, disp_latch,
    output reg [4:0] disp_addr,
    output reg disp_r0, disp_g0, disp_b0,
    output reg disp_r1, disp_g1, disp_b1
);
    reg [$clog2(N_COLS_MAX)-1:0] cnt_col;
    reg [$clog2(N_ROWS_MAX)-1:0] cnt_row;
    reg [$clog2(BITDEPTH_MAX)-1:0] cnt_bit;


    reg bcm_go, bcm_done;


    // ****************
    // * Main Control *
    // ****************
    localparam integer MAIN_STATES = $clog2(5);
    localparam [MAIN_STATES-1:0]
        startup = 3'd0,
        idle = 3'd1,
        latch = 3'd2,
        unlatch = 3'd3,
        wait_reset = 3'd4;
    reg [MAIN_STATES-1:0] main_state;
    
    always @(posedge clk) begin
        if (ctrl_rst) begin
            main_state <= startup;
            cnt_row <= 0;
            cnt_bit <= 0;
        end else if (ctrl_en) begin
            case (main_state)
                startup:
                    main_state <= idle;
                // idle:

                // latch:
                // wait_reset:
                // default: 
            endcase
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

    always @(posedge clk) begin
        if (ctrl_rst) begin
            bcm_state <= bcm_idle;
            cnt_col <= 0;
            bcm_done <= 1'b1;
            disp_clk <= 0;
            disp_addr <= 0;
        end else begin
            case (bcm_state)
                bcm_idle: begin
                    if (bcm_go) begin
                        bcm_state <= bcm_shift1;
                        cnt_col <= 0;
                        bcm_done <= 0;
                        disp_addr <= cnt_row;
                        mem_addr <= (cnt_row * ctrl_bitdepth * ctrl_n_cols) + (cnt_bit * ctrl_n_cols) + (ctrl_n_cols * ctrl_n_rows * ctrl_bitdepth * ctrl_disp_buffer);
                    end else begin
                        bcm_done <= 1'b1;
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
                        mem_addr <= mem_addr + 1;
                    end else begin
                        bcm_state <= idle;
                    end
                end

                default:
                    bcm_state <= bcm_idle;
            endcase
        end
    end


endmodule