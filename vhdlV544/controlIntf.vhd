-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	control_intf.vhd -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/11/2011 12:08:09 PM
--	Last change: JO 5/6/2013 11:29:30 AM
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


entity control_intf is
Port (
	Clock						: in std_logic;
	Reset						: in std_logic;
	
	FP_Local					: in std_logic;

	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_DataIn				: in std_logic_vector(15 downto 0);			-- From Link Interface
	Reg_DataOut				: out std_logic_vector(15 downto 0);

	Locked					: in std_logic;
	Clk119MhzOk				: in std_logic;
	
	DataClkLocked			: in std_logic;

	TriggerEn				: out std_logic;
	Configured				: out std_logic;
	Permit					: out std_logic;
	UseAccTrigger			: out std_logic;

	PICFault					: in std_logic;

	ArmWFM					: out std_logic;
	ArmAve					: out std_logic;
	WFMArmed					: in std_logic;
	AveArmed					: in std_logic;

	SelfTriggerEn			: out std_logic;

	Accel						: out std_logic;
	Stndby					: out std_logic;
	OFFL						: out std_logic;
	Maint						: out std_logic;
	
	Local						: out std_logic;

	Status					: out std_logic_vector(15 downto 0)

);

end control_intf;

architecture behaviour of control_intf is

signal iCntlReg			: std_logic_vector(15 downto 0);
signal iStateReg			: std_logic_vector(15 downto 0);
signal iStatus				: std_logic_vector(15 downto 0);
signal iMaint				: std_logic;
signal iLocal				: std_logic;
signal iSelfTriggerEn	: std_logic;
signal LocalSr				: std_logic_vector(2 downto 0);
signal iAccel				: std_logic;
signal iStndby				: std_logic;
signal iOFFL				: std_logic;


begin

Local							<= iLocal;
Maint							<= iMaint;
Accel							<= iAccel;
Stndby						<= iStndby;
OFFL							<= iOFFL;

SelfTriggerEn				<= iSelfTriggerEn;

-- jjo 05/06/13 Changed truth table for UseAccTrigger
-- Should have the Link Node input but that is not
-- configured as of 5/6/13

--UseAccTrigger				<= iCntlReg(6);
iSelfTriggerEn				<= iCntlReg(5);
Configured					<= iCntlReg(2);

-- jjo 05/06/13 Added iOFFL to TriggerEn
TriggerEn					<= iCntlReg(1) and not(iOFFL);
Permit						<= iCntlReg(0);

iStatus(15 downto 12)	<= (Others => '0');
iStatus(9)					<= DataClkLocked;
iStatus(8) 					<= iLocal;
iStatus(7) 					<= Locked;
iStatus(6) 					<= Clk119MhzOk;
iStatus(5 downto 3)		<= iStateReg(2 downto 0);
iStatus(2 downto 0)		<= iCntlReg(2 downto 0);

Status <= iStatus;

AccTrig_p : process(iMaint, iAccel, iStndby, iOffl, iCntlReg(6), PICFault)
begin
if ((iAccel = '1') and (PICFault = '0')) then
	UseAccTrigger <= '1';
else
	UseAccTrigger <= '0';
end if;
end process;

state_p : process(iStateReg)
begin
	case iStateReg(2 downto 0) is
		when "001" => iAccel		<= '1';
							iStndby	<= '0';
							iOFFL		<= '0';
							iMaint	<= '0';
		when "010" => iStndby 	<= '1';
							iAccel	<= '0';
							iOFFL		<= '0';
							iMaint	<= '0';
		when "011" => iOffL		<= '1';
							iAccel	<= '0';
							iStndby	<= '0';
							iMaint	<= '0';
		when "100" => iMaint		<= '1';
							iAccel	<= '0';
							iStndby	<= '0';
							iOFFL		<= '0';
		when others =>
							iAccel	<= '0';
							iStndby	<= '0';
							iOFFL		<= '0';
							iMaint	<= '0';
	end case;
end process;

cntl_p : Process(Clock, Reset)
begin
if (Reset = '1') then
	ArmWfm		<= '0';
	ArmAve		<= '0';
elsif (clock'event and Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is
			when x"0000" =>		
				iStatus(11) <= (iStatus(11) and Not(Lnk_DataIn(11))) OR not(DataClkLocked);
				iStatus(10) <= (iStatus(10) and Not(Lnk_DataIn(10))) OR not(Locked);
			when x"0001" =>
				iStatus(11) <= iStatus(11) OR not(DataClkLocked);
				iStatus(10) <= iStatus(10) OR not(Locked);
				iCntlReg	 	<= Lnk_DataIn OR iCntlReg;
				ArmWFM		<= Lnk_DataIn(3);
				ArmAve		<= Lnk_DataIn(4);
  			when x"0002" =>
				iStatus(11) <= iStatus(11) OR not(DataClkLocked);
				iStatus(10) <= iStatus(10) OR not(Locked);
				iCntlReg 	<= not(Lnk_DataIn) and iCntlReg;
			when x"0003" =>
				iStatus(11) <= iStatus(11) OR not(DataClkLocked);
				iStatus(10) <= iStatus(10) OR not(Locked);
				iStateReg	<= Lnk_DataIn;
			when others =>
		end case;
	else
		ArmWFM		<= '0';
		ArmAve		<= '0';
		iStatus(11) <= iStatus(11) OR not(DataClkLocked);
		iStatus(10) <= iStatus(10) OR not(Locked);
	end if;
end if;
end process;

Rd_p : process(Lnk_Addr, iStatus, iCntlReg, iStateReg, AveArmed, WFMArmed, iSelfTriggerEn)
begin
	Case Lnk_Addr(3 downto 0) is
		when x"0" =>
			Reg_DataOut <= iStatus;
		when x"1" =>
			Reg_DataOut <= "000000000" & iCntlReg(6) & iSelfTriggerEn & AveArmed & WFMArmed & iCntlReg(2 downto 0);
		when x"2" =>
         Reg_DataOut <= "0000000000000" & iStateReg(2 downto 0);
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;

local_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iLocal	<= '0';
elsif (Clock'event and Clock = '1') then
	LocalSr <= LocalSr(1 downto 0) & FP_Local;
	if ((iMaint = '1') and (LocalSr(2 downto 1) = "01")) then
		iLocal <= '1';
	elsif ((iMaint = '0') or (FP_Local = '0')) then
		iLocal <= '0';
	end if;
end if;
end process;

end behaviour;

