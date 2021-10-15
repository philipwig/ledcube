library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity simple_bram is
    generic(
        addr_width : integer;
        data_width : integer;
        c_init_file : string
    );
    port (
        write_clk : in std_logic;
        write_en : in std_logic;
        write_addr : in std_logic_vector(addr_width - 1 downto 0);
        write_data : in std_logic_vector(data_width - 1 downto 0);
        
        read_clk : in std_logic;
        read_addr : in std_logic_vector(addr_width - 1 downto 0);
        read_data : out std_logic_vector(data_width - 1 downto 0)
    );
end simple_bram;

architecture Behavioral of simple_bram is
    type ram_type is array (2 ** addr_width - 1 downto 0)
        of std_logic_vector (data_width - 1 downto 0);
    
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

    -- constant C_INIT_FILE : string := "initialization.coe"; -- Specify name/location of RAM initialization file if using one (leave blank if not)


    signal ram : ram_type := init_from_file_or_zeroes(c_init_file);
    -- signal ram : ram_type;
    signal addr_reg : std_logic_vector(addr_width - 1 downto 0);

begin
    process (write_clk)
    begin
        if rising_edge(write_clk) then
            if (write_en = '1') then
                ram(to_integer(unsigned(write_addr))) <= write_data;
            end if;
         end if;
     end process;
     
    process (read_clk)
    begin
        if rising_edge(read_clk) then
            addr_reg <= read_addr;
         end if;
     end process;
         
     read_data <= ram(to_integer(unsigned(addr_reg)));

end Behavioral;
