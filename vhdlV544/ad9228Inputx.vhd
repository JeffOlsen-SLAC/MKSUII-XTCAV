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
--	Last change: JO 3/22/2011 11:51:12 AM
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
use IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

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
	
	FrameClk						: out std_logic;
	DataClk						: out std_logic

	);
end ad9228Input;

architecture Behavioral of ad9228Input is

signal q_temp 			: std_logic_vector(5 downto 0);
signal d_temp 			: std_logic_vector(11 downto 0);
signal iADC_Data 		: std_logic_vector(11 downto 0);
signal FADC_Clk		: std_logic;

signal iDataStrb		: std_logic;
signal DataStrb		: std_logic;
signal DataStrbSr		: std_logic_vector(1 downto 0);

signal iBeam_VSDIn		: std_logic;
signal Beam_VSDIn		: std_logic;
signal Beam_VQ1		: std_logic;
signal Beam_VQ2		: std_logic;
signal Beam_VSr 		: std_logic_vector(11 downto 0);


signal iBeam_ISDIn		: std_logic;
signal Beam_ISDIn		: std_logic;
signal Beam_IQ1		: std_logic;
signal Beam_IQ2		: std_logic;
signal Beam_ISr 		: std_logic_vector(11 downto 0);

signal iFWD_PWRSDIn	: std_logic;
signal FWD_PWRSDIn	: std_logic;
signal FWD_PWRQ1		: std_logic;
signal FWD_PWRQ2		: std_logic;
signal FWD_PWRSr 		: std_logic_vector(11 downto 0);

signal iREFL_PWRSDIn	: std_logic;
signal REFL_PWRSDIn	: std_logic;
signal REFL_PWRQ1		: std_logic;
signal REFL_PWRQ2		: std_logic;
signal REFL_PWRSr 	: std_logic_vector(11 downto 0);

signal iFrameClk		: std_logic;
signal iDataClk		: std_logic;
signal n_iDataClk		: std_logic;

attribute keep : string;

begin

FrameClk <= REFL_PWRQ1;
DataClk	<= REFL_PWRQ2;

n_iDataClk <= NOT(iDataClk);

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

FrameClkibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> iFrameClk, 			-- Buffer output
	I 	=> FADC_FRAME_CLK_P, -- Diff_p buffer input (connect directly to top-level port)
	IB => FADC_FRAME_CLK_N 	-- Diff_n buffer input (connect directly to top-level port)
);

DataClkibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> iDataClk, 			-- Buffer output
	I 	=> FADC_DATA_CLK_P, 	-- Diff_p buffer input (connect directly to top-level port)
	IB => FADC_DATA_CLK_N 	-- Diff_n buffer input (connect directly to top-level port)
);


BeamVibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> iBeam_VSDIn, 	-- Buffer output
	I 	=> BEAM_V_P, 		-- Diff_p buffer input (connect directly to top-level port)
	IB => BEAM_V_N 		-- Diff_n buffer input (connect directly to top-level port)
);

-- IODELAY: Input and/or Output Fixed/Variable Delay Element
-- Virtex-5
-- Xilinx HDL Libraries Guide, version 13.1
BeamVibufds_IODELAY : IODELAY
generic map (
	DELAY_SRC => "I",	 					-- Specify which input port to be used
												-- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
	HIGH_PERFORMANCE_MODE => TRUE, 	-- TRUE specifies lower jitter
												-- at expense of more power
	IDELAY_TYPE => "Default", 			-- "FIXED" or "VARIABLE"
	IDELAY_VALUE => 0, 					-- 0 to 63 tap values
	ODELAY_VALUE => 0, 					-- 0 to 63 tap values
	REFCLK_FREQUENCY => 200.0,			-- Frequency used for IDELAYCTRL
												-- 175.0 to 225.0
	SIGNAL_PATTERN => "DATA") 			-- Input signal type, "CLOCK" or "DATA"
port map (
	DATAOUT 	=> Beam_VSDIn, 			-- 1-bit delayed data output
	C 			=> '0', 					-- 1-bit clock input
	CE 		=> '0', 						-- 1-bit clock enable input
	DATAIN 	=> '0', 					-- 1-bit internal data input
	IDATAIN 	=> iBeam_VSDIn, 			-- 1-bit input data input (connect to port)
	INC		=> '0', 						-- 1-bit increment/decrement input
	ODATAIN 	=> '0', 						-- 1-bit output data input
	RST 		=> '0', 					-- 1-bit active high, synch reset input
	T 			=> '1'						-- 1-bit 3-state control input
);

BEAM_Viddr : IDDR
generic map (
	DDR_CLK_EDGE 	=> "SAME_EDGE_PIPELINED", 	-- "OPPOSITE_EDGE", "SAME_EDGE"
															-- or "SAME_EDGE_PIPELINED"
	INIT_Q1 			=> '0', 							-- Initial value of Q1: ’0’ or ’1’
	INIT_Q2			=> '0', 							-- Initial value of Q2: ’0’ or ’1’
	SRTYPE 			=> "SYNC"                  -- Set/Reset type: "SYNC" or "ASYNC"
	)
port map (
	Q1 	=> Beam_VQ1, 	-- 1-bit output for positive edge of clock
	Q2 	=> Beam_VQ2, 	-- 1-bit output for negative edge of clock
	C 		=> iDataClk,		-- 1-bit clock input
	CE 	=> '1', 			-- 1-bit clock enable input
	D 		=> Beam_VSDIn,	-- 1-bit DDR data input
	R 		=> Reset, 		-- 1-bit reset
	S 		=> '0' 			-- 1-bit set
);

