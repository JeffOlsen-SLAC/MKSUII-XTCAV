-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	ad9228Input.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/22/2011 11:31:37 AM
--	Last change: JO 3/12/2012 8:07:39 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:25 01/12/2011 
-- Design Name: 
-- Module Name:    ad9228Input - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.mksuii.all;

entity ad9228Input is
port (
	Clock							: in std_logic;
	Reset 						: in std_logic;

	FADC_CLK_P 					: out std_logic;
	FADC_CLK_N 					: out std_logic;

	FADC_FRAME_CLK_P 			: in std_logic;
	FADC_FRAME_CLK_N 			: in std_logic;

	FADC_DATA_CLK_P 			: in std_logic;
	FADC_DATA_CLK_N 			: in std_logic;

	BEAM_V_P 					: in std_logic;
	BEAM_V_N 					: in std_logic;

	BEAM_I_P 					: in std_logic;
	BEAM_I_N 					: in std_logic;

	FWD_PWR_P 					: in std_logic;
	FWD_PWR_N 					: in std_logic;

	REFL_PWR_P 					: in std_logic;
	REFL_PWR_N 					: in std_logic;
	
	Beam_V_Data 				: out std_logic_vector(11 downto 0);
	Beam_I_Data 				: out std_logic_vector(11 downto 0);
	FWD_PWR_Data 				: out std_logic_vector(11 downto 0);
	REFL_PWR_Data 				: out std_logic_vector(11 downto 0);
	
--	FrameClk						: out std_logic;
--	DataClk						: out std_logic;
	DataClkLocked				: out std_logic

	);
end ad9228Input;

architecture Behavioral of ad9228Input is

signal FADC_Clk		: std_logic;

signal DataStrb		: std_logic;
signal iFrameClk_d	: std_logic;
signal DataStrbSr		: std_logic_vector(4 downto 0);

signal Beam_VQ1		: std_logic;
signal Beam_VQ2		: std_logic;
signal Beam_VSr 		: std_logic_vector(12 downto 0);


signal Beam_IQ1		: std_logic;
signal Beam_IQ2		: std_logic;
signal Beam_ISr 		: std_logic_vector(12 downto 0);

signal FWD_PWRQ1		: std_logic;
signal FWD_PWRQ2		: std_logic;
signal FWD_PWRSr 		: std_logic_vector(12 downto 0);

signal REFL_PWRQ1		: std_logic;
signal REFL_PWRQ2		: std_logic;
signal REFL_PWRSr 	: std_logic_vector(12 downto 0);

signal iFrameClk		: std_logic;
signal iDataClk		: std_logic;

signal DCMRst			: std_logic := '1';
signal RstCnt 			: std_logic_vector(3 downto 0) := "0000";


attribute keep : string;

begin

--FrameClk 	<= REFL_PWRQ1;
--DataClk	<= REFL_PWRQ2;

FADC_Clkoddr : ODDR
generic map(
	DDR_CLK_EDGE 	=> "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
	INIT 				=> '0', 					-- Initial value for Q port (’1’ or ’0’)
	SRTYPE 			=> "SYNC" 				-- Reset Type ("ASYNC" or "SYNC")
	)
port map (
	Q 		=> FADC_Clk, 	-- 1-bit DDR output
	C 		=> Clock, 		-- 1-bit clock input
	CE 	=> '1', 			-- 1-bit clock enable input
	D1 	=> '1', 			-- 1-bit data input (positive edge)
	D2 	=> '0', 			-- 1-bit data input (negative edge)
	R 		=> Reset, 		-- 1-bit reset input
	S 		=> '0' 			-- 1-bit set input
);

FADC_Clkobufds : OBUFDS
generic map (
	IOSTANDARD => "DEFAULT"
	)
port map (
	O 		=> FADC_CLK_P, 	-- Diff_p output (connect directly to top-level port)
	OB 	=> FADC_CLK_N, 	-- Diff_n output (connect directly to top-level port)
	I 		=> FADC_CLK 		-- Buffer input
);

--DataClkibufds : IBUFDS
--generic map (
--	IOSTANDARD 	=> "DEFAULT"
--	)
--port map (
--	O 	=> iDataClk, 			-- Buffer output
--	I 	=> FADC_DATA_CLK_P, 	-- Diff_p buffer input (connect directly to top-level port)
--	IB => FADC_DATA_CLK_N 	-- Diff_n buffer input (connect directly to top-level port)
--);

