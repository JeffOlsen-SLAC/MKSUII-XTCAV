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

-- jjo 5/23/13
-- Temperatures were giving false readings occasionally
-- Might be that the ADC were in free-run continuous convert mode
-- This could let the ADC Ready "walk" past each other and I could
-- be reading the ADC when it was NOT really ready.

-- Changing the a single read mode.
-- 
-- Data_DataReg   was 000F, Mode 0, Continuous Convert, Rate 4.17Hz
--                    200F, Mode 1, Single Convert, Rate 4.17Hz                      
-- Comm_RdDataReg was 5C, Read Reg 2, Continuous Read
--                    58, Read Reg 2, No Continuous Read
--
-- Move Init_Done_s to after Tx_ZeroCal_s
--
-- Change Readout Loop to include the Tx_LdMode to initiate
-- the single readout
--

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

-- jjo 5/23/13
-- Changed from continuous mode to single
--Constant Data_DataReg	: std_logic_vector(15 downto 0) 	:= x"000F";
-- Changed Data_DataReg to Data_SCONV, starts single Conversion
Constant Data_SCONV	: std_logic_vector(15 downto 0) 	:= x"200F";

-- jjo 5/23/13
-- Changed from Continuous read to single read
--
--Constant Comm_RdDataReg	: std_logic_vector(7 downto 0) 	:= x"5C";

Constant Comm_RdDataReg	: std_logic_vector(7 downto 0) 	:= x"58";

signal BitCntr				: std_logic_vector(5 downto 0);
signal iTempSClk			: std_logic;
signal ADCOutSr			: std_logic_vector(23 downto 0);
signal iTempSr				: std_logic_vector(15 downto 0);
signal iTempSel			: std_logic_vector(1 downto 0);
signal ADCRdy				: std_logic;
signal ADCToCntr			: std_logic_vector(23 downto 0);
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
	Tx_IO_s,				-- 
	Tx_Conf_s,			-- 
	Tx_FSCal_S,
	CSEnA_s,
	Tx_ZeroCal_s,
	CSEnB_s,
	Init_Done_s,
	Tx_StartConv_s,
	CSEnC_s,
	Tx_WaitConv_s,
--	CSEnD_s,
	Tx_ReadCmd,
	Rd_Loop_s,
	Tx_Sync_s,
	Tx_Data_s,
	Tx_Term_s,
	Rx_Data_s,
	Rx_Term_s,
	Delay1_s
);


signal TempState 		: TempState_t;
signal ReturnState 	: TempState_t;

-- 25 Deg Min Range = 59577
-- 45 Deg Max Range = 26026

constant MinRange		: std_logic_vector(16 downto 0) := '0' & x"E8B8"; -- 25 Deg C
constant MaxRange		: std_logic_vector(16 downto 0) := '0' & x"65AA"; -- 45 Deg C

begin

DeltaTemp		<= iDeltaTemp(15 downto 0);

TempSClk			<= iTempSClk;
TempSDOut		<= ADCOutSr(23);

-- jjo 5/23/13
-- Changed iADCTo to iStatus which are latched

--InTemp			<= InTemp_Count when iADCTo(1) = '0' else x"7FFF";
--OutTemp			<= OutTemp_Count when iADCTo(0) = '0' else x"7FFF";

InTemp			<= InTemp_Count when iStatus(1) = '0' else x"7FFF";
OutTemp			<= OutTemp_Count when iStatus(0) = '0' else x"7FFF";

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
-- 
--	if (iStatus(4 downto 0) = "0000") then
--		Fault <= '0';
--	else
--		Fault <= '1';
--	end if;

	if ((InputOutofRange = '1') or (OutputOutofRange = '1') or (OverTemp = '1') or (iADCTO /= "00")) then
		Fault <= '1';
	else
		Fault <= '0';
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
	InTemp_Count	<= (Others => '0');
	OutTemp_Count	<= (Others => '0');
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
			ReturnState <= CSEnA_s;
			TempState 	<= Tx_Sync_s;

-- Make sure CS is asserted before looking for RDY
		when CSEnA_s	=>
			Temp_Out_Cs <= iTempSel(0);
			Temp_In_Cs 	<= iTempSel(1);
			TempState 	<= Tx_ZeroCal_s;
					
		when Tx_ZeroCal_s =>
			ADCToCntr <= ADCToCntr + 1;
			if (ADCToCntr = x"FFFFF") then -- 1sec
-- Change from 17 bits(.131s) to 20bits
				iADCTo		<= iTempSel;
				TempState 	<= Power_On_s;
			elsif (ADCRdy = '1') then
--				Temp_Out_Cs <= '0';
--				Temp_In_Cs 	<= '0';
				BitCntr		<= "010111";
				ADCOutSr		<= Comm_ModeReg & Data_ZeroCal;
				ADCToCntr	<= (Others => '0');
				ReturnState <= CSEnB_s;
				TempState	<= Tx_Sync_s;
			else
				Temp_Out_Cs <= iTempSel(0);
				Temp_In_Cs 	<= iTempSel(1);
				TempState	<= Tx_ZeroCal_s;
			end if;
			
