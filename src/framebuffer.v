// Framebuffer

// File: framebuffer.sv

`include "dual_bram.v"

`timescale 1 ns / 10 ps

`default_nettype none
module framebuffer #(
    // User defined parameters
    parameter N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 256, // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel

    parameter CTRL_WIDTH = 32, // Width of ctrl reg

    // ******** Calculated parameters, DO NOT CHANGE ********
    parameter MEM_DEPTH = N_ROWS_MAX * N_COLS_MAX,  // Number of configured pixels
    parameter W_MEM_ADDR_WIDTH = $clog2(MEM_DEPTH), // Full panel size
    parameter W_MEM_DATA_WIDTH = BITDEPTH_MAX * 3, // Full number of bits per pixel
    parameter R_MEM_ADDR_WIDTH = W_MEM_ADDR_WIDTH - 1, // Half of total frame width since top/bottom
    parameter R_MEM_DATA_WIDTH = 6 // R0, G0, B0, R1, G1, G1 -> 6 total
) (
    // Write Port
    input wire w_clk, w_en,
    input wire w_buffer,  // Which buffer of dual buffer to write
    input wire [W_MEM_ADDR_WIDTH-1:0] w_addr,
    input wire [W_MEM_DATA_WIDTH-1:0] w_din,

    // Read control
    input wire [CTRL_WIDTH-1:0] ctrl_bitdepth,
    
    // Read Port
    input wire r_clk, r_en,
    input wire r_buffer, // Which buffer of dual buffer to read
    input wire [R_MEM_ADDR_WIDTH-1:0] r_addr,
    input wire [$clog2(BITDEPTH_MAX)-1:0] r_bit, // Which bit to read
    output wire [R_MEM_DATA_WIDTH-1:0] r_dout
);

    // Just do two ram blocks, one high and one low
    // Could even split up into r, g, b blocks for greater efficiency?

    /** From https://docs.xilinx.com/v/u/en-US/ug473_7Series_Memory_Resources page 11:
        Each 36 Kb block RAM can be configured as a 64K x 1 (when cascaded with an adjacent 36 Kb block RAM),
        32K x 1, 16K x 2, 8K x 4, 4K x 9, 2K x 18, 1K x 36, or 512 x 72 in simple dual-port mode.
        Each 18 Kb block RAM can be configured as a 16K x 1, 8K x2 , 4K x 4, 2K x 9, 1K x 18 or
        512 x 36 in simple dual-port mode.
    **/

    wire [W_MEM_DATA_WIDTH-1:0] r_upper_dout, r_lower_dout;

    /**
        The upper and lower mem store half of the full frame.
        For 64x64 (64 col, 64 rows) panel with 8 bpc (24 bits total)

        Upper: 64x32
            MEM_DEPTH = 64*32*2
            MEM_ADDR_WIDTH = $clog2(MEM_DEPTH)
            MEM_DATA_WIDTH = BITDEPTH_MAX * 3 (so 24 bits, 3 * 8bpc)

        When writing to framebuffer, think it is 64x64 array
        When reading from framebuffer, think it is 2 64x32 arrays
    */


    dual_bram #(
        .ADDR_WIDTH(R_MEM_ADDR_WIDTH+1), // Use half height addr width + 1 to implement dual buffer
        .DATA_WIDTH(W_MEM_DATA_WIDTH) // Use full write width for 3*BITDEPTH_MAX
    ) mem_upper (
        .a_clk(w_clk),
        .a_we(~w_addr[W_MEM_ADDR_WIDTH-1] & w_en), // MSB bit of addr, invert to get enable
        .a_addr({w_buffer, w_addr[W_MEM_ADDR_WIDTH-2:0]}), // Rest of the bits
        .a_din(w_din),

        .b_clk(r_clk),
        .b_re(r_en),
        .b_addr({r_buffer, r_addr}),
        .b_dout(r_upper_dout)
    );

    dual_bram #(
        .ADDR_WIDTH(R_MEM_ADDR_WIDTH+1), // Use half height addr width + 1 to implement dual buffer
        .DATA_WIDTH(W_MEM_DATA_WIDTH) // Use full write width for 3*BITDEPTH_MAX
    ) mem_lower (
        .a_clk(w_clk),
        .a_we(w_addr[W_MEM_ADDR_WIDTH-1] & w_en), // MSB bit of addr, don't invert to get enable
        .a_addr({w_buffer, w_addr[W_MEM_ADDR_WIDTH-2:0]}), // Rest of the bits
        .a_din(w_din),

        .b_clk(r_clk),
        .b_re(r_en),
        .b_addr({r_buffer, r_addr}),
        .b_dout(r_lower_dout)
    );
    

    assign r_dout = {
        r_upper_dout[(ctrl_bitdepth*2)+r_bit +:1], // R0
        r_upper_dout[(ctrl_bitdepth*1)+r_bit +:1], // G0
        r_upper_dout[(ctrl_bitdepth*0)+r_bit +:1], // B0

        r_lower_dout[(ctrl_bitdepth*2)+r_bit +:1], // R1
        r_lower_dout[(ctrl_bitdepth*1)+r_bit +:1], // G1
        r_lower_dout[(ctrl_bitdepth*0)+r_bit +:1]  // B1
    };

    // // Read Port
    // always @(posedge r_clk) begin
    //     // if (r_en) begin
    //         // index = ((ctrl_bitdepth*2)+r_bit + 1) - 1
    //         r_dout <= {
    //             r_upper_dout[(ctrl_bitdepth*2)+r_bit +:1], // R0
    //             r_upper_dout[(ctrl_bitdepth*1)+r_bit +:1], // G0
    //             r_upper_dout[(ctrl_bitdepth*0)+r_bit +:1], // B0

    //             r_lower_dout[(ctrl_bitdepth*2)+r_bit +:1], // R1
    //             r_lower_dout[(ctrl_bitdepth*1)+r_bit +:1], // G1
    //             r_lower_dout[(ctrl_bitdepth*0)+r_bit +:1]  // B1
    //         };
    //     // end
    // end
    

endmodule