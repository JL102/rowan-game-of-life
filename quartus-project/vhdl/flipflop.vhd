library ieee;
use ieee.std_logic_1164.all;
entity flipflop is
port(
	Clk, D : in std_logic;
	Q : out std_logic);
end flipflop;

architecture imp of flipflop is
begin
	process (Clk) -- Sensitive only to Clk
	begin
		if rising_edge(Clk) then -- 0->1 transition
			Q <= D;
		end if;
	end process;
end imp;
