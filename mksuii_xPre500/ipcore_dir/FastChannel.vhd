----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:51 02/14/2011 
-- Design Name: 
-- Module Name:    WaveForm_Intf - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WaveForm_Intf is
Port ( 
	Clock 				: in std_logic;
	Reset 				: in std_logic;
	Clk119Mhz 			: in std_logic;
	
	DAV					: in std_logic;									-- From FAST ADC
	DataIn				: in std_logic_vector(11 downto 0);			-- From FAST ADC	
	
	Trigger				: in std_logic;
	TimeCntr				: in std_logic_vector(7 downto 0);			-- From Control
	Lo_Thres				: in std_logic_vector(11 downto 0);			-- From Control
	Hi_Thres				: in std_logic_vector(11 downto 0);			-- From Control
	Start					: in std_logic_vector(7 downto 0);			-- From Control
	Stop					: in std_logic_vector(7 downto 0);			-- From Control
	
	WFM_RAddr			: in std_logic_vector(7 downto 0);			-- From Control
	WFM_DOut				: out std_logic_vector(11 downto 0);		-- To Control
	Average				: out std_logic_vector(11 downto 0);		-- To Control
	Status				: out std_logic_vector(1 downto 0);			-- To Control

			  );
end WaveForm_Intf;

architecture Behavioral of WaveForm_Intf is

signal AddB			: std_logic;
signal LoadB 		: std_logic;
signal AveCe 		: std_logic;
signal NSamples 	: std_logic_vector(12 downto 0);
signal FastSum 	: std_logic_vector(19 downto 0);	
signal Average		: std_logic_vector(11 downto 0);	

signal Average		: std_logic_vector(11 downto 0);	

signal WFM_Wr 		: std_logic;
signal WFM_WAddr	: std_logic_vector(7 downto 0);	
signal WFM_RAddr	: std_logic_vector(7 downto 0);	

begin


u_FastAcc : Acc12x20
port map (
	a 			=> a,
	b 			=> DataIn,
	clk 		=> Clk119Mhz,
	ce 		=> AddB,
	bypass 	=> LoadB,
	s 			=> FastSum
	);
	
	
u_FastDiv : Div20x8
port map (
	clk 			=> Clk119Mhz,
	ce 			=> AveCe,
	rfd 			=> open,
	dividend 	=> FastSum,
	divisor 		=> NSamples,
	quotient 	=> Average,
	fractional 	=> open
);

u_Wfm : Ram512x12dp
port map (
	clka 	=> CLK119Mhz,
	wea 	=> WFM_Wr,
	addra => WFM_WAddr,
	dina 	=> DataIn,
	clkb 	=> Clock,
	addrb => WFM_RAddr,
	doutb => WFM_DOut
);
end Behavioral;

