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


entity Sled_Intf is
Port (
	Clock						: in std_logic;
	Reset						: in std_logic;
	
-- Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_DataIn				: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut				: out std_logic_vector(15 downto 0);
	
	
	Clk1KhzEn				: in std_logic;
	Fault_Reset				: in std_logic;

	Modulator_On			: in std_logic;

	SLED_U_DT				: in std_logic;
	SLED_U_T					: in std_logic;
	SLED_L_DT				: in std_logic;
	SLED_L_T					: in std_logic;
	SLED_MN_DT				: in std_logic;
	SLED_MN_T				: in std_logic;

	SLED_TuneEnable		: out std_logic;
	SLED_DeTune				: out std_logic;
	SLED_Tune				: out std_logic;

	SLED_TimeOut			: out std_logic;
	SLED_Fault				: out std_logic;
	SLED_OK					: out std_logic;

	U_T_Test					: out std_logic;
	L_T_Test					: out std_logic;
	MN_T_Test				: out std_logic;
	U_DT_Test				: out std_logic;
	L_DT_Test				: out std_logic;
	MN_DT_Test				: out std_logic;

	Status					: out std_logic_vector(15 downto 0)
);

end Sled_Intf;

architecture behaviour of Sled_Intf is

signal TimeoutCntr 	: std_logic_vector(15 downto 0);
signal Tuned 			: std_logic;
signal DeTuned 		: std_logic;
signal MotorOn			: std_logic;
signal iEn_Sled		: std_logic;
signal T_Sled			: std_logic;
signal DT_Sled			: std_logic;
signal L_T				: std_logic;
signal U_T				: std_logic;
signal MN_T				: std_logic;
signal L_DT				: std_logic;
signal U_DT				: std_logic;
signal MN_DT			: std_logic;
signal iSLED_TimeOut	: std_logic;
signal TOLatch			: std_logic;
signal iStatus		 	: std_logic_vector(15 downto 0);
signal CtrlReg			: std_logic_vector(15 downto 0);
signal TestReg			: std_logic_vector(15 downto 0);
signal ClrEn_Sled		: std_logic;
signal iSLED_DeTune	: std_logic;
signal iSLED_Tune		: std_logic;


type Sled_t is
(	Idle_s,
	Tune_s,
	DeTune_s
);

signal Sled_State : Sled_t;

begin

L_DT_Test	 	<= TestReg(5);
L_T_Test		 	<= TestReg(4);
U_DT_Test	 	<= TestReg(3);
U_T_Test		 	<= TestReg(2);
MN_DT_Test	 	<= TestReg(1);
MN_T_Test	 	<= TestReg(0);

SLED_DeTune		<= iSLED_DeTune;
SLED_Tune		<= iSLED_Tune;

Status 			<= iStatus;

iStatus(15) <= '0';
iStatus(14) <= '0';
iStatus(13) <= SLED_L_DT;
iStatus(12) <= SLED_L_T;
iStatus(11) <= SLED_U_DT;
iStatus(10) <= SLED_U_T;
iStatus(9) <= SLED_MN_DT;
iStatus(8) <= SLED_MN_T;
iStatus(7) <= '0';
iStatus(6) <= MotorOn;
iStatus(5) <= iEn_Sled;
iStatus(4) <= iSLED_DeTune;
iStatus(3) <= iSLED_Tune;
iStatus(2) <= DeTuned;
iStatus(1) <= Tuned;
iStatus(0) <= TOLatch;

Pipeline_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	SLED_TimeOut 	<= '0';
	SLED_OK			<= '0';
	SLED_FAULT 		<= '0';
	Tuned 			<= '0';
	DeTuned 			<= '0';
