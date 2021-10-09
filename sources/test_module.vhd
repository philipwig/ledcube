library ieee;
use ieee.std_logic_1164.all;

entity test_module is
    generic(
        mem_addr_size : integer;
        mem_data_size : integer);

    port(
        clk : in std_logic;

        -- Ram interface
        mem_addr : out std_logic_vector(mem_addr_size - 1 downto 0);
        mem_en : out std_logic;
        mem_read_data : in std_logic_vector(mem_data_size - 1 downto 0);

        output_out : out std_logic);

end test_module;

architecture testing of test_module is

begin
    mem_en <= '1';
    mem_addr <= x"00000000";

    process (clk)
    begin
        if (rising_edge(clk)) then
            if mem_read_data(0) = '1' then
                output_out <= '1';
            else 
                output_out <= '0';
            end if;
        end if;
    end process;

end architecture testing;
