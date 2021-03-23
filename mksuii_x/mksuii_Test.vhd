-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	mksuii_Test.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 5/27/2011 12:52:18 PM
--	Last change: JO 8/25/2011 10:04:10 AM
--
-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Library work;
use work.mksuii.all;

ENTITY testbench IS
  
END testbench;

ARCHITECTURE behavior OF testbench IS 

---- MKSKII Permit, Start of Daisy Chain
--	N_PERMIT 					:  std_logic;
		
---- PCB Pushbutton Reset
signal N_BRD_RST 					: std_logic;
	
signal 	VP_IN						: std_logic;							 -- Dedicated Analog Input Pair
signal 	VN_IN						: std_logic;

	
signal N_MODID 					:  std_logic_vector(7 downto 0);
	
---- External Memory terface
signal MEM_CLK 					:  std_logic;
signal N_MEM_OE 					:  std_logic;
signal N_MEM_GW 					:  std_logic;
signal N_MEM_BWE 					:  std_logic;
signal N_MEM_BW 					:  std_logic_vector(4 downto 1);
signal N_MEM_ADSC 				:  std_logic;
signal MEM_Addr 					:  std_logic_vector(24 downto 0);
signal MEM_Data					:  std_logic_vector(31 downto 0);
signal MEM_Parity					:  std_logic_vector(4 downto 1);
signal Mem_WAIT 					:  std_logic;
signal RS1 							:  std_logic;
signal RS0 							:  std_logic;
signal VPP 							:  std_logic;

---- Flash Memory Control
signal N_FOE 						:  std_logic;
signal N_FCS 						:  std_logic;
signal N_FWE 						:  std_logic;

---- Front Panel	Local control
signal N_SW_TRIGEN 				:  std_logic;
signal N_SW_TEST 					:  std_logic;
signal N_SW_SPARE2 				:  std_logic;
signal N_SW_SPARE1 				:  std_logic;
signal N_SW_LOCAL 				:  std_logic;
signal N_SW_FLT_RST 				:  std_logic;
signal N_SPI_RESET 				:  std_logic;
signal N_SPI_DPOM 				:  std_logic;
signal N_POT2_SW 					:  std_logic;
signal N_POT1_SW 					:  std_logic;
signal POT2_UP 					:  std_logic;
signal POT2_DOWN 					:  std_logic;
signal POT1_UP 					:  std_logic;
signal POT1_DOWN 					:  std_logic;

-- Front Panel LED's
signal FP_LED 						:  std_logic_vector(28 downto 0);

---- Front Panel LCD Display
signal SPI_CLK 					:  std_logic;
signal N_SPI_SS 					:  std_logic;
signal SPI_MISO 					:  std_logic;
signal SPI_MOSI 					:  std_logic;
signal N_SPI_SBUF 				:  std_logic;

-- Slow ADC terface	
signal SLOWADC_CLK 				:  std_logic;
signal N_SLOWADC_CS 				:  std_logic;
signal N_SLOWADC_WR 				:  std_logic;
signal N_SLOWADC_RD 				:  std_logic;
signal SLOWADC_CONVST 			:  std_logic;
signal N_SLOWADC_EOLC 			:  std_logic;
signal N_SLOWADC_EOC 			:  std_logic;
	
-- Voltage Monitor ADC terface
signal MONADC_CLK 				:  std_logic;
signal N_MONADC_CS 				:  std_logic;
signal N_MONADC_WR 				:  std_logic;
signal N_MONADC_RD 				:  std_logic;
signal MONADC_CONVST 			:  std_logic;
signal N_MONADC_EOLC 			:  std_logic;
signal N_MONADC_EOC 				:  std_logic;

-- Mon and Slow ADC Data controlled with CS
signal SLOWADC_DATA 				:  std_logic_vector(11 downto 0);

---- SLED Monitor terface
signal N_SLED_UPPER_TUNED 		:  std_logic;
signal N_SLED_UPPER_DETUNED 	:  std_logic;
signal N_SLED_MOTOR_TUNED 		:  std_logic;
signal N_SLED_MOTOR_DETUNED 	:  std_logic;
signal N_SLED_LOWER_TUNED 		:  std_logic;
signal N_SLED_LOWER_DETUNED 	:  std_logic;

