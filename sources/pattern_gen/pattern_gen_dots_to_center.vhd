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
    
    type state_type is (erase_pixels, write_pixels);
    signal state : state_type := erase_pixels;
    signal generating_pattern : std_logic := '1';

    variable top_line : integer range 0 to n_rows - 1 := 0;
    variable left_line : integer range 0 to n_cols - 1 := 0;        
begin

    pattern_done <= not generating_pattern;

    process (clk)
    
    variable current_row : integer range 0 to n_rows - 1 :=  n_rows - 1;
    variable current_col : integer range 0 to n_cols - 1 := n_cols - 1;   
        
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

                        elsif current_col = n_cols - 1 then
                            -- Go to next row
                            current_row := current_row + 1;
                            current_col := 0;
                        else 
                            -- Go to next col
                            current_col := current_col + 1;
                        end if;

                        case state is
                            when erase_pixels =>
                                if current_row = n_rows - 1 and current_col = n_cols - 1 then
                                    state <= write_pixels;
                                end if;
                                
                                mem_write_data <= (others => '0'); -- Remember to try and make generic for any size of mem_write_data

                            when write_pixels =>
                                if current_row = n_rows - 1 and current_col = n_cols - 1 then
                                    state <= erase_pixels;
                                    generating_pattern <= '0';

                                    if left_line = n_cols / 2 - 1 then
                                        left_line <= 0;
                                        top_line <= 0;
                                    else
                                        left_line <= left_line + 1;
                                        top_line <= top_line + 1;
                                    end if;
                                end if;

                                if current_col = left_line or current_col = n_cols - left_line - 1 then
                                    if current_row = top_line or current_row = n_rows - top_line - 1 then
                                        mem_write_data <= x"FFFFFF"; -- Write white pixel
                                    else
                                        mem_write_data <= x"000000"; -- Write black pixel
                                    end if;
                                else
                                    mem_write_data <= x"000000";
                                end if;
                        end case;
                       
                        mem_write_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_write_addr'length) );
                        mem_write_en <= '1';
                else 
                    mem_write_en <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture cool;
