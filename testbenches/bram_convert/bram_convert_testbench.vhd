library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_convert_testbench is
end bram_convert_testbench;

architecture tb of bram_convert_testbench is
    constant n_rows : integer := 32;
    constant n_cols : integer := 64;
    constant bitdepth : integer := 8;
    constant mem_read_addr_size : integer := 12;
    constant mem_read_data_size : integer := 24;
    constant mem_write_addr_size : integer := 14;
    constant mem_write_data_size : integer := 6;
    
    constant T : time := 20 ns;

    signal clk : std_logic := '1';
    signal rst : std_logic;
    
    signal mem_read_addr : std_logic_vector(mem_read_addr_size - 1 downto 0);
    signal mem_read_data : std_logic_vector(mem_read_data_size - 1 downto 0);

    signal convert_go : std_logic;
    signal convert_done : std_logic;
    signal display_buffer : integer range 0 to 1; 

    signal mem_write_addr : std_logic_vector(mem_write_addr_size - 1 downto 0);
    signal mem_write_data : std_logic_vector(mem_write_data_size - 1 downto 0);
    signal mem_write_en : std_logic;

begin
    bram_convert_unit : entity work.bram_convert
        generic map (n_rows => n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth,
                     mem_read_addr_size => mem_read_addr_size,
                     mem_read_data_size => mem_read_data_size,
                     mem_write_addr_size => mem_write_addr_size,
                     mem_write_data_size => mem_write_data_size)
        port map (clk => clk,
                  rst => rst,

                  mem_read_addr => mem_read_addr,
                  mem_read_data => mem_read_data,

                  convert_go => convert_go,
                  convert_done => convert_done,

                  display_buffer => display_buffer,

                  mem_write_addr => mem_write_addr,
                  mem_write_data => mem_write_data,
                  mem_write_en => mem_write_en);

    clk <= not clk after T/2;

    process
    begin
        rst <= '1';
        wait for 2*T;
        rst <= '0';
        wait for 2*T;

        display_buffer <= 0;

        convert_go <= '1';
        wait for T;
        convert_go <= '0';
            
        wait until convert_done = '1';

        convert_go <= '1';
        wait for T;
        convert_go <= '0';
        
        wait until convert_done = '1';
        wait for 40*T;

        display_buffer <= 1;
        
        convert_go <= '1';
        wait for T;
        convert_go <= '0';
            
        wait until convert_done = '1';

        loop
            wait for T;
        end loop;

    end process;

    process
    begin
        wait on mem_read_addr;
        
        wait for 4 ns;
        mem_read_data <= (mem_read_data'high downto mem_read_addr'length => '0') & mem_read_addr;
    end process;
end architecture tb;