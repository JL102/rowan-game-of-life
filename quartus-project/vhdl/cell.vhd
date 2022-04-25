library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cell is
	port(
		clk : 		in std_logic;
		reset : 	in std_logic; -- Whether to reset to the starting state
		start_as : 	in std_logic; -- Starting state
		adj : 		in std_logic_vector(7 downto 0); -- Adjacent cells' states
		state: 		out std_logic -- Present state
	);
end cell;

architecture rtl of cell is
	
	-- component eight_bit_counter is
	-- 	port (bits : in std_logic_vector(7 downto 0);
	-- 		num : out unsigned(3 downto 0));
	-- end component;
	
	-- signal sum : unsigned (3 downto 0); -- number of bits that are '1' 000
begin	
	-- Counter : eight_bit_counter port map(adj, sum); -- Use the eight bit counter to identify the number of adjacent live cells
	
	process(clk)
	variable sum : unsigned(3 downto 0) := "0000";
	begin
		if rising_edge(clk) then
			sum := "0000";   --initialize count variable.
			for i in 0 to 7 loop   --check for all the bits.
				if(adj(i) = '1') then --check if the bit is '1'
					sum := sum + 1; --if its one, increment the count.
				end if;
			end loop;
			-- When the reset line is on, initialize the cell based on its "start_as" control line
			if reset = '1' then
				state <= start_as;
			-- When there are THREE adjacent live cells, become ALIVE no matter the present state
			elsif sum = "0011" then
				state <= '1';
			-- When there are BELOW 2 or ABOVE 3 adjacent live cells, become DEAD no matter the present state
			elsif sum /= "0010" then
				state <= '0';
			end if;
			-- In any other condition (EXACTLY 2 adjacent live cells), 
			-- 	dead cells stay dead and live cells stay alive (this is a no-op)
		end if;
	end process;
end rtl;