
`include "ledpanel.v"

`timescale 1 ns / 10 ps

module tb_ledpanel;
    parameter N_ROWS_MAX = 64; // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 256; // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8; // Bits per color (bpc), 8 gives 24 bits per pixel
    parameter LSB_BLANK_MAX = 200;

    parameter CTRL_WIDTH = 32; // Width of ctrl reg

    // ******** Calculated parameters, DO NOT CHANGE ********
    parameter MEM_DEPTH = N_ROWS_MAX * N_COLS_MAX; // Number of configured pixels
    parameter R_MEM_ADDR_WIDTH = $clog2(MEM_DEPTH) - 1; // Half of total frame width since top/bottom
    parameter R_MEM_DATA_WIDTH = 6; // R0, G0, B0, R1, G1, G1 -> 6 total

    reg clk; // Global clock
    
    reg ctrl_en; // Enable or disable module
    reg ctrl_rst; // Reset module

    // Current configuration, these are not latched
    reg unsigned [CTRL_WIDTH-1:0] ctrl_n_rows;
    reg unsigned [CTRL_WIDTH-1:0] ctrl_n_cols;
    reg unsigned [CTRL_WIDTH-1:0] ctrl_bitdepth;
    reg unsigned [CTRL_WIDTH-1:0] ctrl_lsb_blank;


    // BRAM interface
    wire mem_clk;
    wire mem_en;
    wire mem_buffer;
    wire [R_MEM_ADDR_WIDTH-1:0] mem_addr;
    wire [$clog2(BITDEPTH_MAX)-1:0] mem_bit;
    reg [R_MEM_DATA_WIDTH-1:0] mem_din;

    // Display interface
    wire disp_clk;
    wire disp_blank;
    wire disp_latch;
    wire [4:0] disp_addr;
    wire disp_r0, disp_g0, disp_b0;
    wire disp_r1, disp_g1, disp_b1;


    ledpanel #(
        .N_ROWS_MAX(N_ROWS_MAX),
        .N_COLS_MAX(N_COLS_MAX),
        .BITDEPTH_MAX(BITDEPTH_MAX),
        .CTRL_WIDTH(CTRL_WIDTH)
    ) dut (
        .clk, // Global clock
    
        .ctrl_en, // Enable or disable module
        .ctrl_rst, // Reset module

        // Current configuration, these are not latched
        .ctrl_n_rows,
        .ctrl_n_cols,
        .ctrl_bitdepth,
        .ctrl_lsb_blank,

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
        .disp_r1, .disp_g1, .disp_b1
    );


    // ******** Simulation ********
    localparam PERIOD = 2;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    always #(PERIOD/2) clk <= ~clk;

    initial begin
        // ********* Set initial values ***********
        clk = 1'b0;
        
        repeat (1) @(negedge clk);
        ctrl_en <= 1'b0;
        ctrl_rst <= 1'b0;

        ctrl_n_rows <= 5;
        ctrl_n_cols <= 5;
        ctrl_bitdepth <= 4;
        ctrl_lsb_blank <= 5;
        // ****************************************


        // **** Set pixel value read from ram *****
        mem_din <= 6'b101010;
        // ****************************************


        // ******** Run simulation *********
        // Reset ledpanel
        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b1;

        repeat (1) @(negedge clk);
        ctrl_rst <= 1'b0;
        ctrl_en <= 1'b1;

        repeat (5000) @(negedge clk);
        // ****************************************


        // repeat (5) @(negedge clk);
        $finish();
    end


    // initial begin
    //     clk = 1'b0;
    //     forever begin
    //         #1 clk = ~clk;
    //     end
    // end


    // assign clk = clk;
    // assign r_clk = clk;







endmodule