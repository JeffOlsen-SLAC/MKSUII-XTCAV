	
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
	Enable		: in std_logic;
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
signal UpSr			: std_logic_vector(1 downto 0);
signal LoadKnob	: std_logic;



type DPotInc_t is array(15 downto 0) of integer;
Constant DPotInc : DPotInc_t :=
(
	0 => 2000,
	1 => 500,
	2 => 200,
	3 => 100,
	4 => 80,
	5 => 40,
	6 => 20,
	7 => 10,
	8 => 10,
	9 => 5,
	10 => 5,
	11 => 2,
	12 => 2,
	13 => 1,
	14 => 1,
	15 => 1
	);

Begin

Down 	<= iDown;
Up		<= iUp;

Sw_p: process(Clock, Reset)
Begin
if (Reset = '1') then
	iUP			<= '0';
	iDown			<= '0';
elsif (Clock'event and CLock = '1') then
	UpSr <= UpSr(0) & Pot_A;
	If ((UpSr = "10") and (Pot_B = '1')) then
		iUP 		<= '1';
	elsif ((UpSr = "01") and (Pot_B = '1')) then
		iDown 	<= '1';
	else
		iDown	 	<= '0';
		iUp		<= '0';
	end if;
end if;
end process;

Knob_p : process(Clock, Reset)
begin
if (Reset = '1') then
	RateCntr 	<= (Others => '0');
	iKnobCntr 	<= (Others => '0');
	KnobCntr 	<= (Others => '0');
	LoadKnob 	<= '0';
elsif (Clock'event and Clock = '1') then
	if (Enable = '1') then
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
			RateCntr <= (Others => '0');
			LoadKnob 	<= '1';
			iKnobCntr	<= iKnobcntr + DPotInc(Conv_Integer(RateCntr(7 downto 4)));
		elsif (iDown = '1') then
			RateCntr <= (Others => '0');
			iKnobCntr	<= iKnobcntr - DPotInc(Conv_Integer(RateCntr(7 downto 4)));
			LoadKnob 	<= '1';
		else
			if ((RateCntr /= x"FF")  and (Clock_En = '1')) then
				RateCntr <= RateCntr + 1;
			end if;	
			LoadKnob 	<= '0';
		end if;
	end if;
end if;
end process;
	
end Behaviour;

  