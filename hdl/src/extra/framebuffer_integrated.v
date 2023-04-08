// Framebuffer

// File: framebuffer.v

`default_nettype none
module framebuffer #(
    // User defined parameters
    parameter N_ROWS_MAX = 64,
    parameter N_COLS_MAX = 256,
    parameter BITDEPTH_MAX = 8, // bits per color (bpc)

    // Calculated parameters, DO NOT CHANGE

    parameter MEM_DEPTH = N_ROWS_MAX * N_COLS_MAX * 2,

    // Framebuffer mem write parameters
    parameter W_MEM_ADDR_WIDTH = $clog2(MEM_DEPTH),
    parameter W_MEM_DATA_WIDTH = BITDEPTH_MAX * 3,

    // Framebuffer mem read parameters
    parameter R_MEM_ADDR_WIDTH = $clog2(MEM_DEPTH / 2), // Half of total frame width since top/bottom
    parameter R_MEM_DATA_WIDTH = 6 // R0, G0, B0, R1, G1, G1 -> 6 total
) (
    // Write Port
    input wire w_clk, w_en,
    input wire [W_MEM_ADDR_WIDTH-1:0] w_addr,
    input wire [W_MEM_DATA_WIDTH-1:0] w_din,

    // Read control
    input wire [31:0] ctrl_bitdepth,
    
    // Read Port
    input wire r_clk, r_en,
    input wire [R_MEM_ADDR_WIDTH-1:0] r_addr,
    input wire [$clog2(BITDEPTH_MAX)-1:0] r_bit,
    output reg [R_MEM_DATA_WIDTH-1:0] r_dout
);

    // Just do two ram blocks, one high and one low
    // Could even split up into r, g, b blocks for greater efficiency?

    /** From https://docs.xilinx.com/v/u/en-US/ug473_7Series_Memory_Resources page 11:
        Each 36 Kb block RAM can be configured as a 64K x 1 (when cascaded with an adjacent 36 Kb block RAM),
        32K x 1, 16K x 2, 8K x 4, 4K x 9, 2K x 18, 1K x 36, or 512 x 72 in simple dual-port mode.
        Each 18 Kb block RAM can be configured as a 16K x 1, 8K x2 , 4K x 4, 2K x 9, 1K x 18 or
        512 x 36 in simple dual-port mode.
    **/
    // reg [W_MEM_DATA_WIDTH-1:0] mem_upper [(2**(W_MEM_ADDR_WIDTH-1))-1:0]; // Top half of frame
    // reg [W_MEM_DATA_WIDTH-1:0] mem_lower [(2**(W_MEM_ADDR_WIDTH-1))-1:0]; // Bottom half of frame

    reg [W_MEM_DATA_WIDTH-1:0] mem_upper, mem_lower [(2**(W_MEM_ADDR_WIDTH-1))-1:0]; // Top and bottom halves of frame

    wire [W_MEM_DATA_WIDTH-1:0] r_data_upper, r_data_lower;

    // Initialize Ram
    integer i;
    initial begin
        for (i=0; i < (2**(W_MEM_ADDR_WIDTH-1)); i=i+1) begin
            mem_upper[i] = 0;
            mem_lower[i] = 0;
            // $readmemb("rams_20c.data", ram, 0, DATA_WIDTH-1);
        end
    end

    // Write Port
    always @(posedge w_clk) begin
        if (w_en) begin
            if (w_addr[W_MEM_ADDR_WIDTH-1]) begin
                mem_lower[w_addr[W_MEM_ADDR_WIDTH-2:0]] <= w_din;
            end else begin
                mem_upper[w_addr[W_MEM_ADDR_WIDTH-2:0]] <= w_din;
            end
        end
    end

    // Read Port
    always @(posedge r_clk) begin
        if (r_en) begin

            r_data_upper <= mem_upper[r_addr];
            r_data_lower <= mem_lower[r_addr];

            r_dout <= {
                r_data_upper[(ctrl_bitdepth*3)+r_bit +:1],
                r_data_upper[(ctrl_bitdepth*2)+r_bit +:1],
                r_data_upper[(ctrl_bitdepth*1)+r_bit +:1],
                r_data_lower[(ctrl_bitdepth*3)+r_bit +:1],
                r_data_lower[(ctrl_bitdepth*2)+r_bit +:1],
                r_data_lower[(ctrl_bitdepth*1)+r_bit +:1]
                };
        end
    end
    

endmodule