
`default_nettype none

`include "led_driver.v"
`include "framebuffer.v"
`include "axil_interface.v"
`include "axif_interface.v"

`timescale 1 ns / 10 ps

module led_driver_top #(

    parameter N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 64*4, // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel, max of 10 with current axi data width
    parameter LSB_BLANK_MAX = 200,

    parameter CTRL_NUM_REG = 7,

    // ********** Calculated parameters **********
    parameter N_PIXELS = N_ROWS_MAX * N_COLS_MAX,

    // AXI Lite Parameters
    parameter C_AXIL_ADDR_WIDTH = $clog2(CTRL_NUM_REG) + 2, // plus two because byte addressed
    parameter C_AXIL_DATA_WIDTH = 32,

    // AXI Full Parameters
    parameter C_S_AXIF_ID_WIDTH = 2,
    parameter C_S_AXIF_DATA_WIDTH = 32, // Can do max of 10 bpc
    parameter C_S_AXIF_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX) + 2 // plus two because byte addressed

) (

    // AXI Lite Control Interface
    // {{{
    input wire S_AXIL_ACLK,
    input wire S_AXIL_ARESETN,

    input wire S_AXIL_AWVALID,
    output wire S_AXIL_AWREADY,
    input wire [C_AXIL_ADDR_WIDTH-1:0] S_AXIL_AWADDR,
    input wire [2:0] S_AXIL_AWPROT,

    input wire S_AXIL_WVALID,
    output wire S_AXIL_WREADY,
    input wire [C_AXIL_DATA_WIDTH-1:0] S_AXIL_WDATA,
    input wire [C_AXIL_DATA_WIDTH/8-1:0] S_AXIL_WSTRB,

    output wire S_AXIL_BVALID,
    input wire S_AXIL_BREADY,
    output wire [1:0] S_AXIL_BRESP,

    input wire S_AXIL_ARVALID,
    output wire S_AXIL_ARREADY,
    input wire [C_AXIL_ADDR_WIDTH-1:0] S_AXIL_ARADDR,
    input wire [2:0] S_AXIL_ARPROT,

    output wire S_AXIL_RVALID,
    input wire S_AXIL_RREADY,
    output wire	[C_AXIL_DATA_WIDTH-1:0] S_AXIL_RDATA,
    output wire	[1:0] S_AXIL_RRESP,
    // }}}


    // AXI Full Data Interface
    // {{{
    input wire S_AXIF_ACLK,
    input wire S_AXIF_ARESETN,

    input wire [C_S_AXIF_ID_WIDTH-1:0] S_AXIF_AWID,
    input wire [C_S_AXIF_ADDR_WIDTH-1:0] S_AXIF_AWADDR,
    input wire [7:0] S_AXIF_AWLEN,
    input wire [2:0] S_AXIF_AWSIZE,
    input wire [1:0] S_AXIF_AWBURST,
    input wire S_AXIF_AWLOCK,
    input wire [3:0] S_AXIF_AWCACHE,
    input wire [2:0] S_AXIF_AWPROT,
    input wire [3:0] S_AXIF_AWQOS,
    input wire S_AXIF_AWVALID,
    output wire S_AXIF_AWREADY,

    input wire [C_S_AXIF_DATA_WIDTH-1:0] S_AXIF_WDATA,
    input wire [(C_S_AXIF_DATA_WIDTH/8)-1:0] S_AXIF_WSTRB,
    input wire S_AXIF_WLAST,
    input wire S_AXIF_WVALID,
    output wire S_AXIF_WREADY,

    output wire [C_S_AXIF_ID_WIDTH-1:0] S_AXIF_BID,
    output wire [1:0] S_AXIF_BRESP,
    output wire S_AXIF_BVALID,
    input wire S_AXIF_BREADY,

    input wire [C_S_AXIF_ID_WIDTH-1:0] S_AXIF_ARID,
    input wire [C_S_AXIF_ADDR_WIDTH-1:0] S_AXIF_ARADDR,
    input wire [7:0] S_AXIF_ARLEN,
    input wire [2:0] S_AXIF_ARSIZE,
    input wire [1:0] S_AXIF_ARBURST,
    input wire S_AXIF_ARLOCK,
    input wire [3:0] S_AXIF_ARCACHE,
    input wire [2:0] S_AXIF_ARPROT,
    input wire [3:0] S_AXIF_ARQOS,
    input wire S_AXIF_ARVALID,
    output wire S_AXIF_ARREADY,

    output wire [C_S_AXIF_ID_WIDTH-1:0] S_AXIF_RID,
    output wire [C_S_AXIF_DATA_WIDTH-1:0] S_AXIF_RDATA,
    output wire [1:0] S_AXIF_RRESP,
    output wire S_AXIF_RLAST,
    output wire S_AXIF_RVALID,
    input wire S_AXIF_RREADY,
    // }}}


    // Display interface
    // {{{
    output wire disp_clk,
    output wire disp_blank,
    output wire disp_latch,
    output wire [4:0] disp_addr,
    output wire disp_r0, disp_g0, disp_b0,
    output wire disp_r1, disp_g1, disp_b1
    // }}}
);
    // ************ Calculated parameters ************
    // Write port parameters
    localparam MEM_W_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX);
    localparam MEM_W_DATA_WIDTH = C_S_AXIF_DATA_WIDTH; // Full number of bits per pixel, needs to be multiple of 8

    // Read port parameters
    localparam MEM_R_ADDR_WIDTH = MEM_W_ADDR_WIDTH - 1; // Half of total frame width since top/bottom
    localparam MEM_R_DATA_WIDTH = 6; // R0, G0, B0, R1, G1, G1 -> 6 total
    // ***********************************************


    // ************** Connecting Wires ***************
    wire clk, ctrl_en, ctrl_rst;
    wire [C_AXIL_DATA_WIDTH-1:0] ctrl_display, ctrl_n_rows, ctrl_n_cols, ctrl_bitdepth, ctrl_lsb_blank, ctrl_brightness;

    wire mem_wclk, mem_wen;
    wire [MEM_W_ADDR_WIDTH-1:0] mem_waddr;
    wire [MEM_W_DATA_WIDTH/8-1:0] mem_wstrb;
    wire [MEM_W_DATA_WIDTH-1:0] mem_wdata;

    wire mem_rclk, mem_ren, mem_rbuffer;
    wire [MEM_R_ADDR_WIDTH-1:0] mem_raddr;
    wire [$clog2(BITDEPTH_MAX)-1:0] mem_rbit;
    wire [MEM_R_DATA_WIDTH-1:0] mem_rdata;
    // ***********************************************


    // ************* Clock Connections ***************
    assign clk = S_AXIL_ACLK;
    assign mem_rclk = S_AXIL_ACLK;
    assign mem_wclk = S_AXIF_ACLK;
    // ***********************************************


    // ********** Control Reg Connections ************
    assign ctrl_en = ctrl_display[0];
    assign ctrl_rst = ctrl_display[1];
    // ***********************************************



    // ************ Module Instantiations ************

    axil_interface #(
        .C_AXI_ADDR_WIDTH(C_AXIL_ADDR_WIDTH),
        .C_AXI_DATA_WIDTH(C_AXIL_DATA_WIDTH)
    ) axi_lite (
        .S_AXI_ACLK(S_AXIL_ACLK),
        .S_AXI_ARESETN(S_AXIL_ARESETN),
        .S_AXI_AWVALID(S_AXIL_AWVALID),
        .S_AXI_AWREADY(S_AXIL_AWREADY),
        .S_AXI_AWADDR(S_AXIL_AWADDR),
        .S_AXI_AWPROT(S_AXIL_AWPROT),
        .S_AXI_WVALID(S_AXIL_WVALID),
        .S_AXI_WREADY(S_AXIL_WREADY),
        .S_AXI_WDATA(S_AXIL_WDATA),
        .S_AXI_WSTRB(S_AXIL_WSTRB),
        .S_AXI_BVALID(S_AXIL_BVALID),
        .S_AXI_BREADY(S_AXIL_BREADY),
        .S_AXI_BRESP(S_AXIL_BRESP),
        .S_AXI_ARVALID(S_AXIL_ARVALID),
        .S_AXI_ARREADY(S_AXIL_ARREADY),
        .S_AXI_ARADDR(S_AXIL_ARADDR),
        .S_AXI_ARPROT(S_AXIL_ARPROT),
        .S_AXI_RVALID(S_AXIL_RVALID),
        .S_AXI_RREADY(S_AXIL_RREADY),
        .S_AXI_RDATA(S_AXIL_RDATA),
        .S_AXI_RRESP(S_AXIL_RRESP),

        .ctrl_display(ctrl_display),
        .ctrl_n_rows(ctrl_n_rows),
        .ctrl_n_cols(ctrl_n_cols),
        .ctrl_bitdepth(ctrl_bitdepth),
        .ctrl_lsb_blank(ctrl_lsb_blank),
        .ctrl_brightness(ctrl_brightness),
        .ctrl_buffer(ctrl_buffer)
    );


    axif_interface #(
        .C_S_AXI_ID_WIDTH(C_S_AXIF_ID_WIDTH),
        .C_S_AXI_DATA_WIDTH(C_S_AXIF_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S_AXIF_ADDR_WIDTH)
    ) axi_full (
        .S_AXI_ACLK(S_AXIF_ACLK),
        .S_AXI_ARESETN(S_AXIF_ARESETN),
        .S_AXI_AWID(S_AXIF_AWID),
        .S_AXI_AWADDR(S_AXIF_AWADDR),
        .S_AXI_AWLEN(S_AXIF_AWLEN),
        .S_AXI_AWSIZE(S_AXIF_AWSIZE),
        .S_AXI_AWBURST(S_AXIF_AWBURST),
        .S_AXI_AWLOCK(S_AXIF_AWLOCK),
        .S_AXI_AWCACHE(S_AXIF_AWCACHE),
        .S_AXI_AWPROT(S_AXIF_AWPROT),
        .S_AXI_AWQOS(S_AXIF_AWQOS),
        .S_AXI_AWVALID(S_AXIF_AWVALID),
        .S_AXI_AWREADY(S_AXIF_AWREADY),
        .S_AXI_WDATA(S_AXIF_WDATA),
        .S_AXI_WSTRB(S_AXIF_WSTRB),
        .S_AXI_WLAST(S_AXIF_WLAST),
        .S_AXI_WVALID(S_AXIF_WVALID),
        .S_AXI_WREADY(S_AXIF_WREADY),
        .S_AXI_BID(S_AXIF_BID),
        .S_AXI_BRESP(S_AXIF_BRESP),
        .S_AXI_BVALID(S_AXIF_BVALID),
        .S_AXI_BREADY(S_AXIF_BREADY),
        .S_AXI_ARID(S_AXIF_ARID),
        .S_AXI_ARADDR(S_AXIF_ARADDR),
        .S_AXI_ARLEN(S_AXIF_ARLEN),
        .S_AXI_ARSIZE(S_AXIF_ARSIZE),
        .S_AXI_ARBURST(S_AXIF_ARBURST),
        .S_AXI_ARLOCK(S_AXIF_ARLOCK),
        .S_AXI_ARCACHE(S_AXIF_ARCACHE),
        .S_AXI_ARPROT(S_AXIF_ARPROT),
        .S_AXI_ARQOS(S_AXIF_ARQOS),
        .S_AXI_ARVALID(S_AXIF_ARVALID),
        .S_AXI_ARREADY(S_AXIF_ARREADY),
        .S_AXI_RID(S_AXIF_RID),
        .S_AXI_RDATA(S_AXIF_RDATA),
        .S_AXI_RRESP(S_AXIF_RRESP),
        .S_AXI_RLAST(S_AXIF_RLAST),
        .S_AXI_RVALID(S_AXIF_RVALID),
        .S_AXI_RREADY(S_AXIF_RREADY),

        .o_we(mem_wen),
        .o_waddr(mem_waddr),
        .o_wdata(mem_wdata),
        .o_wstrb(mem_wstrb),
        .o_rd(1'b0),
        .o_raddr(0),
        .i_rdata(0)
    );


    led_driver #(
        .N_ROWS_MAX(N_ROWS_MAX), // Total num rows on panel (64 for 64x64 panel)
        .N_COLS_MAX(N_COLS_MAX), // Number of panels * number of cols per panel (256 for 4 64x64 panels)
        .BITDEPTH_MAX(BITDEPTH_MAX), // Bits per color (bpc), 8 gives 24 bits per pixel
        .LSB_BLANK_MAX(LSB_BLANK_MAX),

        .CTRL_REG_WIDTH(C_AXIL_DATA_WIDTH) // Width of ctrl reg
    ) driver (
        .clk(clk), // Global clock
        
        .ctrl_en(ctrl_en), // Enable or disable module
        .ctrl_rst(ctrl_rst), // Reset module
        // .ctrl_en(1'b1), // Enable or disable module
        // .ctrl_rst(1'b0), // Reset module

        // Current configuration, these are not latched
        .ctrl_n_rows(ctrl_n_rows),
        .ctrl_n_cols(ctrl_n_cols),
        .ctrl_bitdepth(ctrl_bitdepth),
        .ctrl_lsb_blank(ctrl_lsb_blank),
        .ctrl_brightness(ctrl_brightness),
        .ctrl_buffer(ctrl_buffer),

        // BRAM interface
        .mem_clk(mem_rclk),
        .mem_en(mem_ren),
        .mem_buffer(mem_rbuffer),
        .mem_addr(mem_raddr),
        .mem_bit(mem_rbit),
        .mem_din(mem_rdata),

        // Display interface
        .disp_clk(disp_clk),
        .disp_blank(disp_blank),
        .disp_latch(disp_latch),
        .disp_addr(disp_addr),
        .disp_r0(disp_r0), .disp_g0(disp_g0), .disp_b0(disp_b0),
        .disp_r1(disp_r1), .disp_g1(disp_g1), .disp_b1(disp_b1)
    );


    framebuffer #(
        .N_ROWS_MAX(N_ROWS_MAX), // Total num rows on panel (64 for 64x64 panel)
        .N_COLS_MAX(N_COLS_MAX), // Number of panels * number of cols per panel (256 for 4 64x64 panels)
        .BITDEPTH_MAX(BITDEPTH_MAX), // Bits per color (bpc), 8 gives 24 bits per pixel

        .CTRL_REG_WIDTH(C_AXIL_DATA_WIDTH) // Width of ctrl reg
    ) frames (
        // Write Port
        .w_clk(mem_wclk),
        .w_en(mem_wen),
        .w_buffer(~mem_rbuffer),  // Which buffer of dual buffer to write
        .w_strb(mem_wstrb),
        .w_addr(mem_waddr),
        .w_din(mem_wdata),

        // Read control
        .ctrl_n_rows(ctrl_n_rows),
        .ctrl_n_cols(ctrl_n_cols),
        .ctrl_bitdepth(ctrl_bitdepth),

        // Read Port
        .r_clk(mem_rclk),
        .r_en(mem_ren),
        .r_buffer(mem_rbuffer), // Which buffer of dual buffer to read
        .r_addr(mem_raddr),
        .r_bit(mem_rbit), // Which bit to read
        .r_dout(mem_rdata)
    );


    // ***********************************************


endmodule