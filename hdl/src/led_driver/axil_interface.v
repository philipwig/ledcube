////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	axil_interface
// {{{
// Project:	WB2AXIPSP: bus bridges and other odds and ends
//
// Purpose:	Demonstrates a simple AXI-Lite interface.
//
//	This was written in light of my last demonstrator, for which others
//	declared that it was much too complicated to understand.  The goal of
//	this demonstrator is to have logic that's easier to understand, use,
//	and copy as needed.
//
//	Since there are two basic approaches to AXI-lite signaling, both with
//	and without skidbuffers, this example demonstrates both so that the
//	differences can be compared and contrasted.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2020-2022, Gisselquist Technology, LLC
// {{{
//
// This file is part of the WB2AXIP project.
//
// The WB2AXIP project contains free software and gateware, licensed under the
// Apache License, Version 2.0 (the "License").  You may not use this project,
// or this file, except in compliance with the License.  You may obtain a copy
// of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations
// under the License.
//
////////////////////////////////////////////////////////////////////////////////
//

`include "skidbuffer.v"


`default_nettype none
// }}}
module axil_interface #(
        // {{{
        //
        // Size of the AXI-lite bus.  These are fixed, since 1) AXI-lite
        // is fixed at a width of 32-bits by Xilinx def'n, and 2) since
        // we only ever have 4 configuration words.
        parameter C_AXI_ADDR_WIDTH = 6,
        parameter C_AXI_DATA_WIDTH = 32,
        parameter [0:0] OPT_LOWPOWER = 0
        // }}}
    ) (
        // {{{
        input wire S_AXI_ACLK,
        input wire S_AXI_ARESETN,
        //
        input wire S_AXI_AWVALID,
        output wire S_AXI_AWREADY,
        input wire [C_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        input wire [2:0] S_AXI_AWPROT,
        //
        input wire S_AXI_WVALID,
        output wire S_AXI_WREADY,
        input wire [C_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
        input wire [C_AXI_DATA_WIDTH/8-1:0]	S_AXI_WSTRB,
        //
        output wire S_AXI_BVALID,
        input wire S_AXI_BREADY,
        output wire [1:0] S_AXI_BRESP,
        //
        input wire S_AXI_ARVALID,
        output wire S_AXI_ARREADY,
        input wire [C_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        input wire [2:0] S_AXI_ARPROT,
        //
        output wire S_AXI_RVALID,
        input wire S_AXI_RREADY,
        output wire [C_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
        output wire [1:0] S_AXI_RRESP,
        // }}}

        output reg [C_AXI_DATA_WIDTH-1:0] ctrl_display, ctrl_n_rows, ctrl_n_cols, ctrl_bitdepth, 
                          ctrl_lsb_blank, ctrl_brightness

    );

    ////////////////////////////////////////////////////////////////////////
    //
    // Register/wire signal declarations
    // {{{
    ////////////////////////////////////////////////////////////////////////
    //
    localparam ADDRLSB = $clog2(C_AXI_DATA_WIDTH)-3;

    wire i_reset = !S_AXI_ARESETN;

    wire axil_write_ready;
    wire [C_AXI_ADDR_WIDTH-ADDRLSB-1:0] awskd_addr;
    //
    wire [C_AXI_DATA_WIDTH-1:0] wskd_data;
    wire [C_AXI_DATA_WIDTH/8-1:0] wskd_strb;
    reg axil_bvalid;
    //
    wire axil_read_ready;
    wire [C_AXI_ADDR_WIDTH-ADDRLSB-1:0] arskd_addr;
    reg [C_AXI_DATA_WIDTH-1:0] axil_read_data;
    reg axil_read_valid;

    wire [31:0] wskd_display, wskd_n_rows, wskd_n_cols, wskd_bitdepth, wskd_lsb_blank, wskd_brightness;

    // }}}
    ////////////////////////////////////////////////////////////////////////
    //
    // AXI-lite signaling
    //
    ////////////////////////////////////////////////////////////////////////
    //
    // {{{

    //
    // Write signaling
    //
    // {{{

    // {{{
    wire awskd_valid, wskd_valid;

    skidbuffer #(
        .OPT_OUTREG(0),
        .OPT_LOWPOWER(OPT_LOWPOWER),
        .DW(C_AXI_ADDR_WIDTH-ADDRLSB)
    ) axilawskid (
        .i_clk(S_AXI_ACLK),
        .i_reset(i_reset),
        .i_valid(S_AXI_AWVALID),
        .o_ready(S_AXI_AWREADY),
        .i_data(S_AXI_AWADDR[C_AXI_ADDR_WIDTH-1:ADDRLSB]),
        .o_valid(awskd_valid),
        .i_ready(axil_write_ready),
        .o_data(awskd_addr)
    );

    skidbuffer #(
        .OPT_OUTREG(0),
        .OPT_LOWPOWER(OPT_LOWPOWER),
        .DW(C_AXI_DATA_WIDTH+C_AXI_DATA_WIDTH/8)
    ) axifwskid (
        .i_clk(S_AXI_ACLK),
        .i_reset(i_reset),
        .i_valid(S_AXI_WVALID),
        .o_ready(S_AXI_WREADY),
        .i_data({ S_AXI_WDATA, S_AXI_WSTRB }),
        .o_valid(wskd_valid),
        .i_ready(axil_write_ready),
        .o_data({ wskd_data, wskd_strb })
    );

    assign axil_write_ready = awskd_valid && wskd_valid
            && (!S_AXI_BVALID || S_AXI_BREADY);


    initial	axil_bvalid = 0;
    always @(posedge S_AXI_ACLK) begin
        if (i_reset)
            axil_bvalid <= 0;
        else if (axil_write_ready)
            axil_bvalid <= 1;
        else if (S_AXI_BREADY)
            axil_bvalid <= 0;
    end

    assign	S_AXI_BVALID = axil_bvalid;
    assign	S_AXI_BRESP = 2'b00;
    // }}}

    // Read signaling
    wire arskd_valid;

    skidbuffer #(
        .OPT_OUTREG(0),
        .OPT_LOWPOWER(OPT_LOWPOWER),
        .DW(C_AXI_ADDR_WIDTH-ADDRLSB)
    ) axilarskid (
        .i_clk(S_AXI_ACLK),
        .i_reset(i_reset),
        .i_valid(S_AXI_ARVALID),
        .o_ready(S_AXI_ARREADY),
        .i_data(S_AXI_ARADDR[C_AXI_ADDR_WIDTH-1:ADDRLSB]),
        .o_valid(arskd_valid),
        .i_ready(axil_read_ready),
        .o_data(arskd_addr)
    );

    assign	axil_read_ready = arskd_valid
            && (!axil_read_valid || S_AXI_RREADY);


    initial	axil_read_valid = 1'b0;
    always @(posedge S_AXI_ACLK) begin
        if (i_reset)
            axil_read_valid <= 1'b0;
        else if (axil_read_ready)
            axil_read_valid <= 1'b1;
        else if (S_AXI_RREADY)
            axil_read_valid <= 1'b0;
    end

    assign S_AXI_RVALID = axil_read_valid;
    assign S_AXI_RDATA = axil_read_data;
    assign S_AXI_RRESP = 2'b00;

    ////////////////////////////////////////////////////////////////////////
    //
    // AXI-lite register logic
    //
    ////////////////////////////////////////////////////////////////////////

    // apply_wstrb(old_data, new_data, write_strobes)
    assign	wskd_display = apply_wstrb(ctrl_display, wskd_data, wskd_strb);
    assign	wskd_n_rows = apply_wstrb(ctrl_n_rows, wskd_data, wskd_strb);
    assign	wskd_n_cols = apply_wstrb(ctrl_n_cols, wskd_data, wskd_strb);
    assign	wskd_bitdepth = apply_wstrb(ctrl_bitdepth, wskd_data, wskd_strb);
    assign	wskd_lsb_blank = apply_wstrb(ctrl_lsb_blank, wskd_data, wskd_strb);
    assign	wskd_brightness = apply_wstrb(ctrl_brightness, wskd_data, wskd_strb);

    initial	ctrl_display = 32'h00000002;
    initial	ctrl_n_rows = 64;
    initial	ctrl_n_cols = 64;
    initial	ctrl_bitdepth = 8;
    initial	ctrl_lsb_blank = 20;
    initial	ctrl_brightness = 0;
    always @(posedge S_AXI_ACLK) begin
        if (i_reset) begin
            ctrl_display <= 32'h00000002;
            ctrl_n_rows <= 64;
            ctrl_n_cols <= 64;
            ctrl_bitdepth <= 8;
            ctrl_lsb_blank <= 20;
            ctrl_brightness <= 0;
        end else if (axil_write_ready) begin
            case(awskd_addr)
                3'b000:	ctrl_display <= wskd_display;
                3'b001:	ctrl_n_rows <= wskd_n_rows;
                3'b010:	ctrl_n_cols <= wskd_n_cols;
                3'b011:	ctrl_bitdepth <= wskd_bitdepth;
                3'b100:	ctrl_lsb_blank <= wskd_lsb_blank;
                3'b101:	ctrl_brightness <= wskd_brightness;
                default: ;
            endcase
        end
    end

    initial	axil_read_data = 0;
    always @(posedge S_AXI_ACLK) begin
        if (OPT_LOWPOWER && !S_AXI_ARESETN)
            axil_read_data <= 0;
        else if (!S_AXI_RVALID || S_AXI_RREADY) begin
            case(arskd_addr)
                3'b000:	axil_read_data	<= ctrl_display;
                3'b001:	axil_read_data	<= ctrl_n_rows;
                3'b010:	axil_read_data	<= ctrl_n_cols;
                3'b011:	axil_read_data	<= ctrl_bitdepth;
                3'b100:	axil_read_data	<= ctrl_lsb_blank;
                3'b101:	axil_read_data	<= ctrl_brightness;
                default: ;
            endcase

            if (OPT_LOWPOWER && !axil_read_ready)
                axil_read_data <= 0;
        end
    end

    function [C_AXI_DATA_WIDTH-1:0]	apply_wstrb;
        input	[C_AXI_DATA_WIDTH-1:0]		prior_data;
        input	[C_AXI_DATA_WIDTH-1:0]		new_data;
        input	[C_AXI_DATA_WIDTH/8-1:0]	wstrb;

        integer	k;
        for(k=0; k<C_AXI_DATA_WIDTH/8; k=k+1) begin
            apply_wstrb[k*8 +: 8] = wstrb[k] ? new_data[k*8 +: 8] : prior_data[k*8 +: 8];
        end
    endfunction
    // }}}

    // Make Verilator happy
    // {{{
    // Verilator lint_off UNUSED
    // wire	unused;
    // assign	unused = &{ 1'b0, S_AXI_AWPROT, S_AXI_ARPROT,
    //         S_AXI_ARADDR[ADDRLSB-1:0],
    //         S_AXI_AWADDR[ADDRLSB-1:0] };
    // Verilator lint_on  UNUSED
    // }}}

endmodule
