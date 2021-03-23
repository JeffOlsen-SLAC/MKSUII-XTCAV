-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	sled_intf.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/11/2011 12:08:09 PM
--	Last change: JO 8/11/2011 9:49:00 AM
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


entity TankPump is
Port (
	Clock						: in std_logic;
	Reset						: in std_logic;
	
-- Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_DataIn				: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut				: out std_logic_vector(15 downto 0);
	
	Fault_Reset				: in std_logic;

	Modulator_On			: in std_logic;

--	SLED_U_DT				: in std_logic;
	PUMPII					: in std_logic;
	TANK_LO					: in std_logic;
	TANK_HI					: in std_logic;
--	SLED_MN_DT				: in std_logic;
--	SLED_MN_T				: in std_logic;

--	SLED_TuneEnable		: out std_logic;
--	SLED_DeTune				: out std_logic;
--	SLED_Tune				: out std_logic;

--	SLED_TimeOut			: out std_logic;
--	SLED_Fault				: out std_logic;
--	SLED_OK					: out std_logic;

	PUMPII_Test				: out std_logic;
	TANK_HI_Test			: out std_logic;
--	MN_T_Test				: out std_logic;
--	U_DT_Test				: out std_logic;
	TANK_LO_Test			: out std_logic;
--	MN_DT_Test				: out std_logic;

	Status					: out std_logic_vector(15 downto 0)
);

end TankPump;

architecture behaviour of TankPump is

signal iStatus		 	: std_logic_vector(15 downto 0);
signal CtrlReg			: std_logic_vector(15 downto 0);
signal TestReg			: std_logic_vector(15 downto 0);

begin

TANK_LO_Test	<= TestReg(5);
TANK_HI_Test	<= TestReg(4);
PUMPII_Test		<= TestReg(2);

Status 			<= iStatus;

iStatus(15) <= '0';
iStatus(14) <= '0';
iStatus(13) <= TANK_LO;
iStatus(12) <= TANK_HI;
iStatus(11) <= '0';
iStatus(10) <= PUMPII;
iStatus(9 downto 0) <= "0000000000";

wr_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	CtrlReg 				<= (Others => '0');
	TestReg				<= (Others => '0');
elsif (Clock'event and Clock = '1') then
If (Lnk_Wr = '1') then
	case Lnk_Addr is
		when x"0003" =>
			TestReg(5 downto 0) <= Lnk_DataIn(5 downto 0) or TestReg(5 downto 0);
		when x"0004" =>
			TestReg(5 downto 0) <= (not(Lnk_DataIn(5 downto 0)) and TestReg(5 downto 0));
		when others =>
	end case;
end if;
end if;
end process;

rd_p : process(Lnk_Addr, iStatus, CtrlReg, TestReg)
Begin
	case Lnk_Addr(3 downto 0) is
		when x"0" => Reg_DataOut <= iStatus;
		when x"2" => Reg_DataOut <= (15 downto 6 => '0') & TestReg(5 downto 4) & '0' & TestReg(2) & "00";
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;

end;

