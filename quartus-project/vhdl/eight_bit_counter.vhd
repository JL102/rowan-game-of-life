library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eight_bit_counter is
	port (
		bits : in std_logic_vector(7 downto 0);
		num : out std_logic_vector(3 downto 0)
	);
end eight_bit_counter;

architecture rtl of eight_bit_counter is 
	
	component four_bit_counter is 
	port ( a, b, c, d : in std_logic; w, x, y : out std_logic );
	end component;
	
	component full_adder is
		port ( A, B, Cin : in std_logic; S, Cout : out std_logic );
	end component;
	
	signal cnt1 : std_logic_vector(2 downto 0);
	signal cnt2 : std_logic_vector(2 downto 0);
	signal carry : std_logic_vector(3 downto 0);
begin
	-- First, find the number of 1s in the two four-bit segments
	C0: four_bit_counter port map(bits(3), bits(2), bits(1), bits(0), cnt1(2), cnt1(1), cnt1(0));
	C1: four_bit_counter port map(bits(7), bits(6), bits(5), bits(4), cnt2(2), cnt2(1), cnt2(0));
	
	-- Then, add them together
	F0: full_adder port map(cnt1(0), cnt2(0), '0', num(0), carry(0));
	F1: full_adder port map(cnt1(1), cnt2(1), carry(0), num(1), carry(1));
	F2: full_adder port map(cnt1(2), cnt2(2), carry(1), num(2), num(3));
end rtl;