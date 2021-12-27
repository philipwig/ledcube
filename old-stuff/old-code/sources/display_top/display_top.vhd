library ieee;
use ieee.std_logic_1164.all;

entity display_top is
    generic(n_rows : integer := 32;
            n_cols : integer := 64;
            bitdepth : integer := 8;
            lsb_blank_length : integer := 20);
    port (clk : in std_logic;
          rst : in std_logic;
          
          -- Display interface
          display_clk_out : out std_logic;
          display_blank_out : out std_logic;
          display_latch_out : out std_logic;
          display_address_out : out std_logic_vector(4 downto 0);
          R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic);

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
    constant framebuffer_ram_depth : integer := n_rows * n_cols * bitdepth * 2; -- Stores all the data for each pixel on the display times 2 for two framebuffers **Make sure this is a power of 2**
    
    constant framebuffer_addr_size : integer := clogb2(framebuffer_ram_depth);
    constant framebuffer_data_size : integer := framebuffer_ram_width;

    -- Signals for the framebuffer
    signal framebuffer_write_addr : std_logic_vector(framebuffer_addr_size - 1 downto 0);
    signal framebuffer_write_data : std_logic_vector(framebuffer_data_size - 1 downto 0);
    signal framebuffer_write_en : std_logic;

    signal framebuffer_read_addr : std_logic_vector(framebuffer_addr_size - 1 downto 0);
    signal framebuffer_read_data : std_logic_vector(framebuffer_data_size - 1 downto 0);



    -- Constants defining size of patternbuffer
    constant patternbuffer_ram_width : integer := 3 * bitdepth; -- For RGB value with each bit taking up bitdepth number of bits
    constant patternbuffer_ram_depth : integer := n_rows * n_cols * 2; -- Stores all the data for each pixel on the display **Make sure this is a power of 2**
    
    constant patternbuffer_addr_size : integer := clogb2(patternbuffer_ram_depth);
    constant patternbuffer_data_size : integer := patternbuffer_ram_width;

    -- Signals for the patternbuffer
    signal patternbuffer_write_addr : std_logic_vector(patternbuffer_addr_size - 1 downto 0);
    signal patternbuffer_write_data : std_logic_vector(patternbuffer_data_size - 1 downto 0);
    signal patternbuffer_write_en : std_logic := '0';

    signal patternbuffer_read_addr : std_logic_vector(patternbuffer_addr_size - 1 downto 0);
    signal patternbuffer_read_data : std_logic_vector(patternbuffer_data_size - 1 downto 0);



    -- Signals for bcm module
    signal bcm_go : std_logic;
    signal bcm_done : std_logic;
    signal display_row : integer range 0 to n_rows - 1;
    signal display_bit : integer range 0 to bitdepth - 1;
    
    -- Frambuffer swapping contol
    signal display_buffer : integer range 0 to 1; -- Which framebuffer to read from, 0 or 1, input only taken when starting bcm with bcm_go
    
    -- Pattern generator control
    signal pattern_go : std_logic;
    signal pattern_done : std_logic;

    -- Signal for blanking
    signal blank_go : std_logic;
    signal latch_rdy : std_logic;
    
    -- Signals for conversion module
    signal convert_go : std_logic;
    signal convert_done : std_logic;

