-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	FastChannel.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/22/2011 3:56:09 PM
--	Last change: JO 4/26/2011 10:43:24 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:51 02/14/2011 
-- Design Name: 
-- Module Name:    WaveForm_Intf - Behavioral 
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
use IEEE.std_logic_UNSIGNED.ALL;

library work;
use work.mksuii.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FastChannel is
Port ( 
	Clock 				: in std_logic;
	Reset 				: in std_logic;
	ADCClk				: in std_logic;
	
	DataIn				: in std_logic_vector(11 downto 0);			-- From FAST ADC
	
	Trigger				: in std_logic;
	TimeCntr				: in std_logic_vector(8 downto 0);			-- From Control
	Lo_Thres				: in std_logic_vector(11 downto 0);			-- From Control
	Hi_Thres				: in std_logic_vector(11 downto 0);			-- From Control
	Start					: in std_logic_vector(8 downto 0);			-- From Control
	Stop					: in std_logic_vector(8 downto 0);			-- From Control
	Num_AveSamples		: in std_logic_vector(8 downto 0);
	
	ArmWFM				: in std_logic;
	ArmAve				: in std_logic;
	WFMArmed				: out std_logic;
	AveArmed				: out std_logic;
	
	WFM_RAddr			: in std_logic_vector(8 downto 0);			-- From Control
	WFM_DOut				: out std_logic_vector(15 downto 0);		-- To Control
	AVE_DOut				: out std_logic_vector(15 downto 0);
	Average				: out std_logic_vector(15 downto 0);		-- To Control
	Status				: out std_logic_vector(1 downto 0);			-- To Control Over, Under
	Done					: out std_logic 									--

);
end FastChannel;

architecture Behavioral of FastChannel is

signal AddB			: std_logic;
signal LoadB 		: std_logic;
signal iAverage 	: std_logic_vector(19 downto 0);
signal NSamples 	: std_logic_vector(9 downto 0);
signal FastSum 	: std_logic_vector(19 downto 0);	
signal DivEn		: std_logic;	
signal DivDel		: std_logic_vector(4 downto 0);	

signal Threshold	: std_logic_vector(11 downto 0);	
signal WFMDout12	: std_logic_vector(11 downto 0);	
signal Average12	: std_logic_vector(11 downto 0);

signal WFM_Wr 		: std_logic_vector(0 downto 0);
signal WFM_WAddr	: std_logic_vector(8 downto 0);	
signal iWFM_WAddr	: std_logic_vector(8 downto 0);	

signal LessThan	: std_logic;
signal GrtrThan	: std_logic;
signal DivRFD		: std_logic;
signal ClrWFMArmed		: std_logic;
signal ClrAveArmed		: std_logic;
signal StorWFM				: std_logic;
signal StorAve				: std_logic;
signal iWFMArmed			: std_logic;
signal iAveArmed			: std_logic;

signal Ave_Wr 		: std_logic_vector(0 downto 0);
signal Ave_Cntr	: std_logic_vector(8 downto 0);	
signal AveDout12	: std_logic_vector(11 downto 0);	


--signal DinCntr		: std_logic_vector(11 downto 0);

type FastADC_t is
	(
	Idle_s,
	Start_s,
	Stop_s,
	Average_s,
	Lo_Thres_s,
	Hi_Thres_s
	);
	
signal FastADC_State : FastADC_t;

begin

WFM_DOut <= WFMDout12(11) & WFMDout12(11) & WFMDout12(11) & WFMDout12(11) & WFMDout12;
AVE_DOut <= AveDout12(11) & AveDout12(11) & AveDout12(11) & AveDout12(11) & AveDout12;
Average	<= Average12(11) & Average12(11) & Average12(11) & Average12(11) & Average12;

WFMArmed	<= iWFMArmed;
AveArmed	<= iAveArmed;


flag_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	iAveArmed <= '0';	
	iWFMArmed <= '0';
