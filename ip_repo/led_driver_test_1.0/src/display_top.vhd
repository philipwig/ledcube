library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_top is
    generic(
        N_ROWS_MAX : integer; -- This is the actual number of rows on the display so 64 for a 64x64 display
        N_COLS_MAX : integer; -- The actual number of col on the display so 64 for 64x64 display
        BITDEPTH_MAX : integer; -- This is the number of bits of color data for each of R G and B, so if 8, 24 bits for RGB combined
        LSB_BLANK_MAX : integer; -- The number of cycles of the OUTPUT CLOCK (so display_clk_out) to blank for

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

end display_top;

architecture rtl of display_top is
    --  The following function calculates the address width based on specified RAM depth
    function clogb2( depth : natural) return integer is
        variable temp    : integer := depth;
        variable ret_val : integer := 0;
        begin
            while temp > 1 loop
                ret_val := ret_val + 1;
                temp    := temp / 2;
            end loop;
            return ret_val;
    end function;


    -- Constants defining size of the framebuffer
    constant framebuffer_ram_width : integer := 6; -- For R0, G0, B0, R1, G1, G1 -> 6 total
    constant framebuffer_ram_depth : integer := N_ROWS_MAX * N_COLS_MAX * BITDEPTH_MAX * 2; -- Stores all the data for each pixel on the display times 2 for two framebuffers **Make sure this is a power of 2**
    
    constant framebuffer_addr_size : integer := clogb2(framebuffer_ram_depth);
    constant framebuffer_data_size : integer := framebuffer_ram_width;

    -- Signals for the framebuffer
    signal framebuffer_write_addr : std_logic_vector(framebuffer_addr_size - 1 downto 0);
    signal framebuffer_write_data : std_logic_vector(framebuffer_data_size - 1 downto 0);
    signal framebuffer_write_en : std_logic;

    signal framebuffer_read_addr : std_logic_vector(framebuffer_addr_size - 1 downto 0);
    signal framebuffer_read_data : std_logic_vector(framebuffer_data_size - 1 downto 0);

    -- Signals for the patternbuffer
    signal patternbuffer_clk : std_logic;
    signal patternbuffer_write_en : std_logic := '0';
    signal patternbuffer_addr : std_logic_vector(AXI_PATTERNBUFFER_ADDR_WIDTH - 1 downto 0);
    signal patternbuffer_write_data : std_logic_vector(AXI_PATTERNBUFFER_DATA_WIDTH - 1 downto 0);
    signal patternbuffer_read_data : std_logic_vector(AXI_PATTERNBUFFER_DATA_WIDTH - 1 downto 0);

    -- Signals for the configuration values
    signal n_cols : integer range 0 to N_COLS_MAX;
    signal n_rows : integer range 0 to N_ROWS_MAX;
    signal bitdepth : integer range 0 to BITDEPTH_MAX;
    signal lsb_blank_length : integer range 0 to LSB_BLANK_MAX;

    -- Signals for bcm module
    signal bcm_go : std_logic;
    signal bcm_done : std_logic;
    signal display_row : integer range 0 to N_ROWS_MAX;
    signal display_bit : integer range 0 to BITDEPTH_MAX;
    
    -- Frambuffer swapping contol
    signal display_buffer : integer range 0 to 1; -- Which framebuffer to read from, 0 or 1, input only taken when starting bcm with bcm_go
    
    -- Signal for blanking
    signal blank_go : std_logic;
    signal latch_rdy : std_logic;
    
    -- Signals for conversion module
    signal convert_go : std_logic;
    signal convert_done : std_logic;


begin
    -- Controller Module -> Controls all of the different modules and makes sure they work together
    display_contoller_unit : entity work.display_contoller
        generic map (
            N_ROWS_MAX => N_ROWS_MAX,
            N_COLS_MAX => N_COLS_MAX,
            BITDEPTH_MAX => BITDEPTH_MAX,
            LSB_BLANK_MAX => LSB_BLANK_MAX
        )
        port map (
            clk => clk,
            rst => rst,
            en => en,

            -- Configuration values from the axi interface
            n_rows_config => n_rows_config,
            n_cols_config => n_cols_config,
            bitdepth_config => bitdepth_config,
            lsb_blank_length_config => lsb_blank_length_config,

            -- Current values from config to all the other modules, these have been latched/delayed correctly
            n_cols => n_cols,
            n_rows => n_rows,
            bitdepth => bitdepth,
            lsb_blank_length => lsb_blank_length,

            -- Which framebuffer to read from, 0 or 1, input only taken when starting bcm with bcm_go. Used in multiple modules
            display_buffer => display_buffer,

            -- bcm module contol
            bcm_go => bcm_go,
            bcm_done => bcm_done,
            display_row => display_row,
            display_bit => display_bit,

            -- blanking control
            blank_go => blank_go,
            latch_rdy => latch_rdy,
                  
            -- Converter control
            convert_go => convert_go,
            convert_done => convert_done,
                  
            -- Display output signal
            display_latch_out => display_latch_out
        );

    -- Blanking Module -> Contols the blanking of the display
    display_blanking_unit : entity work.display_blanking
        generic map (
            BITDEPTH_MAX => BITDEPTH_MAX,
            LSB_BLANK_MAX => LSB_BLANK_MAX
        )
        port map (
            clk => clk,
            rst => rst,

            bitdepth => bitdepth,
            lsb_blank_length => lsb_blank_length,
            
            -- Contol signals
            blank_go => blank_go,
            latch_rdy => latch_rdy,
            
            -- Display output signal
            display_blank_out => display_blank_out
        );

    -- BCM Module -> Writes the pixel data to the display using binary coded modulation
    display_bcm_unit : entity work.display_bcm
        generic map (
            N_ROWS_MAX => N_ROWS_MAX,
            N_COLS_MAX => N_COLS_MAX,
            BITDEPTH_MAX => BITDEPTH_MAX,
            mem_addr_size => framebuffer_addr_size,
            mem_data_size => framebuffer_data_size
        )
        port map (
            clk => clk,
            rst => rst,
        
            -- Current display configuration
            n_rows => n_rows,
            n_cols => n_cols,
            bitdepth => bitdepth,

            -- Control signals
            bcm_go => bcm_go,
            bcm_done => bcm_done,
            display_row => display_row,
            display_bit => display_bit,
            display_buffer => display_buffer,

            -- Interface to the BRAM
            mem_read_addr => framebuffer_read_addr,
            mem_read_data => framebuffer_read_data,
                  
            -- Display output signals
            display_clk_out => display_clk_out,
            display_address_out => display_address_out,
            R0_out => R0_out,
            G0_out => G0_out,
            B0_out => B0_out,
            R1_out => R1_out,
            G1_out => G1_out,
            B1_out => B1_out
        );

    -- Framebuffer -> Stores the frames and uses double buffering
    framebuffer_unit : entity work.simple_bram
            generic map (
                addr_width => framebuffer_addr_size,
                data_width => framebuffer_data_size,
                c_init_file => ""
            )
            port map (
                write_clk => clk,
                write_en => framebuffer_write_en,
                write_addr => framebuffer_write_addr,
                write_data => framebuffer_write_data,
                    
                read_clk => clk,
                read_addr => framebuffer_read_addr,
                read_data => framebuffer_read_data
            );

    -- Converter -> Converts and moves the display data from the Patternbuffer to the Framebuffer
    bram_convert_unit : entity work.bram_convert
                generic map (
                    N_ROWS_MAX => N_ROWS_MAX,
                    N_COLS_MAX => N_COLS_MAX,
                    BITDEPTH_MAX => BITDEPTH_MAX,

                    mem_read_addr_size => AXI_PATTERNBUFFER_ADDR_WIDTH,
                    mem_read_data_size => AXI_PATTERNBUFFER_DATA_WIDTH,
                    mem_write_addr_size => framebuffer_addr_size,
                    mem_write_data_size => framebuffer_data_size
                )
                port map (
                    clk => clk,
                    rst => rst,

                    n_rows => n_rows,
                    n_cols => n_cols,
                    bitdepth => bitdepth,

                    mem_read_addr => patternbuffer_addr,
                    mem_read_data => patternbuffer_read_data,

                    convert_go => convert_go,
                    convert_done => convert_done,
                    display_buffer => display_buffer,

                    mem_write_addr => framebuffer_write_addr,
                    mem_write_data => framebuffer_write_data,
                    mem_write_en => framebuffer_write_en
                );

    -- Patternbuffer -> Stores the generated pattern that will be displayed on the LED panel
    patternbuffer_unit : entity work.dual_bram
        generic map (
            DATA_WIDTH => AXI_PATTERNBUFFER_DATA_WIDTH,
            ADDR_WIDTH => AXI_PATTERNBUFFER_ADDR_WIDTH
        )
        port map (
            -- Port A
            a_clk => clk,
            a_we => axi_patternbuffer_write_en,
            a_addr => axi_patternbuffer_addr,
            a_din => axi_patternbuffer_write_data,
            a_dout => axi_patternbuffer_read_data,
            
            -- Port B
            b_clk => clk,
            b_we => patternbuffer_write_en,
            b_addr => patternbuffer_addr,
            b_din => patternbuffer_write_data,
            b_dout => patternbuffer_read_data
        );
end architecture rtl;