-- Make sure CS is asserted before looking for RDY
		when CSEnB_s	=>
			Temp_Out_Cs <= iTempSel(0);
			Temp_In_Cs 	<= iTempSel(1);
			TempState 	<= Init_Done_s;
			
		when Init_Done_s =>
 			ADCToCntr <= ADCToCntr + 1;
-- Change from 17 bits(.131s) to 20bits
			if (ADCToCntr = x"FFFFF") then
				iADCTo		<= iTempSel;
				TempState	<= Power_On_s;
			elsif (ADCRdy = '1') then
				if (iTempSel = "10") then
					ADCOutSr(23)<= '0';
					Temp_Out_Cs	<= '1';
					Temp_In_Cs	<= '0';
					iTempSel 	<= "01";
					ADCToCntr	<= (Others => '0');
					TempState 	<= Tx_StartConv_s;
				else
					Temp_Out_Cs	<= '0';
					Temp_In_Cs	<= '1';
					iTempSel 	<= "10";
					TempState 	<= Reset_s;
				end if;
			else
					TempState 	<= Init_Done_s;
			end if;
			
		when Tx_StartConv_s =>
				BitCntr		<= "010111";
				ADCOutSr		<= Comm_ModeReg & Data_SCONV;
				ADCToCntr	<= (Others => '0');
				ReturnState <= CSEnC_s;
				TempState	<= Tx_Sync_s;	
		
-- Make sure CS is asserted before looking for RDY
		when CSEnC_s	=>
			Temp_Out_Cs <= iTempSel(0);
			Temp_In_Cs 	<= iTempSel(1);
			TempState 	<= Tx_WaitConv_s;
	
	when Tx_WaitConv_s =>
			ADCToCntr <= ADCToCntr + 1;
-- Change from 17 bits(.131s) to 20bits
--			if (ADCToCntr = "11111111111111111") then
			if (ADCToCntr = x"FFFFF") then
				iADCTo		<= iTempSel;
				TempState	<= Power_On_s;
			elsif (ADCRdy = '1') then
				Temp_Out_Cs <= '0';
				Temp_In_Cs 	<= '0';
				TempState	<= Tx_ReadCmd;
			else
				Temp_Out_Cs <= iTempSel(0);
				Temp_In_Cs 	<= iTempSel(1);
				TempState	<= Tx_WaitConv_s;
			end if;
			
		when Tx_ReadCmd =>
			ADCOutSr		<= Comm_RdDataReg & x"0000";
			BitCntr		<= "000111";

-- jjo 05/23/13
-- Changed returnstate to CSEnC_s
--			ReturnState <= Init_Done_s;
			ReturnState <= Rd_Loop_s;
			TempState	<= Tx_Sync_s;
			
---- Make sure CS is asserted before looking for RDY
--		when CSEnD_s	=>
--			Temp_Out_Cs <= iTempSel(0);
--			Temp_In_Cs 	<= iTempSel(1);
--			TempState 	<= Rd_Loop_s;
						
		when Rd_Loop_s =>
			BitCntr		<= "001111";
			Temp_Out_Cs <= iTempSel(0);
			Temp_In_Cs 	<= iTempSel(1);
			TempState	<= Rx_Data_s;
--			ADCToCntr 	<= ADCToCntr + 1;
--			if (ADCToCntr = "11111111111111111") then
--				iADCTo		<= iTempSel;
--				TempState	<= Power_On_s;
--			elsif (ADCRdy = '1') then
--				BitCntr		<= "001111";
--				ADCToCntr	<= (Others => '0');
--			else
--				TempState	<= Rd_Loop_s;
--			end if;
			
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
-- jjo 5/23/13
-- Don't remember why a 1 is set here
-- Looks ugly in sim so I changed it to a '0';

--			ADCOutSr(23)	<= '1';
			ADCOutSr(23)	<= '0';
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
			Temp_Out_Cs	<= '0';
			Temp_In_Cs	<= '0';
				if (iTempSel(1) = '1') then -- TempSel already inverted
					OutTemp_Count 	<= iTempSr;
				else
					InTemp_Count 	<= iTempSr;
				end if;
				
-- jjo 5/23/13
-- Return to Tx_StartConv_s to start new single convert
--
--			TempState	<=	Rd_Loop_s;
			TempState	<=	Delay1_s;
			
		When Delay1_s =>
			Temp_Out_Cs	<= iTempSel(0);
			Temp_In_Cs	<= iTempSel(1);
			TempState	<=	Tx_StartConv_s;
			
			
		when others =>
			TempState <= Power_On_s;
		end case;
	end if;
end if;
end process;


end behaviour;
