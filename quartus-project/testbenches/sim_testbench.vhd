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
	signal enable	: std_logic	:=	'1';
	signal clk_div_ctrl : unsigned(2 downto 0);
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
		start_as(25, 2) <= '1';
		start_as(23, 3) <= '1';
		start_as(25, 3) <= '1';
		start_as(13, 4) <= '1';
		start_as(14, 4) <= '1';
		start_as(21, 4) <= '1';
		start_as(22, 4) <= '1';
		start_as(35, 4) <= '1';
		start_as(36, 4) <= '1';
		start_as(12, 5) <= '1';
		start_as(16, 5) <= '1';
		start_as(21, 5) <= '1';
		start_as(22, 5) <= '1';
		start_as(35, 5) <= '1';
		start_as(36, 5) <= '1';
		start_as(1, 6) <= '1';
		start_as(2, 6) <= '1';
		start_as(11, 6) <= '1';
		start_as(17, 6) <= '1';
		start_as(21, 6) <= '1';
		start_as(22, 6) <= '1';
		start_as(1, 7) <= '1';
		start_as(2, 7) <= '1';
		start_as(11, 7) <= '1';
		start_as(15, 7) <= '1';
		start_as(17, 7) <= '1';
		start_as(18, 7) <= '1';
		start_as(23, 7) <= '1';
		start_as(25, 7) <= '1';
		start_as(11, 8) <= '1';
		start_as(17, 8) <= '1';
		start_as(25, 8) <= '1';
		start_as(12, 9) <= '1';
		start_as(16, 9) <= '1';
		start_as(13, 10) <= '1';
		start_as(14, 10) <= '1';
		
		clk_div_ctrl <= "000";
		wait for 10 ns;
		reset <= '0';
		
		wait for 100 ns;
		clk_div_ctrl <= "010";
		wait for 100 ns;
		clk_div_ctrl <= "011";
		wait for 1200 ns;
		clk_div_ctrl <= "100";
		wait for 100 ns;
		clk_div_ctrl <= "101";
		wait for 100 ns;
		clk_div_ctrl <= "110";
		wait for 100 ns;
		clk_div_ctrl <= "111";
		wait for 100 ns;

		enable <= '0';
		wait for 10 ns;
		enable <= '1';
		wait for 10 ns;

		reset <= '1';
		wait for 10 ns;

		reset <= '0';
		wait for 100 ns;

		-- wait for 3000 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.cell_simulation
	port map(
		clk, reset, start_as, enable, clk_div_ctrl, states
		-- , sum --debugging
	);
end tb;