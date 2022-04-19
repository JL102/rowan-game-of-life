library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- author: Ryan Oliver
-- version: 4.18.22
-- Midware to debounce a button press to align with 
-- the clk rising edge using dff
-- take a clock, wait unit next clock cycle, and push a 1

-- period = 1/clk_25 = 1/25 MHz = 40 ns. 
-- Therefore need a period of 39 ns

entity button_debouncer is
    port(
        clk     :   in  std_logic;
        buttons :   in  std_logic_vector(3 downto 0);
        push    :   out std_logic_vector(3 downto 0)
    );
end button_debouncer;

architecture rtl of button_debouncer is

    signal counter :   std_logic_vector(3 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            counter <= std_logic_vector(unsigned(counter) + x"0001");
            if(counter >= x"0027") then
                counter <= (others => '0');
            end if;
        end if;
    end process;
    push <= (others => '1') when counter = x"0027" else (others => '0');
end rtl;