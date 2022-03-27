library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cell_testbench is -- A testbench usually has no ports
end cell_testbench;

architecture tb of cell_testbench is
	signal clk : std_logic := '0'; -- Must initialize!
	-- One signal per port is typical
	signal reset, start_as : std_logic;
	signal state : std_logic;
	signal adjacents : std_logic_vector(7 downto 0);
begin
	clk <= not clk after 5 ns;
	-- Apply stimulus and check the results
	process
		begin
		reset <= '1';
		start_as <= '0';
		wait for 40 ns;
		reset <= '0';
		wait for 40 ns;
		reset <= '1';
		start_as <= '1';
		wait for 40 ns;
		reset <= '0';
		wait for 40 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell
	port map(
		clk, reset, start_as, adjacents, state
	);
end tb;