---- SLED Control terface
signal N_SLED_ENABLE 			:  std_logic;
signal N_SLED_TUNE 				:  std_logic;
signal N_SLED_DETUNE 			:  std_logic;
--
---- SLED Test terface	
signal SLED_U_TUNED_TEST 		:  std_logic;
signal SLED_U_DETUNED_TEST 	:  std_logic;
signal SLED_M_TUNED_TEST 		:  std_logic;
signal SLED_M_DETUNED_TEST 	:  std_logic;
signal SLED_L_TUNED_TEST 		:  std_logic;
signal SLED_L_DETUNED_TEST 	:  std_logic;

-- GBit Transceiver terface
signal MGTCLK1_n 					:  std_logic;
signal MGTCLK1_p 					:  std_logic;
	
signal TX0_p 		 				:  std_logic;
signal TX0_n 						:  std_logic;
signal RX0_n 						:  std_logic;
signal RX0_p 						:  std_logic;
	

signal N_MOD_PRES0 				:  std_logic;
signal TX_DISABLE0 				:  std_logic;
signal SCL0 						:  std_logic;
signal SDA0 						:  std_logic;
signal RX_LOS0 					:  std_logic;
signal TX_FAULT0 					:  std_logic;

signal TX1_p 						:  std_logic;
signal TX1_n 						:  std_logic;
signal RX1_n 						:  std_logic;
signal RX1_p 						:  std_logic;
	
signal N_MOD_PRES1 				:  std_logic;
signal TX_DISABLE1 				:  std_logic;
signal SCL1 						:  std_logic;
signal SDA1 						:  std_logic;
signal RX_LOS1 					:  std_logic;
signal TX_FAULT1 					:  std_logic;
--

---- Temperature Monitor terface	
signal TEMP_ADC_CLK 				:  std_logic;
signal N_TEMP_OUT_CS 				:  std_logic;
signal N_TEMP_IN_CS 				:  std_logic;
signal TEMP_DIn_RDY 				:  std_logic;
signal TEMP_SCLK 					:  std_logic;
signal TEMP_DOut 					:  std_logic;

---- RF Attenuator terface	
signal RFATTN_SCLK 				:  std_logic;
signal RFATTN_SDOut 					:  std_logic;
signal RFATTN_SDIn 					:  std_logic;
signal N_RFATTN_SYNC 			:  std_logic;

-- Trigger IO
signal CLK119MHZ_IN_p 				:  std_logic;
signal CLK119MHZ_IN_n 				:  std_logic;
signal TRIGGER_IN1_p 				:  std_logic;
signal TRIGGER_IN1_n 				:  std_logic;
signal TRIGGER_IN0_p 				:  std_logic;
signal TRIGGER_IN0_n 				:  std_logic;
	

signal N_MOD_TRIGGER_EN 		:  std_logic;
signal N_MOD_TRIGGER 			:  std_logic;
signal N_REAR_TRIGGER 			:  std_logic;
signal N_FRONT_TRIGGER 			:  std_logic;

---- Focus Coil terface	
signal FOCUS_SCLK 				:  std_logic;
signal N_FOCUS_SYNC 				:  std_logic;
signal FOCUS_SDIn					:  std_logic;

-- Fast ADC terface
signal FADC_SCLK 					:  std_logic;
signal N_FADC_CS	 				:  std_logic;
signal FADC_SDIO 					:  std_logic;
	
signal FADC_CLK_P 				:  std_logic;
signal FADC_CLK_N 				:  std_logic;
signal FADC_FRAME_CLK_P 		:  std_logic;
signal FADC_FRAME_CLK_N 		:  std_logic;
signal FADC_DATA_CLK_P 			:  std_logic;
signal FADC_DATA_CLK_N 			:  std_logic;
signal BEAM_V_P 					:  std_logic;
signal BEAM_V_N 					:  std_logic;
signal BEAM_I_P 					:  std_logic;
signal BEAM_I_N 					:  std_logic;
signal FWD_PWR_P 					:  std_logic;
signal FWD_PWR_N 					:  std_logic;
signal REFL_PWR_P 				:  std_logic;
signal REFL_PWR_N 				:  std_logic;

