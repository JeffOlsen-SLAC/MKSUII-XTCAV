		-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	TempADC -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/5/2011 10:06:50 AM
--
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_SIGNED.ALL;

library work;
use work.mksuii.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity TempADC is
Port (
	Clock						: in std_logic;
	Reset 	  				: in std_logic;
	Clk1MhzEn				: in std_logic;

	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_DataIn		 		: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_DataOut				: out std_logic_vector(15 downto 0);		-- To Link Interface

	TempSClk					: out std_logic;
	TempSDOut				: out std_logic;
	TempSDIn					: in std_logic;
	Temp_Out_Cs				: out std_logic;
	Temp_In_Cs				: out std_logic;

	InTemp					: out std_logic_vector(15 downto 0);
	OutTemp					: out std_logic_vector(15 downto 0);

	DeltaTemp				: out std_logic_vector(15 downto 0);
	
	Fault						: out std_logic;

	Status					: out std_logic_vector(4 downto 0)
	);

end TempADC;

architecture behaviour of TempADC is

-- IO Register is only 8 bits, put in upper 8 set bit count to 16
--  not 24
Constant Comm_IOReg		: std_logic_vector(7 downto 0) 	:= x"28";
Constant Data_IOReg		: std_logic_vector(15 downto 0) 	:= x"0200";

Constant Comm_ConfReg	: std_logic_vector(7 downto 0) 	:= x"10";
Constant Data_ConfReg	: std_logic_vector(15 downto 0) 	:= x"3200";

-- Changed filtering from xxx5 to xxxF

Constant Comm_ModeReg	: std_logic_vector(7 downto 0) 	:= x"08";
Constant Data_FSCal		: std_logic_vector(15 downto 0) 	:= x"A00F";
Constant Data_ZeroCal	: std_logic_vector(15 downto 0) 	:= x"800F";
Constant Data_DataReg	: std_logic_vector(15 downto 0) 	:= x"000F";

Constant Comm_RdDataReg	: std_logic_vector(7 downto 0) 	:= x"5C";

signal BitCntr				: std_logic_vector(5 downto 0);
signal iTempSClk			: std_logic;
signal ADCOutSr			: std_logic_vector(23 downto 0);
signal iTempSr				: std_logic_vector(15 downto 0);
signal iTempSel			: std_logic_vector(1 downto 0);
signal ADCRdy				: std_logic;
signal ADCToCntr			: std_logic_vector(19 downto 0);
signal iADCTo 				: std_logic_vector(1 downto 0);
signal iTempSDin			: std_logic;
signal iDeltaTemp			: std_logic_Vector(16 downto 0);
signal TempOffset			: std_logic_Vector(15 downto 0);
signal InputOutofRange	: std_logic;
signal OutputOutofRange	: std_logic;
signal OutofRange			: std_logic_Vector(1 downto 0);
signal OMinusI				: std_logic_Vector(16 downto 0);
signal OverTemp			: std_logic;
signal iStatus				: std_logic_Vector(4 downto 0);
signal InTemp_Count		: std_logic_Vector(15 downto 0);
signal OutTemp_Count		: std_logic_Vector(15 downto 0);
signal DeltaTempMax		: std_logic_Vector(15 downto 0);

type TempState_t is
(
	Power_On_s,			-- Wait ~48us just for the heck of it
	Reset_s,				-- Send 48 '1's to then ADC to reset it
	Init_s,				-- Configure IO register
	Tx_IO_s,			-- 
	Tx_Conf_s,			-- 
	Tx_FSCal_S,
	Tx_ZeroCal_s,
	Tx_LdMode_s,
	Tx_LdCont_s,
	Init_Done_s,
	Rd_Loop_s,
	Tx_Sync_s,
	Tx_Data_s,
	Tx_Term_s,
	Rx_Data_s,
	Rx_Term_s
);


signal TempState 		: TempState_t;
signal ReturnState 	: TempState_t;

constant MinRange		: std_logic_vector(16 downto 0) := '0' & x"E8B8"; -- 25 Deg C
constant MaxRange		: std_logic_vector(16 downto 0) := '0' & x"65AA"; -- 45 Deg C

