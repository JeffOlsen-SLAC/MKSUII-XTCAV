
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
--      Last change: JO 3/24/2011 1:14:51 PM
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

--  Modifications:

Library work;
use work.mksuii_x.all;

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

Begin

Level_p: process( clock, reset)
Begin
if (Reset = '1') then
	iStart <= "00";
elsif (Clock'event and Clock = '1') then
	iStart <= iStart(0) & Start;
	if (Level = '1') then
		Trigger <= Start;
	else
		if (iStart = "01") then -- Leading edge
			Trigger <= '1';
		else
			Trigger <= '0';
		end if;
	end if;
end if;
end process; -- Level_p

oneshot_p: process (Clock, Reset)
Begin
if (Reset = '1') then
	Counter 		<= (Others => '0');
	OS_Out 		<= '0';
	OS_State 	<= OS_Idle;
elsif (Clock'event and Clock = '1') then
	if (ClockEn = '1') then
		Case OS_State is
		When OS_Idle =>
			if (Trigger = '1') then
				if (OS_Time = x"0") then
					OS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else	
					Counter		<= OS_Time;
					OS_Out		<= '1';
					OS_State 	<= OS_Count;
				end if;
			else
				OS_Out			<= '0';
				OS_State 		<= OS_Idle;
			end if;

		When OS_Count =>
			if ((RetrigEn = '1') and (Trigger = '1')) then
				if (OS_Time = x"0") then
					OS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else
					Counter		<= OS_Time;
					OS_State 	<= OS_Count;
				end if;
			else
				Counter <= Counter -1;
				if (Counter = x"0") then
					OS_State 	<= OS_Idle;
				else
					OS_State 	<= OS_Count;
				end if;
			end if;

		When Others =>
				Counter	<= x"0";
				OS_Out		<= '0';
				OS_State 	<= OS_Idle;
		End case;
	end if;
end if;   
end process; -- oneshot_p
end Behaviour;
          
  