---- Modulator Command terface
signal N_SYSTEM_FAULT 			:  std_logic;
signal N_X_FAULT_RST_CMD 		:  std_logic;
signal N_X_HV_OFF_CMD 			:  std_logic;
signal N_X_HV_ON_CMD 			:  std_logic;
signal N_X_CTRL_PWR_ON_CMD 	:  std_logic;
--
---- Modulator Monitor terface	
signal N_MOD_HV_ON_MON 			:  std_logic;
signal N_MOD_FAULT_MON 			:  std_logic;
signal N_MOD_EXT_INTLK_MON 	:  std_logic;
signal N_MOD_HVOC_MON 			:  std_logic;
signal N_MOD_EOLC_MON 			:  std_logic;
signal N_MOD_TTOC_MON 			:  std_logic;
signal N_MOD_HV_RDY_MON 		:  std_logic;
signal N_MOD_AVAIL_MON 			:  std_logic;
signal N_MOD_INTLK_COMP_MON 	:  std_logic;
signal N_MOD_CTRL_PWR_FLT_MON :  std_logic;
signal N_MOD_KLY_FIL_TD_MON 	:  std_logic;
signal N_MOD_VVS_PWR_MON 		:  std_logic;

---- Modulator Monitor Test terface	
signal MOD_HV_ON_TEST 			:  std_logic;
signal MOD_FAULT_TEST 			:  std_logic;
signal MOD_EXT_INTLK_TEST 		:  std_logic;
signal MOD_HVOC_TEST 			:  std_logic;
signal MOD_EOLC_TEST 			:  std_logic;
signal MOD_TTOC_TEST 			:  std_logic;
signal MOD_HV_RDY_TEST 			:  std_logic;
signal MOD_AVAIL_TEST 			:  std_logic;
signal MOD_INTLK_COMP_TEST 	:  std_logic;
signal MOD_CTRL_PWR_FLT_TEST 	:  std_logic;
signal MOD_VVS_PWR_TEST 		:  std_logic;
signal MOD_KLY_FIL_TD_TEST 	:  std_logic;

---- Flow Switch Monitor	
signal N_ACC2_FLOW_MON 			:  std_logic;
signal N_ACC1_FLOW_MON 			:  std_logic;
signal N_WG1_FLOW_MON 			:  std_logic;
signal N_WG2_FLOW_MON 			:  std_logic;
signal N_KLY_FLOW_MON 			:  std_logic;
signal N_FLOW_SUMMARY			:  std_logic;

---- Flow Switch Test	
signal ACC2_FLOW_TEST 			:  std_logic;
signal ACC1_FLOW_TEST 			:  std_logic;
signal WG1_FLOW_TEST 			:  std_logic;
signal WG2_FLOW_TEST 			:  std_logic;
signal KLY_FLOW_TEST 			:  std_logic;

---- Legacy IO Monitor
signal N_X_MOD_ON 				:  std_logic;
signal N_WG_TCGUAGE_MON 		:  std_logic;
signal N_WG_VALVE_MON 			:  std_logic;
signal N_LEGACY_AVAIL_MON 		:  std_logic;

---- Legacy IO Test
signal LEGACY_WG_VALVE_TEST 	:  std_logic;
signal LEGACY_WGTC_GAUGE_TEST :  std_logic;
signal LEGACY_MODAVAIL_TEST 	:  std_logic;

---- ION Pump Monitor
signal N_ION_PUMP_MON 			:  std_logic;

---- ION Pump Test
signal ION_PUMP_TEST 			:  std_logic;
--
---- Wave Guide Vacuum Monitor
signal N_WG_VAC_OK_MON 			:  std_logic;
signal N_WG_VAC_BAD_MON 		:  std_logic;

---- Wave Guide Vacuum Test
signal WG_VAC_OK_TEST 			:  std_logic;
signal WG_VAC_BAD_TEST 			:  std_logic;

----Magnet Monitor
signal N_MAG_I_INTLK_MON 		:  std_logic;
signal N_MAG_I_OK_MON 			:  std_logic;
signal N_MAG_KLIXON_MON 		:  std_logic;
signal N_MAG_PS_ON 				:  std_logic;
--
----Magnet Test
signal MAG_I_INTLK_TEST 		:  std_logic;
signal MAG_I_OK_TEST 			:  std_logic;
signal MAG_KLIXON_TEST 			:  std_logic;

