// Dual-Port Block RAM with Two Write Ports

// File: dual_bram.v
`timescale 1 ns / 10 ps

`default_nettype none
module dual_bram #(
    parameter DATA_WIDTH = 64,
    parameter ADDR_WIDTH = 8
) (
    // Port A
    input wire a_clk, a_we,
    input wire [ADDR_WIDTH-1:0] a_addr,
    input wire [DATA_WIDTH-1:0] a_din,

    // Port B
    input wire b_clk, b_re,
    input wire [ADDR_WIDTH-1:0] b_addr,
    output reg [DATA_WIDTH-1:0] b_dout
);

    reg [DATA_WIDTH-1:0] ram [(2**ADDR_WIDTH)-1:0];

    // Initialize Ram
    // integer i;
    // initial begin
    //     for (i=0; i<(2**ADDR_WIDTH); i=i+1) ram[i] = 0;
    //     // $readmemb("rams_20c.data", ram, 0, DATA_WIDTH-1);
    // end

    // Port A
    always @(posedge a_clk) begin
        if (a_we) begin
            ram[a_addr] <= a_din;
        end
    end

    // Port B
    always @(posedge b_clk) begin
        if (b_re) begin
            b_dout <= ram[b_addr];
        end
    end
    

endmodule