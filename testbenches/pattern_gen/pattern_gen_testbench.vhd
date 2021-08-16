library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_gen_testbench is
end pattern_gen_testbench;

architecture tb of pattern_gen_testbench is
    constant n_rows : integer := 64;
    constant n_cols : integer := 64;
    constant bitdepth : integer := 8;
    constant mem_addr_size : integer := 12;
    constant mem_data_size : integer := 24;
    constant T : time := 20 ns;

    signal clk : std_logic := '1';
    signal rst : std_logic;

    signal mem_write_addr : std_logic_vector(mem_addr_size - 1 downto 0);
    signal mem_write_data : std_logic_vector(mem_data_size - 1 downto 0);
    signal mem_write_en : std_logic;

    signal pattern_go : std_logic;
    signal pattern_done : std_logic;
begin
    pattern_gen_unit : entity work.pattern_gen
        generic map (n_rows => n_rows,
                n_cols => n_cols,
                bitdepth => bitdepth,
                mem_addr_size => mem_addr_size,
                mem_data_size => mem_data_size)
        port map (clk => clk,
              rst => rst,
            
              -- Ram interface
              mem_write_addr => mem_write_addr,
              mem_write_data => mem_write_data,
              mem_write_en => mem_write_en,
    
              -- Pattern gen contol
              pattern_go => pattern_go,
              pattern_done => pattern_done);
    
    clk <= not clk after T/2;

    process
    begin
        rst <= '0';

        loop
            wait for T;
            pattern_go <= '1';
            wait for T;
            pattern_go <= '0';
            if pattern_done = '0' then
                wait until pattern_done = '1';
            else
                wait for 8192*T;
             end if;
        end loop;
        
    end process;
end architecture tb;