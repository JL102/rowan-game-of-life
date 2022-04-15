library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pll is
    port (
        clk_in  : in  std_logic;
        rst     : in  std_logic := 'X';
        clk_out : out std_logic := 'X'
    );

end pll; 

architecture imp of pll is

end imp;