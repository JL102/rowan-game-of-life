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
	signal sum : std_logic_vector(3 downto 0);
	signal enable : std_logic := '1';
	signal clk_div_ctrl : unsigned(2 downto 0);
	signal clk_out : std_logic;
begin
	clk <= not clk after 2 ns;
	-- Apply stimulus and check the results
	process
	begin
		clk_div_ctrl <= "000";
		adjacents <= "00000000";
		reset <= '1';
		start_as <= '0';
		wait for 40 ns;
		reset <= '0';
		adjacents <= "00011100";
		wait for 40 ns;
		reset <= '1';
		start_as <= '1';
		wait for 40 ns;
		reset <= '0';
		wait for 40 ns;
		adjacents <= "10101010"; -- death
		wait for 40 ns;
		clk_div_ctrl <= "001";
		adjacents <= "00010101"; -- birth
		wait for 40 ns;
		adjacents <= "11000000"; -- staying alive
		wait for 40 ns;
		adjacents <= "01110110"; -- death
		wait for 40 ns;
		adjacents <= "00000000";
		wait for 40 ns;
		adjacents <= "10110000"; -- birth
		wait for 40 ns;
		adjacents <= "00000000"; -- death
		wait for 40 ns;
		adjacents <= "10110111";
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell
	port map(
		clk, reset, start_as, enable, adjacents, clk_div_ctrl, state
		-- , sum --debugging
		-- , clk_out -- debugging
	);
end tb;
