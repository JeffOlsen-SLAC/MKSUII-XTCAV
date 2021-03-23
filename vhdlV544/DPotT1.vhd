	
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
--      Last change: JO 10/27/2010 9:30:03 AM
--
--

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


Library work;
use work.Test.all;


Entity DPot is
port (
	Clock 		: in std_logic;
	Reset 		: in std_logic;
	Clock_En		: in std_logic;
	SWInA 		: in std_logic;
	SWInB 		: in std_logic;
	UP				: out std_logic;
	Down			: out std_logic;
	KnobCntr		: out std_logic_vector(15 downto 0);
	F_SWInA		: out  std_logic;
	F_SWInB		: out  std_logic
);
End DPot;

  
Architecture Behaviour of DPot is

signal SWInAFltr 	: std_logic_vector(3 downto 0);
signal SWInBFltr 	: std_logic_vector(3 downto 0);

Signal SWARising	: std_logic;
signal SWBRising	: std_logic;

signal d_SWINA		: std_logic;
signal d_SWINB		: std_logic;

signal iUp 			: std_logic;
signal iDown 		: std_logic;
signal iKnobCntr 	: std_logic_vector(17 downto 0);
signal RateCntr	: std_logic_vector(7 downto 0);

type DPot_state_t is
(
	Idle_s,
	Wait_Up_s,
	Wait_Down_s
);

signal DPot_State 		: DPot_state_t;

Begin

F_SWInA 	<= '0';
F_SWInB 	<= '0';

Up 		<= iUp;
Down 		<= iDown;

in_p : process(Clock, Reset) 
begin
if (Reset = '1') then
	d_SWINA <= '0';
	d_SWINB <= '0';
