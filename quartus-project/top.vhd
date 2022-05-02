library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_types.all;

-- Quartus  fitter was whining at me, so I'm making a TLE which contains the TimingAnalyzer
entity top is 
	port (
		clock : in std_logic;
		LEDR  :out std_logic_vector(9 downto 0)
	);
end top;

architecture rtl of top is
	component cell_simulation is 
		port(
			clk 				:	in std_logic;
			reset 			: 	in std_logic;
			start_as_arr	:	in array_states;
			enable			:	in std_logic;
			clk_div_ctrl	:	in unsigned(2 downto 0);
			 states 			: 	inout array_states
		);
	end component;
	signal reset, enable : std_logic;
	signal states : array_states;
	signal start_as : array_states := (others => (others => '0')); -- Initialize most of start_as as 0 so I can pick which ones to turn on
	signal clk_div_ctrl : unsigned(2 downto 0) := "000";
begin

		
		start_as(27, 2) <= '1';
		start_as(25, 3) <= '1';
		start_as(27, 3) <= '1';
		start_as(15, 4) <= '1';
		start_as(16, 4) <= '1';
		start_as(23, 4) <= '1';
		start_as(24, 4) <= '1';
		start_as(37, 4) <= '1';
		start_as(38, 4) <= '1';
		start_as(14, 5) <= '1';
		start_as(18, 5) <= '1';
		start_as(23, 5) <= '1';
		start_as(24, 5) <= '1';
		start_as(37, 5) <= '1';
		start_as(38, 5) <= '1';
		start_as(3, 6) <= '1';
		start_as(4, 6) <= '1';
		start_as(13, 6) <= '1';
		start_as(19, 6) <= '1';
		start_as(23, 6) <= '1';
		start_as(24, 6) <= '1';
		start_as(3, 7) <= '1';
		start_as(4, 7) <= '1';
		start_as(13, 7) <= '1';
		start_as(17, 7) <= '1';
		start_as(19, 7) <= '1';
		start_as(20, 7) <= '1';
		start_as(25, 7) <= '1';
		start_as(27, 7) <= '1';
		start_as(13, 8) <= '1';
		start_as(19, 8) <= '1';
		start_as(27, 8) <= '1';
		start_as(14, 9) <= '1';
		start_as(18, 9) <= '1';
		start_as(15, 10) <= '1';
		start_as(16, 10) <= '1';

	TA : cell_simulation port map (clock, reset, start_as, enable, clk_div_ctrl, states);
	LEDR(0) <= states(27,2);
end rtl;