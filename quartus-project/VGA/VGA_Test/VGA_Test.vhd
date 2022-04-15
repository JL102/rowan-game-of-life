
---------------------------------------------------------
--  This code is generated by Terasic System Builder
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Test is
port
(
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 50.0MHz

	-- Read from memory to access position
	read			:	in std_logic;
	write		: 	in std_logic;
	chipselect	:	in std_logic;
	address		: 	in std_logic_vector(3 downto 0);
	readdata	:	out std_logic_vector(15 downto 0);
	writedata	:	in std_logic_vector(15 downto 0);
	------------ CLOCK ------------
	CLOCK2_50       	:in    	std_logic;
	CLOCK3_50       	:in    	std_logic;
	CLOCK4_50       	:in    	std_logic;
	CLOCK_50        	:in    	std_logic;

	------------ KEY ------------
	KEY             	:in    	std_logic_vector(3 downto 0);

	------------ SW ------------
	SW              	:in    	std_logic_vector(9 downto 0);

	------------ LED ------------
	LEDR            	:out   	std_logic_vector(9 downto 0);

	------------ Seg7 ------------
	HEX0            	:out   	std_logic_vector(6 downto 0);
	HEX1            	:out   	std_logic_vector(6 downto 0);
	HEX2            	:out   	std_logic_vector(6 downto 0);
	HEX3            	:out   	std_logic_vector(6 downto 0);
	HEX4            	:out   	std_logic_vector(6 downto 0);
	HEX5            	:out   	std_logic_vector(6 downto 0);

	------------ VGA ------------
	VGA_HS          	:out   	std_logic; --Horizontal Sync
	VGA_SYNC      		:out   	std_logic;
	VGA_VS          	:out   	std_logic; -- Vertical Sync
	VGA_BLANK     		:out   	std_logic;
	VGA_CLK         	:out   	std_logic; --VGA Clock Signal
	VGA_R           	:out   	std_logic_vector(7 downto 0); -- Red
	VGA_B           	:out   	std_logic_vector(7 downto 0); -- Blue
	VGA_G           	:out   	std_logic_vector(7 downto 0); -- Green

	------------ HPS ------------
	HPS_CONV_USB_N  	:inout 	std_logic;
	HPS_DDR3_ADDR   	:out   	std_logic_vector(14 downto 0);
	HPS_DDR3_BA     	:out   	std_logic_vector(2 downto 0);
	HPS_DDR3_CAS_N  	:out   	std_logic;
	HPS_DDR3_CKE    	:out   	std_logic;
	HPS_DDR3_CK_N   	:out   	std_logic;
	HPS_DDR3_CK_P   	:out   	std_logic;
	HPS_DDR3_CS_N   	:out   	std_logic;
	HPS_DDR3_DM     	:out   	std_logic_vector(3 downto 0);
	HPS_DDR3_DQ     	:inout 	std_logic_vector(31 downto 0);
	HPS_DDR3_DQS_N  	:inout 	std_logic_vector(3 downto 0);
	HPS_DDR3_DQS_P  	:inout 	std_logic_vector(3 downto 0);
	HPS_DDR3_ODT    	:out   	std_logic;
	HPS_DDR3_RAS_N  	:out   	std_logic;
	HPS_DDR3_RESET_N	:out   	std_logic;
	HPS_DDR3_RZQ    	:in    	std_logic;
	HPS_DDR3_WE_N   	:out   	std_logic;
	HPS_ENET_GTX_CLK	:out   	std_logic;
	HPS_ENET_INT_N  	:inout 	std_logic;
	HPS_ENET_MDC    	:out   	std_logic;
	HPS_ENET_MDIO   	:inout 	std_logic;
	HPS_ENET_RX_CLK 	:in    	std_logic;
	HPS_ENET_RX_DATA	:in    	std_logic_vector(3 downto 0);
	HPS_ENET_RX_DV  	:in    	std_logic;
	HPS_ENET_TX_DATA	:out   	std_logic_vector(3 downto 0);
	HPS_ENET_TX_EN  	:out   	std_logic;
	HPS_FLASH_DATA  	:inout 	std_logic_vector(3 downto 0);
	HPS_FLASH_DCLK  	:out   	std_logic;
	HPS_FLASH_NCSO  	:out   	std_logic;
	HPS_GSENSOR_INT 	:inout 	std_logic;
	HPS_I2C1_SCLK   	:inout 	std_logic;
	HPS_I2C1_SDAT   	:inout 	std_logic;
	HPS_I2C2_SCLK   	:inout 	std_logic;
	HPS_I2C2_SDAT   	:inout 	std_logic;
	HPS_I2C_CONTROL 	:inout 	std_logic;
	HPS_KEY         	:inout 	std_logic;
	HPS_LCM_BK      	:inout 	std_logic;
	HPS_LCM_D_C     	:inout 	std_logic;
	HPS_LCM_RST_N   	:inout 	std_logic;
	HPS_LCM_SPIM_CLK	:out   	std_logic;
	HPS_LCM_SPIM_MISO	:in    	std_logic;
	HPS_LCM_SPIM_MOSI	:out   	std_logic;
	HPS_LCM_SPIM_SS 	:out   	std_logic;
	HPS_LED         	:inout 	std_logic;
	HPS_LTC_GPIO    	:inout 	std_logic;
	HPS_SD_CLK      	:out   	std_logic;
	HPS_SD_CMD      	:inout 	std_logic;
	HPS_SD_DATA     	:inout 	std_logic_vector(3 downto 0);
	HPS_SPIM_CLK    	:out   	std_logic;
	HPS_SPIM_MISO   	:in    	std_logic;
	HPS_SPIM_MOSI   	:out   	std_logic;
	HPS_SPIM_SS     	:out   	std_logic;
	HPS_UART_RX     	:in    	std_logic;
	HPS_UART_TX     	:out   	std_logic;
	HPS_USB_CLKOUT  	:in    	std_logic;
	HPS_USB_DATA    	:inout 	std_logic_vector(7 downto 0);
	HPS_USB_DIR     	:in    	std_logic;
	HPS_USB_NXT     	:in    	std_logic;
	HPS_USB_STP     	:out   	std_logic
);

