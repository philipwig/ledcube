library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity led_driver_test_v1_0 is
    generic (
        -- Users to add parameters here
        N_ROWS_MAX : integer := 64;
        N_COLS_MAX : integer := 128;
        BITDEPTH_MAX : integer := 8;
        LSB_BLANK_MAX : integer := 100;

        PATTERNBUFFER_WIDTH : integer := 32; -- Width of the data
        PATTERNBUFFER_ADDR_SIZE : integer := 16; -- Size of the addr lines
        -- User parameters ends
        -- Do not modify the parameters beyond this line

        -- Parameters of Axi Slave Bus Interface axi_control
        C_axi_control_DATA_WIDTH	: integer	:= 32;
        C_axi_control_ADDR_WIDTH	: integer	:= 7
    );
    port (
        -- Users to add ports here
        axi_patternbuffer_clk : in std_logic;
        axi_patternbuffer_rst : in std_logic;
        axi_patternbuffer_write_en : in std_logic;
        axi_patternbuffer_addr : in std_logic_vector(PATTERNBUFFER_ADDR_SIZE - 1 downto 0);
        axi_patternbuffer_write_data : in std_logic_vector(PATTERNBUFFER_WIDTH - 1 downto 0);
        axi_patternbuffer_read_data : out std_logic_vector(PATTERNBUFFER_WIDTH - 1 downto 0);      

        display_clk_out : out std_logic;
        display_blank_out : out std_logic;
        display_latch_out : out std_logic;
        display_address_out : out std_logic_vector(4 downto 0);
        R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic;
        -- User ports ends
        -- Do not modify the ports beyond this line


        -- Ports of Axi Slave Bus Interface axi_control
        axi_control_aclk	: in std_logic;
        axi_control_aresetn	: in std_logic;
        axi_control_awaddr	: in std_logic_vector(C_axi_control_ADDR_WIDTH-1 downto 0);
        axi_control_awprot	: in std_logic_vector(2 downto 0);
        axi_control_awvalid	: in std_logic;
        axi_control_awready	: out std_logic;
        axi_control_wdata	: in std_logic_vector(C_axi_control_DATA_WIDTH-1 downto 0);
        axi_control_wstrb	: in std_logic_vector((C_axi_control_DATA_WIDTH/8)-1 downto 0);
        axi_control_wvalid	: in std_logic;
        axi_control_wready	: out std_logic;
        axi_control_bresp	: out std_logic_vector(1 downto 0);
        axi_control_bvalid	: out std_logic;
        axi_control_bready	: in std_logic;
        axi_control_araddr	: in std_logic_vector(C_axi_control_ADDR_WIDTH-1 downto 0);
        axi_control_arprot	: in std_logic_vector(2 downto 0);
        axi_control_arvalid	: in std_logic;
        axi_control_arready	: out std_logic;
        axi_control_rdata	: out std_logic_vector(C_axi_control_DATA_WIDTH-1 downto 0);
        axi_control_rresp	: out std_logic_vector(1 downto 0);
        axi_control_rvalid	: out std_logic;
        axi_control_rready	: in std_logic
    );
end led_driver_test_v1_0;

