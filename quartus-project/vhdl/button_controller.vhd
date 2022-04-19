library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_controller is
    port(
        clk         :   in std_logic;
        buttons     :   in std_logic_vector(3 downto 0);
        control     :   in  unsigned(2 downto 0);
        clk_out     :   out std_logic;
        buttons_out :   out std_logic_vector(3 downto 0)
    );
end button_controller;

architecture rtl of button_controller is
    
    component button_debouncer is
        port(
            clk     	:   in  std_logic;
            buttons  :   in  std_logic_vector(3 downto 0);
            push    	:   out std_logic_vector(3 downto 0)
        );
    end component;

    component clock_div is
        port(
            clk     :   in  std_logic;
            enable  :   in  std_logic;
            reset   :   in  std_logic;
            control :   in  unsigned(2 downto 0);
            clk_out :   out std_logic
        );
    end component;

    signal enable       :   std_logic := '1';
    signal reset        :   std_logic := '0';
    signal button_clock :   std_logic;

begin

	 clk_out <= button_clock;
	 
    port1 : clock_div
    port map(clk, enable, reset, control, button_clock);
    
    port2 : button_debouncer
    port map(button_clock, buttons, buttons_out);

end rtl ; -- rtl