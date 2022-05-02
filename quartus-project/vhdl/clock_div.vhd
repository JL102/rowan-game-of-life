library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- author: Ryan Oliver
-- version: 4.18.22

entity clock_div is
    port(
        -- ~25 MHz clock
        clk     :   in  std_logic;
        enable  :   in  std_logic;
        reset   :   in  std_logic;

        -- 3 switches that allow user to change the amount
        -- the clock is being divided at
        -- The higher the value, the slower the simulation
        -- goes (ie. divide by 8^0, 8^1, 8^2... etc)
        control :   in  unsigned(2 downto 0);

        -- single bit to turn clk on or off
        clk_out :   out std_logic
		; count : inout unsigned(20 downto 0) -- for debugging
    );
end clock_div;

architecture rtl of clock_div is
    -- counter
    -- signal count    :   unsigned(20 downto 0);
begin
    process(clk, control)
    begin
        if enable = '1' then  
            if reset = '1' then
                count <= "000000000000000000000";	  -- 0000 0000 0000 0000 0001
            elsif rising_edge(clk) then
                count <= count + 1;
                -- divide by what is set by the control
                -- with count select clk_out <= 
                --     clk       when  "000",
                --     count(2)  when  "001",
                --     count(5)  when  "010",
                --     count(8)  when  "011",
                --     count(11) when  "100",
                --     count(14) when  "101",
                --     count(17) when  "110",
                --     count(20) when  "111";
            end if;
        end if;
    end process;
	
	process(clk)
	begin
		case(control) is
			when "000" => clk_out <= clk; -- it's divided by 2 but for some reason, I ca't assign it <= clk.
			when "001" => clk_out <= count(2);
			when "010" => clk_out <= count(5);
			when "011" => clk_out <= count(8);
			when "100" => clk_out <= count(11);
			when "101" => clk_out <= count(14);
			when "110" => clk_out <= count(17);
			when "111" => clk_out <= count(20);
			when others => clk_out <= '-';
		end case ;
	end process;
end rtl ; -- rtl