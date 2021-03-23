
-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      oneshotCEn.vhd -
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 03/01/06
--      Last change: JO 5/23/2011 8:50:59 AM
--
-- 
-- Crated by Jeff Olsen 03/01/06
--
--  Filename: oneshotCEn.vhd
--
--  Function:
--  generic oneshot
--  RetrigEn - 0, no retrig
--  RetrigEn - 1, new start will reset counter
--  Level - 0, input is edge sensitive
--  Level - 1, input is level and will restart if start is high

--  jjo 05/23/13 
--  Or'd OS_Out with Trigger
--  Conditioned trigger with os_time
--  

--  Modifications:

Library work;
use work.mksuii.all;

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity oneshotCEn4Bit is
port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	ClockEn		: in std_logic;
	Start 		: in std_logic;
	RetrigEn 	: in std_logic;
	Level 		: in std_logic;
	OS_Time 		: in std_logic_vector(3 downto 0);
	OS_Out 		: out std_logic
	);
End oneshotCEn4Bit;

Architecture Behaviour of oneshotCEn4Bit is

type OS_t is
	(
	OS_Idle,
	OS_Count
	);

signal OS_State 	: OS_t;
signal counter 	: std_logic_vector(3 downto 0);
signal iStart 		: std_logic_vector(1 downto 0);
signal Trigger 	: std_logic;
signal ClrTrigger : std_logic;
signal iOS_Out : std_logic;

Begin

OS_Out <= iOS_Out OR Trigger;

Level_p: process( clock, reset)
Begin
if (Reset = '1') then
	iStart 	<= "00";
	Trigger 	<= '0';
elsif (Clock'event and Clock = '1') then
	iStart <= iStart(0) & Start;
	if (OS_Time /= x"0") then
		if (Level = '1') then
			if (iStart(1) = '1') then
				Trigger <= '1';
			elsif (ClrTRigger = '1') then
				Trigger <= '0';
			end if;
		else
			if (iStart = "01") then -- Leading edge
				Trigger <= '1';
			elsif (ClrTRigger = '1') then
				Trigger <= '0';
			end if;
		end if;
	end if;
end if;
end process; -- Level_p

oneshot_p: process (Clock, Reset)
Begin
if (Reset = '1') then
	Counter 		<= (Others => '0');
	iOS_Out 		<= '0';
	OS_State 	<= OS_Idle;
	ClrTrigger	<= '0';
elsif (Clock'event and Clock = '1') then
	if (ClockEn = '1') then
		Case OS_State is
		When OS_Idle =>
			if (Trigger = '1') then
				ClrTrigger 		<= '1';
				if (OS_Time = x"0") then
					iOS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else	
					Counter		<= OS_Time;
					iOS_Out		<= '1';
					OS_State 	<= OS_Count;
				end if;
			else
				ClrTrigger 		<= '0';
				iOS_Out			<= '0';
				OS_State 		<= OS_Idle;
			end if;

		When OS_Count =>
			if ((RetrigEn = '1') and (Trigger = '1')) then
				ClrTrigger 		<= '1';
				if (OS_Time = x"0") then
					iOS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else
					Counter		<= OS_Time;
					OS_State 	<= OS_Count;
				end if;
			else
				ClrTrigger 		<= '0';
				Counter 			<= Counter -1;
				if (Counter = x"1") then
					iOS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else
					OS_State 	<= OS_Count;
				end if;
			end if;

		When Others =>
				Counter		<= x"0";
				iOS_Out		<= '0';
				OS_State 	<= OS_Idle;
		End case;
	end if;
end if;   
end process; -- oneshot_p
end Behaviour;
          
  