-------------------------------------------------------------------------------
-- Modified by Group 5: Game of Life (Jordan Lees, Dwight Bedford, Ryan Oliver , Brian Dalmar)
-- Description: VGA raster controller for DE10-Standard
-- Adapted from DE2 controller written by Stephen A. Edwards/ D. M. Calhoun
-- 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_types.all;


entity de2_vga_raster is
  
  port (
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 50.0MHz
	---------Read from memory to access position *Not utilized------------------
	read			:	in std_logic;
	write		: 	in std_logic;
	chipselect	:	in std_logic;
	address		: 	in std_logic_vector(3 downto 0);
	readdata	:	out std_logic_vector(15 downto 0);
	writedata	:	in std_logic_vector(15 downto 0);
-------------------------------------------------------------------------------
	-- VGA connectivity
    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic := '0';        -- SYNC
    VGA_R,                           -- Red[7:0]
    VGA_G,                           -- Green[7:0]
    VGA_B : out std_logic_vector(7 downto 0); -- Blue[7:0]
	 SwitchButtons_signal : in  std_logic_vector(15 downto 0) -- Switches and Buttons (Switches Bits 15-6, Buttons 5-2, Blank 1/0)
    );

end de2_vga_raster;

-------------------------------------------------------------------------------
architecture rtl of de2_vga_raster is
	
	-- Cell simulation
	signal states : array_states;
	signal start_as : array_states := (others => (others => '0')); -- Initialize most of start_as as 0 so I can pick which ones to turn on
	signal enable	: std_logic	:=	'1';
	signal clk_div_ctrl : unsigned(2 downto 0);
	signal sim_reset : std_logic := '1'; -- hacky but needed
-------------------------------------------------------------------------------
	component cell_simulation is port(
		clk 			:	in std_logic;
		reset 			: 	in std_logic;
		start_as_arr	:	in array_states;
		enable			:	in std_logic;
		clk_div_ctrl	:	in unsigned(2 downto 0);
	    states 			: 	inout array_states
	);
	end component;
-------------------------------------------------------------------------------
--------------------------Video parameters-------------------------------------
	constant HTOTAL       : integer := 800;
	constant HSYNC        : integer := 96;
	constant HBACK_PORCH  : integer := 48;
	constant HACTIVE      : integer := 640;
	constant HFRONT_PORCH : integer := 16;

	constant VTOTAL       : integer := 525;
	constant VSYNC        : integer := 2;
	constant VBACK_PORCH  : integer := 33;
	constant VACTIVE      : integer := 480;
	constant VFRONT_PORCH : integer := 10;


	--------------------Signals for the video controller---------------------------
	signal Hcount : unsigned(9 downto 0);-- := 200;  -- Horizontal position (0-800)
	signal Vcount : unsigned(9 downto 0);-- := 200;  -- Vertical position (0-524)
	signal CellX, CellY : unsigned(9 downto 0);
	signal EndOfLine, EndOfField : std_logic;
	signal vga_hblank, vga_hsync, vga_vblank, vga_vsync : std_logic := '0';  -- Sync. signals

	--------------------Signals for 25MHZ Clock and Cell State---------------------
	signal clk_25 : std_logic := '0';
	signal cell_alive : std_logic := '0';
	
	-------------------------------------------------------------------------------
begin
	-- Set up start_as ROMstart_as(25, 2) <= '1'; ("Glider Gun")
	start_as(23, 3) <= '1';
	start_as(25, 3) <= '1';
	start_as(13, 4) <= '1';
	start_as(14, 4) <= '1';
	start_as(21, 4) <= '1';
	start_as(22, 4) <= '1';
	start_as(35, 4) <= '1';
	start_as(36, 4) <= '1';
	start_as(12, 5) <= '1';
	start_as(16, 5) <= '1';
	start_as(21, 5) <= '1';
	start_as(22, 5) <= '1';
	start_as(35, 5) <= '1';
	start_as(36, 5) <= '1';
	start_as(1, 6) <= '1';
	start_as(2, 6) <= '1';
	start_as(11, 6) <= '1';
	start_as(17, 6) <= '1';
	start_as(21, 6) <= '1';
	start_as(22, 6) <= '1';
	start_as(1, 7) <= '1';
	start_as(2, 7) <= '1';
	start_as(11, 7) <= '1';
	start_as(15, 7) <= '1';
	start_as(17, 7) <= '1';
	start_as(18, 7) <= '1';
	start_as(23, 7) <= '1';
	start_as(25, 7) <= '1';
	start_as(11, 8) <= '1';
	start_as(17, 8) <= '1';
	start_as(25, 8) <= '1';
	start_as(12, 9) <= '1';
	start_as(16, 9) <= '1';
	start_as(13, 10) <= '1';
	start_as(14, 10) <= '1';
	-------------------Clock Speed configured based on Switch Positions---------------------------
	clk_div_ctrl <= SwitchButtons_signal(15) & SwitchButtons_signal(14) & SwitchButtons_signal(13);
	------------------- Simulation Reset Pushbutton ----------------------------------------------
		sim_reset <= SwitchButtons_signal(3);
	------------------- Simulation Enable Trigger ------------------------------------------------
	--(Start/Stop)
	--enable <= not SwitchButtons_signal(4); (Configured currently as "pause") 
	----------------------------------------------------------------------------------------------
		
	-- Create the simulation component
	sim : cell_simulation port map (
		clk, sim_reset, start_as, enable, clk_div_ctrl, states
	);


	-- Set up 25 MHz clock
	process (clk)
	begin
		if rising_edge(clk) then
			clk_25 <= not clk_25;
