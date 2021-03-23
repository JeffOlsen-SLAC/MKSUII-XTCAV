-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	FrontPanel_Input -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 5/6/2013 12:59:26 PM
--
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


entity FrontPanel_Input is
Port (
	Clock 	  					: in std_logic;
	Reset 	  					: in std_logic;
	ClkEn							: in std_logic;

	SW_TRIGEN 					: in std_logic;
	SW_TEST 						: in std_logic;
	SW_SPARE2 					: in std_logic;
	SW_SPARE1 					: in std_logic;
	SW_FLT_RST 					: in std_logic;
	SW_LOCAL 					: in std_logic;
	SW_POT2 						: in std_logic;
	SW_POT1						: in std_logic;
	POT2_UP 						: in std_logic;
	POT2_DOWN 					: in std_logic;
	POT1_UP 						: in std_logic;
	POT1_DOWN 					: in std_logic;

	SW_Trigger_Enable_db		: out std_logic;
	SW_Test_db			  		: out std_logic;
	SW_Fault_Reset_db 	  	: out std_logic;
	SW_Fault_Reset_Le  	  	: out std_logic;
	SW_Local_db			 	  	: out std_logic;

	Delay_Up_db 		 	  	: out std_logic;
	Delay_Dn_db 		 	  	: out std_logic;
	Delay_Sw_db 		 	  	: out std_logic;

	Drive_Up_db 			  	: out std_logic;
	Drive_Dn_db 			  	: out std_logic;
	Drive_Sw_db 			  	: out std_logic;

	SW_Inc_db		 	  		: out std_logic;
	SW_Dec_db		 	  		: out std_logic

	);

end FrontPanel_Input;

architecture Behavioral of FrontPanel_Input is

signal dSW_Fault_Reset 		: std_logic;
signal iSW_Fault_Reset_db 	: std_logic;

begin

fprst_p : process(Clock, Reset)
begin
if (Reset = '1') then
	dSW_Fault_Reset <= '0';
elsif (Clock'event and Clock = '1') then
	dSW_Fault_Reset <= iSW_Fault_Reset_db;
	if ((dSW_Fault_Reset = '0' and iSW_Fault_Reset_db = '1')) then -- Le
		SW_Fault_Reset_Le <= '1';
	else
		SW_Fault_Reset_Le <= '0';
	end if;
end if;
end process;

u_sw_Trigen : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_TRIGEN,
	Dout 		=> SW_Trigger_Enable_db
	);

u_SW_TEST : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_TEST,
	Dout 		=> Sw_Test_db
	);

u_SW_FLT_RST : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_FLT_RST,
	Dout 		=> iSW_Fault_Reset_db
	);

u_SW_LOCAL : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_LOCAL,
	Dout 		=> SW_Local_db
	);


u_SW_POT1 : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_POT1,
	Dout 		=> Delay_Sw_db
	);

u_SW_POT2 : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_POT2,
	Dout 		=> Drive_Sw_db
	);

u_POT1_Up : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> POT1_Up,
	Dout 		=> Delay_Up_db
	);

u_POT1_Dn : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> POT1_Down,
	Dout 		=> Delay_Dn_db
	);

u_POT2_Up : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> POT2_Up,
	Dout 		=> Drive_Up_db
	);

u_POT2_Dn : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> POT2_Down,
	Dout 		=> Drive_Dn_db
	);

u_SW_Spare1 : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_Spare1,
	Dout 		=> SW_Inc_db
	);
	
u_SW_Spare2 : DeBounce
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> ClkEn,
	Din 		=> SW_Spare2,
	Dout 		=> SW_Dec_db
	);

end Behavioral;