elsif (Clock'event and CLock = '1') then
	d_SWINA <= SWINA;
	d_SWINB <= SWINB;
end if;
end process;


filterA_p : process(Clock, Reset, d_SWinA) 
begin
if (reset = '1') OR (d_SWinA = '0') then
	SWINAFltr <= (others => '0');
elsif (Clock'event and CLock = '1') then
	if (Clock_En = '1') then
		SWINAFltr <= SWInAFltr(2 downto 0) & d_SWINA;
	end if;
end if;
end process;

filterB_p : process(Clock, Reset, d_SWinB) 
begin
if (reset = '1') OR (d_SWinB = '0') then
	SWINBFltr <= (others => '0');
elsif (Clock'event and CLock = '1') then
	if (Clock_En = '1') then
		SWINBFltr <= SWInBFltr(2 downto 0) & d_SWINB;
	end if;
end if;
end process;

Sw_p: process(Clock, Reset)
Begin
if (Reset = '1') then
	SWARising	<= '0';
	SWBRising	<= '0';
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
		
	if (Clock_En = '1') then
		if (SWINAFltr = "0111") then
			SWARising <= '1';
		else 
			SWARising <= '0';
		end if;

		if (SWINBFltr = "0111") then
			SWBRising <= '1';
		else 
			SWBRising <= '0';
		end if;
				
		case	DPot_State is
		when Idle_s =>
			iUP 		<= '0';
			iDown 	<= '0';
			if (SWINBFltr = "1111") and (SWARising = '1') then
				DPot_State <= Wait_Down_s;
			elsif (SWINAFltr = "1111") and (SWBRising = '1') then 
				DPot_State <= Wait_Up_s;
			else
				DPot_State <= Idle_s;
			end if;
		When Wait_Up_s =>
			if (SWINBFltr = "0000") then
				iUP <= '1';
				DPot_State <= Idle_s;
			else
				DPot_State <= Wait_Up_s;
			end if;
		When Wait_Down_s =>
			if (SWINAFltr = "0000") then
				iDown 		<= '1';
				DPot_State <= Idle_s;
			else
				DPot_State <= Wait_Down_s;
			end if;
		when others =>
			DPot_State <= Idle_s;
		end case;
	else
		iDown 	<= '0';
		iUp		<= '0';
	end if;
end if;
end process;

Knob_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iKnobCntr <= (Others => '0');
	KnobCntr <= (Others => '0');
elsif (Clock'event and Clock = '1') then

	if (iKnobCntr(17 downto 16) = "01") then -- over flow
		KnobCntr 	<= x"FFFF";
		iKnobCntr 	<= "001111111111111111";
	elsif (iKnobCntr(17 downto 16) = "11") then  -- under flow
		KnobCntr 	<= x"0000";
		iKnobCntr 	<= "000000000000000000";
	else
		KnobCntr <= iKnobCntr(15 downto 0);
	end if;

	if (iUp = '1') then
		if ((RateCntr >= DpotRate(0)) and (RateCntr < DpotRate(1))) then
			iKnobCntr <= iKnobCntr + DPotInc(0);
		elsif ((RateCntr >= DpotRate(1)) and (RateCntr < DpotRate(2))) then
			iKnobCntr <= iKnobCntr + DPotInc(1);
		elsif ((RateCntr >= DpotRate(2)) and (RateCntr < DpotRate(3))) then
			iKnobCntr <= iKnobCntr + DPotInc(2);
		elsif ((RateCntr >= DpotRate(3)) and (RateCntr < DpotRate(4))) then
			iKnobCntr <= iKnobCntr + DPotInc(3);
		elsif ((RateCntr >= DpotRate(4)) and (RateCntr < DpotRate(5))) then
			iKnobCntr <= iKnobCntr + DPotInc(4);
		elsif ((RateCntr >= DpotRate(5)) and (RateCntr < DpotRate(6))) then
			iKnobCntr <= iKnobCntr + DPotInc(5);
		elsif ((RateCntr >= DpotRate(6)) and (RateCntr < DpotRate(7))) then
			iKnobCntr <= iKnobCntr + DPotInc(6);
		elsif ((RateCntr >= DpotRate(7)) and (RateCntr < DpotRate(8))) then
			iKnobCntr <= iKnobCntr + DPotInc(7);
		elsif ((RateCntr >= DpotRate(8)) and (RateCntr < DpotRate(9))) then
			iKnobCntr <= iKnobCntr + DPotInc(8);
		end if;
		
	elsif (iDown = '1') then
		if ((RateCntr >= DpotRate(0)) and (RateCntr < DpotRate(1))) then
			iKnobCntr <= iKnobCntr - DPotInc(0);
		elsif ((RateCntr >= DpotRate(1)) and (RateCntr < DpotRate(2))) then
			iKnobCntr <= iKnobCntr - DPotInc(1);
		elsif ((RateCntr >= DpotRate(2)) and (RateCntr < DpotRate(3))) then
			iKnobCntr <= iKnobCntr - DPotInc(2);
		elsif ((RateCntr >= DpotRate(3)) and (RateCntr < DpotRate(4))) then
			iKnobCntr <= iKnobCntr - DPotInc(3);
		elsif ((RateCntr >= DpotRate(4)) and (RateCntr < DpotRate(5))) then
			iKnobCntr <= iKnobCntr - DPotInc(4);
		elsif ((RateCntr >= DpotRate(5)) and (RateCntr < DpotRate(6))) then
			iKnobCntr <= iKnobCntr - DPotInc(5);
		elsif ((RateCntr >= DpotRate(6)) and (RateCntr < DpotRate(7))) then
			iKnobCntr <= iKnobCntr - DPotInc(6);
		elsif ((RateCntr >= DpotRate(7)) and (RateCntr < DpotRate(8))) then
			iKnobCntr <= iKnobCntr - DPotInc(7);
		elsif ((RateCntr >= DpotRate(8)) and (RateCntr < DpotRate(9))) then
			iKnobCntr <= iKnobCntr - DPotInc(8);
		end if;
	end if;
end if;
end process;
	
end Behaviour;

  