-- A parameterized, inferable, true dual-port, dual-clock block RAM in VHDL.
-- Modified from original: https://danstrother.com/2010/09/11/inferring-rams-in-fpgas/

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity dual_bram is
    generic (
        DATA_WIDTH : integer;
        ADDR_WIDTH : integer;
        INIT_FILE : string := ""
    );
    port (
        -- Port A
        a_clk   : in  std_logic;
        a_we    : in  std_logic;
        a_addr  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        a_din   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        a_dout  : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        
        -- Port B
        b_clk   : in  std_logic;
        b_we    : in  std_logic;
        b_addr  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        b_din   : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        b_dout  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end dual_bram;
 
architecture rtl of dual_bram is
    -- Shared memory
    type ram_type is array ((2**ADDR_WIDTH) - 1 downto 0 ) 
        of std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- The folowing code either initializes the memory values to a specified file or to all zeros to match hardware
    function initramfromfile (ramfilename : in string) return ram_type is
        file ramfile : text is in ramfilename;
        variable ramfileline : line;
        variable ram_name	: ram_type;
        variable bitvec : bit_vector(data_width - 1 downto 0);
    begin
        -- for i in ram_type'range loop
        for i in 0 to ram_type'length - 1 loop
            readline(ramfile, ramfileline);
            read(ramfileline, bitvec);
            ram_name(i) := to_stdlogicvector(bitvec);
        end loop;
        return ram_name;
    end function;

   function init_from_file_or_zeroes(ramfile : string) return ram_type is
   begin
       if ramfile'length = 0 then
            return (others => (others => '0'));
       else
           return InitRamFromFile(ramfile) ;
       end if;
   end;
   
   shared variable mem : ram_type := init_from_file_or_zeroes(INIT_FILE);
begin
 
-- Port A
process(a_clk)
begin
    if (rising_edge(a_clk)) then
        if (a_we='1') then
            mem(to_integer(unsigned(a_addr))) := a_din;
        end if;

        a_dout <= mem(to_integer(unsigned(a_addr)));
    end if;
end process;
 
-- Port B
process(b_clk)
begin
    if (rising_edge(b_clk)) then
        if (b_we='1') then
            mem(to_integer(unsigned(b_addr))) := b_din;
        end if;

        b_dout <= mem(to_integer(unsigned(b_addr)));
    end if;
end process;
 
end rtl;