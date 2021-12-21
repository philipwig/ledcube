library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real."**";


entity display_blanking is
    generic (bitdepth : integer;
             lsb_blank_length : integer);
    port (clk : in std_logic;
          rst : in std_logic;
          
          -- Contol signals
          blank_go : in std_logic;
          latch_rdy : out std_logic;

          -- Display output signal
          display_blank_out : out std_logic);

end entity display_blanking;

architecture fast of display_blanking is
    signal blank_timer : integer range 0 to ((2 ** (bitdepth - 1)) * lsb_blank_length) := 1; --Change to an accurate upperbound value. Depends on the length of the string of led and the bit depth. max is 2^(bitdepth - 1) * lsb_blank_length

begin
    process (clk)
        variable bit_num : integer range 1 to (2 ** (bitdepth - 1)) := 1; -- tracks the index of the bit of the BCM. 0 is first bit, 1 is next one, etc. max is 2^(bitdepth - 1)
    
    begin
        if rising_edge(clk) then
            if rst = '1' then
                bit_num := 1;
                blank_timer <= 1;

                latch_rdy <= '0';
                display_blank_out <= '1'; -- Display off

            elsif blank_go = '1' and blank_timer = 0 then
                if bit_num = (2 ** (bitdepth - 1)) then
                    bit_num := 1;
                else
                    bit_num := to_integer(shift_left(to_unsigned(bit_num, 8), 1));
                end if;

                blank_timer <= bit_num * lsb_blank_length; --Increment this by 2^x to get required timing

            else
                if blank_timer /= 0 then
                    blank_timer <= blank_timer - 1;
                    latch_rdy <= '0';
                    display_blank_out <= '0'; -- Display on
                else
                    latch_rdy <= '1';
                    display_blank_out <= '1'; -- Display off
                end if;
            end if;
        end if;
    end process;


end fast;