dcmRst_p : process(Clock,reset)
begin
if (Clock'event and Clock = '1') then
	if (Reset = '1') then
		DCMRst <= '1';
	end if;
	if (RstCnt = "1111") then
		DCMRst <= '0';
	else
		RstCnt <= RstCnt + 1;
	end if;
end if;
end process;

DataClkibufds : FADCClkDCM PORT MAP(
	CLKIN_N_IN 			=> FADC_DATA_CLK_N,
	CLKIN_P_IN 			=> FADC_DATA_CLK_P,
	RST_IN 				=> DCMRst,
	CLKIN_IBUFGDS_OUT => open,
	CLK0_OUT 			=> open,
	CLK90_OUT 			=> open,
	CLK180_OUT 			=> open,
	CLK270_OUT 			=> iDataClk,
	LOCKED_OUT 			=> DataClkLocked
);


u_FrameClkIn : FastDiffIn 
port map (
	Clock			=> iDataClk,
	Reset			=> Reset,
	Din_P			=> FADC_FRAME_CLK_P,
	Din_N			=> FADC_FRAME_CLK_N,
	QOut_1		=> iFrameClk,
	QOut_2		=> Open
);

u_BeamVIn : FastDiffIn
port map (
	Clock			=> iDataClk,
	Reset			=> Reset,
	Din_P			=> Beam_V_P,
	Din_N			=> Beam_V_N,
	QOut_1		=> Beam_VQ1,
	QOut_2		=> Beam_VQ2
);

u_BeamIIn : FastDiffIn
port map (
	Clock			=> iDataClk,
	Reset			=> Reset,
	Din_P			=> Beam_I_P,
	Din_N			=> Beam_I_N,
	QOut_1		=> Beam_IQ1,
	QOut_2		=> Beam_IQ2
);

u_FwdPwrIn : FastDiffIn
port map (
	Clock			=> iDataClk,
	Reset			=> Reset,
	Din_P			=> FWD_PWR_P,
	Din_N			=> FWD_PWR_N,
	QOut_1		=> FWD_PWRQ1,
	QOut_2		=> FWD_PWRQ2
);

u_ReflPwrIn : FastDiffIn
port map (
	Clock			=> iDataClk,
	Reset			=> Reset,
	Din_P			=> REFL_PWR_P,
	Din_N			=> REFL_PWR_N,
	QOut_1		=> REFL_PWRQ1,
	QOut_2		=> REFL_PWRQ2
);

Isr_p : process(iDataClk, Reset)
Begin
	if (Reset = '1') then
		Beam_VSr 		<= (Others => '0');
		Beam_V_Data 	<= (Others => '0');
		Beam_ISr 		<= (Others => '0');
		Beam_I_Data 	<= (Others => '0');
		FWD_PWRSr 		<= (Others => '0');
		FWD_PWR_Data 	<= (Others => '0');
		REFL_PWRSr 		<= (Others => '0');
		REFL_PWR_Data 	<= (Others => '0');
		iFrameClk_d	 	<= '0';
		
		DataStrbSr		<= (Others => '0');
		DataStrb			<= '0';
	elsif (iDataClk'event and iDataClk = '1') then
		iFrameClk_d <= iFrameClk;
		DataStrbSr	<= DataStrbSr(3 downto 0) & (not(iFrameClk_d) AND iFrameClk);
		DataStrb		<= DataStrbSr(4);
		
--		Beam_VSr 	<= Beam_VSr(9 downto 0) & Beam_VQ2 & Beam_VQ1;
--		Beam_ISr 	<= Beam_ISr(9 downto 0) & Beam_IQ2 & Beam_IQ1;
--		FWD_PWRSr 	<= FWD_PWRSr(9 downto 0) & FWD_PWRQ2 & FWD_PWRQ1;
--		REFL_PWRSr 	<= REFL_PWRSr(9 downto 0) & REFL_PWRQ2 & REFL_PWRQ1;
		
		Beam_VSr 	<= Beam_VSr(10 downto 0) & Beam_VQ1 & Beam_VQ2;
		Beam_ISr 	<= Beam_ISr(10 downto 0) & Beam_IQ1 & Beam_IQ2;
		FWD_PWRSr 	<= FWD_PWRSr(10 downto 0) & FWD_PWRQ1 & FWD_PWRQ2;
		REFL_PWRSr 	<= REFL_PWRSr(10 downto 0) & REFL_PWRQ1 & REFL_PWRQ2;
		
		if (DataStrb = '1') then
			Beam_V_Data 	<= Beam_VSr(12 downto 1);
			Beam_I_Data 	<= Beam_ISr(12 downto 1);
			FWD_PWR_Data 	<= FWD_PWRSr(12 downto 1);
			REFL_PWR_Data 	<= REFL_PWRSr(12 downto 1);
		end if;
	end if;
end process;

end Behavioral;

