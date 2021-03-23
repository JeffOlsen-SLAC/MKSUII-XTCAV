-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	FrontPanel_LED - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 5/27/2011 1:11:42 PM
--

-- jjo 05/29/13
-- Add one-shot to all leds
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;


library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity FrontPanel_LED is
Port (
	Clock 	  		: in std_logic;
	Reset 	  		: in std_logic;
	ClkEn				: in std_logic;
	FP_ClkEn			: in std_logic;

	Configured 		: in std_logic;
	Sw_Local		 	: in std_logic;
	Mode_Local		: in std_logic;
	LED_Test	  		: in std_logic;
	
	LED_Out	  		: out std_logic_vector(28 downto 0);

	ACCEL1			: in std_logic;
	ACCEL2			: in std_logic;
	WG_WATER1  		: in std_logic;
	WG_WATER2  		: in std_logic;
	KLY_WATER  		: in std_logic;
	WG_VAC_INTLK	: in std_logic;
	WG_VALVE			: in std_logic;
	KLY_VAC_INTLK	: in std_logic;
	KLY_DELTA_T		: in std_logic;	
	KLY_MAG_INTLK	: in std_logic;
	TANK_FAULT		: in std_logic;
	PUMPII_FAULT	: in std_logic;
	MOD_OV			: in std_logic;
	MOD_OI			: in std_logic;
	FWR_PWR 			: in std_logic;
	OFFLINE			: in std_logic;
	RF_PWR 			: in std_logic;
	MAINTENANCE		: in std_logic;
	TCVAC				: in std_logic;
	STANDBY 			: in std_logic;
	SPARE1 			: in std_logic;
	ACCELERATE 		: in std_logic;
	SPARE2 			: in std_logic;
	DRIVE_FAULT 	: in std_logic;
	MOD_AVAIL		: in std_logic;
	TRIGGEREN		: in std_logic;
	HEARTBEAT		: in std_logic;
	BATTERY_FAULT 	: in std_logic;
	FAULT_LIMIT 	: in std_logic
	);

end FrontPanel_LED;

architecture Behavioral of FrontPanel_LED is

signal Inputs 				: std_logic_vector(28 downto 0);
signal Inputs_Os 			: std_logic_vector(28 downto 0);
signal iFPLED 				: std_logic_vector(28 downto 0);
signal FPLEDSR				: std_logic_vector(28 downto 0);
signal Blink   			: std_logic;
signal Cntr	   			: std_logic_vector(7 downto 0);
signal HeartBeat_LED   	: std_logic;

begin

LED_Out		<= iFPLED;

Inputs(0) 	<= ACCEL1;
Inputs(1) 	<= ACCEL2;
Inputs(2) 	<= WG_WATER1;
Inputs(3) 	<= WG_WATER2;
Inputs(4) 	<= KLY_WATER;
Inputs(5) 	<= WG_VAC_INTLK;
Inputs(6) 	<= WG_VALVE;
Inputs(7) 	<= KLY_VAC_INTLK;
Inputs(8) 	<= KLY_DELTA_T;
Inputs(9) 	<= KLY_MAG_INTLK;
Inputs(10)	<= TANK_FAULT;
Inputs(11)	<= PUMPII_FAULT;
Inputs(12)	<= MOD_OV;
Inputs(13)	<= MOD_OI;
Inputs(14)	<= FWR_PWR;
Inputs(15)	<= OFFLINE;
Inputs(16)	<= RF_PWR;
Inputs(17)	<= MAINTENANCE;
Inputs(18)	<= TCVAC;
Inputs(19)	<= STANDBY;
Inputs(20)	<= Mode_Local;
Inputs(21)	<= ACCELERATE;
Inputs(22)	<= SPARE2;
Inputs(23)	<= DRIVE_FAULT;
Inputs(24)	<= MOD_AVAIL;
Inputs(25)	<= TriggerEn;
Inputs(26)	<= '0';
Inputs(27)	<= BATTERY_FAULT;
Inputs(28)	<= FAULT_LIMIT;

FPLED_p : process(Clock, Reset)
Begin
if (reset = '1') then
	Blink 	<= '0';
  	iFPLED 	<= "00000000000000000000000000001";
elsif (Clock'event and 	Clock = '1') then
	if (ClkEn = '1') then
		Cntr <= Cntr + 1;
		IF (Cntr = x"FF") then
			FPLEDSR 	<=  FPLEDSR(27 downto 0) & (FPLEDSR(28) XOR FPLEDSR(7) XOR FPLEDSR(2) XOR NOT(FPLEDSR(15)));
			if (LED_Test = '1') then
				if (Blink = '0') then
					Blink 	<= '1';
				else
					Blink 	<= '0';
				end if;
			end if;
		end if;
	end if;
	
	if (LED_Test = '1') then
		iFPLED 	<= (others => Blink); 
	elsif ((Sw_Local = '1') or (Configured = '1')) then
		iFPLED(25 downto 0) 	<= Inputs_OS(25 downto 0);
		iFPLED(26) 				<= HEARTBEAT_Led;
		iFPLED(28 downto 27) <= Inputs_OS(28 downto 27);
		
	else
		iFPLED	<=	FPLEDSR;
	end if;
end if;
end process;


u_stretch : oneshotCEn4Bit
port map (
	Clock 		=> Clock,
	Reset 		=> Reset,
	ClockEn		=> ClkEn,
	Start 		=> HeartBeat,
	RetrigEn 	=> '1',
	Level 		=> '0',
	OS_Time 		=> "1111",
	OS_Out 		=> HeartBeat_LED
	);

-- jjo 05/29/13
-- Add one-shots to All leds

Gen_Fp : 
for I in 0 to 28 generate
	u_FpStrech : oneshotCEn4Bit
	port map (
		Clock 		=> Clock,
		Reset 		=> Reset,
		ClockEn		=> FP_ClkEn,
		Start 		=> Inputs(I),
		RetrigEn 	=> '1',
		Level 		=> '1',
		OS_Time 		=> "0011",
		OS_Out 		=> Inputs_Os(I)
		);
end generate Gen_Fp;
	

end Behavioral;