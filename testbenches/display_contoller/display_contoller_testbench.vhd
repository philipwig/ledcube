library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_contoller_testbench is
end entity display_contoller_testbench;

architecture tb of display_contoller_testbench is
    constant n_rows : integer := 32;
    constant n_cols : integer := 64;
    constant bitdepth : integer := 8;
    constant T : time := 20 ns;    

    signal clk : std_logic := '1';
    signal rst : std_logic;

    -- Which framebuffer to read from
    signal display_buffer : integer range 0 to 1; 

    -- bcm module contol
    signal bcm_go : std_logic;
    signal bcm_done : std_logic;
    signal display_row : integer range 0 to n_rows - 1;
    signal display_bit : integer range 0 to bitdepth - 1;

    -- blanking control
    signal blank_go : std_logic;
    signal latch_rdy : std_logic;
    
    -- Converter control
    signal convert_go : std_logic;
    signal convert_done : std_logic;

    -- Pattern generation control 
    signal pattern_go : std_logic;
    signal pattern_done : std_logic;
          
    -- Display output signal
    signal display_latch_out : std_logic;

begin
    
    display_contoller_unit : entity work.display_contoller
        generic map (n_rows => n_rows,
                     n_cols => n_cols,
                     bitdepth => bitdepth)
        port map (clk => clk,
                  rst => rst,
                  
                  -- current framebuffer
                  display_buffer => display_buffer,
          
                  -- bcm module contol
                  bcm_go => bcm_go,
                  bcm_done => bcm_done,
                  display_row => display_row,
                  display_bit => display_bit,

                  -- blanking control
                  blank_go => blank_go,
                  latch_rdy => latch_rdy,

                  -- Converter contol
                  convert_go => convert_go,
                  convert_done => convert_done,

                  -- Pattern generation contol
                  pattern_go => pattern_go,
                  pattern_done => pattern_done,
                
                  -- Display output signal
                  display_latch_out => display_latch_out);
    
    clk <= not clk after T/2;

    process
    begin
        rst <= '1';
        wait for T;         
        rst <= '0';
        wait for 4*T;

        loop
            latch_rdy <= '1';
            bcm_done <= '1';
            wait for T;
            latch_rdy <= '0';
            bcm_done <= '0';
            
            wait until display_latch_out = '1';
            wait until display_latch_out = '0';

            wait for 4*T;
            convert_done <= '1';
            wait for T;
            convert_done <= '0';

            wait for 16*T;

        end loop;

    end process;
end tb;