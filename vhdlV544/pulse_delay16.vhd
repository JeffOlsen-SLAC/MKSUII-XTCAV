-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      Pulse_Delay16.vhd -
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

Entity pulse_delay16 is
Port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	TriggerIn 	: in std_logic;
	Delay  		: in std_logic_vector(15 downto 0);
	Pulse 		: out std_logic
	);
end pulse_delay16 ;

Architecture Behaviour of pulse_delay16 is

Type delay_t is
	(
	delayIdle,
	delayWait,
	delayWaitFall,
	delayOut
	);

signal DelayState 	: delay_t;
					
signal Counter 		: std_logic_vector(15 downto 0);
signal WidthCntr 		: std_logic_vector(15 downto 0);
signal Width 			: std_logic_vector(15 downto 0);
signal TrigSr  		: std_logic_vector(1 downto 0);


signal DelayPulse 	: std_logic;

Begin

Pulse <= DelayPulse;

DelayandPulse: Process(CLock, Reset)
Begin

If (Reset = '1') then
	DelayPulse 	<= '0';
	Counter 		<= (Others => '0');
	TrigSr 		<= (Others => '0');
	DelayState 	<= DelayIdle;
	WidthCntr 	<= (Others => '0');
	Width 		<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	TrigSr <= TrigSr(0) & TriggerIn;
	Case DelayState is
	When DelayIdle =>
		If (TrigSr = "01") then
			WidthCntr <= (Others => '0');
			if (Delay = X"0000") then
				Counter			<= (Others => '0');
				DelayPulse		<= '1';
				DelayState		<= delayWaitFall;
			else
				Counter			<= Delay -1;
				DelayState		<= DelayWait;
			end if;
		else
			DelayState		<= DelayIdle;
		end if;

	When DelayWait =>
		If (Counter = X"0000") then
			DelayPulse		<= '1';
			Counter			<= Delay - 1;
			DelayState		<= DelayWaitFall;
		else
			WidthCntr		<= WidthCntr + 1;
			Counter			<= Counter -1;
			DelayState		<= DelayWait;
			if (TrigSr = "10") then
				Width <= WidthCntr;
			end if;
		end if;

	When DelayWaitFall =>
		if (TrigSr = "00") then
			if (Counter = x"0000") then
				DelayPulse		<= '0';
				DelayState		<= DelayIdle;
			else
				Counter 			<= Width;
				DelayState		<= DelayOut;
			end if;		
		elsif (TrigSr = "10") then
			if (Delay = x"0000") then
				DelayPulse		<= '0';
				DelayState		<= DelayIdle;
			else
				DelayState		<= DelayOut;
			end if;
		else
			DelayState <= DelayWaitFall;
		end if;

	When DelayOut =>
		if (Counter = x"0000") then
			DelayPulse		<= '0';
			DelayState		<= DelayIdle;
		else
			Counter			<= Counter -1;
			DelayState		<= DelayOut;
		end if;
		
	When others =>
			DelayState		<= DelayIdle;

	end Case;
end if;
end process; --DelayandPulse

end Behaviour;