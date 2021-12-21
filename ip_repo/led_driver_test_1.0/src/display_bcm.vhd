library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_bcm is
    generic(
        N_ROWS_MAX : integer;
        N_COLS_MAX : integer;
        BITDEPTH_MAX : integer;
        mem_addr_size : integer;
        mem_data_size : integer
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
          
        -- Current display configuration
        n_rows : in integer range 0 to N_ROWS_MAX;
        n_cols : in integer range 0 to N_COLS_MAX;
        bitdepth : in integer range 0 to BITDEPTH_MAX;

        bcm_go : in std_logic; -- Start the bcm module
        bcm_done : out std_logic := '1'; -- Shifting data into display is done
        display_row : in integer range 0 to N_ROWS_MAX - 1; -- Row num to shift data into
        display_bit : in integer range 0 to BITDEPTH_MAX - 1; -- Current bit to display
        display_buffer : in integer range 0 to 1; -- Which framebuffer to read from, 0 or 1, input only taken when starting bcm with bcm_go
          
        -- Interface to the BRAM
        mem_read_addr : out std_logic_vector(mem_addr_size - 1 downto 0);
        mem_read_data : in std_logic_vector(mem_data_size - 1 downto 0);

        -- Display output signals
        display_clk_out : out std_logic := '0';
        display_address_out : out std_logic_vector(4 downto 0) := "00000";
        R0_out, G0_out, B0_out, R1_out, G1_out, B1_out : out std_logic := '0'
    );

end entity display_bcm;

architecture fast of display_bcm is
    type state_type is (idle, shift1, shift2);
    signal state : state_type := idle;

    signal col_num : integer range 0 to N_COLS_MAX - 1 := 0;
    signal ram_read_addr : std_logic_vector(mem_addr_size - 1 downto 0) := (others => '0');
    
    signal rgb_data : std_logic_vector(5 downto 0) := (others => '0');

begin
    mem_read_addr <= ram_read_addr;
    
    -- Should probably check this to make sure it is actaully makes sense
    -- I don't actually think this should be right but it seems to work
    R0_out <= mem_read_data(2);
    G0_out <= mem_read_data(1);
    B0_out <= mem_read_data(0);
    R1_out <= mem_read_data(5);
    G1_out <= mem_read_data(4);
    B1_out <= mem_read_data(3);


    process (clk)
        begin
            if(rising_edge(clk)) then            
                if rst = '0' then
                    state <= idle;
                    bcm_done <= '1';
                    display_clk_out <= '0';
                    display_address_out <= "00000";
                    col_num <= 0;
                else
                    case state is
                        when idle =>
                            display_clk_out <= '0';

                            if bcm_go = '1' then
                                state <= shift1;
                                col_num <= 0;
                                bcm_done <= '0';
                                display_address_out <= std_logic_vector(to_unsigned(display_row, display_address_out'length));
                                ram_read_addr <= std_logic_vector(to_unsigned((display_row * bitdepth * n_cols) + (display_bit * n_cols) + (n_cols * n_rows * bitdepth * display_buffer), ram_read_addr'length) );
                            else 
                                bcm_done <= '1';
                            end if;

                        when shift1 =>
                            state <= shift2;
                            display_clk_out <= '0';

                        when shift2 =>
                            display_clk_out <= '1'; -- Clock the data into the shift registers

                            if col_num < n_cols - 1 then
                                col_num <= col_num + 1;
                                state <= shift1;

                                -- Set the next line to be read from the ram 
                                ram_read_addr <= std_logic_vector(unsigned(ram_read_addr) + 1);
                            else
                                state <= idle;
                            end if;

                    end case;
                end if;
            end if;
    end process;

end fast;