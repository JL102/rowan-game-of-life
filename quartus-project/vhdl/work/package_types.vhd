<<<<<<< HEAD
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
	
	constant MAX_ROW : integer := 6;
	constant MAX_COL : integer := 6;
	
	type array_states is array (MAX_ROW downto 0, MAX_COL downto 0) of std_logic;

=======
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
	
	constant MAX_ROW : integer := 48;
	constant MAX_COL : integer := 48;
	
	type array_states is array (MAX_ROW downto 0, MAX_COL downto 0) of std_logic;

>>>>>>> 4cfb614c43c7adc7ab19ca1eb506debcd5152822
end package package_types;