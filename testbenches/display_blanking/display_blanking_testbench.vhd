library ieee;
use ieee.std_logic_1164.all;

entity blanking_testbench is
end blanking_testbench;

architecture tb of blanking_testbench is
    signal clk : std_logic := '1';
    signal rst : std_logic := '0';
    signal blank_go : std_logic := '0';

    signal latch_rdy : std_logic := '0';
    signal display_blank_out : std_logic := '0';

    constant T : time := 40 ns;

    signal bit_num_vector : std_logic_vector(7 downto 0);

begin
    display_blanking_unit : entity work.display_blanking
        generic map (bitdepth => 8)
        port map (clk => clk,
                  rst => rst,
                  blank_go => blank_go,
                  latch_rdy => latch_rdy,
                  display_blank_out => display_blank_out);

    clk <= not clk after T/2;
    rst <= '1', '0' after T;

    process
    begin
        -- No delay after latch_rdy
        wait until latch_rdy = '1';
        blank_go <= '1';
        wait for T;
        blank_go <= '0';

        -- Small half cycle delay
        wait until latch_rdy = '1';
        wait for 3*T;
        blank_go <= '1';
        wait for T;
        blank_go <= '0';

        -- Medium sized delay
        wait until latch_rdy = '1';
        wait for 4*T;
        blank_go <= '1';
        wait for T;
        blank_go <= '0';

        -- Large delay
        wait until latch_rdy = '1';
        wait for 20*T;
        blank_go <= '1';
        wait for T;
        blank_go <= '0';

        -- Not waiting for latch_rdt
        wait for 4*T;
        blank_go <= '1';
        wait for T;
        blank_go <= '0';

        -- Constant blank_go
        -- wait for T;
        -- blank_go <= '1';

    end process;
end tb;

