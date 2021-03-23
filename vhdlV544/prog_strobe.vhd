-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      prog_strobe.vhd - 
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 08/23/05 
--      Last change: JO 5/23/2011 8:50:59 AM
--
-- 
-- Created by Jeff Olsen 08/23/05
--
--  Filename: prog_strobe.vhd
--
--  Function:
--  Generate delayed  Pulse
--
--  Modifications:
--  04/21/06 jjo
--  Changed to 24 bit registers
--  Use only 1 counter for both delay and width
--



Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity prog_strobe is
Port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	TriggerIn 	: in std_logic;
	Delay  		: in std_logic_vector(19 downto 0);
	Width  		: in std_logic_vector(19 downto 0);
	Pulse 		: out std_logic
	);
end prog_strobe ;

Architecture Behaviour of prog_strobe is

Type delay_t is
	(
	delayIdle,
	delayWait,
	delayOut
	);

signal DelayState 	: delay_t;
					
signal Counter 		: std_logic_vector(19 downto 0);
signal iWidth  		: std_logic_vector(19 downto 0);

signal DelayPulse 	: std_logic;

Begin

Pulse <= DelayPulse;

DelayandPulse: Process(CLock, Reset)
Begin

If (Reset = '1') then
	DelayPulse 		<= '0';
	Counter 	<= (Others => '0');
	iWidth 	<= (Others => '0');
	DelayState 		<= DelayIdle;
elsif (Clock'event and Clock = '1') then
Case DelayState is
When DelayIdle =>
	If (TriggerIn = '1') then
		If (Width = X"00000") then
			DelayPulse 		<= '0';
			DelayState 		<= DelayIdle;
		elsif (Delay = X"00000") then
			DelayPulse 		<= '1';
			Counter 			<= Width -1;
			iWidth 			<= Width -1;
			DelayState 		<= DelayOut;
		else
			Counter 			<= Delay -1;
			DelayState 		<= DelayWait;
		end if;
	else
		DelayState 		<= DelayIdle;
	end if;

When DelayWait =>
	If (Counter = X"00000") then 
		DelayPulse 		<= '1';
		Counter 			<= iWidth;
		DelayState 		<= DelayOut;
	else
		Counter 			<= Counter -1;
		DelayState 		<= DelayWait;
		end if;

When DelayOut =>
	if (Counter = X"00000") then
		DelayPulse 		<= '0';
		DelayState 		<= DelayIdle;
	else
		Counter 			<= Counter -1;
		DelayState 		<= DelayOut;
	end if;

When others =>
		DelayState 		<= DelayIdle;

end Case;
end if;
end process; --DelayandPulse

end Behaviour;