
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

--  Modifications:

Library work;
use work.mksuii.all;

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity oneshotCEn is
  generic (N   : positive);     -- number of BITS
port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	ClockEn		: in std_logic;
	Start 		: in std_logic;
	RetrigEn 	: in std_logic;
	Level 		: in std_logic;
	OS_Time 		: in std_logic_vector(N-1 downto 0);
	OS_Out 		: out std_logic
	);
End oneshotCEn;

  
Architecture Behaviour of oneshotCEn is

type OS_t is
	(
	OS_Idle,
	OS_Count
	);


signal OS_State 	: OS_t;
signal counter 	: std_logic_vector(N-1 downto 0);
signal iStart 		: std_logic_vector(1 downto 0);
signal Trigger 	: std_logic;
signal ClrStart 	: std_logic;

Begin

Level_p: process( clock, reset)
Begin
if (Reset = '1') then
	iStart <= "00";
elsif (Clock'event and Clock = '1') then
	iStart <= iStart(0) & Start;
	if (Level = '1') then
		Trigger <= Start;
	elsif (iStart = "01") then -- Leading edge
			Trigger <= '1';
	elsif (ClrStart = '1') then
		Trigger <= '0';
	end if;
end if;
end process; -- Level_p

oneshot_p: process (Clock, Reset)
Begin
if (Reset = '1') then
	Counter 		<= (Others => '0');
	OS_Out 		<= '0';
	ClrStart		<= '0';
	OS_State 	<= OS_Idle;
elsif (Clock'event and Clock = '1') then
		Case OS_State is
		When OS_Idle =>
			if (Trigger = '1') then
				ClrStart <= '1';
				if (OS_Time = 0) then
					OS_Out		<= '0';
					OS_State 	<= OS_Idle;
				else	
					Counter		<= OS_Time;
					OS_Out		<= '1';
					OS_State 	<= OS_Count;
				end if;
			else
				ClrStart 		<= '0';
				OS_Out			<= '0';
				OS_State 		<= OS_Idle;
			end if;

		When OS_Count =>
			ClrStart 		<= '0';
			if (ClockEn = '1') then
				if ((RetrigEn = '1') and (Trigger = '1')) then
					if (OS_Time = 0) then
						OS_Out		<= '0';
						OS_State 	<= OS_Idle;
					else
						Counter		<= OS_Time;
						OS_State 	<= OS_Count;
					end if;
				else
					Counter <= Counter -1;
					if (Counter = 0) then
						OS_State 	<= OS_Idle;
					else
						OS_State 	<= OS_Count;
					end if;
				end if;
			end if;
			
		When Others =>
				Counter	<= (others => '0');
				OS_Out		<= '0';
				OS_State 	<= OS_Idle;
		End case;
	end if;   
end process; -- oneshot_p
end Behaviour;
          
  