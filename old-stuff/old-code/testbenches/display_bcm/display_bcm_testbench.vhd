library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_bcm_testbench is
end display_bcm_testbench;

architecture tb of display_bcm_testbench is
    constant n_rows : integer := 32;
    constant n_cols : integer := 64;
    constant bitdepth : integer := 8;
    constant mem_addr_size : integer := 15;
    constant mem_data_size : integer := 6;

    signal clk : std_logic := '1';
    signal rst : std_logic;

    signal bcm_go : std_logic; -- Start the bcm module
    signal bcm_done : std_logic; -- Shifting data into display is done

    signal display_row : integer range 0 to n_cols - 1; -- Row num to shift data into
    signal display_bit : integer range 0 to bitdepth - 1;
    signal display_buffer : integer range 0 to 1;

    signal mem_read_addr : std_logic_vector(mem_addr_size - 1 downto 0);
    signal mem_read_data : std_logic_vector(mem_data_size - 1 downto 0);

    -- Display output signals
    signal display_clk_out : std_logic;
    signal display_address_out : std_logic_vector(4 downto 0);
    signal R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : std_logic;


    constant T : time := 20 ns;

begin
    display_bcm_unit : entity work.display_bcm
        generic map (n_rows => n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth,
                     mem_addr_size => mem_addr_size,
                     mem_data_size => mem_data_size)
        port map (clk => clk,
                  rst => rst,

                  bcm_go => bcm_go,
                  bcm_done => bcm_done,

                  display_row => display_row,
                  display_bit => display_bit,
                  display_buffer => display_buffer,
                        
                  mem_read_addr => mem_read_addr,
                  mem_read_data => mem_read_data,
            
                  display_clk_out => display_clk_out,
                  display_address_out => display_address_out,
            
                  R0_out => R0_out,
                  G0_out => G0_out,
                  B0_out => B0_out,
                  R1_out => R1_out,
                  G1_out => G1_out,
                  B1_out => B1_out);

    clk <= not clk after T/2;

    process
    begin
    
        display_row <= 0;

        rst <= '1';
        wait for T;         
        rst <= '0';
        wait for 4*T;

        -- Cycle 1
        bcm_go <= '1';
        wait for T;
        bcm_go <= '0';

        wait for 4*T;

        wait until bcm_done = '1';

        -- Delay between cycles
        wait for 4*T;

        -- Cycle 2
        wait for 2*T;

        bcm_go <= '1';
        wait until bcm_done = '0';
        wait for T;
        bcm_go <= '0';

        wait until bcm_done = '1';
        
        -- Delay between cycles
        wait for 4*T;

        -- Cycle 3
        bcm_go <= '1';
        
        wait until bcm_done = '0';
        wait for T;
        bcm_go <= '0';

        wait until bcm_done = '1';
        wait for T;
        bcm_go <= '1';

        wait until bcm_done = '0';
        wait for T;
        bcm_go <= '0';

        wait until bcm_done = '1';

        -- Delay between cycles
        wait for 4*T;

        -- End simualtion
        -- assert false report "Test: OK" severity failure;

    end process;

    process
    begin
        wait on mem_read_addr;
        wait for T;
        mem_read_data <= mem_read_addr(mem_read_data'length - 1 downto 0);
    end process;

end tb;