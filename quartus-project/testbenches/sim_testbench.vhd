library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_types.all; -- see package_types.vhd


entity sim_testbench is -- A testbench usually has no ports
end sim_testbench;

architecture tb of sim_testbench is
	signal clk : std_logic := '0'; -- Must initialize!
	-- One signal per port is typical
	signal reset : std_logic;
	signal states : array_states;
	signal start_as : array_states := (others => (others => '0')); -- Initialize most of start_as as 0 so I can pick which ones to turn on
	-- signal state : std_logic;
	-- signal adjacents : std_logic_vector(7 downto 0);
	-- signal sum : std_logic_vector(3 downto 0);
begin
	clk <= not clk after 1 ns;
	
	-- start_as(0) <= ('0', '1', '0', '0', '0', '0');
	-- Apply stimulus and check the results
	process
	begin
		reset <= '1';
		-- Use roms/makerom.js to get testbench code from an image
		
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
		
		
		wait for 10 ns;
		reset <= '0';
		
		wait for 3000 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell_simulation
	port map(
		clk, reset, start_as, states
	);
end tb;