elsif (Clock'event and Clock = '1') then
	SLED_TimeOut 	<= TOLatch;

	SLED_OK			<= (Tuned OR DeTuned) and NOT(MotorOn) and NOT(TOLatch);
	SLED_FAULT 		<= (NOT(Tuned) and NOT(DeTuned)) OR TOLatch;

--Redefined Tuned and DeTuned

	Tuned 			<= L_T and U_T and MN_DT and
						NOT(L_DT) and NOT(U_DT) and NOT(MN_T);

	DeTuned 			<= L_DT and U_DT and MN_T and
						NOT(L_T) and NOT(U_T) and not(MN_DT);
end if;
end process;


wr_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	TOLatch				<= '0';
	T_SLED 				<= '0';
	iEn_Sled 			<= '0';
	DT_SLED 				<= '0';
	CtrlReg 				<= (Others => '0');
	TestReg				<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	If (Lnk_Wr = '1') then
		case Lnk_Addr is
			when x"0000" =>
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				elsif (Lnk_DataIn(0) = '1') then
					TOLatch <= '0';
				end if;

			when x"0001" =>
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				end if;
				if (ClrEn_Sled = '1') then
					iEn_Sled <= '0';
					T_SLED 	<= '0';
					DT_SLED 	<= '0';
				else
					iEn_Sled	<= (Lnk_DataIn(0) or CtrlReg(0));
					T_SLED	<= (Lnk_DataIn(1) and not(Lnk_DataIn(2)));
					DT_SLED	<= (Lnk_DataIn(2) and not(Lnk_DataIn(1)));
					CtrlReg(2 downto 0)	<= Lnk_DataIn(2 downto 0) or CtrlReg(2 downto 0);
				end if;
				
			when x"0002" =>
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				end if;
				if (ClrEn_Sled = '1') then
					iEn_Sled <= '0';
					T_SLED 	<= '0';
					DT_SLED 	<= '0';
				else
					iEn_Sled	<= (not(Lnk_DataIn(0)) and CtrlReg(0));
					CtrlReg(2 downto 0)	<= (not(Lnk_DataIn(2 downto 0)) and CtrlReg(2 downto 0));
				end if;

			when x"0003" =>
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				end if;
				if (ClrEn_Sled = '1') then
					iEn_Sled <= '0';
					T_SLED 	<= '0';
					DT_SLED 	<= '0';
				end if;

				TestReg(5 downto 0) <= Lnk_DataIn(5 downto 0) or TestReg(5 downto 0);

			when x"0004" =>
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				end if;
				if (ClrEn_Sled = '1') then
					iEn_Sled <= '0';
					T_SLED 	<= '0';
					DT_SLED 	<= '0';
				end if;

				TestReg(5 downto 0) <= (not(Lnk_DataIn(5 downto 0)) and TestReg(5 downto 0));

			when others =>
				if (ClrEn_Sled = '1') then
					iEn_Sled <= '0';
					T_SLED 	<= '0';
					DT_SLED 	<= '0';
				end if;	
				if (iSLED_Timeout = '1') then
					TOLatch <= '1';
				end if;
		end case;
	else
		if (ClrEn_Sled = '1') then
			iEn_Sled <= '0';
			T_SLED 	<= '0';
			DT_SLED 	<= '0';
		end if;	
		if (iSLED_Timeout = '1') then
			TOLatch <= '1';
		end if;
		DT_SLED 	<= '0';
		T_SLED 	<= '0';
	end if;
end if;
end process;

rd_p : process(Lnk_Addr, iStatus, CtrlReg, TestReg, iEn_Sled)
Begin
	case Lnk_Addr(3 downto 0) is
		when x"0" => Reg_DataOut <= iStatus;
		when x"1" => Reg_DataOut <= CtrlReg(15 downto 1) & iEn_Sled;
		when x"2" => Reg_DataOut <= TestReg;
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;


u_LT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_L_T,
	Dout 		=> L_T
	);

u_UT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_U_T,
	Dout 		=> U_T
	);

u_MNT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_MN_T,
	Dout 		=> MN_T
	);

u_LDT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_L_DT,
	Dout 		=> L_DT
	);

u_UDT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_U_DT,
	Dout 		=> U_DT
	);

u_MNDT : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> SLED_MN_DT,
	Dout 		=> MN_DT
	);

TimeOut_p :  process(Clock, reset)
Begin
if (Reset = '1') then
	TimeoutCntr 		<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if ((T_Sled = '1') or (DT_Sled = '1')) then
		TimeoutCntr 	<= Sled_TimeoutMax;
	elsif ((Clk1khzEn = '1') and (MotorOn = '1')) then
		TimeoutCntr 	<= TimeoutCntr - 1;
	end if;
end if;
end process;

SledCntl_p : process(Clock, Reset, Fault_Reset)
Begin
if ((Reset = '1') or (Fault_Reset = '1')) then
	MotorOn 				<= '0';
	SLED_TuneEnable	<= '0';
	iSLED_Tune			<= '0';
	iSLED_DeTune		<= '0';
	iSled_Timeout 		<= '0';
	ClrEn_Sled			<= '0';
	Sled_State 			<= Idle_s;
elsif (Clock'event	and Clock = '1') then
	case Sled_State is
	when Idle_s =>
		ClrEn_Sled		<= '0';
		iSled_Timeout 	<= '0';
--		if ((T_Sled = '1')  and (Modulator_On = '0')
		if ((T_Sled = '1')  and (iEn_Sled = '1') and (TOLatch = '0')) then
			SLED_TuneEnable	<= '1';
			iSLED_Tune			<= '1';
			iSLED_DeTune		<= '0';
			Sled_State			<= Tune_s;
--		elsif ((DT_Sled = '1') and (Modulator_On = '0')
		elsif ((DT_Sled = '1') and (iEn_Sled = '1') and (TOLatch = '0')) then
			SLED_TuneEnable	<= '1';
			iSLED_Tune			<= '0';
			iSLED_DeTune		<= '1';
			Sled_State			<= DeTune_s;
		else
			MotorOn 				<= '0';
			SLED_TuneEnable	<= '0';
			iSLED_Tune			<= '0';
			iSLED_DeTune		<= '0';
			Sled_State			<= Idle_s;
		end if;
		
	when Tune_s =>
		if (TimeoutCntr = x"0000") then
			MotorOn 			<= '0';
			iSled_Timeout 	<= '1';
			ClrEn_Sled		<= '1';
			Sled_State 		<= Idle_s;
		elsif ((Tuned = '1') or (iEn_Sled = '0')) then
			ClrEn_Sled		<= '1';
			MotorOn 			<= '0';
			Sled_State 		<= Idle_s;
		else
			MotorOn 			<= '1';
			Sled_State 		<= Tune_s;
		end if;

	when DeTune_s =>
		if (TimeoutCntr = x"0000") then
			MotorOn 			<= '0';
			iSled_Timeout 	<= '1';
			ClrEn_Sled		<= '1';
			Sled_State 		<= Idle_s;
		elsif ((DeTuned = '1') OR (iEn_Sled = '0')) then
			ClrEn_Sled		<= '1';
			MotorOn 			<= '0';
			Sled_State 		<= Idle_s;
		else
			MotorOn 			<= '1';
			Sled_State 		<= DeTune_s;
		end if;
		
	when others =>
		Sled_State 		<= Idle_s;
	end case;
end if;
end process;
end;