begin
    -- Controller Module -> Controls all of the different modules and makes sure they work together
    display_contoller_unit : entity work.display_contoller
        generic map (n_rows => n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth)
        port map (clk => clk,
                  rst => rst,
                                    
                  -- bcm module contol
                  bcm_go => bcm_go,
                  bcm_done => bcm_done,
                  display_row => display_row,
                  display_bit => display_bit,
                  display_buffer => display_buffer,

                  -- blanking control
                  blank_go => blank_go,
                  latch_rdy => latch_rdy,
                  
                  -- Converter control
                  convert_go => convert_go,
                  convert_done => convert_done,
                  
                  -- Buffer control input
                  pattern_go => pattern_go,
                  pattern_done => pattern_done,
          
                  -- Display output signal
                  display_latch_out => display_latch_out);

    -- Blanking Module -> Contols the blanking of the display
    display_blanking_unit : entity work.display_blanking
        generic map (bitdepth => bitdepth,
                     lsb_blank_length => lsb_blank_length)
        port map (clk => clk,
                  rst => rst,

                  blank_go => blank_go,
                  latch_rdy => latch_rdy,
                  display_blank_out => display_blank_out);

    -- BCM Module -> Writes the pixel data to the display using binary coded modulation
    display_bcm_unit : entity work.display_bcm
        generic map (n_rows => n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth,
                     mem_addr_size => framebuffer_addr_size,
                     mem_data_size => framebuffer_data_size)
        port map (clk => clk,
                  rst => rst,

                  bcm_go => bcm_go,
                  bcm_done => bcm_done,
                  display_row => display_row,
                  display_bit => display_bit,
                  display_buffer => display_buffer,

                  mem_read_addr => framebuffer_read_addr,
                  mem_read_data => framebuffer_read_data,
                  
                  display_clk_out => display_clk_out,
                  display_address_out => display_address_out,
              
                  R0_out => R0_out,
                  G0_out => G0_out,
                  B0_out => B0_out,
                  R1_out => R1_out,
                  G1_out => G1_out,
                  B1_out => B1_out);

    -- Framebuffer -> Stores the frames and uses double buffering
    framebuffer_unit : entity work.simple_bram
            generic map (addr_width => framebuffer_addr_size,
                         data_width => framebuffer_data_size,
                         c_init_file => "")
            port map (write_clk => clk,
                      write_en => framebuffer_write_en,
                      write_addr => framebuffer_write_addr,
                      write_data => framebuffer_write_data,
                    
                      read_clk => clk,
                      read_addr => framebuffer_read_addr,
                      read_data => framebuffer_read_data);

    -- Converter -> Converts and moves the display data from the Patternbuffer to the Framebuffer
    bram_convert_unit : entity work.bram_convert
                generic map (n_rows => n_rows,
                             n_cols => n_cols,
                             bitdepth => bitdepth,
                             mem_read_addr_size => patternbuffer_addr_size,
                             mem_read_data_size => patternbuffer_data_size,
                             mem_write_addr_size => framebuffer_addr_size,
                             mem_write_data_size => framebuffer_data_size)
                port map (clk => clk,
                          rst => rst,

                          mem_read_addr => patternbuffer_read_addr,
                          mem_read_data => patternbuffer_read_data,

                          convert_go => convert_go,
                          convert_done => convert_done,
                          display_buffer => display_buffer,

                          mem_write_addr => framebuffer_write_addr,
                          mem_write_data => framebuffer_write_data,
                          mem_write_en => framebuffer_write_en);

    -- Patternbuffer -> Stores the generated pattern that will be displayed on the LED panel
    patternbuffer_unit : entity work.simple_bram
            generic map (addr_width => patternbuffer_addr_size,
                         data_width => patternbuffer_data_size,
                         c_init_file => "initalization/output.txt")
            port map (write_clk => clk,
                      write_en => patternbuffer_write_en,
                      write_addr => patternbuffer_write_addr,
                      write_data => patternbuffer_write_data,
                    
                      read_clk => clk,
                      read_addr => patternbuffer_read_addr,
                      read_data => patternbuffer_read_data);
    
    -- Pattern Generator -> Generates the patterns to be displayed without using the ARM CPU
    pattern_gen_unit : entity work.pattern_gen 
        generic map (n_rows => n_rows * 2,
                     n_cols => n_cols,
                     bitdepth => bitdepth,
                     mem_addr_size => patternbuffer_addr_size,
                     mem_data_size => patternbuffer_data_size)
        port map (clk => clk,
                  rst => rst,

                  mem_write_addr => patternbuffer_write_addr,
                  mem_write_data => patternbuffer_write_data,
                  mem_write_en => patternbuffer_write_en,
                                    
                  pattern_go => pattern_go,
                  pattern_done => pattern_done);
        
end architecture rtl;