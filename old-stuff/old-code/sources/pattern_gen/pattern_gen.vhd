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
    
    -- For the base pattern generator
    type state_type is (erase_pixels, write_pixels);
    signal state : state_type := erase_pixels;

    signal generating_pattern : std_logic := '1';

    signal current_row : integer range 0 to n_rows - 1 :=  n_rows - 1;
    signal current_col : integer range 0 to n_cols - 1 := n_cols - 1;


    -- Square outline pattern
    constant square_outline_display_frames : integer := 9;
    constant square_outline_animation_frames: integer := 64*4;

    signal top_line : integer range 0 to n_rows - 1 := n_rows / 2 - 1;
    signal bottom_line : integer range 0 to n_rows - 1 := n_rows / 2;
    signal left_line : integer range 0 to n_cols - 1 := n_cols / 2 - 1;
    signal right_line : integer range 0 to n_cols - 1 := n_cols / 2;

    type direction_type is (into, outof);
    signal square_direction : direction_type := into;
    
    signal corner_filled : boolean := true;
    signal head_pixel_col : integer range 0 to n_cols - 1 := n_cols / 2 - 1;
    signal head_pixel_row : integer range 0 to n_rows - 1 := n_rows / 2 - 1;

    constant head_color : std_logic_vector(23 downto 0) := x"FFFFFF";
    constant fill_color : std_logic_vector(23 downto 0) := x"0000FF";
    constant background_color : std_logic_vector(23 downto 0) := x"000000";


    -- Colored noise pattern
    constant colored_noise_display_frames : integer := 9;
    constant colored_noise_animation_frames : integer := 300;

    signal rand_pixel_on : std_logic_vector(31 downto 0);
    signal rand_pixel_color : std_logic_vector(31 downto 0);

    -- maximal length 32-bit xnor LFSR based on xilinx app note XAPP210
    function lfsr32(x : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return x(30 downto 0) & (x(0) xnor x(1) xnor x(21) xnor x(31));
    end function;


    -- Spiral pattern
    constant spiral_display_frames : integer := 1;
    constant spiral_animation_frames : integer := 64 * 64 - 4;

    -- Define pattern type and current pattern
    type pattern_type is (square_outline, colored_noise, spiral);--, filled_square, scanning_dot);
    signal current_pattern : pattern_type := spiral;

    -- The needed values can be calculated using the equations below, all you need to know is the number of frames an animation takes to complete
    -- display_refresh_rate / (n_animation_frames * animations_per_second) = n_display_frames or
    -- display_refresh_rate / (n_animation_frames / seconds_per_animation) = n_display_frames
    constant max_display_frames : integer := 20;
    signal n_display_frames : integer range 0 to max_display_frames - 1 := spiral_display_frames; -- This is the number of display frames for every animation frame
    signal current_display_frame : integer range 0 to max_display_frames - 1 := 0;

    constant max_animation_frames : integer := 8192;
    signal n_animation_frames : integer range 0 to max_animation_frames - 1 := spiral_animation_frames; -- This is the number of total animation frames
    signal current_animation_frame : integer range 0 to max_animation_frames - 1 := 0;

    
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if rst = '1' then
                mem_write_addr <= (others => '0');
                mem_write_data <= (others => '0');
                mem_write_en <= '0';
                generating_pattern <= '0';
            else
                if pattern_go = '1' and generating_pattern = '0' then
                    if current_animation_frame = n_animation_frames - 1 and current_display_frame = n_display_frames - 1 then
                        case current_pattern is
                            when square_outline =>
                                current_pattern <= colored_noise;
                                n_animation_frames <= colored_noise_animation_frames;
                                n_display_frames <= colored_noise_display_frames;

                            when colored_noise =>
                                current_pattern <= spiral;
                                n_animation_frames <= spiral_animation_frames;
                                n_display_frames <= spiral_display_frames;
                                top_line <= n_rows / 2 - 1;
                                bottom_line <= n_rows / 2;
                                left_line <= n_cols / 2 - 1;
                                right_line <= n_cols / 2;
            
                                head_pixel_row <= n_rows / 2 - 1;
                                head_pixel_col <= n_cols / 2 - 1;

                            when spiral => 
                                current_pattern <= square_outline;
                                n_animation_frames <= square_outline_animation_frames;
                                n_display_frames <= square_outline_display_frames;
                                left_line <= 0;
                                top_line <= 0;
                                square_direction <= into;

                        end case;                        
                        
                        generating_pattern <= '1';
                        current_animation_frame <= 0;
                        current_display_frame <= 0;
                    elsif current_display_frame = n_display_frames - 1 then
                        generating_pattern <= '1';
                        current_animation_frame <= current_animation_frame + 1;
                        current_display_frame <= 0;
                    else
                        current_display_frame <= current_display_frame + 1;
                    end if;

                elsif pattern_go = '0' and generating_pattern = '1' then
                        if current_row = n_rows - 1 and current_col = n_cols - 1 then
                            -- Done generating pattern
                            current_row <= 0;
                            current_col <= 0;

                        elsif current_col = n_cols - 1 then
                            -- Go to next row
                            current_row <= current_row + 1;
                            current_col <= 0;
                        else 
                            -- Go to next col
                            current_col <= current_col + 1;
                        end if;

                        -- Determines whether to erase or write pixels and what pattern to write them with
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

                                    case current_pattern is
                                        when spiral =>
                                            if head_pixel_col = 0 and head_pixel_row = 0 then -- Reached the end of the spiral, go back to beginning
                                                -- Initial Conditions
                                                top_line <= n_rows / 2 - 1;
                                                bottom_line <= n_rows / 2;
                                                left_line <= n_cols / 2 - 1;
                                                right_line <= n_cols / 2;
                            
                                                head_pixel_row <= n_rows / 2 - 1;
                                                head_pixel_col <= n_cols / 2 - 1;
                            
                                                corner_filled <= true; -- Whether the corner state is a filled square or not                                               
                                            elsif head_pixel_col = left_line and head_pixel_row = top_line then --Head pixel in top left corner
                                                if corner_filled then
                                                    top_line <= top_line - 1;
                                                    head_pixel_row <= head_pixel_row - 1;
                                                    corner_filled <= false;
                                                else
                                                    head_pixel_col <= head_pixel_col + 1;
                                                    corner_filled <= true;
                                                end if;
                                            elsif head_pixel_col = right_line and head_pixel_row = top_line then -- Head pixel is in top right corner
                                                if corner_filled then
                                                    right_line <= right_line + 1;
                                                    head_pixel_col <= head_pixel_col + 1;
                                                    corner_filled <= false;
                                                else
                                                    head_pixel_row <= head_pixel_row + 1;
                                                    corner_filled <= true;
                                                end if;
                                            elsif head_pixel_col = right_line and head_pixel_row = bottom_line then -- Head pixel is in bottom right corner
                                                if corner_filled then
                                                    bottom_line <= bottom_line + 1;
                                                    head_pixel_row <= head_pixel_row + 1;
                                                    corner_filled <= false;
                                                else
                                                    head_pixel_col <= head_pixel_col - 1;
                                                    corner_filled <= true;
                                                end if;
                                            elsif head_pixel_col = left_line and head_pixel_row = bottom_line then -- Head pixel is in bottom left corner
                                                if corner_filled then
                                                    left_line <= left_line - 1;
                                                    head_pixel_col <= head_pixel_col - 1;
                                                    corner_filled <= false;
                                                else
                                                    head_pixel_row <= head_pixel_row - 1;
                                                    corner_filled <= true;
                                                end if;
                                            else -- Head pixel is not in a corner, its along side
                                                if head_pixel_row = top_line then
                                                    head_pixel_col <= head_pixel_col + 1;
                                                elsif head_pixel_row = bottom_line then
                                                    head_pixel_col <= head_pixel_col - 1;
                                                elsif head_pixel_col = left_line then
                                                    head_pixel_row <= head_pixel_row - 1;
                                                elsif head_pixel_col = right_line then
                                                    head_pixel_row <= head_pixel_row + 1;
                                                end if;
                                            end if;

                                        when square_outline =>
                                            if left_line = 0 and square_direction = outof then -- Finished going out, switch to going in
                                                square_direction <= into;
                                                left_line <= left_line + 1;
                                                top_line <= top_line + 1;
                                            elsif left_line = n_cols / 2 - 1 and square_direction = into then -- Finished going into, switch to going out
                                                square_direction <= outof;
                                                left_line <= left_line - 1;
                                                top_line <= top_line - 1;
                                            elsif square_direction = into then -- Going into middle
                                                left_line <= left_line + 1;
                                                top_line <= top_line + 1;
                                            elsif square_direction = outof then -- Going outside
                                                left_line <= left_line - 1;
                                                top_line <= top_line - 1;
                                            end if;

                                        when colored_noise =>
                                            
                                        end case;
                                end if;

                                case current_pattern is
                                    when square_outline =>
                                        if current_col > left_line and current_col < n_cols - left_line - 1 then
                                            if current_row = top_line or current_row = n_rows - top_line - 1 then
                                                mem_write_data <= x"00FF00"; -- Draw top and bottom lines of square
                                            else
                                                mem_write_data <= x"000000";
                                            end if;
                                        elsif current_row >= top_line and current_row <= n_rows - top_line - 1 then
                                            if current_col = left_line or current_col = n_cols - left_line - 1 then
                                                mem_write_data <= x"00FF00"; -- Draw left and right lines of square
                                            else
                                                mem_write_data <= x"000000";
                                            end if;
                                        else
                                            mem_write_data <= x"000000"; -- Fill in other pixels with blue
                                        end if;
                            
                                    when colored_noise =>
                                        rand_pixel_color <= lfsr32(rand_pixel_color);
                                        
                                        if current_col = 0 then
                                            rand_pixel_on <= lfsr32(rand_pixel_on);
                                        end if;
                                        
                                        if rand_pixel_color(3 downto 0) = rand_pixel_on(3 downto 0) then
                                            mem_write_data <= "00" & rand_pixel_color(17 downto 12) & "00" & rand_pixel_color(11 downto 6) & "00" & rand_pixel_color(5 downto 0);-- Remember to make generic for any size of mem_write_data
                                        else
                                            mem_write_data <= x"000000";
                                        end if;
                                                                
                                    when spiral =>
                                        if current_col >= left_line and current_col <= right_line and current_row >= top_line and current_row <= bottom_line then
                                            if (head_pixel_col = left_line and head_pixel_row = bottom_line) or (head_pixel_col = right_line and head_pixel_row = top_line) then -- Head pixel is in bottom left or top right corner
                                                if corner_filled then -- This is a filled in square
                                                    if current_col = head_pixel_col and current_row = head_pixel_row then
                                                        mem_write_data <= head_color;
                                                    else
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                else
                                                    if current_col = head_pixel_col then
                                                        if current_row = head_pixel_row then -- Current is the head pixel
                                                            mem_write_data <= head_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;
                                                    else
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                end if;
                                                
                                            elsif (head_pixel_col = left_line and head_pixel_row = top_line) or (head_pixel_col = right_line and head_pixel_row = bottom_line) then -- Head pixel is in top left or botom right corner
                                                if corner_filled then -- This is a filled in square
                                                    if current_col = head_pixel_col and current_row = head_pixel_row then
                                                        mem_write_data <= head_color;
                                                    else
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                else
                                                    if current_row = head_pixel_row then
                                                        if current_col = head_pixel_col then
                                                            mem_write_data <= head_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;                                 
                                                    else
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                end if;
                                            else -- Head pixel is not at a corner
                                                if head_pixel_col = left_line then -- Head pixel is on the left line
                                                    if current_col = left_line then
                                                        if current_row = head_pixel_row then
                                                            mem_write_data <= head_color;
                                                        elsif current_row > head_pixel_row then
                                                            mem_write_data <= fill_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;
                                                    else -- Everything to the right of the left line
                                                        mem_write_data <= fill_color;
                                                    end if;
                            
                                                elsif head_pixel_col = right_line then -- Head pixel is on the right line
                                                    if current_col = right_line then
                                                        if current_row = head_pixel_row then
                                                            mem_write_data <= head_color;
                                                        elsif current_row < head_pixel_row then
                                                            mem_write_data <= fill_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;
                                                    else -- Everything to the left of the right line
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                    
                                                elsif head_pixel_row = top_line then -- Head pixel is on the top line
                                                    if current_row = top_line then
                                                        if current_col = head_pixel_col then
                                                            mem_write_data <= head_color;
                                                        elsif current_col < head_pixel_col then
                                                            mem_write_data <= fill_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;
                                                    else -- Everything to the left of the right line
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                    
                                                elsif head_pixel_row = bottom_line then -- Head pixel is on the bottom line
                                                    if current_row = bottom_line then
                                                        if current_col = head_pixel_col then
                                                            mem_write_data <= head_color;
                                                        elsif current_col > head_pixel_col then
                                                            mem_write_data <= fill_color;
                                                        else
                                                            mem_write_data <= background_color;
                                                        end if;
                                                    else -- Everything to the left of the right line
                                                        mem_write_data <= fill_color;
                                                    end if;
                                                end if;
                                                -- else
                                                --     print("HELP")
                                            end if;
                                        else
                                            mem_write_data <= background_color;
                                        end if;
                                end case;
                        end case;
                    
                        mem_write_addr <= std_logic_vector(to_unsigned( (n_cols * current_row) + current_col, mem_write_addr'length) );
                        mem_write_en <= '1';
                else 
                    mem_write_en <= '0';
                end if;
            end if;
        end if;
    end process;

    pattern_done <= not generating_pattern;



end architecture cool;