signal TP							:  std_logic_vector(6 downto 0);

signal Reset 						:  std_logic;

signal tx_clk 						:  std_logic;
signal tx_locked 					:  std_logic;

signal tstr_data 					:  std_logic_vector(7 downto 0);
signal tstr_DataStrb 			:  std_logic;
signal tstr_MessType 			:  std_logic_vector(7 downto 0);
signal tstr_TaskId 				:  std_logic_vector(7 downto 0);
signal tstr_MessStrb 			:  std_logic;

signal Tx_Start 					:  std_logic;
signal Tx_MessType 				:  std_logic_vector(7 downto 0);
signal Tx_TaskId 					:  std_logic_vector(7 downto 0);
signal Tx_Count 		  			:  std_logic_vector(15 downto 0);
signal Tx_Data 					:  std_logic_vector(7 downto 0);
signal Tx_Done 					:  std_logic;
signal Tx_Rdy 				  		:  std_logic;
signal BRD_ID 						:  std_logic_vector(7 downto 0);
signal MGTCLK_P 					:  std_logic;
signal MGTCLK_N 					:  std_logic;
signal MGTCLK 						:  std_logic;
signal clk119mhz 					:  std_logic;
signal TstrReset 					:  std_logic;

signal  Q 							: 	std_logic_vector(3 downto 0);
signal  QB 							:  std_logic_vector(3 downto 0);

BEGIN


N_BRD_RST		<= NOT(reset);
MGTCLK_P 		<= MGTCLK;
MGTCLK_N 		<= Not(MGTCLK);
CLK119MHZ_IN_p <= CLK119Mhz;
CLK119MHZ_IN_n	<= Not(CLK119Mhz);
N_MODID			<= not(Brd_Id);

