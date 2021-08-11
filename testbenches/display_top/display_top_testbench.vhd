library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_top_testbench is
end display_top_testbench;

architecture tb of display_top_testbench is
    constant n_rows : integer := 32;
    constant n_cols : integer := 64;
    constant bitdepth : integer := 8;
    constant lsb_blank_length : integer := 20;
--    constant mem_addr_size : integer := 14;
    constant T : time := 20 ns;

    signal clk : std_logic := '1';
    signal rst : std_logic;

--    signal mem_write_addr : std_logic_vector(mem_addr_size downto 0);
--    signal mem_write_data : std_logic_vector(5 downto 0);
--    signal mem_write_en : std_logic;

--    signal mem_read_addr : std_logic_vector(mem_addr_size downto 0);
--    signal mem_read_data : std_logic_vector(5 downto 0);
    
    signal display_clk_out : std_logic;
    signal display_blank_out : std_logic;
    signal display_latch_out : std_logic;
    signal display_address_out : std_logic_vector(4 downto 0);
    signal R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : std_logic;

begin
    display_top_unit : entity work.display_top
        generic map (n_rows=> n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth,
                     lsb_blank_length => lsb_blank_length)
        port map (clk => clk,
                  rst => rst,
                
                 -- BRAM interface
--                 mem_write_addr => mem_write_addr,
--                 mem_write_data => mem_write_data,
--                 mem_write_en => mem_write_en,

--                 mem_read_addr => mem_read_addr,
--                 mem_read_data => mem_read_data,
         
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
                  B1_out => B1_out);
    
    clk <= not clk after T/2;

    process
    begin
        rst <= '0';
        wait for T;         
        rst <= '0';

        loop
            wait for T;
        end loop;

    end process;

--    process
--    begin
--        wait on mem_read_addr;
--        wait for 4 ns;
--        mem_read_data <= mem_read_addr(5 downto 0);
--    end process;
    
end architecture tb;