begin

DeltaTemp		<= iDeltaTemp(15 downto 0);

TempSClk			<= iTempSClk;
TempSDOut		<= ADCOutSr(23);

InTemp			<= InTemp_Count when iADCTo(1) = '0' else x"7FFF";
OutTemp			<= OutTemp_Count when iADCTo(0) = '0' else x"7FFF";


Status 			<= iStatus;

-- If Out > In temperature
-- then OCount < InCount


u_OutMinusIn : process(Clock, Reset)
begin
if (Reset = '1') then
	OMinusI 		<= (Others => '0');
	iDeltaTemp 	<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	OMinusI 		<= ('0' & InTemp_Count) - ('0' & OutTemp_Count);
	iDeltaTemp 	<= OMinusI - ('0' & TempOffset);
end if;
end process;

OutOfRange <= InputOutofRange & OutputOutofRange;

range_p : process(Clock, Reset)
begin
if (Reset = '1') then
	InputOutofRange 	<= '0';
	OutputOutofRange 	<= '0';
	OverTemp				<= '0';
elsif (Clock'event and Clock = '1') then
-- 25 Deg Min Range = 59577
-- 45 Deg Max Range = 26026
-- 
	if (iStatus(4 downto 0) = "0000") then
		Fault <= '0';
	else
		Fault <= '1';
	end if;

	if ('0'& InTemp_Count < MinRange) and ('0' & InTemp_Count > MaxRange) then
		InputOutofRange <= '0';
	else
		InputOutofRange <= '1';
	end if;
	
	if ('0' & OutTemp_Count < MinRange) and ('0' & OutTemp_Count > MaxRange) then
		OutputOutofRange <= '0';
	else
		OutputOutofRange <= '1';
	end if;
	
	if (iDeltaTemp > DeltaTempMax) then
		OverTemp <= '1';
	else
		OverTemp <= '0';
	end if;
end if;
end process;


outMux_p : process (Lnk_Addr, iStatus, 
			TempOffset, iDeltaTemp, InTemp_Count, OutTemp_Count, DeltaTempMax)
begin
case Lnk_Addr(3 downto 0) is
when x"0" =>
	Lnk_DataOut		<= "00000000000" & iStatus;
when x"1" =>
	Lnk_DataOut 	<= TempOffset;
when x"2" =>
	Lnk_DataOut 	<= DeltaTempMax;
when x"3" =>
	Lnk_DataOut 	<= iDeltaTemp(15 downto 0);
when x"4" =>
	Lnk_DataOut 	<= OutTemp_Count;
when x"5" =>
	Lnk_DataOut 	<= InTemp_Count;
when others =>
	Lnk_DataOut 	<= (Others => '0');
end case;
end process;


in_sync_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iTempSDin 	<= '0';
	ADCRdy		<= '0';
elsif (Clock'event and Clock = '1') then
	iTempSDin 	<= TempSDin;
	ADCRdy 		<= not(iTempSDin);
end if;
end process;

Status_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iStatus <= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is
			when x"0000" =>
				iStatus(1 downto 0)	<= (iStatus(1 downto 0) OR iADCTo) AND NOT(Lnk_DataIn(1 downto 0));
				iStatus(3 downto 2)	<= (iStatus(3 downto 2) OR OutofRange) AND NOT(Lnk_DataIn(3 downto 2));
				iStatus(4)				<= (iStatus(4) OR OverTemp) AND Not(Lnk_DataIn(4));

			when x"0001" =>
				TempOffset <= Lnk_DataIn;
				iStatus(1 downto 0)	<= iStatus(1 downto 0) OR iADCTo;
				iStatus(3 downto 2)	<= iStatus(3 downto 2) OR OutofRange;
				iStatus(4)				<= iStatus(4) OR OverTemp;

			when x"0002" =>
				DeltaTempMax <= Lnk_DataIn;
				iStatus(1 downto 0)	<= iStatus(1 downto 0) OR iADCTo;
				iStatus(3 downto 2)	<= iStatus(3 downto 2) OR OutofRange;
				iStatus(4)				<= iStatus(4) OR OverTemp;

			when others =>
				iStatus(1 downto 0)	<= iStatus(1 downto 0) OR iADCTo;
				iStatus(3 downto 2)	<= iStatus(3 downto 2) OR OutofRange;
				iStatus(4)				<= iStatus(4) OR OverTemp;
		end case;
	else
		iStatus(1 downto 0)	<= iStatus(1 downto 0) OR iADCTo;
		iStatus(3 downto 2)	<= iStatus(3 downto 2) OR OutofRange;
		iStatus(4)				<= iStatus(4) OR OverTemp;
	end if;
end if;
end process;
	
temperature_p : process(Clock, Reset)
begin
if (Reset = '1') then
	BitCntr			<= (Others => '0');
	ADCOutSr			<= (Others => '0');
	iTempSr			<= (Others => '0');
	iTempSel			<= (Others => '0');
	ADCToCntr 		<= (Others => '0');
	iADCTo 			<= "00";
	iTempSClk		<= '0';
	Temp_Out_Cs		<= '0';
	Temp_In_Cs		<= '0';
	TempState 		<= Power_On_s;
elsif (Clock'event and Clock = '1') then
	if (Clk1MhzEn = '1') then
		case TempState is
		when Power_On_s =>
			iTempSClk 		<= '1';
			if (BitCntr = "111111") then
				iTempSel 		<= "01";
				Temp_Out_Cs		<= '1';
				Temp_In_Cs		<= '0';
				ADCOutSr(23)	<= '1';
				BitCntr 			<= "000000";
				TempState 		<= Reset_s;
			else
				BitCntr 			<= BitCntr +1;
				TempState 		<= Power_On_s;
			end if;
			
-- Drive Din for > 32 clocks to force a reset
		when Reset_s =>
			ADCOutSr(23)	<= '1';
			BitCntr 	<= BitCntr +1;
			if (BitCntr = "111111") then
				iTempSClk 		<= '1';
				Temp_Out_Cs		<= '0';
				Temp_In_Cs		<= '0';
				TempState 		<= Tx_IO_s;
			else
				iTempSClk 		<= not(iTempSClk);
				TempState 		<= Reset_s;
			end if;
			
		when Tx_IO_s =>
			Temp_Out_Cs <= iTempSel(0);
			Temp_In_Cs 	<= iTempSel(1);
			BitCntr 		<= "001111";
			ADCOutSr		<= Comm_IOReg & Data_IOReg;
			ReturnState <= Tx_Conf_s;
			TempState 	<= Tx_Sync_s;
			
		when Tx_Conf_s =>
			BitCntr 		<= "010111";
			ADCOutSr		<= Comm_ConfReg & Data_ConfReg;
			ReturnState <= Tx_FSCal_s;
			TempState 	<= Tx_Sync_s;
			
		when Tx_FSCal_s =>
			BitCntr 		<= "010111";
			ADCOutSr		<= Comm_ModeReg & Data_FSCal;
			ADCToCntr 	<= (Others => '0');
			ReturnState <= Tx_ZeroCal_s;
			TempState 	<= Tx_Sync_s;
			
		when Tx_ZeroCal_s =>
			ADCToCntr <= ADCToCntr + 1;
			if (ADCToCntr = x"FFFFF") then -- 1sec
				iADCTo		<= iTempSel;
				TempState 	<= Power_On_s;
			elsif (ADCRdy = '1') then
				Temp_Out_Cs <= '0';
				Temp_In_Cs 	<= '0';
				BitCntr		<= "010111";
				ADCOutSr		<= Comm_ModeReg & Data_ZeroCal;
				ADCToCntr	<= (Others => '0');
				ReturnState <= Tx_LdMode_s;
				TempState	<= Tx_Sync_s;
			else
				Temp_Out_Cs <= iTempSel(0);
				Temp_In_Cs 	<= iTempSel(1);
				TempState	<= Tx_ZeroCal_s;
			end if;
			
		when Tx_LdMode_s =>
			ADCToCntr <= ADCToCntr + 1;
			if (ADCToCntr = "11111111111111111") then
				iADCTo		<= iTempSel;
				TempState	<= Power_On_s;
			elsif (ADCRdy = '1') then
				Temp_Out_Cs <= '0';
				Temp_In_Cs 	<= '0';
				BitCntr		<= "010111";
				ADCOutSr		<= Comm_ModeReg & Data_DataReg;
				ADCToCntr	<= (Others => '0');
				ReturnState <= Tx_LdCont_s;
				TempState	<= Tx_Sync_s;
			else
				Temp_Out_Cs <= iTempSel(0);
				Temp_In_Cs 	<= iTempSel(1);
				TempState	<= Tx_LdMode_s;
			end if;
			
		when Tx_LdCont_s =>
			BitCntr 		<= "000111";
			ADCOutSr		<= Comm_RdDataReg & x"0000";
			ReturnState <= Init_Done_s;
			TempState	<= Tx_Sync_s;
			
		when Init_Done_s =>
   		if (iTempSel = "10") then
				ADCOutSr(23)<= '0';
				Temp_Out_Cs	<= '1';
				Temp_In_Cs	<= '0';
				iTempSel 	<= "01";
				ADCToCntr	<= (Others => '0');
				TempState 	<= Rd_Loop_s;
			else
				Temp_Out_Cs	<= '0';
				Temp_In_Cs	<= '1';
				iTempSel 	<= "10";
				TempState 	<= Reset_s;
			end if;
			
		when Rd_Loop_s =>
			ADCToCntr 	<= ADCToCntr + 1;
			if (ADCToCntr = "11111111111111111") then
				iADCTo		<= iTempSel;
				TempState	<= Power_On_s;
			elsif (ADCRdy = '1') then
				BitCntr		<= "001111";
				ADCToCntr	<= (Others => '0');
				TempState	<= Rx_Data_s;
			else
				TempState	<= Rd_Loop_s;
			end if;
			
		when Tx_Sync_s =>
			Temp_Out_Cs	<= iTempSel(0);
			Temp_In_Cs	<= iTempSel(1);
			iTempSClk 	<= not(iTempSClk);
			TempState	<= Tx_Data_s;
			
		when Tx_Data_s =>
			iTempSClk <= NOT(iTempSClk);
			if (iTempSClk = '1') then
				ADCOutSr <= ADCOutSr(22 downto 0) & '0';
				if (BitCntr = x"0") then
					Temp_Out_Cs	<= '0';
					Temp_In_Cs	<= '0';
					TempState	<=	Tx_Term_s;
				else
					BitCntr		<= BitCntr - 1;
					TempState	<= Tx_Data_s;
				end if;
			end if;
			
		when Tx_Term_s =>
			ADCOutSr(23)	<= '1';
			if (Clk1MhzEn = '1') then
				iTempSClk 	<= '1';
				TempState	<= ReturnState;
			else
				TempState	<= Tx_Term_s;
			end if;
			
		when Rx_Data_s =>
			iTempSClk <= NOT(iTempSClk);
			if (iTempSClk = '0') then
				iTempSr <= iTempSr(14 downto 0) & TempSDIn;
				if (BitCntr = x"0") then
					iTempSel 	<= not(iTempSel);
					TempState	<=	Rx_Term_s;
				else
					BitCntr		<= BitCntr - 1;
					TempState	<= Rx_Data_s;
				end if;
			end if;
			
		when Rx_Term_s =>
			iTempSClk 	<= '1';
			Temp_Out_Cs	<= iTempSel(0);
			Temp_In_Cs	<= iTempSel(1);
					if (iTempSel(1) = '1') then -- TempSel already inverted
					OutTemp_Count 	<= iTempSr;
				else
					InTemp_Count 	<= iTempSr;
				end if;
			TempState	<=	Rd_Loop_s;
			
		when others =>
			TempState <= Power_On_s;
		end case;
	end if;
end if;
end process;


end behaviour;
