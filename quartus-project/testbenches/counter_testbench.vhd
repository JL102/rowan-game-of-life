library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; -- for addition

entity counter_testbench is -- A testbench usually has no ports
end counter_testbench;

architecture tb of counter_testbench is
	signal adjacents : std_logic_vector(7 downto 0) := "00000000";
	signal number : std_logic_vector(3 downto 0);
	
	-- signal cnt1 : std_logic_vector(2 downto 0);
	-- signal cnt2 : std_logic_vector(2 downto 0);
	-- signal carry : std_logic_vector(3 downto 0);
begin
	adjacents <= adjacents + '1' after 10 ns;
	-- Apply stimulus and check the results
	process
		begin
		wait for 2560 ns;
		
		assert false report "Test: OK" severity failure;
	end process;
	-- Instantiate the Unit Under Test
	uut : entity work.eight_bit_counter
	port map(
		adjacents, number
		-- , cnt1, cnt2, carry
	);
end tb;
