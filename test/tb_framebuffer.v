
`include "framebuffer.v"

`timescale 1 ns / 10 ps

module tb_framebuffer;
    parameter N_ROWS_MAX = 64; // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 64*4; // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8; // Bits per color (bpc), 8 gives 24 bits per pixel

    parameter CTRL_REG_WIDTH = 32; // Width of ctrl reg

    // ******** Calculated parameters, DO NOT CHANGE ********
    parameter MEM_W_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX); // Full panel size
    parameter MEM_W_DATA_WIDTH = 32; // Full number of bits per pixel
    parameter MEM_R_ADDR_WIDTH = MEM_W_ADDR_WIDTH - 1; // Half of total frame width since top/bottom
    parameter MEM_R_DATA_WIDTH = 6; // R0, G0, B0, R1, G1, G1 -> 6 total

    reg w_clk, w_en, w_buffer;
    reg [MEM_W_ADDR_WIDTH-1:0] w_addr;
    reg [MEM_W_DATA_WIDTH/8-1:0] w_strb;
    reg [MEM_W_DATA_WIDTH-1:0] w_din;

    reg [CTRL_REG_WIDTH-1:0] ctrl_bitdepth;

    reg r_clk, r_en, r_buffer;
    reg [MEM_R_ADDR_WIDTH-1:0] r_addr;
    reg [$clog2(BITDEPTH_MAX)-1:0] r_bit;
    wire [MEM_R_DATA_WIDTH-1:0] r_dout;
    
    framebuffer #(
        .N_ROWS_MAX(N_ROWS_MAX),
        .N_COLS_MAX(N_COLS_MAX),
        .BITDEPTH_MAX(BITDEPTH_MAX),
        .CTRL_REG_WIDTH(CTRL_REG_WIDTH)
    ) dut (
        .w_clk,
        .w_en,
        .w_buffer,
        .w_addr,
        .w_strb,
        .w_din,
        .ctrl_bitdepth,
        .r_clk,
        .r_en,
        .r_buffer,
        .r_addr,
        .r_bit,
        .r_dout
    );

    // ******** Simulation ********
    localparam PERIOD = 2;

    reg [MEM_W_DATA_WIDTH-1:0] result_upper, result_lower;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    always #(PERIOD/2) w_clk <= ~w_clk;
    always #(PERIOD/2) r_clk <= ~r_clk;

    initial begin
        // ********* Set initial values ***********
        w_clk = 1'b0;
        r_clk = 1'b0;
        
        repeat (1) @(negedge w_clk);
        w_en <= 1'b0;
        w_buffer <= 1'b0;
        w_addr <= 0;
        w_strb <= 0;
        w_din <= 0;
        ctrl_bitdepth <= 8;
        // ****************************************


        // ******** Write values into ram *********
        // Write value to first pixel on panel
        repeat (2) @(negedge w_clk);
        w_en <= 1'b1;
        w_addr <= 0;
        w_strb <= 4'b1111;
        w_din <= 24'hAAFF11;

        repeat (1) @(negedge w_clk);
        w_en <= 1'b0;

        // Write value to first pixel in bottom half
        repeat (2) @(negedge w_clk);
        w_en <= 1'b1;
        w_addr <= 2048;
        w_strb <= 4'b1111;
        w_din <= 24'hAAFF11;

        repeat (1) @(negedge w_clk);
        w_en <= 1'b0;
        // ****************************************


        // ******** Read values from ram **********
        repeat (1) @(negedge w_clk);
        r_addr <= 0;
        r_buffer <= 1'b0;
        r_en <= 1'b1;

        for (integer i=0; i<8; i=i+1) begin
            r_bit <= i;
            repeat (1) @(negedge w_clk);
            result_upper[8*2+i] <= r_dout[5];
            result_upper[8*1+i] <= r_dout[4];
            result_upper[8*0+i] <= r_dout[3];
            result_lower[8*2+i] <= r_dout[2];
            result_lower[8*1+i] <= r_dout[1];
            result_lower[8*0+i] <= r_dout[0];
        end

        r_en <= 1'b0;

        // Check if correct values read
        repeat (1) @(negedge w_clk);
        if ((result_upper == w_din)) $display("Result upper passed");
        else $display("Result upper  failed");
        if ((result_upper == w_din)) $display("Result lower passed");
        else $display("Result lower  failed");
        // ****************************************


        // repeat (5) @(negedge w_clk);
        $finish();
    end


    // initial begin
    //     w_clk = 1'b0;
    //     forever begin
    //         #1 w_clk = ~w_clk;
    //     end
    // end


    // assign w_clk = clk;
    // assign r_clk = clk;







endmodule