-- Component Instantiation
uut : mksuii_x
Port map (     
	
---- MKSKII Permit, Start of Daisy Chain
--	N_PERMIT 					=>	n_Permit,
		
-- PCB Pushbutton Reset
	N_BRD_RST 					=> 	N_BRD_RST,
	
	VP_IN							=>    VP_In,							 -- Dedicated Analog Input Pair
	VN_IN							=>    VN_In,
	
	N_MODID 						=> 	N_MODID,
	                          	                        
---- External Memory Interfac
	MEM_CLK 						=>    MEM_CLK,
	N_MEM_OE 					=>    N_MEM_OE,
	N_MEM_GW 					=>    N_MEM_GW,
	N_MEM_BWE 					=>    N_MEM_BWE,
	N_MEM_BW 					=>    N_MEM_BW,
	N_MEM_ADSC 					=>    N_MEM_ADSC,
	MEM_Addr 					=>    MEM_Addr,
	MEM_Data						=>    MEM_Data,
	MEM_Parity					=>    MEM_Parity,
	Mem_WAIT 					=>    Mem_WAIT,
	RS1 							=>    RS1,
	RS0 							=>    RS0,
	VPP 							=>    VPP,

---- Flash Memory Control
	N_FOE 						=>    N_FOE,
	N_FCS 						=>    N_FCS,
	N_FWE 						=>    N_FWE,
--
---- Front Panel	Local contr
	N_SW_TRIGEN 				=>    N_SW_TRIGEN,
	N_SW_TEST 					=> 	N_SW_TEST,
	N_SW_SPARE2 				=>    N_SW_SPARE2,
	N_SW_SPARE1 				=>    N_SW_SPARE1,
	N_SW_LOCAL 					=> 	N_SW_LOCAL,
	N_SW_FLT_RST 				=>    N_SW_FLT_RST,
	N_POT2_SW 					=>    N_POT2_SW,
	N_POT1_SW 					=>    N_POT1_SW,
	POT2_UP 						=>    POT2_UP,
	POT2_DOWN 					=>    POT2_DOWN,
	POT1_UP 						=>    POT1_UP,
	POT1_DOWN 					=>    POT1_DOWN,
--
-- Front Panel LED's
	FP_LED 						=> 	FP_LED ,

-- Front Panel LCD Display
	SPI_CLK 						=>    SPI_CLK,
	N_SPI_SS 					=>    N_SPI_SS,
	SPI_MISO 					=>    SPI_MISO,
	SPI_MOSI 					=>    SPI_MOSI,
	N_SPI_SBUF 					=>    N_SPI_SBUF,
	N_SPI_RESET 				=>    N_SPI_RESET,
	N_SPI_DPOM 					=>    N_SPI_DPOM,

-- Slow ADC Interface
	SLOWADC_CLK 				=> 	SLOWADC_CLK,
	N_SLOWADC_CS 				=> 	N_SLOWADC_CS,
	N_SLOWADC_WR 				=> 	N_SLOWADC_WR,
	N_SLOWADC_RD 				=> 	N_SLOWADC_RD,
	SLOWADC_CONVST 			=> 	SLOWADC_CONVST,
	N_SLOWADC_EOLC 			=> 	N_SLOWADC_EOLC,
	N_SLOWADC_EOC 				=> 	N_SLOWADC_EOC,
	                          	                        
-- Voltage Monitor ADC Interf-- Voltage Monitor ADC In
	MONADC_CLK 					=> 	MONADC_CLK,
	N_MONADC_CS 				=> 	N_MONADC_CS,
	N_MONADC_WR 				=> 	N_MONADC_WR,
	N_MONADC_RD 				=> 	N_MONADC_RD,
	MONADC_CONVST 				=> 	MONADC_CONVST,
	N_MONADC_EOLC 				=> 	N_MONADC_EOLC,
	N_MONADC_EOC 				=> 	N_MONADC_EOC,

-- Mon and Slow ADC Data cont
	SLOWADC_DATA 				=> 	SLOWADC_DATA,

-- SLED Monitor Interface
--	N_SLED_UPPER_TUNED 		=>    N_SLED_UPPER_TUNED,
--	N_SLED_UPPER_DETUNED 	=>    N_SLED_UPPER_DETUNED,
--	N_SLED_MOTOR_TUNED 		=>    N_SLED_MOTOR_TUNED,
--	N_SLED_MOTOR_DETUNED 	=>    N_SLED_MOTOR_DETUNED,
--	N_SLED_LOWER_TUNED 		=>    N_SLED_LOWER_TUNED,
--	N_SLED_LOWER_DETUNED 	=>    N_SLED_LOWER_DETUNED,

	N_TANK_LO        			=> N_TANK_LO,
	TANK_HI           		=> TANK_HI,
	N_PUMPII						=> N_PUMPII,


-- SLED Control Interface
--	N_SLED_ENABLE 				=>    N_SLED_ENABLE,
--	N_SLED_TUNE 				=>    N_SLED_TUNE,
--	N_SLED_DETUNE 				=>    N_SLED_DETUNE,
--
---- SLED Test Interface
--	SLED_U_TUNED_TEST 		=>    SLED_U_TUNED_TEST,
--	SLED_U_DETUNED_TEST 		=>    SLED_U_DETUNED_TEST,
--	SLED_M_TUNED_TEST 		=>    SLED_M_TUNED_TEST,
--	SLED_M_DETUNED_TEST 		=>    SLED_M_DETUNED_TEST,
--	SLED_L_TUNED_TEST 		=>    SLED_L_TUNED_TEST,
--	SLED_L_DETUNED_TEST 		=>    SLED_L_DETUNED_TEST,

	TANK_LO_TEST  				=> TANK_LO_Test,
	TANK_HI_TEST  				=> TANK_HI_Test,
	PUMPII_TEST   				=> N_PUMPII_Test,



-- GBit Transceiver Interface
	MGTCLK1_n 					=> 	MGTCLK_n,
	MGTCLK1_p 					=> 	MGTCLK_p,
	                          	                        
	TX0_p 						=> 	TX0_p,
	TX0_n 						=> 	TX0_n,
	RX0_n 						=> 	RX0_n,
	RX0_p 						=> 	RX0_p,
	                          	                        
--	N_MOD_PRES0 				=>    N_MOD_PRES0,
	TX_DISABLE0 				=> 	TX_DISABLE0,
--	SCL0 							=>    SCL0,
--	SDA0 							=>    SDA0,
--	RX_LOS0 						=>    RX_LOS0,
--	TX_FAULT0 					=>    TX_FAULT0,

	TX1_p 						=> 	TX1_p,
	TX1_n 						=> 	TX1_n,
	RX1_n 						=> 	RX1_n,
	RX1_p 						=> 	RX1_p,
	                          	                        
--	N_MOD_PRES1 				=>    N_MOD_PRES1,
	TX_DISABLE1 				=> 	TX_DISABLE1,
--	SCL1 							=>    SCL1,
--	SDA1 							=>    SDA1,
--	RX_LOS1 						=>    RX_LOS1,
--	TX_FAULT1 					=>    TX_FAULT1,
--

---- Temperature Monitor Inte
	TEMP_ADC_CLK 				=>    TEMP_ADC_CLK,
	N_TEMP_OUT_CS 				=>    N_TEMP_OUT_CS,
	N_TEMP_IN_CS 				=>    N_TEMP_IN_CS,
	TEMP_DIn_RDY 				=>    TEMP_DIn_RDY,
	TEMP_SCLK 					=>    TEMP_SCLK,
	TEMP_DOut					=>    TEMP_DOut,
--
---- RF Attenuator Interface
	RFATTN_SCLK 				=>    RFATTN_SCLK,
	RFATTN_SDOUT 				=>    RFATTN_SDOUT,
	RFATTN_SDIN 				=>    RFATTN_SDIN,
	N_RFATTN_SYNC 				=>    N_RFATTN_SYNC,
--
-- Trigger IO
	CLK119MHZ_IN_p 			=> 	CLK119MHZ_IN_p,
	CLK119MHZ_IN_n 			=> 	CLK119MHZ_IN_n,
	TRIGGER_IN1_p 				=> 	TRIGGER_IN1_p,
	TRIGGER_IN1_n 				=> 	TRIGGER_IN1_n,
	TRIGGER_IN0_p 				=> 	TRIGGER_IN0_p,
	TRIGGER_IN0_n 				=> 	TRIGGER_IN0_n,
	                          	                        

	N_MOD_TRIGGER_EN 			=> 	N_MOD_TRIGGER_EN,
	N_MOD_TRIGGER 				=> 	N_MOD_TRIGGER,
	N_REAR_TRIGGER 			=> 	N_REAR_TRIGGER,
	N_FRONT_TRIGGER 			=> 	N_FRONT_TRIGGER,

---- Focus Coil Interface
	FOCUS_SCLK 					=>    FOCUS_SCLK,
	N_FOCUS_SYNC 				=>    N_FOCUS_SYNC,
	FOCUS_SDIN 					=>    FOCUS_SDIN,

-- Fast ADC Interface
	FADC_SCLK 					=> 	FADC_SCLK,
	N_FADC_CS	 				=> 	N_FADC_CS,
	FADC_SDIO 					=> 	FADC_SDIO,
	                          	                        
	FADC_CLK_P 					=> 	FADC_CLK_P,
	FADC_CLK_N 					=> 	FADC_CLK_N,
	FADC_FRAME_CLK_P 			=> 	FADC_FRAME_CLK_P,
	FADC_FRAME_CLK_N 			=> 	FADC_FRAME_CLK_N,
	FADC_DATA_CLK_P 			=> 	FADC_DATA_CLK_P,
	FADC_DATA_CLK_N 			=> 	FADC_DATA_CLK_N,
	BEAM_V_P 					=> 	BEAM_V_P,
	BEAM_V_N 					=> 	BEAM_V_N,
	BEAM_I_P 					=> 	BEAM_I_P,
	BEAM_I_N 					=> 	BEAM_I_N,
	FWD_PWR_P 					=> 	FWD_PWR_P,
	FWD_PWR_N 					=> 	FWD_PWR_N,
	REFL_PWR_P 					=> 	REFL_PWR_P,
	REFL_PWR_N 					=> 	REFL_PWR_N,

-- Modulator Command Interf
--	N_SYSTEM_FAULT 			=>    N_SYSTEM_FAULT,
	N_X_FAULT_RST_CMD 		=>    N_X_FAULT_RST_CMD,
	N_X_HV_OFF_CMD 			=>    N_X_HV_OFF_CMD,
	N_X_HV_ON_CMD 				=>    N_X_HV_ON_CMD,
	N_X_CTRL_PWR_ON_CMD 		=>    N_X_CTRL_PWR_ON_CMD,

-- Modulator Monitor Interf
	N_MOD_HV_ON_MON 			=>    N_MOD_HV_ON_MON,
	N_MOD_FAULT_MON 			=>    N_MOD_FAULT_MON,
	N_MOD_EXT_INTLK_MON 		=>    N_MOD_EXT_INTLK_MON,
	N_MOD_HVOC_MON 			=>    N_MOD_HVOC_MON,
	N_MOD_EOLC_MON 			=>    N_MOD_EOLC_MON,
	N_MOD_TTOC_MON 			=>    N_MOD_TTOC_MON,
	N_MOD_HV_RDY_MON 			=>    N_MOD_HV_RDY_MON,
	N_MOD_AVAIL_MON 			=>    N_MOD_AVAIL_MON,
	N_MOD_INTLK_COMP_MON 	=>    N_MOD_INTLK_COMP_MON,
	N_MOD_CTRL_PWR_FLT_MON 	=>    N_MOD_CTRL_PWR_FLT_MON,
	N_MOD_KLY_FIL_TD_MON 	=>    N_MOD_KLY_FIL_TD_MON,
	N_MOD_VVS_PWR_MON 		=>    N_MOD_VVS_PWR_MON,

-- Modulator Monitor Test
	MOD_HV_ON_TEST 			=>    MOD_HV_ON_TEST,
	MOD_FAULT_TEST 			=>    MOD_FAULT_TEST,
	MOD_EXT_INTLK_TEST 		=>    MOD_EXT_INTLK_TEST,
	MOD_HVOC_TEST 				=>    MOD_HVOC_TEST,
	MOD_EOLC_TEST 				=>    MOD_EOLC_TEST,
	MOD_TTOC_TEST 				=>    MOD_TTOC_TEST,
	MOD_HV_RDY_TEST 			=>    MOD_HV_RDY_TEST,
	MOD_AVAIL_TEST 			=>    MOD_AVAIL_TEST,
	MOD_INTLK_COMP_TEST 		=>    MOD_INTLK_COMP_TEST,
	MOD_CTRL_PWR_FLT_TEST 	=>    MOD_CTRL_PWR_FLT_TEST,
	MOD_VVS_PWR_TEST 			=>    MOD_VVS_PWR_TEST,
	MOD_KLY_FIL_TD_TEST 		=>    MOD_KLY_FIL_TD_TEST,

-- Flow Switch Monitor
	N_ACC2_FLOW_MON 			=>    N_ACC2_FLOW_MON,
	N_ACC1_FLOW_MON 			=>    N_ACC1_FLOW_MON,
	N_WG1_FLOW_MON 			=>    N_WG1_FLOW_MON,
	N_WG2_FLOW_MON 			=>    N_WG2_FLOW_MON,
	N_KLY_FLOW_MON 			=>    N_KLY_FLOW_MON,
	N_FLOW_SUMMARY				=>    N_FLOW_SUMMARY,


-- Flow Switch Test
	ACC2_FLOW_TEST 			=>    ACC2_FLOW_TEST,
	ACC1_FLOW_TEST 			=>    ACC1_FLOW_TEST,
	WG1_FLOW_TEST 				=>    WG1_FLOW_TEST,
	WG2_FLOW_TEST 				=>    WG2_FLOW_TEST,
	KLY_FLOW_TEST 				=>    KLY_FLOW_TEST,

-- Legacy IO Monitor
	N_X_MOD_ON 					=>    N_X_MOD_ON,
	N_WG_TCGUAGE_MON 			=>    N_WG_TCGUAGE_MON,
	N_WG_VALVE_MON 			=>    N_WG_VALVE_MON,
	N_LEGACY_AVAIL_MON 		=>    N_LEGACY_AVAIL_MON,

-- Legacy IO Test
	LEGACY_WG_VALVE_TEST 	=>    LEGACY_WG_VALVE_TEST,
	LEGACY_WGTC_GAUGE_TEST 	=>    LEGACY_WGTC_GAUGE_TEST,
	LEGACY_MODAVAIL_TEST 	=>    LEGACY_MODAVAIL_TEST,

-- ION Pump Monitor
	N_ION_PUMP_MON 			=>    N_ION_PUMP_MON,

-- ION Pump Test
	ION_PUMP_TEST 				=>    ION_PUMP_TEST,

-- Wave Guide Vacuum Monitor
	N_WG_VAC_OK_MON 			=>    N_WG_VAC_OK_MON,
	N_WG_VAC_BAD_MON 			=>    N_WG_VAC_BAD_MON,

-- Wave Guide Vacuum Test
	WG_VAC_OK_TEST 			=>    WG_VAC_OK_TEST,
	WG_VAC_BAD_TEST 			=>    WG_VAC_BAD_TEST,

--Magnet Monitor
	N_MAG_I_INTLK_MON 		=>    N_MAG_I_INTLK_MON,
	N_MAG_I_OK_MON 			=>    N_MAG_I_OK_MON,
	N_MAG_KLIXON_MON 			=>    N_MAG_KLIXON_MON,
	N_MAG_PS_ON 				=>    N_MAG_PS_ON,

--Magnet Test
	MAG_I_INTLK_TEST 			=>    MAG_I_INTLK_TEST,
	MAG_I_OK_TEST 				=>    MAG_I_OK_TEST,
	MAG_KLIXON_TEST 			=>    MAG_KLIXON_TEST ,

	TP								=> 	TP
	);

