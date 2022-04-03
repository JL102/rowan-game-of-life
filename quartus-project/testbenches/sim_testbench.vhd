library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.package_types.all; -- see package_types.vhd


entity sim_testbench is -- A testbench usually has no ports
end sim_testbench;

architecture tb of sim_testbench is
	signal clk : std_logic := '0'; -- Must initialize!
	-- One signal per port is typical
	signal reset : std_logic;
	signal states : array_states;
	signal start_as : array_states;
	-- signal state : std_logic;
	-- signal adjacents : std_logic_vector(7 downto 0);
	-- signal sum : std_logic_vector(3 downto 0);
begin
	clk <= not clk after 5 ns;
	-- Apply stimulus and check the results
	process
	begin
		wait for 40 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell_simulation
	port map(
		clk, reset, start_as, states
		-- , sum --debugging
	);
end tb;