elsif (Clock'event and Clock = '1') then
	if (ArmWFM = '1') then
		iWFMArmed <= '1';
	elsif (ClrWfmArmed = '1') then
		iWFMArmed <= '0';
	end if;
	
	if (ArmAve = '1') then
		iAveArmed <= '1';
	elsif (ClrAveArmed = '1') then
		iAveArmed <= '0';
	end if;
end if;
end process;
	
fast_adc_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	NSamples 		<= (Others => '0');
	Threshold 		<= (Others => '0');
	DivDel			<= (Others => '0');
	Average12		<= (Others => '0');
	DivEn				<= '0';
	AddB				<= '0';
	LoadB				<= '0';
	WFM_Wr(0)		<= '0';
	Ave_Wr(0)		<= '0';
	Done				<= '0';
	StorWFM			<= '0';
	StorAVe			<= '0';
	ClrWFMArmed		<= '0';
	ClrAveArmed		<= '0';
	WFM_WAddr		<= (Others => '0');
	iWFM_WAddr		<= (Others => '0');
	Ave_Cntr 		<= (Others => '0');
	--DinCntr			<= (Others => '0');
	Status			<= "00";
	FastADC_State 	<= Idle_s;
elsif (Clock'event and Clock = '1') then
	if (ADCClk = '1') then
		WFM_WAddr		<= iWFM_WAddr;
		Case FastADC_State is
		when Idle_s =>
-- jjo 6/19/13
-- removed the reset so that the status is always valid
--			Status 			<= "00";
			Done 				<= '0';
			ClrWFMArmed		<= '0';
			ClrAveArmed 	<= '0';
			Ave_Wr(0)		<= '0';
			DivDel			<= (Others => '0');
			if (Trigger = '1') then
				StorWFM			<= iWFMArmed;
				StorAve			<= iAveArmed;
				if ((iAveArmed = '1') and (StorAve = '0')) then
					Ave_Cntr <= (Others => '0');
				else
					Ave_Cntr <= Ave_Cntr + 1;
				end if;
--				DinCntr		<= (Others => '0');
				WFM_Wr(0) 	<= StorWFM;
				iWFM_WAddr	<= iWFM_WAddr + 1 ;
				NSamples 	<= '0'& (Stop - Start + 1);
				if (Start = x"00") then
					AddB 				<= '1';
					LoadB 			<= '1';
					FastADC_State 	<= Stop_s;
				else
					FastADC_State 	<= Start_s;
				end if;
			else
				FastADC_State <= Idle_s;
			end if;
		
		when Start_s =>
--			DinCntr		<= DinCntr + 1;
			WFM_Wr(0)	<= StorWFM;
			iWFM_WAddr	<= iWFM_WAddr + 1 ;
			if (start = TimeCntr) then
				AddB 				<= '1';
				LoadB				<= '1';
				FastADC_State 	<= Stop_s;
			else
				FastADC_State	<= Start_s;
			end if;
			
		when Stop_s =>
			if (Stop < TimeCntr) then
				AddB <= '0';
			else
				AddB <= '1';
			end if;
			if (TimeCntr = x"1FF") then
				iWFM_WAddr		<= (Others => '0');
				DivEn				<= '1';
				FastADC_State 	<= Average_s;
			else
--				DinCntr			<= DinCntr + 1;
				WFM_Wr(0)		<= StorWFM;
				LoadB 			<= '0';
				iWFM_WAddr		<= iWFM_WAddr + 1 ;
				FastADC_State 	<= Stop_s;
			end if;
			
		when Average_s =>
			if (DivDel = x"16") then
				DivEn				<= '0';
				Average12 		<= iAverage(11 downto 0);
				ThresHold 		<= Lo_Thres(11 downto 0);
				FastADC_State 	<= Lo_Thres_s;
			else
				DivDel 			<= DivDel + 1;
				FastADC_State 	<= Average_s;
			end if;
			
		when Lo_Thres_s =>
				if (LessThan = '1') then
					Status(0) <= '1';
				else
					Status(0) <= '0';
				end if;
				ThresHold 		<= Hi_Thres(11 downto 0);
				FastADC_State 	<= Hi_Thres_s;
			
		when Hi_Thres_s =>
			if (GrtrThan = '1') then
				Status(1) <= '1';
			else
				Status(1) <= '0';
			end if;
			Done 				<= '1';
			ClrWFMArmed		<= '1';
			Ave_Wr(0)		<= StorAve;
			
			if (Ave_Cntr = Num_AveSamples) then
				ClrAveArmed <= '1';
			end if;
			
			FastADC_State 	<= Idle_s;
			
		when others =>
			FastADC_State <= Idle_s;
			
		end case;
	else
		AddB 			<= '0';
		LoadB			<= '0';
		WFM_Wr(0)	<= '0';
	end if;

end if;
end process;

		
u_Comp : ThresComp 
Port map ( 
	a 				=> iAverage(11 downto 0),
	b 				=> Threshold(11 downto 0),
	LessThan 	=> LessThan,
	GrtrThan 	=> GrtrThan,
	Equal			=> open
	);

u_FastAcc : Acc12x20
PORT MAP (
	clk 		=> Clock,
	b 			=> DataIn,
	ce 		=> AddB,
	bypass	=> LoadB,
	q 			=> FastSum
);	
	
u_FastDiv : Div20x8
port map (
	clk 			=> Clock,
	ce 			=> DivEn,
	rfd 			=> DivRFD,
	dividend 	=> FastSum,
	divisor 		=> NSamples,
	quotient 	=> iAverage,
	fractional 	=> open
);

u_Wfm : Ram512x12dp
port map (
	clka 			=> Clock,
	wea 			=> WFM_Wr,
	addra 		=> WFM_WAddr,
	dina 			=> DataIn,
	clkb 			=> Clock,
	addrb 		=> WFM_RAddr,
	doutb 		=> WFMDout12
);

u_Ave : Ram512x12dp
port map (
	clka 			=> Clock,
	wea 			=> Ave_Wr,
	addra 		=> Ave_Cntr,
	dina 			=> Average12,
	clkb 			=> Clock,
	addrb 		=> WFM_RAddr,
	doutb 		=> AveDout12
);

end Behavioral;

