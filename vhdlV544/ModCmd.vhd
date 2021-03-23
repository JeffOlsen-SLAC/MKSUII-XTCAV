-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	ModCmd -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/5/2011 12:30:30 PM
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


entity ModCmd is
Port (
	Clock							: in std_logic;
	Reset 	  					: in std_logic;

-- Link Interface
	Lnk_Addr		 				: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 				: in std_logic;									-- From Link Interface
	Lnk_DataIn					: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut					: out std_logic_vector(15 downto 0);

	Clk10hzEn					: in std_logic;

	MOD_VVS_PWR_Mon 			: in std_logic;
	MOD_KLY_FIL_TD_MON 		: in std_logic;
	MOD_CTRL_PWR_FLT_MON 	: in std_logic;
	MOD_INTLK_COMP_MON		: in std_logic;
	MOD_AVAIL_MON				: in std_logic;
	MOD_HV_RDY_MON 			: in std_logic;
	MOD_TTOC_MON				: in std_logic;
	MOD_EOLC_MON				: in std_logic;
	MOD_HVOC_MON				: in std_logic;
	MOD_EXT_INTLK_MON 		: in std_logic;
	MOD_FAULT_MON				: in std_logic;
	MOD_HV_ON_MON				: in std_logic;

	MOD_VVS_PWR_Test 			: out std_logic;
	MOD_KLY_FIL_TD_Test 		: out std_logic;
	MOD_CTRL_PWR_FLT_Test 	: out std_logic;
	MOD_INTLK_COMP_Test		: out std_logic;
	MOD_AVAIL_Test				: out std_logic;
	MOD_HV_RDY_Test 			: out std_logic;
	MOD_TTOC_Test				: out std_logic;
	MOD_EOLC_Test				: out std_logic;
	MOD_HVOC_Test				: out std_logic;
	MOD_EXT_INTLK_Test 		: out std_logic;
	MOD_FAULT_Test				: out std_logic;
	MOD_HV_ON_Test				: out std_logic;



	Reset_FP						: in std_logic;
	FaultHvOff					: in std_logic;

	FaultReset_Cmd				: out std_logic;
	CtrlPwr_On_Cmd				: out std_logic;
	HV_ON_Cmd     				: out std_logic;
	HV_OFF_Cmd     			: out std_logic;

	Status						: out std_logic_vector(15 downto 0)

	);

end ModCmd;

architecture behaviour of ModCmd is

signal iHvOn		: std_logic;
signal iiHvOn		: std_logic;
signal iHvOff		: std_logic;
signal iiHvOff		: std_logic;
signal ifltRst 	: std_logic;
signal iCtrlPwr 	: std_logic;
signal HvOnRst 	: std_logic;

signal HvOn			: std_logic;
signal HvOff		: std_logic;
signal FltRst 		: std_logic;
signal CtrlPwr 	: std_logic;
signal iStatus		: std_logic_Vector(15 downto 0);
signal TestReg		: std_logic_Vector(15 downto 0);
signal CtrlReg		: std_logic_Vector(15 downto 0);

begin

MOD_VVS_PWR_Test 			<= TestReg(11);
MOD_KLY_FIL_TD_Test 		<= TestReg(10);
MOD_CTRL_PWR_FLT_Test 	<= TestReg(9);
MOD_INTLK_COMP_Test		<= TestReg(8);
MOD_AVAIL_Test				<= TestReg(7);
MOD_HV_RDY_Test 			<= TestReg(6);
MOD_TTOC_Test				<= TestReg(5);
MOD_EOLC_Test				<= TestReg(4);
MOD_HVOC_Test				<= TestReg(3);
MOD_EXT_INTLK_Test 		<= TestReg(2);
MOD_FAULT_Test				<= TestReg(1);
MOD_HV_ON_Test				<= TestReg(0);


FaultReset_Cmd 			<= FltRst;
CtrlPwr_On_Cmd				<= CtrlPwr;
HV_On_Cmd					<= HvOn;
HV_Off_Cmd					<= HvOff;

HvOnRst 						<= Reset OR HvOff;

Status 						<= iStatus;

