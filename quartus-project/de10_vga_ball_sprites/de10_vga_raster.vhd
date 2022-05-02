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
	signal sim_clk : std_logic;
	-- For zooming 
	-- signal div_amount : signed(3 downto 0) := "0011";
	signal div_amount : unsigned(2 downto 0) := "011";
	-- For panning
	signal horiz_add : unsigned(9 downto 0) := (others => '0'); 
	signal vert_add : unsigned(9 downto 0) := (others => '0');
	-- for debouncing zoom/pan buttons & detecting high only once
	-- signal btn_counter : unsigned(7 downto 0) := (others => '0'); 
	signal btn_counter : std_logic := '0';
	signal doZoomOrPan, isLeftOrRight : std_logic := '0';
	
	-------------------------------------------------------------------------------
begin
	-- Set up start_as ROM ("Glider Gun")
	start_as(25, 2) <= '1';
	start_as(46, 2) <= '1';
	start_as(47, 2) <= '1';
	start_as(54, 2) <= '1';
	start_as(55, 2) <= '1';
	start_as(23, 3) <= '1';
	start_as(25, 3) <= '1';
	start_as(45, 3) <= '1';
	start_as(47, 3) <= '1';
	start_as(54, 3) <= '1';
	start_as(56, 3) <= '1';
	start_as(13, 4) <= '1';
	start_as(14, 4) <= '1';
	start_as(21, 4) <= '1';
	start_as(22, 4) <= '1';
	start_as(35, 4) <= '1';
	start_as(36, 4) <= '1';
	start_as(45, 4) <= '1';
	start_as(56, 4) <= '1';
	start_as(12, 5) <= '1';
	start_as(16, 5) <= '1';
	start_as(21, 5) <= '1';
	start_as(22, 5) <= '1';
	start_as(35, 5) <= '1';
	start_as(36, 5) <= '1';
	start_as(42, 5) <= '1';
	start_as(43, 5) <= '1';
	start_as(45, 5) <= '1';
	start_as(56, 5) <= '1';
	start_as(58, 5) <= '1';
	start_as(59, 5) <= '1';
	start_as(1, 6) <= '1';
	start_as(2, 6) <= '1';
	start_as(11, 6) <= '1';
	start_as(17, 6) <= '1';
	start_as(21, 6) <= '1';
	start_as(22, 6) <= '1';
	start_as(42, 6) <= '1';
	start_as(43, 6) <= '1';
	start_as(45, 6) <= '1';
	start_as(47, 6) <= '1';
	start_as(50, 6) <= '1';
	start_as(51, 6) <= '1';
	start_as(54, 6) <= '1';
	start_as(56, 6) <= '1';
	start_as(58, 6) <= '1';
	start_as(59, 6) <= '1';
	start_as(1, 7) <= '1';
	start_as(2, 7) <= '1';
	start_as(11, 7) <= '1';
	start_as(15, 7) <= '1';
	start_as(17, 7) <= '1';
	start_as(18, 7) <= '1';
	start_as(23, 7) <= '1';
	start_as(25, 7) <= '1';
	start_as(45, 7) <= '1';
	start_as(47, 7) <= '1';
	start_as(49, 7) <= '1';
	start_as(52, 7) <= '1';
	start_as(54, 7) <= '1';
	start_as(56, 7) <= '1';
	start_as(11, 8) <= '1';
	start_as(17, 8) <= '1';
	start_as(25, 8) <= '1';
	start_as(45, 8) <= '1';
	start_as(47, 8) <= '1';
	start_as(49, 8) <= '1';
	start_as(52, 8) <= '1';
	start_as(54, 8) <= '1';
	start_as(56, 8) <= '1';
	start_as(12, 9) <= '1';
	start_as(16, 9) <= '1';
	start_as(42, 9) <= '1';
	start_as(43, 9) <= '1';
	start_as(45, 9) <= '1';
	start_as(47, 9) <= '1';
	start_as(50, 9) <= '1';
	start_as(51, 9) <= '1';
	start_as(54, 9) <= '1';
	start_as(56, 9) <= '1';
	start_as(58, 9) <= '1';
	start_as(59, 9) <= '1';
	start_as(13, 10) <= '1';
	start_as(14, 10) <= '1';
	start_as(42, 10) <= '1';
	start_as(43, 10) <= '1';
	start_as(45, 10) <= '1';
	start_as(56, 10) <= '1';
	start_as(58, 10) <= '1';
	start_as(59, 10) <= '1';
	start_as(45, 11) <= '1';
	start_as(56, 11) <= '1';
	start_as(45, 12) <= '1';
	start_as(47, 12) <= '1';
	start_as(54, 12) <= '1';
	start_as(56, 12) <= '1';
	start_as(46, 13) <= '1';
	start_as(47, 13) <= '1';
	start_as(54, 13) <= '1';
	start_as(55, 13) <= '1';
	
	
	process (clk)
	begin
		if rising_edge(clk) then
			-------------------Clock Speed configured based on Switch Positions---------------------------
			clk_div_ctrl <= SwitchButtons_signal(15) & SwitchButtons_signal(14) & SwitchButtons_signal(13);
			------------------- Simulation Reset Pushbutton ----------------------------------------------
			sim_reset <= not SwitchButtons_signal(3);
			------------------- Simulation Enable Trigger ------------------------------------------------
			--(Start/Stop)
			enable <= SwitchButtons_signal(6); -- (Configured currently as "pause") 
			----------------------------------------------------------------------------------------------
			
		end if;
	end process;
	-- [15-13: zoom] [12,11: x/y/zoom] ... [7: manual/auto] [6: play/pause]
	-- [5,4: zoom/pan] [3: reset] [2: manual button]
	
	------------------- Switcher between manual and auto mode ------------------------------------
	process (SwitchButtons_signal, clk)
	begin
		if SwitchButtons_signal(7) = '1' then
			sim_clk <= clk; -- Auto mode
		else 
			sim_clk <= not SwitchButtons_signal(2); -- Manual mode
		end if;
	end process;
	
	------------------ Zoom/pan control ----------------------------------------------------------
	process( doZoomOrPan )
	begin
		if rising_edge( doZoomOrPan ) then
			-- Left
			if isLeftOrRight = '1' then
				if SwitchButtons_signal(12) = '1' then -- X movement
					horiz_add <= horiz_add + 16; -- move LEFT
				elsif SwitchButtons_signal(11) = '1' then -- Y movement
					vert_add <= vert_add + 16; -- move DOWN
				else -- zoom
					div_amount <= div_amount - 1; -- zoom IN
				end if;
			-- Right
			else 
				if SwitchButtons_signal(12) = '1' then -- X movement
					horiz_add <= horiz_add - 16; -- move RIGHT
				elsif SwitchButtons_signal(11) = '1' then -- Y movement
					vert_add <= vert_add - 16; -- move UP
				else
					div_amount <= div_amount + 1; -- zoom OUT
				end if;
			end if;
		end if;
	end process;
	
	isLeftOrRight <= not SwitchButtons_signal(5); -- 1 if left button, 0 if right button
	
	HandleZoomPanPress : process( clk, SwitchButtons_signal )
	begin
		if rising_edge(clk) then
			-- either button on
			if SwitchButtons_signal(5) = '0' or SwitchButtons_signal(4) = '0' then
				
				if btn_counter = '1' then
					doZoomOrPan <= '1'; -- finally enable doZoomOrPan
				else 
					btn_counter <= '1'; -- set to 1 if not already
				end if;
			-- both buttons off
			else
				-- disable doZoomOrPan and reset btn_counter
				btn_counter <= '0';
				doZoomOrPan <= '0';
			end if;
		end if;
	end process ; -- HandleZoomPanPress
	
	-- Create the simulation component
	sim : cell_simulation port map (
		sim_clk, sim_reset, start_as, enable, clk_div_ctrl, states
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
	------------------- Checks the state of each cell --------------------------------------------
	CellChecker : process (clk_25)
	begin
		if rising_edge(clk_25) then
			-- Uses a bitshift to zoom in/out, i.e. divide the x and y coordinate by 
			CellX <= shift_right(Hcount + horiz_add, to_integer(div_amount));
			CellY <= shift_right(Vcount + vert_add,  to_integer(div_amount));
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
			-- elsif cell_alive = '-' then
			-- 	VGA_R <= "00000000"; -- Used for troubleshooting
			-- 	VGA_G <= "11111111";
			-- 	VGA_B <= "11111111";
			-- elsif cell_alive = 'U' then
			-- 	VGA_R <= "11111111"; -- Used for troubleshooting
			-- 	VGA_G <= "00000000";
			-- 	VGA_B <= "11111111";
			-- elsif cell_alive = 'X' then
			-- 	VGA_R <= "11111111"; -- Used for troubleshooting
			-- 	VGA_G <= "11111111";
			-- 	VGA_B <= "00000000";
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
