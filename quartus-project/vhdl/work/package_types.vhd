library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;

-- By copying the way ieee wrote their definitions for std_logic_1164, we can 
-- 	define our own types in a similar manner. (because online VHDL resources were
-- 	not helpful at this).
-- 	Simply include package_types in the project and add: use ieee.package_types.all;

-- C:\intelFPGA_lite\18.1\quartus\libraries\vhdl\ieee\2008
package package_types is
	
	constant MAX_ROW : integer := 40;
	constant MAX_COL : integer := 13;
	constant DIV_AMT : integer := 3; -- this is for zooming in to the cell simulation
	
	type array_states is array (MAX_ROW downto 0, MAX_COL downto 0) of std_logic;

end package package_types;
