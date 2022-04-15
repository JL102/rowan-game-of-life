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
	signal A, B :  unsigned(127 downto 0);
	signal C :     unsigned(31 downto 0);
	signal sum :   unsigned(159 downto 0);
begin
	TA : cell_simulation port map (clock, reset, start_as, states);
end rtl;