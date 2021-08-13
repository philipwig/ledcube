library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_gen is
    generic(n_rows : integer;
            n_cols : integer;
            bitdepth : integer;
            mem_addr_size : integer;
            mem_data_size : integer);
    port (clk : in std_logic;
          rst : in std_logic;
        
          -- Ram interface
          mem_write_addr : out std_logic_vector(mem_addr_size - 1 downto 0);
          mem_write_data : out std_logic_vector(mem_data_size - 1 downto 0);
          mem_write_en : out std_logic;

          -- Pattern gen contol
          pattern_go : in std_logic;
          pattern_done : out std_logic);

end pattern_gen;

architecture cool of pattern_gen is

    signal generating_pattern : std_logic := '1';

    signal rand_number : std_logic_vector(31 downto 0);
        
begin

    pattern_done <= not generating_pattern;

    process (clk)
    
    variable current_row : integer range 0 to n_rows - 1 :=  n_rows - 1;
    variable current_col : integer range 0 to n_cols - 1 := n_cols - 1;
    variable write_pixel : integer range 0 to 1 := 1;
        

      -- maximal length 32-bit xnor LFSR based on xilinx app note XAPP210
      function lfsr32(x : std_logic_vector(31 downto 0)) return std_logic_vector is
      begin
        return x(30 downto 0) & (x(0) xnor x(1) xnor x(21) xnor x(31));
      end function;


    begin
        if (rising_edge(clk)) then
            if rst = '1' then
                mem_write_addr <= (others => '0');
                mem_write_data <= (others => '0');
                mem_write_en <= '0';
                generating_pattern <= '0';
            else
                if pattern_go = '1' and generating_pattern = '0' then
                    generating_pattern <= '1';
                elsif generating_pattern = '1' then
                        if current_row = n_rows - 1 and current_col = n_cols - 1 then
                            -- Done generating pattern
                            current_row := 0;
                            current_col := 0;
                            generating_pattern <= '0';
                        elsif current_col = n_cols - 1 then
                            -- Go to next row
                            current_row := current_row + 1;
                            current_col := 0;
                        else
                            -- Go to next col
                            current_col := current_col + 1;
                        end if;

                        rand_number <= lfsr32(rand_number);
                        -- mem_write_data <= "11110000" & "11110000" & "11111111";
                        mem_write_data <= "00" & rand_number(17 downto 12) & "00" & rand_number(11 downto 6) & "00" & rand_number(5 downto 0);-- Remember to make generic for any size of mem_write_data
                        mem_write_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_write_addr'length) );
                        mem_write_en <= '1';
                else 
                    mem_write_en <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture cool;
