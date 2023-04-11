
`ifndef DUMP_FILE_NAME
`define DUMP_FILE_NAME "tb_led_driver.vcd"
`endif

`include "led_driver.sv"

`timescale 1 ns / 10 ps


module tb_led_driver;
    parameter integer N_ROWS_MAX = 64; // Total num rows on panel (64 for 64x64 panel)
    parameter integer N_COLS_MAX = 256; // Number of panels * number of cols per panel
    parameter integer BITDEPTH_MAX = 8; // Bits per color (bpc), 8 gives 24 bits per pixel
    parameter integer LSB_BLANK_MAX = 100;

    parameter integer CTRL_REG_WIDTH = 32; // Width of ctrl reg

    // ******** Calculated parameters, DO NOT CHANGE ********
    parameter integer MEM_R_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX) - 1; // Half of total frame
    parameter integer MEM_R_DATA_WIDTH = 6; // R0, G0, B0, R1, G1, G1 -> 6 total

    reg clk; // Global clock

    reg ctrl_en; // Enable or disable module
    reg ctrl_rst; // Reset module

    // Current configuration, these are not latched
    reg unsigned [CTRL_REG_WIDTH-1:0] ctrl_n_rows;
    reg unsigned [CTRL_REG_WIDTH-1:0] ctrl_n_cols;
    reg unsigned [CTRL_REG_WIDTH-1:0] ctrl_bitdepth;
    reg unsigned [CTRL_REG_WIDTH-1:0] ctrl_lsb_blank;
    reg unsigned [CTRL_REG_WIDTH-1:0] ctrl_brightness;


    // BRAM interface
    wire mem_clk;
    wire mem_en;
    wire mem_buffer;
    wire [MEM_R_ADDR_WIDTH-1:0] mem_addr;
    wire [$clog2(BITDEPTH_MAX)-1:0] mem_bit;
    reg [MEM_R_DATA_WIDTH-1:0] mem_din;

    // Display interface
    wire disp_clk;
    wire disp_blank;
    wire disp_latch;
    wire [4:0] disp_addr;
    wire disp_r0, disp_g0, disp_b0;
    wire disp_r1, disp_g1, disp_b1;

    wire irq_disp_sync;


    led_driver #(
        .N_ROWS_MAX(N_ROWS_MAX),
        .N_COLS_MAX(N_COLS_MAX),
        .BITDEPTH_MAX(BITDEPTH_MAX),
        .CTRL_REG_WIDTH(CTRL_REG_WIDTH)
    ) dut (
        .clk, // Global clock

        .ctrl_en, // Enable or disable module
        .ctrl_rst, // Reset module

        // Current configuration, these are not latched
        .ctrl_n_rows,
        .ctrl_n_cols,
        .ctrl_bitdepth,
        .ctrl_lsb_blank,
        .ctrl_brightness,

        // BRAM interface
        .mem_clk,
        .mem_en,
        .mem_buffer,
        .mem_addr,
        .mem_bit,
        .mem_din,

    // Display interface
        .disp_clk,
        .disp_blank,
        .disp_latch,
        .disp_addr,
        .disp_r0, .disp_g0, .disp_b0,
        .disp_r1, .disp_g1, .disp_b1,

        .irq_disp_sync
    );


    // ******** Simulation ********
    // disp_clk = 30Mhz, system clk = 60MHz
    // localparam PERIOD = 1e9/(2*30e6);

    // disp_clk = 25Mhz, system clk = 50MHz (25MHz seems to be fastest speed)
    localparam integer PERIOD = 1e9/(2*25e6);

    initial begin
        $dumpfile(`DUMP_FILE_NAME);
        $dumpvars;
    end

    always #(PERIOD/2) clk <= ~clk;

    // BRAM Model
    always @(posedge clk) begin
        if (mem_en) begin
            mem_din <= mem_addr;
        end
    end

    initial begin
        // ********* Set initial values ***********
        clk = 1'b0;

        repeat (1) @(negedge clk);
        ctrl_en <= 1'b0;
        ctrl_rst <= 1'b0;

        ctrl_n_rows <= 20;
        ctrl_n_cols <= 8;
        ctrl_bitdepth <= 4;
        ctrl_lsb_blank <= 6;
        ctrl_brightness <= 0; // Full brightness

        // ****************************************


        // **** Set pixel value read from ram *****
        // mem_din <= 6'b101010;
        // ****************************************


        // ******** Run simulation *********
        // Reset ledpanel
        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b1;

        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b0;
        ctrl_en <= 1'b1;

        repeat (5000) @(negedge clk);

        // Reset ledpanel
        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b1;
        ctrl_brightness <= 4; // Half brightness

        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b0;
        ctrl_en <= 1'b1;

        repeat (5000) @(negedge clk);
        // ****************************************


        // repeat (5) @(negedge clk);
        $finish();
    end


endmodule
