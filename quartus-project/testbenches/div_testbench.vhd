library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_testbench is -- A testbench usually has no ports
end div_testbench;

architecture tb of div_testbench is
	signal clk : std_logic := '0'; -- Must initialize!
	-- One signal per port is typical
	signal reset : std_logic;
	signal enable : std_logic := '1';
	signal control : unsigned(2 downto 0);
	signal clk_out : std_logic;
	signal count : unsigned(20 downto 0);
begin
	clk <= not clk after 1 ns;
	-- Apply stimulus and check the results
	process
	begin
		reset <= '1';
		control <= "000";
		wait for 10 ns;
		reset <= '0';
		
		wait for 100 ns;
		control <= "001";
		wait for 100 ns;
		control <= "010";
		wait for 256 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.clock_div
	port map(
		clk, enable, reset, control, clk_out
		, count -- debugging
	);
end tb;
