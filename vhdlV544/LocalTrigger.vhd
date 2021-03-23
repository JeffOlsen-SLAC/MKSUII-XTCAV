-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	LocalTrigger.vhd -
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 8/18/2011 3:21:24 PM
--	Last change: JO 9/23/2011 9:14:49 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:35:16 04/18/2011 
-- Design Name: 
-- Module Name:    LocalTrigger - Behavioral
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
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.mksuii.all;

entity LocalTrigger is
Port ( 
	Clock 				: in std_logic;
	Reset 				: in std_logic;
	Clk_En				: in std_logic;
	Mode_Local			: in std_logic;

	Delay_up				: in std_logic;
	Delay_Dn 			: in std_logic;
	Delay_Sw				: in std_logic;
	FP_SW_Inc			: in std_logic;
	FP_SW_Dec			: in std_logic;

	LocalTrigDelay 	: out std_logic_vector(15 downto 0);
	LocalRateDiv		: out std_logic_vector(2 downto 0);

	up						: out std_logic;
	dn						: out std_logic

	);

end LocalTrigger;

architecture Behavioral of LocalTrigger is

signal IncSr					: std_logic_vector(1 downto 0);
signal DecSr					: std_logic_vector(1 downto 0);
signal Enable 					: std_Logic;
signal iLocalRateDiv			: std_logic_vector(2 downto 0);
signal iLocalTrigDelay		: std_logic_vector(15 downto 0);

begin

LocalTrigDelay <= iLocalTrigDelay;
LocalRateDiv	<= iLocalRateDiv;

u_LTrig : DPot
port map (
	Clock 		=> Clock,
	Reset 		=> Reset,
	Clock_En		=> Clk_En,
	Enable		=> Mode_Local,
	Pot_A			=> Delay_Up,
	Pot_B			=> Delay_Dn,
	UP				=> up,
	Down			=> dn,
	KnobCntr		=> iLocalTrigDelay
);


sw_Le : process(Clock, Reset)
begin
	if (Reset = '1') then
		IncSr				<= "00";
		DecSr				<= "00";
		iLocalRateDiv 	<= "000";
	elsif (clock'event and clock = '1') then
		IncSr <= IncSr(0) & FP_SW_Inc;
		DecSr <= DecSr(0) & FP_SW_Dec;
		if (Mode_Local = '1') then
			if (IncSr = "01") then
				if (iLocalRateDiv /= "000") then
					iLocalRateDiv <= iLocalRateDiv - 1;
				end if;
			elsif	(DecSr = "01") then
				if (iLocalRateDiv /= "101") then	
					iLocalRateDiv <= iLocalRateDiv + 1;
				end if;
			end if;
		end if;
	end if;
end process;

end Behavioral;

