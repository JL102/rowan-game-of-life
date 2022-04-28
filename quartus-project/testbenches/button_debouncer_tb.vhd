library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_debouncer_tb is 
end button_debouncer_tb;

architecture tb of button_debouncer_tb is

    signal clk      :   std_logic   := '0';
    signal buttons  :   std_logic_vector(3 downto 0) := '0000'

begin

end tb ; -- tb