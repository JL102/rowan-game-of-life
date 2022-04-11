library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Adjacent cells: (possibly up for modification)
--- 7	6	5
--- 0		4
---	1	2	3
-- Alternative:
--- 0   1   2
--- 7       3
--- 6   5   4

entity block_of_four is
	port(
		clk : 		in std_logic;
		reset : 	in std_logic; -- Whether to reset to the starting state
		start_as : 	in std_logic_vector(15 downto 0); -- Starting state
		adj : 		in std_logic_vector(7 downto 0); -- Adjacent cells' states
		states: 	out std_logic_vector(15 downto 0) -- Present state
	);
end block_of_four;

architecture rtl of block_of_four is
	
	component cell is
		port(clk : 		in std_logic;
			reset : 	in std_logic;
			start_as : 	in std_logic;
			adj : 		in std_logic_vector(7 downto 0);
			state: 		out std_logic);
	end component;
begin
	
	gen_cells : 
	for row in 0 to 3 generate
	begin
		gen_row : 
		for col in 0 to 3 generate
		begin
			gen_cell : cell port map (
				clk, reset, 
				start_as(row * 4 + col)
			);
		end generate;
	end generate;
	
	
	
end rtl;