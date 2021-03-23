	
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
signal RateCntr	: std_logic_vector(15 downto 0);
signal GrayCnt		: std_logic_vector(1 downto 0);
signal DirUp		: std_logic;
signal DirDown		: std_logic;
signal ValidUp		: std_logic;
signal ValidDown	: std_logic;

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

type DPotRate_t is array(9 downto 0) of std_logic_vector(7 downto 0);
Constant DPotRate 	: DpotRate_t := 
(
	0 => x"04",  
	1 => x"10",  
	2 => x"1C", 
	3 => x"28",  
	4 => x"34",  
	5 => x"40",  
	6 => x"4C",   -- 76ms
	7 => x"58",   -- 88ms
	8 => x"64",   -- 100ms
	9 => x"C8"    -- 200ms  
);

type DPotInc_t is array(9 downto 0) of std_logic_vector(15 downto 0);
Constant DPotInc : DPotInc_t :=
(
	0 => x"32C8",
	1 => x"0DAC",
	2 => x"04B0",
	3 => x"015E",
	4 => x"0064", 
	5 => x"0023",  
	6 => x"000A",  
	7 => x"0003",  
	8 => x"0001",  
	9 => x"0000"  
);



Begin

UP 	<= iUp;
Down 	<= iDown;

GrayCnt <= Pot_B & Pot_A;

Sw_p: process(Clock, Reset)
Begin
if (Reset = '1') then
	iUP			<= '0';
	iDown			<= '0';
	DirUp			<= '0';
	DirDown		<= '0';
	ValidUp		<= '0';
	ValidDown	<= '0';
	RateCntr 	<= (Others => '0');
	DPot_State 	<= Idle_s;
elsif (Clock'event and CLock = '1') then
	if ((iUp = '1') or (iDown = '1')) then
		RateCntr <= (Others => '0');
	elsif ((RateCntr /= x"FF")  and (Clock_En = '1')) then
		RateCntr <= RateCntr + 1;
	end if;	
	
	if ((DirUp = '1') and (iUp = '1')) then
		ValidUp <= '1';
	elsif (DirUp = '0') then
		ValidUp <= '0';
	end if;
	
	if ((DirDown = '1') and (iDown = '1')) then
		ValidDown <= '1';
	elsif (DirDown = '0') then
		ValidDown <= '0';
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
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;
		
	When up_1_s =>
		if (GrayCnt = "01") then
			DPot_State 	<= up_0_s;
		elsif (GrayCnt = "11") then
			DPot_State 	<= up_1_s;
		else
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;

	When up_0_s =>
		if (GrayCnt = "00") then
			DirUp 		<= '1';
			DirDown		<= '0';
			if (DirUp = '1') then
				iUp 			<= '1';
			end if;

			DPot_State 	<= Idle_s;
		elsif (GrayCnt = "01") then
			DPot_State 	<= up_0_s;
		else
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;

	When Down_3_s =>
		if (GrayCnt = "11") then
			DPot_State 	<= Down_2_s;
		elsif (GrayCnt = "01") then
			DPot_State 	<= Down_3_s;
		else
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;

	When Down_2_s =>
		if (GrayCnt = "10") then
			DPot_State 	<= Down_0_s;
		elsif (GrayCnt = "11") then
			DPot_State 	<= Down_2_s;
		else
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;
		
	When Down_0_s =>
		if (GrayCnt = "00") then
			DirUp		<= '0';
			DirDown	<= '1';
			if (DirDown = '1') then
				iDown			<= '1';
			end if;

			
			DPot_State 	<= Idle_s;
		elsif (GrayCnt = "10") then
			DPot_State 	<= Down_0_s;
		else
			DirUp 		<= '0';
			DirDown		<= '0';
			DPot_State 	<= Idle_s;
		end if;
		
		
	when others =>
		DirUp 		<= '0';
		DirDown		<= '0';
		DPot_State 	<= Idle_s;
	end case;

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

	if ((iUp = '1') and (ValidUp = '1')) then
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
		
	elsif ((iDown = '1') and (ValidDown = '1')) then
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

  