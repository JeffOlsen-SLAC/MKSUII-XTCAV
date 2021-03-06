-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	Mon_ADC_Cntl.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 4:45:25 PM
--	Last change: JO 1/26/2012 3:05:36 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:24:14 02/10/2011 
-- Design Name: 
-- Module Name:    Mon_ADC_Cntl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Library work;
use work.mksuii.all;

entity Mon_ADC_Cntl is
Port ( 
-- System 
	Clock 				: in std_logic;
	Reset 				: in std_logic;
	SlowClkEn 			: in std_logic;
	StartCycle			: in std_logic;
	CycleDone			: out std_logic;
	
-- Link Interface
	Lnk_Addr		 		: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Dav				: out std_logic;									-- To Link Interface
	Lnk_DataOut			: out std_logic_vector(15 downto 0);		-- To Link Interface
	
-- ADC Control and Data
	Wr						: out std_logic;
	Cs 					: out std_logic;
	Rd						: out std_logic;
	Convst				: out std_logic;
	ADC_Clk				: out std_logic;
	EOC					: in std_logic;
	EOLC					: in std_logic;
	ADCDataIn			: in std_logic_vector(11 downto 0);
	
-- System Status
	Status				: out std_logic_vector(15 downto 0)
 );
end Mon_ADC_Cntl;

architecture Behavioral of Mon_ADC_Cntl is

signal ADCDAV 			: std_logic;
signal LoadB			: std_logic;
signal AddB				: std_logic;
signal ADCData 		: std_logic_vector(11 downto 0);
signal AccDout 		: std_logic_vector(15 downto 0);
signal Sum				: std_logic_vector(15 downto 0);
signal SumWr			: std_logic;

signal StoreWe			: std_logic;
signal AveDataOut		: std_logic_vector(15 downto 0);

signal iiChannelCntr	: std_logic_vector(3 downto 0);
signal iChannelCntr	: std_logic_vector(3 downto 0);
signal ChannelCntr	: std_logic_vector(3 downto 0);
signal SampleCntr		: std_logic_vector(3 downto 0);
signal Start			: std_logic;

signal iADC_Clk  		: std_logic;
signal M24VFault		: std_logic;
signal Data16			: std_logic_vector(15 downto 0);

-- 24V +/- 10% => 26.4 to 21.6V
-- Actual supply = 27.7V 
constant LowThreshold : std_logic_vector(15 downto 0) := x"FBF9"; -- -1031
constant HiThreshold  : std_logic_vector(15 downto 0) := x"FCC0"; -- -832



type Mon_State_t is
	(
		Idle_s,
		Load_Acc_s,
		Acc_s,
		Acc_Delay1_s,
		Acc_Delay2_s,
		Acc_Delay3_s,
		Acc_Delay4_s
		);
		
signal Mon_State : Mon_State_t;

constant MaxSamples : integer := 7; -- n-1-1

begin
-- / 16 and sign extend

ADC_Clk <= iADC_Clk;

Data16 		<= Sum(15) & Sum(15) & Sum(15)  & Sum(15 downto 3);
Lnk_DataOut <=  AveDataOut(15) & AveDataOut(15) & AveDataOut(15)  & AveDataOut(15 downto 3);
Status 		<= x"000" & "000" & M24VFault;
Lnk_Dav		<= '0';

Clk_p : process(Clock, Reset)
begin
if (Reset = '1') then
	iADC_Clk <= '0';
