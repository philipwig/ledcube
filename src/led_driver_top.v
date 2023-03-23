

module led_driver_top #(

    parameter N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
    parameter N_COLS_MAX = 256, // Number of panels * number of cols per panel (256 for 4 64x64 panels)
    parameter BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel
    parameter LSB_BLANK_MAX = 200,



    parameter CTRL_NUM_REG = 12,
    parameter CTRL_REG_WIDTH = 32,


    // AXI Lite Parameters
    parameter C_AXIL_ADDR_WIDTH = $clog2(CTRL_NUM_REG),
    parameter C_AXIL_DATA_WIDTH = 32,

    // AXI Full Parameters
    parameter C_S_AXIF_ID_WIDTH = 2,
    parameter C_S_AXIF_DATA_WIDTH = 32,
    parameter C_S_AXIF_ADDR_WIDTH = 6,

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
    output wire	[1:0] S_AXIL_RRESP
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
    input wire S_AXIF_RREADY
    // }}}



    // Display interface
    // {{{
    output reg disp_clk,
    output wire disp_blank,
    output reg disp_latch,
    output wire [4:0] disp_addr,
    output wire disp_r0, disp_g0, disp_b0,
    output wire disp_r1, disp_g1, disp_b1
    // }}}
);



endmodule