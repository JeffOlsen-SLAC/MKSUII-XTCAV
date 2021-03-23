	
-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      DPot.vhd -
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 03/01/06
--      Last change: JO 9/26/2011 8:48:08 AM
--
--

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Library work;
use work.mksuii.all;


Entity DPot is
port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	Clock_En		: in std_logic;
	Pot_A			: in std_logic;
	Pot_B			: in std_logic;
	UP				: out std_logic;
	Down			: out std_logic;
	KnobCntr		: out std_logic_vector(15 downto 0)
);
End DPot;

  
Architecture Behaviour of DPot is

signal iUp 			: std_logic;
signal iDown 		: std_logic;
signal iKnobCntr 	: std_logic_vector(17 downto 0);
signal RateCntr	: std_logic_vector(7 downto 0);
signal GrayCnt		: std_logic_vector(1 downto 0);
signal LoadKnob	: std_logic;

type DPot_state_t is
(
	Idle_s,
	UP_0_s,
	UP_2_s,
	UP_3_s,
	UP_1_s,
	Down_0_s,
	Down_1_s,
	Down_3_s,
	Down_2_s,
	CheckDir
);

signal DPot_State 		: DPot_state_t;


type DPotInc_t is array(15 downto 0) of integer;
Constant DPotInc : DPotInc_t :=
(
	0 => 0,
	1 => 1,
	2 => 1,
	3 => 1,
	4 => 1,
	5 => 1,
	6 => 1,
	7 => 1,
	8 => 1,
	9 => 1,
	10 => 1,
	11 => 1,
	12 => 1,
	13 => 1,
	14 => 1,
	15 => 1
	);

Begin

Down 	<= iDown;
Up		<= iUp;

GrayCnt <= Pot_B & Pot_A;

Sw_p: process(Clock, Reset)
Begin
if (Reset = '1') then
	iUP			<= '0';
	iDown			<= '0';
	RateCntr 	<= (Others => '0');
	DPot_State 	<= Idle_s;
elsif (Clock'event and CLock = '1') then
	if ((iUp = '1') or (iDown = '1')) then
		RateCntr <= (Others => '0');
	elsif ((RateCntr /= x"FF")  and (Clock_En = '1')) then
		RateCntr <= RateCntr + 1;
	end if;	

			
	case	DPot_State is
	when Idle_s =>
		iUP 		<= '0';
		iDown 	<= '0';
		if (GrayCnt = "00") then
			DPot_State <= CheckDir;
		else
			DPot_State <= Idle_s;
		end if;
		
	when CheckDir =>
		if (GrayCnt = "10") then
			DPot_State <= Up_3_s;
		elsif (GrayCnt = "01") then
			DPot_State <= Down_3_s;
		end if;
		
	When up_3_s =>
		if (GrayCnt = "11") then
			DPot_State <= Up_1_s;
		elsif (GrayCnt = "10") then
			DPot_State <= up_3_s;
		else
			DPot_State 	<= Idle_s;
		end if;
		
	When up_1_s =>
		if (GrayCnt = "01") then
			DPot_State 	<= up_0_s;
		elsif (GrayCnt = "11") then
			DPot_State 	<= up_1_s;
		else
			DPot_State 	<= Idle_s;
		end if;

	When up_0_s =>
		if (GrayCnt = "00") then
			iUp 			<= '1';
			DPot_State 	<= Idle_s;
		elsif (GrayCnt = "01") then
			DPot_State 	<= up_0_s;
		else
			DPot_State 	<= Idle_s;
		end if;

	When Down_3_s =>
		if (GrayCnt = "11") then
			DPot_State 	<= Down_2_s;
		elsif (GrayCnt = "01") then
			DPot_State 	<= Down_3_s;
		else
			DPot_State 	<= Idle_s;
		end if;

	When Down_2_s =>
		if (GrayCnt = "10") then
			DPot_State 	<= Down_0_s;
		elsif (GrayCnt = "11") then
			DPot_State 	<= Down_2_s;
		else
			DPot_State 	<= Idle_s;
		end if;
		
	When Down_0_s =>
		if (GrayCnt = "00") then
			iDown			<= '1';		
			DPot_State 	<= Idle_s;
		elsif (GrayCnt = "10") then
			DPot_State 	<= Down_0_s;
		else
			DPot_State 	<= Idle_s;
		end if;
		
		
	when others =>
		iUp 			<= '0';
		iDown			<= '0';
		DPot_State 	<= Idle_s;
	end case;

end if;
end process;

Knob_p : process(Clock, Reset)

begin
if (Reset = '1') then
	iKnobCntr 	<= (Others => '0');
	KnobCntr 	<= (Others => '0');
	LoadKnob 	<= '0';
elsif (Clock'event and Clock = '1') then
	if (LoadKnob = '1') then
		if (iKnobCntr(17 downto 16) = "01") then -- over flow
			KnobCntr 	<= x"FFFF";
			iKnobCntr	<= "001111111111111111";
		elsif (iKnobCntr(17 downto 16) = "11") then	-- under flow
			KnobCntr 	<= x"0000";
			iKnobCntr	<= "000000000000000000";
		else
			KnobCntr <= iKnobCntr(15 downto 0);
		end if;
	end if;

	if (iUp = '1') then
		LoadKnob 	<= '1';
		iKnobCntr	<= iKnobcntr + DPotInc(Conv_Integer(RateCntr(7 downto 4)));
	elsif (iDown = '1') then
		iKnobCntr	<= iKnobcntr - DPotInc(Conv_Integer(RateCntr(7 downto 4)));
		LoadKnob 	<= '1';
	else
		LoadKnob 	<= '0';
	end if;

end if;
end process;
	
end Behaviour;

  