u_tester :  mksuii_GLink
port map (
	Reset 					=> Reset,
	Clock						=> tx_clk,
	
	Lnk_Clk					=> tx_clk,
	Active					=> open,
	Lnk_Error				=> open,	

	Lnk_Locked				=> tx_locked,

	Lnk_DataOut				=> tstr_data,
	Lnk_DataStrb			=> tstr_DataStrb,
	Lnk_MessType			=> tstr_MessType,
	Lnk_TaskId   			=> tstr_TaskId,
	Lnk_MessStrb			=> tstr_MessStrb,

-- Tx Data
	Tx_Start					=> tx_start,
	Tx_MessType				=> tx_MessType,		-- Transmit message type
	Tx_TaskId    			=> tx_TaskId,
	Tx_Count					=> tx_count,		-- Number of byte of data
	Tx_Data_in     		=> tx_data,		-- Data from external memory or registers
	Tx_Done					=> tx_done,
	Tx_Rdy					=> tx_Rdy,

-- Brd_Id used as LSByte of EMAC and IP Address and UDP Lk Node ID
	BRD_ID					=> brd_id,


--EMAC-MGT lk status
 
-- 1000BASE-X PCS/PMA terface - EMAC0
	TXP_0						=> Rx0_p,
	TXN_0						=> Rx0_n,
	RXP_0						=> Tx0_p,
	RXN_0						=> Tx0_n,

-- unused transceiver
	TXN_1_UNUSED			=> open,
	TXP_1_UNUSED			=> open,
	RXN_1_UNUSED			=> '1',
	RXP_1_UNUSED			=> '0',
-- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer puts
	MGTCLK_P					=>	MGTCLK_p,
	MGTCLK_N					=>	MGTCLK_n
);


BEAM_V_P 					<= 	Q(0);
BEAM_V_N 					<= 	QB(0);
BEAM_I_P 					<= 	Q(1);
BEAM_I_N 					<= 	QB(1);
FWD_PWR_P 					<= 	Q(2);
FWD_PWR_N 					<= 	QB(2);
REFL_PWR_P 					<= 	Q(3);
REFL_PWR_N 					<= 	QB(3);


u_fadc : ad9228_tstr 
Port map ( 
  clock 	=> FADC_CLK_P,
  clockB => FADC_CLK_N,
  Reset 	=> TstrReset,
  

  FC 		=> FADC_FRAME_CLK_P,
  FCB 	=> FADC_FRAME_CLK_N,
  
  DC 		=> FADC_DATA_CLK_P,
  DCB 	=> FADC_DATA_CLK_N,
  
  Q 		=> Q,
  QB 		=> QB
  );

  END;
