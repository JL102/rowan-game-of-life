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
	clk <= not clk after 5 ns;
	
	-- start_as(0) <= ('0', '1', '0', '0', '0', '0');
	-- Apply stimulus and check the results
	process
	begin
		reset <= '1';
		-- Glider from playgameoflife.com
		start_as(2, 1) <= '1';
		start_as(3, 2) <= '1';
		start_as(1, 3) <= '1';
		start_as(2, 3) <= '1';
		start_as(3, 3) <= '1';
		
		
		wait for 10 ns;
		reset <= '0';
		
		wait for 200 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell_simulation
	port map(
		clk, reset, start_as, states
		-- , sum --debugging
	);
end tb;
