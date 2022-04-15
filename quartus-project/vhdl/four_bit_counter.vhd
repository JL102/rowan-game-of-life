library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Counts the number of bits that are '1' in a four bit number.
entity four_bit_counter is 
	port (
		a, b, c, d : in std_logic;
		w, x, y : out std_logic
	);
end four_bit_counter;

architecture rtl of four_bit_counter is
begin
	w <= a and b and c and d;
	-- https://www.charlie-coleman.com/experiments/kmap/
	
	-- x minterms: 3,5,6,7,9,10,11,12,13,14
	x <= (not a and c and d) or (not a and b and d) or (not a and b and c) or (a and not b and d) or (a and c and not d) or (a and b and not c);
	-- y minterms: 1,2,4,7,8,11,13,14
	y <= a xor b xor c xor d;
end rtl;