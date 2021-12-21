library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_panel_driver_v1_0 is
	generic (
		-- Users to add parameters here
		n_rows_max : integer := 64;
        n_cols_max : integer := 256;
        bitdepth_max : integer := 8;
		lsb_blank_length_max : integer := 100;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7
	);
	port (
		-- Users to add ports here
		display_clk_out : out std_logic;
        display_blank_out : out std_logic;
        display_latch_out : out std_logic;
        display_address_out : out std_logic_vector(4 downto 0);
        R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end led_panel_driver_v1_0;

architecture arch_imp of led_panel_driver_v1_0 is

	signal reset : std_logic;
	signal enable : std_logic;

	signal n_rows_config : integer range 0 to n_rows_max;
	signal n_cols_config : integer range 0 to n_cols_max;
	signal bitdepth_config : integer range 0 to bitdepth_max;
	signal lsb_blank_length_config : integer range 0 to lsb_blank_length_max;

	-- component declaration
	component led_panel_driver_v1_0_S00_AXI is
		generic (
			n_rows_max : integer;
			n_cols_max : integer;
			bitdepth_max : integer;
			lsb_blank_length_max : integer;

			C_S_AXI_DATA_WIDTH	: integer	:= 32;
			C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
			reset : out std_logic;
			enable : out std_logic;
			
			n_rows_config : out integer range 0 to n_rows_max;
			n_cols_config : out integer range 0 to n_cols_max;
			bitdepth_config : out integer range 0 to bitdepth_max;
			lsb_blank_length_config : out integer range 0 to lsb_blank_length_max;
	
			S_AXI_ACLK	: in std_logic;
			S_AXI_ARESETN	: in std_logic;
			S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
			S_AXI_AWVALID	: in std_logic;
			S_AXI_AWREADY	: out std_logic;
			S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
			S_AXI_WVALID	: in std_logic;
			S_AXI_WREADY	: out std_logic;
			S_AXI_BRESP	: out std_logic_vector(1 downto 0);
			S_AXI_BVALID	: out std_logic;
			S_AXI_BREADY	: in std_logic;
			S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
			S_AXI_ARVALID	: in std_logic;
			S_AXI_ARREADY	: out std_logic;
			S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_RRESP	: out std_logic_vector(1 downto 0);
			S_AXI_RVALID	: out std_logic;
			S_AXI_RREADY	: in std_logic
		);
	end component led_panel_driver_v1_0_S00_AXI;

	component display_top is
		generic(
			n_rows_max : integer;
			n_cols_max : integer;
			bitdepth_max : integer;
			lsb_blank_length_max : integer
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			en : in std_logic;
	
			-- Configuration values from the axi interface
			n_rows_config : in integer range 0 to n_rows_max;
			n_cols_config : in integer range 0 to n_cols_max;
			bitdepth_config : in integer range 0 to bitdepth_max;
			lsb_blank_length_config : in integer range 0 to lsb_blank_length_max;
	
			-- Display interface
			display_clk_out : out std_logic;
			display_blank_out : out std_logic;
			display_latch_out : out std_logic;
			display_address_out : out std_logic_vector(4 downto 0);
			R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic
		);
	
	end component;

begin

-- Instantiation of Axi Bus Interface S00_AXI
led_panel_driver_v1_0_S00_AXI_inst : led_panel_driver_v1_0_S00_AXI
	generic map (
		n_rows_max => n_rows_max,
        n_cols_max => n_cols_max,
        bitdepth_max => bitdepth_max,
        lsb_blank_length_max => lsb_blank_length_max,

		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		reset => reset,
		enable => enable,

        n_rows_config => n_rows_config,
        n_cols_config => n_cols_config,
        bitdepth_config => bitdepth_config,
        lsb_blank_length_config => lsb_blank_length_config,

		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	display_top_inst : display_top
	generic map (
		n_rows_max => n_rows_max,
		n_cols_max => n_cols_max,
		bitdepth_max => bitdepth_max,
		lsb_blank_length_max => lsb_blank_length_max
	)
	port map (
		clk => s00_axi_aclk,
		rst => reset,
		en => enable,

		-- Configuration values from the axi interface
		n_rows_config => n_rows_config,
		n_cols_config => n_cols_config,
		bitdepth_config => bitdepth_config,
		lsb_blank_length_config => lsb_blank_length_config,
		
		-- Display interface
		display_clk_out => display_clk_out,
		display_blank_out => display_blank_out,
		display_latch_out => display_latch_out,
		display_address_out => display_address_out,

		R0_out => R0_out,
		G0_out => G0_out,
		B0_out => B0_out,
		R1_out => R1_out,
		G1_out => G1_out,
		B1_out => B1_out
	);
	-- User logic ends

end arch_imp;