elsif (Clock'event and Clock = '1') then
	if (SlowClkEn = '1') then
		iADC_Clk <= NOT(iadc_Clk);
	end if;
end if;
end process;

Mon_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	LoadB 			<= '0';
	AddB				<= '0';
	SumWr				<= '0';
	Start				<= '0';
	StoreWe			<= '0';
	CycleDone		<= '0';
	iChannelCntr 	<= (Others => '0');
	SampleCntr 		<= (Others => '0');
	Mon_State 		<= Idle_s;
elsif (Clock'event and Clock = '1') then
	SumWr				<= LoadB OR AddB ;
	iiChannelCntr 	<= iChannelCntr;
	ChannelCntr 	<= iiChannelCntr;
	if (SampleCntr = MaxSamples) then
		StoreWe 	<= AddB AND not(Start);
	end if;
	
	case Mon_State is
		when Idle_s =>
			AddB				<= '0';
			LoadB				<= '0';
			CycleDone		<= '0';
			If (StartCycle = '1') then
				Start 			<= '1';
				iChannelCntr 	<= x"0";
				SampleCntr 		<= x"0";
				Mon_State 		<= Load_Acc_s;
			else
				Mon_State	<= Idle_s;
			end if;
		
		when Load_Acc_s =>
			if (ADCDAV = '1') then
				LoadB		<= '1';
				AddB		<= '1';
				if (iChannelCntr = x"7") then
						SampleCntr		<= SampleCntr +1;
						Start 			<= '1';
						iChannelCntr	<= x"0";
						Mon_State		<= Acc_s;
				else
					Start 			<= '0';
					iChannelCntr 	<= iChannelCntr + 1;
					Mon_State 		<= Load_Acc_s;
				end if;
			else
				LoadB			<= '0';
				AddB			<= '0';
				Start 		<= '0';
				Mon_State 	<= Load_Acc_s;
			end if;
				
		when Acc_s =>
			LoadB		<= '0';
			if (ADCDAV = '1') then
				AddB <= '1';
				if (iChannelCntr = x"7") then
					if (SampleCntr = MaxSamples) then
						CycleDone		<= '1';
						Mon_State 		<= Acc_Delay1_s;
					else
						SampleCntr 		<= SampleCntr + 1;
						iChannelCntr 	<= x"0";
						Start				<= '1';
						Mon_State		<= Acc_s;
					end if;
				else	
					Start				<= '0';
					iChannelCntr 	<= iChannelCntr + 1;
					Mon_State 		<= Acc_s;
				end if;
			else
				Start			<= '0';
				AddB 			<= '0';
				Mon_State 	<= Acc_s;
			end if;

		when Acc_Delay1_s =>
			AddB 				<= '0';
			Mon_State 		<= Acc_Delay2_s;
			
		when Acc_Delay2_s =>
			Mon_State 		<= Acc_Delay3_s;
			
		when Acc_Delay3_s =>
			Mon_State 		<= Acc_Delay4_s;
			
		when Acc_Delay4_s =>
			Mon_State 		<= Idle_s;
			
		when Others =>
			Mon_State <= Idle_s;
			
		end case;
	end if;
end process;
				
u_Max1308 :  Max1308Intf
Port map ( 
	Clock 		=> Clock,
	reset 		=> Reset,
	ClkEn 		=> SlowClkEn,
	Start			=> Start,
-- ADC Control and Data
	Wr				=> Wr,
	Cs 			=> Cs,
	Rd				=> Rd,
	Convst		=> Convst,
	EOC			=> EOC,
	EOLC			=> EOLC,
	DataIn		=> ADCDataIn,
-- ADC Data Out
	DAV			=> ADCDAV,
	AddrOut		=> open,
	DataOut		=> ADCData
);

u_Adder : Acc12x16
port map (
	clk 		=> Clock,
	a 			=> AccDout,
	b 			=> ADCData,
	ce 		=> AddB,
	bypass 	=> LoadB,
	s 			=> Sum
);

u_AccMem : ram16x16
port map (
	clk 	=> Clock,
	d 		=> Sum,
	a 		=> ChannelCntr,
	we 	=> SumWr,
	spo 	=> AccDout
);

u_Average : Ram16x16dp
port map (
	clk 	=> Clock,
	a 		=> ChannelCntr,
	d 		=> Sum,
	we 	=> StoreWe,
	spo 	=> open,
	dpra 	=> Lnk_Addr(3 downto 0),
	dpo	=> AveDataOut
	);

Data16 		<= Sum(15) & Sum(15) & Sum(15)  & Sum(15 downto 3);

M24V_p : process(Clock, Reset)
begin
if (Reset = '1') then
	M24VFault <= '0';
elsif (Clock'event and Clock = '1') then
	if ((StoreWe = '1')  and (ChannelCntr = x"0")) then
-- jjo 04/04/13
-- Changed 24v Fault
--		if ((Data16 < LowThreshold) or  (Data16 > HiThreshold)) then
		if ((Data16 > HiThreshold)) then
			M24VFault <= '1';
		else
			M24VFault <= '0';
		end if;
	end if;
end if;
end process;
		
end Behavioral;

