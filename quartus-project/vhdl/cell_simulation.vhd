library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_types.all; -- see package_types.vhd

-- Adjacent cells: (possibly up for modification)
--- 7	6	5
--- 0		4
---	1	2	3

entity cell_simulation is
	port(
		clk 			:	in std_logic;
		reset 			: 	in std_logic; -- Whether to reset to the starting state
		start_as_arr	:	in array_states;
		enable			:	in std_logic;
		clk_div_ctrl	:	in unsigned(2 downto 0);
	    states 			: 	inout array_states
	);
end cell_simulation;

architecture rtl of cell_simulation is
	
	component cell is
		port(clk 			:	in 	std_logic;
			reset 			: 	in 	std_logic;
			start_as 		: 	in 	std_logic;
			enable			:	in 	std_logic;
			adj 			: 	in 	std_logic_vector(7 downto 0);
			clk_div_ctrl	:	in unsigned(2 downto 0);
			state			:	out std_logic);
	end component;
	
	-- signal states : array_states;
begin
	
	-- Using for-generate, loop through each cell, by row and column, and generate the cell depending on its position.
	gen_rows :
	for row in 0 to MAX_ROW generate
	begin
		gen_cols :
		for col in 0 to MAX_COL generate
		begin
			-- top left corner
			gen_if1 : if row = 0 and col = 0 generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => '0', adj(1) => '0',				  adj(2) => '0',
					adj(3) => '0',								  adj(4) => states(row,   col+1),
					adj(5) => '0', adj(6) => states(row+1, col),  adj(7) => states(row+1, col+1),
					state => states(row, col)
				);
			end generate gen_if1;
			-- top right corner
			gen_if2 : if row = 0 and col = MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => '0', 					adj(1) => '0', 				  adj(2) => '0',
					adj(3) => states(row,   col-1),								  adj(4) => '0',
					adj(5) => states(row+1, col-1), adj(6) => states(row+1, col), adj(7) => '0',
					state => states(row,   col)
				);
			end generate gen_if2;
			-- bottom left corner
			gen_if3 : if row = MAX_ROW and col = 0 generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => '0', adj(1) => states(row-1, col), 	adj(2) => states(row-1, col+1),
					adj(3) => '0',								  	adj(4) => states(row,   col+1),
					adj(5) => '0', adj(6) => '0',					adj(7) => '0',
					state => states(row,   col)
				);
			end generate gen_if3;
			-- bottom right corner
			gen_if4 : if row = MAX_ROW and col = MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => states(row-1, col-1), adj(1) => states(row-1, col), adj(2) => '0',
					adj(3) => states(row,   col-1),								  adj(4) => '0',
					adj(5) => '0', adj(6) => '0', adj(7) => '0',
					state => states(row,   col)
				);
			end generate gen_if4;
			-- top edge
			gen_if5 : if row = 0 and row < MAX_ROW and col > 0 and col < MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => '0', adj(1) => '0', adj(2) => '0',
					adj(3) => states(row,   col-1),								  adj(4) => states(row,   col+1),
					adj(5) => states(row+1, col-1), adj(6) => states(row+1, col), adj(7) => states(row+1, col+1),
					state => states(row,   col)
				);
			end generate gen_if5;
			-- bottom edge
			gen_if6 : if row = MAX_ROW and col > 0 and col < MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => states(row-1, col-1), adj(1) => states(row-1, col), adj(2) => states(row-1, col+1),
					adj(3) => states(row,   col-1),								  adj(4) => states(row,   col+1),
					adj(5) => '0', 					adj(6) => '0', 				  adj(7) => '0',
					state => states(row,   col)
				);
			end generate gen_if6;
			-- left edge
			gen_if7 : if row > 0 and row < MAX_ROW and col = 0 generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => '0', adj(1) => states(row-1, col), adj(2) => states(row-1, col+1),
					adj(3) => '0',								 adj(4) => states(row,   col+1),
					adj(5) => '0', adj(6) => states(row+1, col), adj(7) => states(row+1, col+1),
					state => states(row,   col)
				);
			end generate gen_if7;
			-- right edge
			gen_if8 : if row > 0 and row < MAX_ROW and col = MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => states(row-1, col-1), adj(1) => states(row-1, col), adj(2) => '0',
					adj(3) => states(row,   col-1),								  adj(4) => '0',
					adj(5) => states(row+1, col-1), adj(6) => states(row+1, col), adj(7) => '0',
					state => states(row,   col)
				);
			end generate gen_if8;
			
			-- center of the grid
			gen_if9 : if row > 0 and row < MAX_ROW and col > 0 and col < MAX_COL generate
				gen_cell : cell port map (
					clk => clk, reset => reset, enable => enable,
					clk_div_ctrl => clk_div_ctrl,
					start_as => start_as_arr(row, col),
					adj(0) => states(row-1, col-1), adj(1) => states(row-1, col), adj(2) => states(row-1, col+1),
					adj(3) => states(row,   col-1),								  adj(4) => states(row,   col+1),
					adj(5) => states(row+1, col-1), adj(6) => states(row+1, col), adj(7) => states(row+1, col+1),
					state => states(row,   col)
				);
			end generate gen_if9;
			-- JL note: Can't use "&" in port map because ModelSim doesn't understand it.
		end generate;
	end generate;
	
end rtl;