--			if sim_reset = '1' then
--				sim_reset <= '0';
--			end if;
		end if;
	end process;

-----------------Horizontal and Vertical Counters for VGA-----------------------------

	HCounter : process (clk_25)
	begin
		if rising_edge(clk_25) then      
			if reset = '1' then
			  Hcount <= (others => '0');
			elsif EndOfLine = '1' then
			  Hcount <= (others => '0');
			else
			  Hcount <= Hcount + 1;
			end if;
		end if;
	end process HCounter;

	EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';
	  
	VCounter: process (clk_25)
	begin
		if rising_edge(clk_25) then      
			if reset = '1' then
			  Vcount <= (others => '0');
			elsif EndOfLine = '1' then
			  if EndOfField = '1' then
				 Vcount <= (others => '0');
			  else
				 Vcount <= Vcount + 1;
			  end if;
			end if;
		end if;
	end process VCounter;

	EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';
-------------------------------------------------------------------------------
-------- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK-----------
-------------------------------------------------------------------------------
	HSyncGen : process (clk_25)
	begin
		if rising_edge(clk_25) then     
			if reset = '1' or EndOfLine = '1' then
			  vga_hsync <= '1';
			elsif Hcount = HSYNC - 1 then
			  vga_hsync <= '0';
			end if;
		end if;
	end process HSyncGen;
	  
	HBlankGen : process (clk_25)
	begin
		if rising_edge(clk_25) then
			if reset = '1' then
				vga_hblank <= '1';
			elsif Hcount = HSYNC + HBACK_PORCH then
				vga_hblank <= '0';
			elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
				vga_hblank <= '1';
			end if;      
		end if;
	end process HBlankGen;

	VSyncGen : process (clk_25)
	begin
		if rising_edge(clk_25) then
			if reset = '1' then
				vga_vsync <= '1';
			elsif EndOfLine ='1' then
				if EndOfField = '1' then
					vga_vsync <= '1';
				elsif Vcount = VSYNC - 1 then
					vga_vsync <= '0';
				end if;
			end if;      
		end if;
	end process VSyncGen;

	VBlankGen : process (clk_25)
	begin
		if rising_edge(clk_25) then    
			if reset = '1' then
				vga_vblank <= '1';
			elsif EndOfLine = '1' then
				if Vcount = VSYNC + VBACK_PORCH - 1 then
					vga_vblank <= '0';
				elsif Vcount = VSYNC + VBACK_PORCH + VACTIVE - 1 then
					vga_vblank <= '1';
				end if;
			end if;
		end if;
	end process VBlankGen;
-------------------------------------------------------------------------------
	CellChecker : process (clk_25)
	begin
		if rising_edge(clk_25) then
			CellX <= shift_right(Hcount + HBACK_PORCH, 4);
			CellY <= shift_right(Vcount + VBACK_PORCH, 4);
			cell_alive <= states(to_integer(CellX), to_integer(CellY));
		end if;
	end process CellChecker;
	

-------------------------------------------------------------------------------
-- Registered video signals going to the video DAC
-------------------------------------------------------------------------------
	VideoOut : process (clk_25, reset)
	begin
		if reset = '1' then -- Complete Reset - VGA Displays Blank (Black)
			VGA_R <= "00000000";
			VGA_G <= "00000000";
			VGA_B <= "00000000";
		elsif clk_25'event and clk_25 = '1' then
			if cell_alive = '1' then --Cell is alive, white pixel
				VGA_R <= "11111111";
				VGA_G <= "11111111";
				VGA_B <= "11111111";
			elsif cell_alive = '-' then
				VGA_R <= "00000000"; -- Used for troubleshooting
				VGA_G <= "11111111";
				VGA_B <= "11111111";
			elsif cell_alive = 'U' then
				VGA_R <= "11111111"; -- Used for troubleshooting
				VGA_G <= "00000000";
				VGA_B <= "11111111";
			elsif cell_alive = 'X' then
				VGA_R <= "11111111"; -- Used for troubleshooting
				VGA_G <= "11111111";
				VGA_B <= "00000000";
			elsif cell_alive = '0' then
				VGA_R <= "00000000"; -- Cell is dead, black pixel
				VGA_G <= "00000000";
				VGA_B <= "00000000";
			elsif vga_hblank = '0' and vga_vblank = '0' then
				VGA_R <= "00000000"; -- Green Screen when "vga blank signal"
				VGA_G <= "11111111";
				VGA_B <= "00000000";
			else
				VGA_R <= "00000000"; -- Blue Default *should not reach case
				VGA_G <= "00000000";
				VGA_B <= "11111111";    
			end if;
	end if;
	end process VideoOut;
-------------------------------------------------------------------------------
	VGA_CLK <= clk_25;
	VGA_HS <= not vga_hsync;
	VGA_VS <= not vga_vsync;
	VGA_SYNC <= '0';
	VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;
