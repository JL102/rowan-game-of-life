library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Adjacent cells: (possibly up for modification)
--- 7	6	5
--- 0		4
---	1	2	3

-- Border Cells (Edge Case 1):
--- |	4	3
---	|	X	2
---	|	0	1	 

-- Corner Cells (Edge Case 2):
--- _	_	_
---	|	X	2
---	|	0	1	

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
	
	
	component flipflop is
		port (Clk, D : in std_logic;
		Q : out std_logic);
	end component;
	
	signal D, Q : std_logic; -- D flip flop i/o
	signal sum : std_logic_vector (2 downto 0); -- number of bits that are '1' 000
begin
	state <= Q; 	-- Output the state from the DFF
	
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				Q <= start_as;
			else 
				-- this is where all the magic will happen
				-- Use counter to implement each state?
				-- any live cell with two or three neighbors survive
				if(state = 1 && (sum = 2 || sum = 3)) then
					Q <= 1;
				-- Any dead cell with 3 live neighbors becomes alive
				elsif(state = 0 && sum = 3) then
					Q <= 1;
				-- Otherwise set as dead
				else
					Q <= 0;
				end if;
			end if;
		end if;
		state <= Q;
	end process;
end rtl;