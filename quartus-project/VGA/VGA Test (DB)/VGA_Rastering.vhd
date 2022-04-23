-------------------------------------------------------------------------------
--
-- Author: D. M. Calhoun
-- Description: VGA raster controller for DE10-Standard with integrated sprite
-- 				 selector and Avalon memory-mapped IO
-- Adapted from DE2 controller written by Stephen A. Edwards
-- Modified by Group 5 For Use in the Game of Life Simulation and Demonstration of RTL GoL
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_vga_raster is
  
  port (
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 50.0MHz

	-- Read from memory to access position
	read			:	in std_logic;
	write		: 	in std_logic;
	chipselect	:	in std_logic;
	address		: 	in std_logic_vector(3 downto 0);
	readdata	:	out std_logic_vector(15 downto 0);
	writedata	:	in std_logic_vector(15 downto 0);
	
	-- VGA connectivity
    VGA_CLK,                         			-- Clock
    VGA_HS,                          			-- H_SYNC
    VGA_VS,                          			-- V_SYNC
    VGA_BLANK,                       			-- BLANK
    VGA_SYNC : out std_logic := '0';   		-- SYNC
    VGA_R,                           			-- Red[7:0]
    VGA_G,                           			-- Green[7:0]
    VGA_B : out std_logic_vector(7 downto 0) -- Blue[7:0]
    );

end de2_vga_raster;

architecture rtl of de2_vga_raster is
	


	-- Video parameters (Not Modified from DE-10 sample code provide

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

	-- Signals for the video controller
	signal Hcount : unsigned(9 downto 0);-- := 200;  -- Horizontal position (0-800)
	signal Vcount : unsigned(9 downto 0);-- := 200;  -- Vertical position (0-524)
	signal EndOfLine, EndOfField : std_logic; -- (Line Horizontal // Field Vertical)

	signal vga_hblank, vga_hsync, vga_vblank, vga_vsync : std_logic := '0';  -- Sync. signals


	-- need to clock at about 25 MHz for NTSC VGA
	signal clk_25 : std_logic := '0';
	signal spr_load : std_logic := '1'; -- Unneeded variable / signal
	
begin
	
	-- Instantiate connections to various sprite memories
	
	
	
	-- set up 25 MHz clock (Split 50Mhz clk into 25Mhz clk_25
	process (clk)
	begin
		if rising_edge(clk) then
			clk_25 <= not clk_25;
		end if;
	end process;


	-- Horizontal and vertical counters

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

	-- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK

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

						
	-- Registered video signals going to the video DAC
	-- 8 Bits per R/G/B
	-- ColorHexa.com // Enter (R,G,B in Numbers) - Get Color Output

	VideoOut : process (clk_25, reset)
	begin
		if reset = '1' then -- All 0's for R/G/B is equal to Black. All 1's is White
			VGA_R <= "00000000";
			VGA_G <= "00000000";
			VGA_B <= "00000000";
		elsif clk_25'event and clk_25 = '1' then
			if spr_load = '1' then -- Display is enabled
				VGA_R <= "11111111";
				VGA_G <= "00001111";
				VGA_B <= "11111111";
			elsif vga_hblank = '0' and vga_vblank = '0' then -- Blue blank signal
				VGA_R <= "00000000";
				VGA_G <= "00000000";
				VGA_B <= "11111111";
			else -- Black Screen
				VGA_R <= "00000000";
				VGA_G <= "00000000";
				VGA_B <= "00000000";    
			end if;
	end if;
	end process VideoOut;

	VGA_CLK <= clk_25;
	VGA_HS <= not vga_hsync;
	VGA_VS <= not vga_vsync;
	VGA_SYNC <= '0';
	VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;