end entity;



---------------------------------------------------------
--  Structural coding
---------------------------------------------------------


architecture rtl of VGA_Test is

	-- Video parameters

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
	signal Hcount : unsigned (9 downto 0);-- := 200;  -- Horizontal position (0-800)
	signal Vcount : unsigned (9 downto 0);-- := 200;  -- Vertical position (0-524)
	signal EndOfLine, EndOfFrame : std_logic;

	signal vga_hblank, vga_hsync, vga_vblank, vga_vsync : std_logic := '0';  -- Sync. signals

	-- need to clock at about 25 MHz for NTSC VGA
	signal clk_25 : std_logic := '0';
	
begin
	
	-- set up 25 MHz clock
	process (clk)
	begin
		if rising_edge(clk) then
			clk_25 <= not clk_25;
		end if;
	end process;


	-- Horizontal and Vertical Counters

	HCounter : process (clk_25)
	begin
		if rising_edge(clk_25) then      
			if reset = '1' then
			  Hcount <= (others => '0'); -- Resets the Horizontal counter to all 0000 (*others sets all bits to '0')
			elsif EndOfLine = '1' then
			  Hcount <= (others => '0'); -- At the end of the line; Resets the Horizontal counter to all 0000 (*others sets all bits to '0')
			else
			  Hcount <= Hcount + 1; -- Not at the end of the line, iterate down to the next horizontal line
			end if;      
		end if;
	end process HCounter;

	EndOfLine <= '1' when Hcount = HTotal - 1 else '0';
	
	VCounter: process (clk_25)
	begin
		if rising_edge(clk_25) then      
			if reset = '1' then
			  Vcount <= (others => '0'); -- Resets the Vertical counter to all 0000 (*others sets all bits to '0')
			elsif EndOfLine = '1' then
			  if EndOfFrame = '1' then
				 Vcount <= (others => '0'); -- At the end of the line; Resets the Horizontal counter to all 0000 (*others sets all bits to '0')
			  else
				 Vcount <= Vcount + 1; -- Not at the end of the line, iterate down to the next horizontal line
			  end if;
			end if;
		end if;
	end process VCounter;

	EndOfFrame <= '1' when Vcount = VTOTAL - 1 else '0';
	
	-- Horizontal Synchro--
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
	
	-- Veritcal Synchro--
	VSyncGen : process (clk_25)
	begin
		if rising_edge(clk_25) then
			if reset = '1' then
				vga_vsync <= '1';
			elsif EndOfLine ='1' then
				if EndOfFrame = '1' then
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
	-- Sprite Loading *Not Needed currently; This may be useful to use if we are pushing live/dead cells to ROM, and then loading configuration? Commented to keep for now
--	Sprite_Load_Process : process (clk_25)
--	begin
--		if reset = '1' then
--			spr_load <= '0';
--		else
--			if rising_edge(clk_25) then
--				if spr_area = '1' then
--					spr_load <= '1';
--				else
--					spr_load <= '0';
--				end if;
--			end if;
--		end if;
-- end process Sprite_Load_Process;
						
	-- Registered video signals going to the video DAC

	VideoOut : process (clk_25, reset)
	--Want to specify that if the cell is alive; all R/G/B should be 0; else cell is dead and all R/G/B = 0; RGB=0 is Black, RGB=1 is White
	--ColorHexa.com can be used to define R/G/B values to colors. 
	
	begin
		if reset = '1' then
			VGA_R <= "00000000";
			VGA_G <= "00000000";
			VGA_B <= "00000000";
		elsif clk_25'event and clk_25 = '1' then
			if vga_hblank = '0' and vga_vblank = '0' then
				VGA_R <= "11111111";
				VGA_G <= "11111111";
				VGA_B <= "00000000";
			else
				VGA_R <= "00000000";
				VGA_G <= "11111111";
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
