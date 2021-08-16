library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_convert is
    generic(n_rows : integer;
            n_cols : integer;
            bitdepth : integer;
            mem_read_addr_size : integer;
            mem_read_data_size : integer;
            mem_write_data_size : integer;
            mem_write_addr_size : integer);
    port (clk : in std_logic;
          rst : in std_logic;

          mem_read_addr : out std_logic_vector(mem_read_addr_size - 1 downto 0);
          mem_read_data : in std_logic_vector(mem_read_data_size - 1 downto 0);

          convert_go : in std_logic;
          convert_done : out std_logic;
          display_buffer : in integer range 0 to 1; -- Which framebuffer to write into, 0 or 1, input only taken when starting bcm with bcm_go

          mem_write_addr : out std_logic_vector(mem_write_addr_size - 1 downto 0);
          mem_write_data : out std_logic_vector(mem_write_data_size - 1 downto 0);
          mem_write_en : out std_logic);

end entity bram_convert;


architecture fast of bram_convert is
    constant bottom_half_offset : integer := n_rows * n_cols + 1;

    type state_type is (idle, read_top, read_bottom, write_line);
    signal state : state_type := idle;

    signal top_pixel, bottom_pixel : std_logic_vector(mem_read_data_size - 1 downto 0);
    
    signal current_row_debug : integer range 0 to n_rows - 1 := 0;
    signal current_col_debug : integer range 0 to n_cols - 1 := 0;
    signal current_bit_debug : integer range 0 to bitdepth - 1 := 0;
    
    signal current_buffer : integer range 0 to 1;

begin

    current_buffer <= 1 when display_buffer = 0 else
                      0;

    process (clk)
        variable current_row : integer range 0 to n_rows - 1 := 0;
        variable current_col : integer range 0 to n_cols - 1 := 0;
        variable current_bit : integer range 0 to bitdepth - 1 := 0;

    begin
        if(rising_edge(clk)) then
            if rst = '1' then
                state <= idle;
                mem_read_addr <= (others => '0');
                convert_done <= '0';
                mem_write_addr <= (others => '0');
                mem_write_data <= (others => '0');
                mem_write_en <= '0';
                top_pixel <= (others => '0');
                bottom_pixel <= (others => '0');
                current_row := 0;
                current_col := 0;
                current_bit := 0;

            else

                mem_write_en <= '0';

                case state is
                    when idle =>
                        mem_write_addr <= (others => '0');
                        mem_write_data <= (others => '0');
                        mem_write_en <= '0';

                        if convert_go = '1' then
                            -- Set the address to read the next top line from memory
                            mem_read_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_read_addr'length));

                            convert_done <= '0';
                            state <= read_top;
                        end if;

                    when read_top =>
                        -- Read the top RGB values from memory and store it into the temp line
                        top_pixel <= mem_read_data;
                        
                        -- Set the address to read the bottom line from memory
                        mem_read_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col + bottom_half_offset, mem_read_addr'length));

                        state <= read_bottom;

                    when read_bottom =>
                        -- Read the bottom RGB values from memory and store into the temp line
                        bottom_pixel <= mem_read_data;
                        
                        state <= write_line;

                    when write_line =>

                        -- Write the temp line into the memory at the correct address
                        mem_write_addr <= std_logic_vector(to_unsigned( (n_rows * n_cols * bitdepth * current_buffer) + (n_cols * bitdepth * current_row) + (n_cols * current_bit) + current_col, mem_write_addr'length));
                        mem_write_data <= top_pixel(2 * bitdepth + current_bit) & top_pixel(bitdepth + current_bit) & top_pixel(current_bit) & bottom_pixel(2 * bitdepth + current_bit) & bottom_pixel(bitdepth + current_bit) & bottom_pixel(current_bit);
                        mem_write_en <= '1';
                        
                        if current_row = n_rows - 1 and current_col = n_cols - 1 and current_bit = bitdepth - 1 then
                            -- Finished writing all bits to framebuffer
                            current_row := 0;
                            current_bit := 0;
                            current_col := 0;
                            
                            convert_done <= '1';
                            state <= idle;

                        elsif current_col = n_cols - 1 and current_bit = bitdepth - 1 then 
                            -- Go to the next row
                            current_row := current_row + 1;
                            current_col := 0;
                            current_bit := 0;

                            -- Set the address to read the next top line from memory
                            mem_read_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_read_addr'length));
                            state <= read_top;

                        elsif current_bit = bitdepth - 1 then 
                            -- Go to the next col
                            current_col := current_col + 1;
                            current_bit := 0;

                            -- Set the address to read the next top line from memory
                            mem_read_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_read_addr'length));
                            state <= read_top;

                        else
                            -- Go to the next bit
                            current_bit := current_bit + 1;
                            state <= write_line;

                        end if;
                end case;
                
            end if;
        end if;
    end process;
end fast;

