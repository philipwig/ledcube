library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_contoller is
    generic(
        n_rows_max : integer;
        n_cols_max : integer;
        bitdepth_max : integer;
        lsb_blank_length_max : integer
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        -- Configuration values from the axi interface
        n_rows_config : in integer range 0 to n_rows_max;
        n_cols_config : in integer range 0 to n_cols_max;
        bitdepth_config : in integer range 0 to bitdepth_max;
        lsb_blank_length_config : in integer range 0 to lsb_blank_length_max;

        -- Current values from config to all the other modules, these have been latched/delayed correctly
        n_cols : out integer range 0 to n_cols_max;
        n_rows : out integer range 0 to n_rows_max;
        bitdepth : out integer range 0 to bitdepth_max;
        lsb_blank_length : out integer range 0 to lsb_blank_length_max;

        -- Which framebuffer to read from, 0 or 1, input only taken when starting bcm with bcm_go. Used in multiple modules
        display_buffer : out integer range 0 to 1; 

        -- bcm module contol
        bcm_go : out std_logic;
        bcm_done : in std_logic;
        display_row : out integer range 0 to n_rows_max;
        display_bit : out integer range 0 to bitdepth_max;

        -- blanking control
        blank_go : out std_logic;
        latch_rdy : in std_logic;

        -- Converter control
        convert_go : out std_logic;
        convert_done : in std_logic;

        -- Pattern generation control 
        pattern_go : out std_logic;
        pattern_done : in std_logic;
          
        -- Display output signal
        display_latch_out : out std_logic
    );

end entity display_contoller;


architecture rtl of display_contoller is
    type state_type is (startup, idle, latch, unlatch, wait_reset);
    signal state : state_type := startup;
    
    signal row_num : integer range 0 to n_rows_max - 1 := 0; -- The current row of the display
    signal bit_num : integer range 0 to bitdepth_max - 1 := 0; -- The current bit of BCM
    signal buffer_num : integer range 0 to 1 := 0;

    signal n_rows_internal : integer range 0 to n_rows_max;
    signal bitdepth_internal : integer range 0 to bitdepth_max;

    signal pattern_gen_sequence : std_logic := '0';

    constant timer_max : integer := 20;
    signal timer : integer range 0 to timer_max - 1 := 0;

begin
    display_row <= row_num;
    display_bit <= bit_num;
    display_buffer <= buffer_num;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                bcm_go <= '0';
                blank_go <= '0';
                display_latch_out <= '0';
                convert_go <= '0';
                
                state <= startup;
                row_num <= 0;
                bit_num <= 0;

            else
                -- "Default" values
                bcm_go <= '0';
                blank_go <= '0';
                convert_go <= '0';
                pattern_go <= '0';

                case state is
                    when startup =>
                        convert_go <= '1';

                        bcm_go <= '0';
                        blank_go <= '0';
                        display_latch_out <= '0';

                        state <= idle;

                    when idle =>
                        if latch_rdy = '1' and bcm_done = '1' then
                            -- Start latching
                            state <= latch;
                            

                        end if;

                    when latch =>                     
                        display_latch_out <= '1'; -- Latches the data into the output registers
                        state <= unlatch;

                    when unlatch => 
                        display_latch_out <= '0'; -- Stop latching the data into the output register

                        -- Go to the next buffer, row or bit
                        if row_num >= n_rows_internal - 1 and bit_num >= bitdepth_internal - 1 then
                            -- Finished with the entire display

                            -- Take the current values of the configuration registers
                            if n_rows_config > 0 then
                                n_rows <= n_rows_config;
                                n_rows_internal <= n_rows_config / 2; -- Divided by two for 1:32 display
                            else
                                n_rows <= n_rows_max;
                                n_rows_internal <= n_rows_max / 2; -- Divided by two for 1:32 display
                            end if;

                            if n_cols_config > 0 then
                                n_cols <= n_cols_config;
                            else
                                n_cols <= n_cols_max;
                            end if;

                            if bitdepth_config > 0 then
                                bitdepth <= bitdepth_config;
                                bitdepth_internal <= bitdepth_config;
                            else
                                bitdepth <= bitdepth_max;
                                bitdepth_internal <= bitdepth_max;
                            end if;

                            if lsb_blank_length_config > 0 then
                                lsb_blank_length <= lsb_blank_length_config;
                            else
                                lsb_blank_length <= lsb_blank_length_max;
                            end if;

                            -- Swap to the other display buffer
                            if buffer_num = 1 then 
                                buffer_num <= 0;
                            else 
                                buffer_num <= 1;
                            end if;

                            row_num <= 0;
                            bit_num <= 0;

                            pattern_go <= '1'; -- Start the pattern generator to write a new patternbuffer

                        elsif bit_num >= bitdepth_internal - 1 then 
                            -- Finished with all bits in a row so go to next row
                            row_num <= row_num + 1;
                            bit_num <= 0;
                        else
                            bit_num <= bit_num + 1;
                        end if;

                        blank_go <= '1'; -- Start the blanking counter
                        bcm_go <= '1'; -- Start the bcm shifting

                        state <= wait_reset;

                    when wait_reset =>
                        if latch_rdy = '0' and bcm_done = '0' then
                            state <= idle;
                        end if;
                end case;


                if pattern_done = '0' then
                    pattern_gen_sequence <= '1';
                elsif pattern_gen_sequence = '1' and pattern_done = '1' then
                    convert_go <= '1';
                    pattern_gen_sequence <= '0';
                end if;

            end if;

        end if;

    end process;

end architecture rtl;