Beam_Iibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> Beam_ISDIn, 		-- Buffer output
	I 	=> BEAM_I_P, 		-- Diff_p buffer input (connect directly to top-level port)
	IB => BEAM_I_N 		-- Diff_n buffer input (connect directly to top-level port)
);

BEAM_Iiddr : IDDR
generic map (
	DDR_CLK_EDGE 	=> "SAME_EDGE_PIPELINED", 	-- "OPPOSITE_EDGE", "SAME_EDGE"
															-- or "SAME_EDGE_PIPELINED"
	INIT_Q1 			=> '0', 							-- Initial value of Q1: '0' or '1'
	INIT_Q2			=> '0', 							-- Initial value of Q2: '0' or '1'
	SRTYPE 			=> "SYNC"                  -- Set/Reset type: "SYNC" or "ASYNC"
	)
port map (
	Q1 	=> Beam_IQ1, 	-- 1-bit output for positive edge of clock
	Q2 	=> Beam_IQ2, 	-- 1-bit output for negative edge of clock
	C 		=> iDataClk,		-- 1-bit clock input
	CE 	=> '1', 			-- 1-bit clock enable input
	D 		=> Beam_ISDIn,	-- 1-bit DDR data input
	R 		=> Reset, 		-- 1-bit reset
	S 		=> '0' 			-- 1-bit set
);

FWD_PWRibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> FWD_PWRSDIn, 		-- Buffer output
	I 	=> FWD_PWR_P, 		-- Diff_p buffer input (connect directly to top-level port)
	IB => FWD_PWR_N 		-- Diff_n buffer input (connect directly to top-level port)
);

FWD_PWRiddr : IDDR
generic map (
	DDR_CLK_EDGE 	=> "SAME_EDGE_PIPELINED", 	-- "OPPOSITE_EDGE", "SAME_EDGE"
															-- or "SAME_EDGE_PIPELINED"
	INIT_Q1 			=> '0', 							-- Initial value of Q1: '0' or '1'
	INIT_Q2			=> '0', 							-- Initial value of Q2: '0' or '1'
	SRTYPE 			=> "SYNC"                  -- Set/Reset type: "SYNC" or "ASYNC"
	)
port map (
	Q1 	=> FWD_PWRQ1, 	-- 1-bit output for positive edge of clock
	Q2 	=> FWD_PWRQ2, 	-- 1-bit output for negative edge of clock
	C 		=> iDataClk,		-- 1-bit clock input
	CE 	=> '1', 			-- 1-bit clock enable input
	D 		=> FWD_PWRSDIn,-- 1-bit DDR data input
	R 		=> Reset, 		-- 1-bit reset
	S 		=> '0' 			-- 1-bit set
);

REFL_PWRibufds : IBUFDS
generic map (
	IOSTANDARD 	=> "DEFAULT"
	)
port map (
	O 	=> REFL_PWRSDIn, 								-- Buffer output
	I 	=> REFL_PWR_P, 								-- Diff_p buffer input (connect directly to top-level port)
	IB => REFL_PWR_N 									-- Diff_n buffer input (connect directly to top-level port)
);

REFL_PWRiddr : IDDR
generic map (
	DDR_CLK_EDGE 	=> "SAME_EDGE_PIPELINED", 	-- "OPPOSITE_EDGE", "SAME_EDGE"
															-- or "SAME_EDGE_PIPELINED"
	INIT_Q1 			=> '0', 							-- Initial value of Q1: '0' or '1'
	INIT_Q2			=> '0', 							-- Initial value of Q2: '0' or '1'
	SRTYPE 			=> "SYNC"                  -- Set/Reset type: "SYNC" or "ASYNC"
	)
port map (
	Q1 	=> REFL_PWRQ1, 							-- 1-bit output for positive edge of clock
	Q2 	=> REFL_PWRQ2, 							-- 1-bit output for negative edge of clock
	C 		=> iDataClk,								-- 1-bit clock input
	CE 	=> '1', 										-- 1-bit clock enable input
	D 		=> REFL_PWRSDIn,							-- 1-bit DDR data input
	R 		=> Reset, 									-- 1-bit reset
	S 		=> '0' 										-- 1-bit set
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
		
		DataStrbSr	<= (Others => '0');
		DataStrb		<= '0';
	elsif (iDataClk'event and iDataClk = '1') then
		DataStrbSr 	<= DataStrbSr(0) & iFrameClk;
		DataStrb		<= not(DataStrbSr(1)) AND DataStrbSr(0);
		
		Beam_VSr 	<= Beam_VSr(9 downto 0) & Beam_VQ1 & Beam_VQ2;
		Beam_ISr 	<= Beam_ISr(9 downto 0) & Beam_IQ1 & Beam_IQ2;
		FWD_PWRSr 	<= FWD_PWRSr(9 downto 0) & FWD_PWRQ1 & FWD_PWRQ2;
		REFL_PWRSr 	<= REFL_PWRSr(9 downto 0) & REFL_PWRQ1 & REFL_PWRQ2;
		
		if (DataStrb = '1') then
			Beam_V_Data 	<= Beam_VSr;
			Beam_I_Data 	<= Beam_ISr;
			FWD_PWR_Data 	<= FWD_PWRSr;
			REFL_PWR_Data 	<= REFL_PWRSr;
		end if;
	end if;
end process;

end Behavioral;