architecture arch_imp of led_driver_test_v1_0 is
    
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_read_data: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer DOUT";
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_write_data: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer DIN";
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_write_en: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer WE";
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_addr: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer ADDR";
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_clk: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer CLK";
    ATTRIBUTE X_INTERFACE_INFO of axi_patternbuffer_rst: SIGNAL is "xilinx.com:interface:bram:1.0 axi_patternbuffer RST";
  
    signal reset : std_logic;
    signal enable : std_logic;

    signal n_rows_config : integer range 0 to N_ROWS_MAX;
    signal n_cols_config : integer range 0 to N_COLS_MAX;
    signal bitdepth_config : integer range 0 to BITDEPTH_MAX;
    signal lsb_blank_length_config : integer range 0 to LSB_BLANK_MAX;

    -- component declaration
    component led_driver_test_v1_0_axi_control is
        generic (
            N_ROWS_MAX : integer;
            N_COLS_MAX : integer;
            BITDEPTH_MAX : integer;
            LSB_BLANK_MAX : integer;

            C_S_AXI_DATA_WIDTH	: integer	:= 32;
            C_S_AXI_ADDR_WIDTH	: integer	:= 7
        );
        port (
            reset : out std_logic;
            enable : out std_logic;
            
            n_rows_config : out integer range 0 to N_ROWS_MAX;
            n_cols_config : out integer range 0 to N_COLS_MAX;
            bitdepth_config : out integer range 0 to BITDEPTH_MAX;
            lsb_blank_length_config : out integer range 0 to LSB_BLANK_MAX;
    
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
    end component led_driver_test_v1_0_axi_control;

    component display_top is
        generic(
            N_ROWS_MAX : integer;
            N_COLS_MAX : integer;
            BITDEPTH_MAX : integer;
            LSB_BLANK_MAX : integer;

            AXI_PATTERNBUFFER_ADDR_WIDTH : integer := 16;
            AXI_PATTERNBUFFER_DATA_WIDTH : integer := 32
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            en : in std_logic;
    
            -- Configuration values from the axi interface
            n_rows_config : in integer range 0 to N_ROWS_MAX;
            n_cols_config : in integer range 0 to N_COLS_MAX;
            bitdepth_config : in integer range 0 to BITDEPTH_MAX;
            lsb_blank_length_config : in integer range 0 to LSB_BLANK_MAX;
    
            -- Data interface to axi
            axi_patternbuffer_clk : in std_logic;
            axi_patternbuffer_rst : in std_logic;
            axi_patternbuffer_write_en : in std_logic;
            axi_patternbuffer_addr : in std_logic_vector(AXI_PATTERNBUFFER_ADDR_WIDTH - 1 downto 0);
            axi_patternbuffer_write_data : in std_logic_vector(AXI_PATTERNBUFFER_DATA_WIDTH - 1 downto 0);
            axi_patternbuffer_read_data : out std_logic_vector(AXI_PATTERNBUFFER_DATA_WIDTH - 1 downto 0);      

            -- Display interface
            display_clk_out : out std_logic;
            display_blank_out : out std_logic;
            display_latch_out : out std_logic;
            display_address_out : out std_logic_vector(4 downto 0);
            R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic
        );
    
    end component;

begin

-- Instantiation of Axi Bus Interface axi_control
led_driver_test_v1_0_axi_control_inst : led_driver_test_v1_0_axi_control
    generic map (
        N_ROWS_MAX => N_ROWS_MAX,
        N_COLS_MAX => N_COLS_MAX,
        BITDEPTH_MAX => BITDEPTH_MAX,
        LSB_BLANK_MAX => LSB_BLANK_MAX,

        C_S_AXI_DATA_WIDTH	=> C_axi_control_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH	=> C_axi_control_ADDR_WIDTH
    )
    port map (
        reset => reset,
        enable => enable,

        n_rows_config => n_rows_config,
        n_cols_config => n_cols_config,
        bitdepth_config => bitdepth_config,
        lsb_blank_length_config => lsb_blank_length_config,

        S_AXI_ACLK	=> axi_control_aclk,
        S_AXI_ARESETN	=> axi_control_aresetn,
        S_AXI_AWADDR	=> axi_control_awaddr,
        S_AXI_AWPROT	=> axi_control_awprot,
        S_AXI_AWVALID	=> axi_control_awvalid,
        S_AXI_AWREADY	=> axi_control_awready,
        S_AXI_WDATA	=> axi_control_wdata,
        S_AXI_WSTRB	=> axi_control_wstrb,
        S_AXI_WVALID	=> axi_control_wvalid,
        S_AXI_WREADY	=> axi_control_wready,
        S_AXI_BRESP	=> axi_control_bresp,
        S_AXI_BVALID	=> axi_control_bvalid,
        S_AXI_BREADY	=> axi_control_bready,
        S_AXI_ARADDR	=> axi_control_araddr,
        S_AXI_ARPROT	=> axi_control_arprot,
        S_AXI_ARVALID	=> axi_control_arvalid,
        S_AXI_ARREADY	=> axi_control_arready,
        S_AXI_RDATA	=> axi_control_rdata,
        S_AXI_RRESP	=> axi_control_rresp,
        S_AXI_RVALID	=> axi_control_rvalid,
        S_AXI_RREADY	=> axi_control_rready
    );

    -- Add user logic here
    display_top_inst : display_top
    generic map (
        N_ROWS_MAX => N_ROWS_MAX,
        N_COLS_MAX => N_COLS_MAX,
        BITDEPTH_MAX => BITDEPTH_MAX,
        LSB_BLANK_MAX => LSB_BLANK_MAX,

        AXI_PATTERNBUFFER_ADDR_WIDTH => PATTERNBUFFER_ADDR_SIZE - 2,
        AXI_PATTERNBUFFER_DATA_WIDTH => PATTERNBUFFER_WIDTH
    )
    port map (
        clk => axi_control_aclk,
        rst => reset,
        en => enable,

        -- Configuration values from the axi interface
        n_rows_config => n_rows_config,
        n_cols_config => n_cols_config,
        bitdepth_config => bitdepth_config,
        lsb_blank_length_config => lsb_blank_length_config,
        
        -- Data interface to axi
        axi_patternbuffer_clk => axi_patternbuffer_clk,
        axi_patternbuffer_rst => axi_patternbuffer_rst,
        axi_patternbuffer_write_en => axi_patternbuffer_write_en,
        axi_patternbuffer_addr => axi_patternbuffer_addr(PATTERNBUFFER_ADDR_SIZE - 1 downto 2),
        axi_patternbuffer_write_data => axi_patternbuffer_write_data,
        axi_patternbuffer_read_data => axi_patternbuffer_read_data,

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