istatus(15) <=	FltRst;
istatus(14) <=	HvOn;
istatus(13) <=	HvOff ;
istatus(12) <= CtrlPwr;
istatus(11) <=	MOD_VVS_PWR_MON;
istatus(10) <=	MOD_KLY_FIL_TD_MON;
istatus(9) 	<=	MOD_CTRL_PWR_FLT_MON;
istatus(8) 	<=	MOD_INTLK_COMP_MON;
istatus(7) 	<=	MOD_AVAIL_MON;
istatus(6) 	<=	MOD_HV_RDY_MON;
istatus(5) 	<=	MOD_TTOC_MON;
istatus(4) 	<=	MOD_EOLC_MON;
istatus(3) 	<=	MOD_HVOC_MON;
istatus(2) 	<=	MOD_EXT_INTLK_MON;
istatus(1) 	<=	MOD_FAULT_MON;
istatus(0) 	<=	MOD_HV_ON_MON;

CtrlReg(15 downto 4) <= (Others => '0');
CtrlReg(3) <= FltRst;
CtrlReg(2) <= HvOff;
CtrlReg(1) <= HvOn;
CtrlReg(0) <= CtrlPwr;

WrReg : process(Clock, Reset)
Begin
if (reset = '1') then
 	iHvOn		<= '0';
 	iHvOff	<= '0';
 	ifltRst 	<= '0';
 	iCtrlPwr <= '0';
	TestReg	<= (Others => '0');
elsif (Clock'event and 	Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is
			when x"0000" =>
			when x"0001" =>
				iCtrlPwr <= Lnk_DataIn(0);
				iHvOn 	<= Lnk_DataIn(1);
				iHvOff 	<= Lnk_DataIn(2);
				ifltRst 	<= Lnk_DataIn(3);
			when x"0003" =>
				TestReg(11 downto 0) <= Lnk_DataIn(11 downto 0) or TestReg(11 downto 0);

			when x"0004" =>
				TestReg(11 downto 0) <= not(Lnk_DataIn(11 downto 0)) and TestReg(11 downto 0);

			when others =>
		end case;
	else
 		iCtrlPwr <= '0';
		iHvOn 	<= '0';
		iHvOff 	<= '0';
 		ifltRst 	<= '0';
	end if;
end if;
end process;


Rd_Reg : Process(Lnk_Addr, iStatus, CtrlReg, TestReg)
begin
	case Lnk_Addr(3 downto 0) is
		when x"0" => Reg_DataOut 	<= iStatus;
		when x"1" => Reg_DataOut	<= CtrlReg;
		when x"2" => Reg_DataOut	<= TestReg;
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;

iiHvOff 	<= iHvOff OR FaultHVOff;
iiHvOn	<= iHvOn and not(HvOff);

u_hvOn : oneshotCen
generic map(
	N => 4
)
port map (
	Clock 		=> Clock,
	Reset 		=> HvOnRst,
	ClockEn		=> Clk10hzEn,
	Start 		=> iiHvOn,
	RetrigEn 	=> '0',
	Level 		=> '0',
	OS_Time 		=> X"A",
	OS_Out 		=> HvOn
	);

u_hvOff : oneshotCen
generic map(
	N => 4
)
port map (
    Clock 		=> Clock,
    Reset 		=> Reset,
    ClockEn		=> Clk10hzEn,
    Start 		=> iiHvOff,
    RetrigEn 	=> '0',
    Level 		=> '0',
    OS_Time 	=> X"A",
    OS_Out 		=> HvOff
	);

u_CtrlPwr : oneshotCen
generic map(
	N => 4
)
port map (
    Clock 		=> Clock,
    Reset 		=> Reset,
    ClockEn		=> Clk10hzEn,
    Start 		=> iCtrlPwr,
    RetrigEn 	=> '0',
    Level 		=> '0',
    OS_Time 	=> X"A",
    OS_Out 		=> CtrlPwr
	);


u_FltRst : oneshotCen
generic map(
	N => 4
)
port map (
    Clock 		=> Clock,
    Reset 		=> Reset,
    ClockEn		=> Clk10hzEn,
    Start 		=> iFltRst,
    RetrigEn 	=> '0',
    Level 		=> '0',
    OS_Time 	=> X"A",
    OS_Out 		=> FltRst
	);
end behaviour;
