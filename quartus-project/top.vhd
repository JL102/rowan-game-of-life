library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.package_types.all;

-- Quartus  fitter was whining at me, so I'm making a TLE which contains the TimingAnalyzer
entity top is 
	port (
		clock : in std_logic
	);
end top;

architecture rtl of top is
	component cell_simulation is 
		port(
			clk : 		in std_logic;
			reset : 	in std_logic; -- Whether to reset to the starting state
			start_as :  in array_states;
			states : 	out array_states
		);
	end component;
	signal reset : std_logic;
	signal states : array_states;
	signal start_as : array_states := (others => (others => '0')); -- Initialize most of start_as as 0 so I can pick which ones to turn on
begin
	TA : cell_simulation port map (clock, reset, start_as, states);
end rtl;