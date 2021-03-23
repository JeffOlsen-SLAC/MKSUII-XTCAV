-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	mksuii_x.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 1:42:15 PM
--	Last change: JO 6/13/2016 8:46:56 AM
--
----------------------------------------------------------------------------------
-- Create Date:    Thu Mar 03 16:56:42 2011
-- Design Name: 
-- Module Name:    MKSUII_x - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity mksuii_x is 
  Port (     
	
---- MKSKII Permit, Start of Daisy Chain
	N_PERMIT 					: out std_logic;
		
-- PCB Pushbutton Reset
	N_BRD_RST 					: in std_logic;

	VP_IN							: in std_logic;							 -- Dedicated Analog Input Pair
	VN_IN							: in std_logic;

	N_MODID 						: in std_logic_vector(7 downto 0);
	
---- External Memory Interface
	MEM_CLK 						: out std_logic;
	N_MEM_OE 					: out std_logic;
	N_MEM_GW 					: out std_logic;
	N_MEM_BWE 					: out std_logic;
	N_MEM_BW 					: out std_logic_vector(4 downto 1);
	N_MEM_ADSC 					: out std_logic;
	MEM_ADDR						: out std_logic_vector(24 downto 0);
	MEM_DATA						: inout std_logic_vector(31 downto 0);
	MEM_PARITY					: out std_logic_vector(4 downto 1);
	Mem_WAIT 					: in std_logic;
	RS1 							: out std_logic;
	RS0 							: out std_logic;
	VPP 							: out std_logic;
--	
---- Flash Memory Control
	N_FOE 						: out std_logic;
	N_FCS 						: out std_logic;
	N_FWE 						: out std_logic;
--	
---- Front Panel	Local control
	N_SW_TRIGEN 				: in std_logic;
	N_SW_TEST 					: in std_logic;
	N_SW_SPARE2 				: in std_logic;
	N_SW_SPARE1 				: in std_logic;
	N_SW_LOCAL 					: in std_logic; -- '0' => Local
	N_SW_FLT_RST 				: in std_logic;
	N_POT2_SW 					: in std_logic;
	N_POT1_SW 					: in std_logic;
	POT2_UP 						: in std_logic;
	POT2_DOWN 					: in std_logic;
	POT1_UP 						: in std_logic;
	POT1_DOWN 					: in std_logic;
--	
-- Front Panel LED's	
	FP_LED 						: out std_logic_vector(28 downto 0);

---- Front Panel LCD Display
	SPI_CLK 						: out std_logic;
	N_SPI_SS 					: out std_logic;
	SPI_MISO 					: in std_logic;
	SPI_MOSI 					: out std_logic;
	N_SPI_SBUF 					: in std_logic;
	N_SPI_RESET 				: out std_logic;
	N_SPI_DPOM 					: out std_logic;
	
-- Slow ADC Interface	
	SLOWADC_CLK 				: out std_logic;
	N_SLOWADC_CS 				: out std_logic;
	N_SLOWADC_WR 				: out std_logic;
	N_SLOWADC_RD 				: out std_logic;
	SLOWADC_CONVST 			: out std_logic;
	N_SLOWADC_EOLC 			: in std_logic;
	N_SLOWADC_EOC 				: in std_logic;
	
-- Voltage Monitor ADC Interface	
	MONADC_CLK 					: out std_logic;
	N_MONADC_CS 				: out std_logic;
	N_MONADC_WR 				: out std_logic;
	N_MONADC_RD 				: out std_logic;
	MONADC_CONVST 				: out std_logic;
	N_MONADC_EOLC 				: in std_logic;
	N_MONADC_EOC 				: in std_logic;

-- Mon and Slow ADC Data controlled with CS
	SLOWADC_DATA 				: in std_logic_vector(11 downto 0);

---- SLED Monitor Interface
--	N_SLED_UPPER_TUNED 			: in std_logic;
--	N_SLED_UPPER_DETUNED 		: in std_logic;
--	N_SLED_MOTOR_NOT_TUNED 		: in std_logic;
--	N_SLED_MOTOR_NOT_DETUNED 	: in std_logic;
--	N_SLED_LOWER_TUNED 			: in std_logic;
--	N_SLED_LOWER_DETUNED 		: in std_logic;

	N_TANK_LO        				: in std_logic;
	TANK_HI           			: in std_logic;
	N_PUMPII							: in std_logic;

---- SLED Control Interface
--	N_SLED_ENABLE 				: out std_logic;
--	N_SLED_TUNE 				: out std_logic;
--	N_SLED_DETUNE 				: out std_logic;

---- SLED Test Interface	
--	SLED_U_TUNED_TEST 		: out std_logic;
--	SLED_U_DETUNED_TEST 		: out std_logic;
--	SLED_M_TUNED_TEST 		: out std_logic;
--	SLED_M_DETUNED_TEST 		: out std_logic;
--	SLED_L_TUNED_TEST 		: out std_logic;
--	SLED_L_DETUNED_TEST 		: out std_logic;

	TANK_LO_TEST  				: out std_logic;
	TANK_HI_TEST  				: out std_logic;
	PUMPII_TEST   				: out std_logic;

-- GBit Transceiver Interface
	MGTCLK1_n 					: in std_logic;
	MGTCLK1_p 					: in std_logic;
	
	TX0_p 						: out std_logic;
	TX0_n 						: out std_logic;
	RX0_n 						: in std_logic;
	RX0_p 						: in std_logic;
	
--	N_MOD_PRES0 				: in std_logic;
	TX_DISABLE0 				: out std_logic;
	SCL0 							: out std_logic;
	SDA0 							: inout std_logic;
--	RX_LOS0 						: in std_logic;
--	TX_FAULT0 					: in std_logic;

	TX1_p 						: out std_logic;
	TX1_n 						: out std_logic;  
	RX1_n 						: in std_logic;
	RX1_p 						: in std_logic;
	
--	N_MOD_PRES1 				: in std_logic;
	TX_DISABLE1 				: out std_logic;
	SCL1 							: out std_logic;
	SDA1							: inout std_logic;
--	RX_LOS1 						: in std_logic;
--	TX_FAULT1 					: in std_logic;
--

-- Temperature Monitor Interface
	TEMP_ADC_CLK 				: in std_logic;
	N_TEMP_OUT_CS 				: out std_logic;
	N_TEMP_IN_CS 				: out std_logic;
	TEMP_DIn_RDY 				: in std_logic;
	TEMP_SCLK 					: out std_logic;
	TEMP_DOut 					: out std_logic;

---- RF Attenuator Interface	
	RFATTN_SCLK 				: out std_logic;
	RFATTN_SDOUT 				: out std_logic;
	RFATTN_SDIN 				: in std_logic;
	N_RFATTN_SYNC 				: out std_logic;
--	
-- Trigger IO	
	CLK119MHZ_IN_p 			: in std_logic;
	CLK119MHZ_IN_n 			: in std_logic;
	TRIGGER_IN1_p 				: in std_logic;
	TRIGGER_IN1_n 				: in std_logic;
	TRIGGER_IN0_p 				: in std_logic;
	TRIGGER_IN0_n 				: in std_logic;
	

	N_MOD_TRIGGER_EN 			: out std_logic;	
	N_MOD_TRIGGER 				: out std_logic;
	N_REAR_TRIGGER 			: out std_logic;
	N_FRONT_TRIGGER 			: out std_logic;

---- Focus Coil Interface	
	FOCUS_SCLK 					: out std_logic;
	N_FOCUS_SYNC 				: out std_logic;
	FOCUS_SDOut 				: out std_logic;
	FOCUS_SDIn 					: in std_logic;
--	
-- Fast ADC Interface
	FADC_SCLK 					: out std_logic;
	N_FADC_CS	 				: out std_logic;
	FADC_SDIO 					: inout std_logic;
	
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

---- Modulator Command Interface
	SYSTEM_FAULT 				: out std_logic;
	N_X_FAULT_RST_CMD 		: out std_logic;
	N_X_HV_OFF_CMD 			: out std_logic;
	N_X_HV_ON_CMD 				: out std_logic;
	N_X_CTRL_PWR_ON_CMD 		: out std_logic;

---- Modulator Monitor Interface	
	N_MOD_HV_ON_MON 			: in std_logic;
	N_MOD_FAULT_MON 			: in std_logic;
	N_MOD_EXT_INTLK_MON 		: in std_logic;
	N_MOD_HVOC_MON 			: in std_logic;
	N_MOD_EOLC_MON 			: in std_logic;
	N_MOD_TTOC_MON 			: in std_logic;
	N_MOD_HV_RDY_MON 			: in std_logic;
	N_MOD_AVAIL_MON 			: in std_logic;
	N_MOD_INTLK_COMP_MON 	: in std_logic;
	N_MOD_CTRL_PWR_FLT_MON 	: in std_logic;
	N_MOD_KLY_FIL_TD_MON 	: in std_logic;
	N_MOD_VVS_PWR_MON 		: in std_logic;
	
---- Modulator Monitor Test Interface	
	MOD_HV_ON_TEST 			: out std_logic;
	MOD_FAULT_TEST 			: out std_logic;
	MOD_EXT_INTLK_TEST 		: out std_logic;
	MOD_HVOC_TEST 				: out std_logic;
	MOD_EOLC_TEST 				: out std_logic;
	MOD_TTOC_TEST 				: out std_logic;
	MOD_HV_RDY_TEST 			: out std_logic;
	MOD_AVAIL_TEST 			: out std_logic;
	MOD_INTLK_COMP_TEST 		: out std_logic;
	MOD_CTRL_PWR_FLT_TEST 	: out std_logic;
	MOD_VVS_PWR_TEST 			: out std_logic;
	MOD_KLY_FIL_TD_TEST 		: out std_logic;
	
---- Flow Switch Monitor	
	N_ACC2_FLOW_MON 			: in std_logic;
	N_ACC1_FLOW_MON 			: in std_logic;
	N_WG1_FLOW_MON 			: in std_logic;
	N_WG2_FLOW_MON 			: in std_logic;
	N_KLY_FLOW_MON 			: in std_logic;
	N_FLOW_SUMMARY				: in std_logic;
	
--	
---- Flow Switch Test	
	ACC2_FLOW_TEST 			: out std_logic;
	ACC1_FLOW_TEST 			: out std_logic;
	WG1_FLOW_TEST 				: out std_logic;
	WG2_FLOW_TEST 				: out std_logic;
	KLY_FLOW_TEST 				: out std_logic;
--	
---- Legacy IO Monitor
	N_X_MOD_ON 					: out std_logic;
	N_WG_TCGUAGE_MON 			: in std_logic;
	N_WG_VALVE_MON 			: in std_logic;
	N_LEGACY_AVAIL_MON 		: in std_logic;
--	
---- Legacy IO Test
	LEGACY_WG_VALVE_TEST 	: out std_logic;
	LEGACY_WGTC_GAUGE_TEST 	: out std_logic;
	LEGACY_MODAVAIL_TEST 	: out std_logic;
--	
---- ION Pump Monitor
	N_ION_PUMP_MON 			: in std_logic;

---- ION Pump Test
	ION_Pump_TEST 				: out std_logic;

---- Wave Guide Vacuum Monitor
	N_WG_VAC_OK_MON 			: in std_logic;
	N_WG_VAC_BAD_MON 			: in std_logic;

---- Wave Guide Vacuum Test
	WG_VAC_OK_TEST 			: out std_logic;
	WG_VAC_BAD_TEST 			: out std_logic;

----Magnet Monitor
	N_MAG_I_INTLK_MON 		: in std_logic;
	N_MAG_I_OK_MON 			: in std_logic;
	N_MAG_KLIXON_MON 			: in std_logic;
	N_MAG_PS_ON 				: out std_logic;
--
----Magnet Test
	MAG_I_INTLK_TEST 			: out std_logic;
	MAG_I_OK_TEST 				: out std_logic;
	MAG_KLIXON_TEST 			: out std_logic;

	TP								: out std_logic_vector(6 downto 0)
	);

end mksuii_x;

architecture Behavioral of mksuii_x is 

-- Low true inputs
--signal SLED_UPPER_TUNED 		: std_logic;
--signal SLED_UPPER_DETUNED 		: std_logic;
--signal SLED_MOTOR_NOT_TUNED 	: std_logic;
--signal SLED_MOTOR_NOT_DETUNED : std_logic;
--signal SLED_LOWER_TUNED 		: std_logic;
--signal SLED_LOWER_DETUNED 		: std_logic;

signal TANK_LO 					: std_logic;
signal PUMPII						: std_logic;

signal MOD_PRES0 					: std_logic;
signal MOD_PRES1 					: std_logic;
signal MOD_HV_ON_MON 			: std_logic;
signal MOD_FAULT_MON 			: std_logic;
signal MOD_EXT_INTLK_MON 		: std_logic;
signal MOD_HVOC_MON 				: std_logic;
signal MOD_EOLC_MON 				: std_logic;
signal MOD_TTOC_MON 				: std_logic;
signal MOD_HV_RDY_MON 			: std_logic;
signal MOD_AVAIL_MON 			: std_logic;
signal MOD_INTLK_COMP_MON 		: std_logic;
signal MOD_CTRL_PWR_FLT_MON	: std_logic;
signal MOD_KLY_FIL_TD_MON 		: std_logic;
signal MOD_VVS_PWR_MON 			: std_logic;
signal ACC2_FLOW_MON 			: std_logic;
signal ACC1_FLOW_MON 			: std_logic;
signal WG1_FLOW_MON 				: std_logic;
signal WG2_FLOW_MON 				: std_logic;
signal KLY_FLOW_MON 				: std_logic;
signal Flow_Sum_Fault			: std_logic;

signal WG_TCGUAGE_MON 		: std_logic;
signal WG_VALVE_MON 			: std_logic;
signal LEGACY_AVAIL_MON 	: std_logic;
signal ION_PUMP_MON 			: std_logic;
signal WG_VAC_OK_MON 		: std_logic;
signal WG_VAC_BAD_MON 		: std_logic;
signal MAG_I_INTLK_MON 		: std_logic;
signal MAG_I_OK_MON 			: std_logic;
signal MAG_KLIXON_MON 		: std_logic;
signal Reset 					: std_logic;

signal SW_TRIGEN 				: std_logic;
signal SW_FLT_RST				: std_logic;
signal SW_TEST 				: std_logic;
signal SW_SPARE2				: std_logic;
signal SW_SPARE1 				: std_logic;
signal SW_POT2					: std_logic;
signal SW_POT1 				: std_logic;
signal SW_LOCAL 				: std_logic;


-- Low True Outputs
signal MAG_PS_ON 				: std_logic;
signal X_MOD_ON 				: std_logic;
--signal SYSTEM_FAULT 			: std_logic;
signal X_FAULT_RST_CMD 		: std_logic;
signal X_HV_OFF_CMD 			: std_logic;
signal X_HV_ON_CMD 			: std_logic;
signal X_CTRL_PWR_ON_CMD 	: std_logic;
signal TEMP_OUT_CS 			: std_logic;
signal TEMP_IN_CS 			: std_logic;
--signal SLED_TUNE 				: std_logic;
--signal SLED_DETUNE 			: std_logic;

signal SLOWADC_CS 			: std_logic;
signal SLOWADC_WR 			: std_logic;
signal SLOWADC_RD 			: std_logic;
signal SLOWADC_EOLC 			: std_logic;
signal SLOWADC_EOC 			: std_logic;

signal MONADC_CS 				: std_logic;
signal MONADC_WR 				: std_logic;
signal MONADC_RD 				: std_logic;
signal MONADC_EOLC 			: std_logic;
signal MONADC_EOC 			: std_logic;


-- GBIT Link
signal Lnk_Clk					: std_logic;
signal Lnk_Active				: std_logic;
signal Lnk_Error				: std_logic;
signal Lnk_Locked				: std_logic;
signal Lnk_Rx_Data			: std_logic_vector(7 downto 0);
signal Lnk_Rx_Address		: std_logic_vector(7 downto 0);
signal Lnk_Rx_Data_Strobe	: std_logic;
signal Lnk_Rx_MessType		: std_logic_vector(7 downto 0);
signal Lnk_Rx_TaskID			: std_logic_vector(7 downto 0);
signal Lnk_Rx_Mess_Strobe	: std_logic;
signal Lnk_Rx_TaskId_Strobe: std_logic;
signal Lnk_Tx_Start			: std_logic;
signal Lnk_Tx_MessType		: std_logic_vector(7 downto 0);
signal Lnk_Tx_TaskID			: std_logic_vector(7 downto 0);
signal Lnk_Tx_Count			: std_logic_vector(15 downto 0);
signal Lnk_Tx_Data			: std_logic_vector(7 downto 0);
signal Lnk_Tx_Done			: std_logic;
signal Lnk_Tx_Ready			: std_logic;
signal Lnk_Addr2Reg			: std_logic_vector(15 downto 0);
signal Lnk_Data2Reg			: std_logic_vector(15 downto 0);
signal Board_ID				: std_logic_vector(7 downto 0);

signal STBY_Trig				: std_logic;
signal CLK119MHZ				: std_logic;
signal clk30MhzEn				: std_logic;
signal clk1MhzEn				: std_logic;
signal clk400KhzEn			: std_logic;
signal Clk10KhzEn				: std_logic;
signal Clk100KhzEn			: std_logic;
signal Clk2hzEn				: std_logic;
signal Clk100HzEn				: std_logic;


signal Lnk_TrigIntf_Wr		: std_logic;
signal Lnk_FastADC_Wr		: std_logic;
signal Lnk_FastADC_WFM_Rd	: std_logic;
signal Lnk_Trigger_DOut		: std_logic_vector(15 downto 0);
signal Lnk_FastADC_DOut		: std_logic_vector(15 downto 0);
signal FASTADC_Status		: std_logic_vector(15 downto 0);

signal InputRate				: std_logic_vector(15 downto 0);
signal OutputRate				: std_logic_vector(15 downto 0);

--signal FADC_Frame_Clk		: std_logic;
--signal FADC_Data_Clk			: std_logic;

signal LocalTrigDelay		: std_logic_vector(15 downto 0);
signal LocalRateDiv			: std_logic_vector(2 downto 0);

signal WFMTrigger				: std_logic;
signal iWFMTrigger			: std_logic;
signal Lnk_WFMRd				: std_logic;

signal Beam_V_Average		: std_logic_vector(15 downto 0);
signal Beam_I_Average		: std_logic_vector(15 downto 0);
signal FWD_PWR_Average		: std_logic_vector(15 downto 0);
signal REFL_PWR_Average		: std_logic_vector(15 downto 0);

signal WFM_DAV					: std_logic;
signal TriggerEn				: std_logic;

signal iMonADC_Clk			: std_logic;
signal iMonADC_CONVST		: std_logic;
signal Mon_ADC_Status		: std_logic_vector(15 downto 0);
signal Mon_ADC_Dav			: std_logic;
signal Mon_ADC_Din			: std_logic_vector(15 downto 0);
signal Mon_ADC_ClkEn			: std_logic;
signal StartMonADC			: std_logic;
signal MonADCDone				: std_logic;
signal Lnk_MonADCWr			: std_logic;

signal iSlowADC_Clk			: std_logic;
signal iSlowADC_CONVST		: std_logic;
signal Slow_ADC_Status		: std_logic_vector(15 downto 0);
signal Slow_ADC_Dav			: std_logic;
signal Slow_ADC_DOut			: std_logic_vector(15 downto 0);
signal Slow_ADC_ClkEn		: std_logic;
signal StartSlowADC			: std_logic;
signal SlowADCDone			: std_logic;
signal Lnk_SlowThres_Wr		: std_logic;
signal Lnk_RdThreshold		: std_logic;
signal Lnk_RdAverage			: std_logic;
signal Lnk_Slow_DAV			: std_logic;
signal Lnk_SlowThres_Din	: std_logic_vector(15 downto 0);
signal Lnk_SlowADC_DOut		: std_logic_vector(15 downto 0);
signal MOD_TRIGGER			: std_logic;
signal REAR_TRIGGER			: std_logic;
signal FRONT_TRIGGER			: std_logic;
signal Lnk_SysMon_DOut		: std_logic_vector(15 downto 0);
signal Lnk_MonADC_DOut		: std_logic_vector(15 downto 0);
signal Configured				: std_logic;

signal Lnk_KlyTempMon_DOut	: std_logic_vector(15 downto 0);
signal Lnk_KlyTempMon_Wr	: std_logic;
signal KlyInTemp				: std_logic_vector(15 downto 0);
signal KlyOutTemp				: std_logic_vector(15 downto 0);
signal KlyTempStatus			: std_logic_vector(4 downto 0);
signal TempSDin				: std_logic;
signal TempSDOut				: std_logic;
signal iTemp_SClk				: std_logic;
signal SysReset				: std_logic;
signal Clk119MhzOk			: std_logic;
signal Clk119MhzBuf			: std_logic;
signal SysClk					: std_logic;
signal iFADC_SClk				: std_logic;
signal iFADC_SDIO				: std_logic;
signal iFADC_Cs				: std_logic;
signal Local_Drive			: std_logic_vector(7 downto 0);
signal Local_Drive_Wr		: std_logic;
signal SystemFault			: std_logic;
signal BeamILowThres			: std_logic;
signal clk10HzEn				: std_logic;
signal clk1HzEn				: std_logic;
signal clk1KHzEn				: std_logic;

signal FpReset					: std_logic;
signal Ramping					: std_logic;
signal RFDriveStatus			: std_logic_vector(15 downto 0);
signal iRFAttn_SClk			: std_logic;
signal iRFAttn_Sync			: std_logic;
signal iRFAttn_SDOut			: std_logic;


signal Lnk_RFDrive_Wr		: std_logic;
signal Lnk_RFDrive_DOut		: std_logic_vector(15 downto 0);
signal Lnk_RFDriveLkUp_DOut: std_logic_vector(15 downto 0);
signal Lnk_RFDriveLkup_Wr	: std_logic;

signal iFocus_SClk			: std_logic;
signal iFocus_Sync			: std_logic;
signal iFocus_SDout			: std_logic;

signal Lnk_FocusCoil_Wr		: std_logic;									-- From Link Interface
signal Lnk_FocusCoil_DOut	: std_logic_vector(15 downto 0);

signal iSPI_Clk				: std_logic;
signal iSPI_SS					: std_logic;
signal iSPI_MOSI				: std_logic;
signal FPD_Reset				: std_logic;
signal FPD_DPOM				: std_logic;
signal iSPI_MISO				: std_logic;
signal iSPI_SBuf				: std_logic;

signal eDip_Rx_Done			: std_logic;
signal Lnk_eDisplay_DOut	: std_logic_vector(15 downto 0);
signal Lnk_eDisplay_Wr		: std_logic;

--signal SLED_TimeOut			: std_logic;
--signal SLED_OK					: std_logic;
--signal SLED_Fault				: std_logic;
--signal SLED_TuneEnable		: std_logic;
signal Lnk_SLED_Wr				: std_logic;									-- From Link Interface
signal Lnk_SLED_DOut			: std_logic_vector(15 downto 0);

signal Fault_Reset			: std_logic;
signal Modulator_On			: std_logic;
signal SLED_Status			: std_logic_vector(15 downto 0);

signal Lnk_Mod_Intf_Wr		: std_logic;
signal Lnk_Mod_Intf_DOut	: std_logic_vector(15 downto 0);
signal Mod_Intf_Status		: std_logic_vector(15 downto 0);
signal FaultHvOff				: std_logic;

signal Lnk_Water_Flow_Wr	: std_logic;
signal Lnk_Water_Flow_DOut	: std_logic_vector(15 downto 0);
signal Flow_Status			: std_logic_vector(15 downto 0);
signal Flow_Fault				: std_logic;

signal Lnk_Legacy_Mod_Wr	: std_logic;
signal Lnk_Legacy_Mod_DOut	: std_logic_vector(15 downto 0);
signal Legacy_Mod_Status	: std_logic_vector(15 downto 0);

signal Lnk_WG_Vac_Wr			: std_logic;
signal Lnk_WG_Vac_DOut		: std_logic_vector(15 downto 0);
signal WG_Vac_Status			: std_logic_vector(15 downto 0);

signal Lnk_MagIntf_Wr		: std_logic;
signal Lnk_MagIntf_DOut		: std_logic_vector(15 downto 0);
signal MagIntf_Status		: std_logic_vector(15 downto 0);

signal Lnk_IonPump_Wr		: std_logic;
signal Lnk_IonPump_DOut		: std_logic_vector(15 downto 0);
signal IonPump_Status		: std_logic_vector(15 downto 0);

signal Lnk_CntlIntf_Wr		: std_logic;
signal Lnk_CntlIntf_DOut	: std_logic_vector(15 downto 0);
signal CntlIntf_Status		: std_logic_vector(15 downto 0);


signal Lnk_FaultGen_Wr		: std_logic;
signal Lnk_FaultGen_DOut	: std_logic_vector(15 downto 0);
signal FaultGen_Status		: std_logic_vector(15 downto 0);

signal Lnk_SFP_DOut			: std_logic_vector(15 downto 0);

signal Lnk_SysInfo_DOut		: std_logic_vector(15 downto 0);

signal Lnk_FaultHistory_Rd		: std_logic;
signal Lnk_FaultHistory_DOut	: std_logic_vector(15 downto 0);

signal FaultBits					: std_logic_vector(31 downto 0);
signal NewFault					: std_logic;
signal EventCounter				: std_logic_vector(31 downto 0);


signal ClkLocked				: std_logic;
signal Permit					: std_logic;

signal Mode_Accel				: std_logic;
signal Mode_Stndby			: std_logic;
signal Mode_OFFL				: std_logic;
signal Mode_Maint				: std_logic;
signal Mode_Local				: std_logic;

signal DataClkLocked			: std_logic;

signal DisplayTrigDelay		: std_logic_vector(15 downto 0);
signal DisplayRFDrive		: std_logic_vector(15 downto 0);
signal DisplayMicroPrev		: std_logic_vector(15 downto 0);
signal DeltaTemp				: std_logic_vector(15 downto 0);
signal WGVac					: std_logic_vector(15 downto 0);
signal KlyVac					: std_logic_vector(15 downto 0);
signal Assign					: std_logic_vector(7 downto 0);
signal HSTA						: std_logic_vector(7 downto 0);
signal ModState				: std_logic_vector(7 downto 0);
signal iFP_LED					: std_logic_vector(28 downto 0);

signal ArmWFM					: std_logic;
signal ArmAve					: std_logic;
signal WFMArmed				: std_logic;
signal AveArmed				: std_logic;
signal Mod_TriggerEn_Out	: std_logic;
signal M24VFault				: std_logic;
signal Fault3of5				: std_logic;
signal BeamILow10s			: std_logic;
signal Mod_Trigger_Out		: std_logic;
signal MAG_PS_Off				: std_logic;

signal FP_Trigger_Enable	: std_logic;
signal FP_Test					: std_logic;
signal FP_Fault_Reset		: std_logic;
signal FP_Fault_Reset_Le	: std_logic;
signal FP_Local				: std_logic;
signal FP_Delay_Up			: std_logic;
signal FP_Delay_Dn			: std_logic;
signal FP_Delay_Sw			: std_logic;
signal FP_Drive_Up			: std_logic;
signal FP_Drive_Dn			: std_logic;
signal FP_Drive_Sw			: std_logic;
signal FP_SW_Inc				: std_logic;
signal FP_SW_Dec				: std_logic;
signal LED_Trigen				: std_logic;

signal DelayUp					: std_logic;
signal DelayDn					: std_logic;

signal Flash_Oe				: std_logic;
signal Flash_Cs				: std_logic;
signal Flash_We				: std_logic;
signal Flash_VPP				: std_logic;
signal Flash_DOut				: std_logic_vector(15 downto 0);
signal Flash_DIn				: std_logic_vector(15 downto 0);
signal Flash_Addr				: std_logic_vector(24 downto 0);

signal Lnk_Flash_WriteBlk	: std_logic;
signal Lnk_Flash_ReadBlk	: std_logic;
signal Lnk_Flash_EraseBlk	: std_logic; 
signal Lnk_Flash_LockBlk	: std_logic; 
signal Lnk_Flash_DOut		: std_logic_vector(15 downto 0);
signal Lnk_Flash_WriteAddr	: std_logic; 
signal Lnk_Flash_DAV			: std_logic; 	 
	
signal SelfTriggerEn			: std_logic; 

signal DisplayUdapteRate	: std_logic; 
signal KlyTempFault			: std_logic; 
signal FocusCoilAnaFault	: std_logic; 
signal KLYVACAna				: std_logic; 
signal WGVACAna				: std_logic; 

signal BeamVRangeFault		: std_logic; 
signal FwdPwrRangeFault		: std_logic; 
signal ReflPwrRangeFault	: std_logic; 
signal BeamIOverFault		: std_logic;  
signal BeamILow				: std_logic; 
signal FwdPwrFault			: std_logic; 
signal ReflPwrFault			: std_logic; 
 
signal TANK_Fault				: std_logic; 
signal N_TANK_HI				: std_logic; 
signal PUMPII_Fault			: std_logic; 
signal UseAccTrigger			: std_logic; 
signal TriggerDisable		: std_logic;

signal Wg_Vac_Fault			: std_logic;
signal iSystem_Fault			: std_logic;
signal SW_Fault_Reset_Le	: std_logic;
signal SysClk119Mhz			: std_logic;
signal MagRfOff				: std_logic;

attribute keep : string;
--attribute keep of iSPI_Clk 	: signal is "true";
--attribute keep of iSPI_SS 		: signal is "true";
--attribute keep of iSPI_MOSI 	: signal is "true";
--attribute keep of iSPI_MISO 	: signal is "true";

attribute keep of sysclk : signal is "true";

begin

Assign 			<= (Others => '0');
HSTA	 			<= (Others => '0');
ModState			<= (Others => '0');

MEM_CLK 			<= '0';
N_MEM_OE 		<= '1'; 
N_MEM_GW 		<= '1'; 
N_MEM_BWE 		<= '1'; 	
N_MEM_BW 		<= (Others => '1'); 				
N_MEM_ADSC 		<= '1'; 	
--MEM_Addr 		<= (Others => '0');
--MEM_Data			<= (Others => '0');
MEM_Parity		<= (Others => '0');
RS0				<= '0';
RS1				<= '0';

TX_DISABLE0				<= '0';
TX_DISABLE1				<= '0';

N_Permit 				<= Not(Permit);

System_Fault			<= iSystem_Fault;

-- jjo 05/08/13
-- used legacy_wg_valve test to 
-- generate external fault
--
Legacy_WG_Valve_Test <= iSystem_Fault;
M24VFault 				<= MON_Adc_Status(0);

--Low true Inputs

-- jjo 05/07/13
-- and'd permit into mod trigger
--

Board_Id					<= NOT(N_MODID);
Reset						<= NOT(N_BRD_RST);
N_MOD_TRIGGER			<= NOT(Mod_Trigger_Out) and Permit and NOT(MAG_PS_Off) and not(isystem_fault);
N_REAR_TRIGGER			<= NOT(REAR_TRIGGER);	
N_FRONT_TRIGGER		<= NOT(FRONT_TRIGGER);
N_MOD_TRIGGER_EN		<= NOT(Mod_TriggerEn_Out) and Permit and NOT(MAG_PS_Off) and not(isystem_fault);

-- Monitor ADC
n_MONADC_CS 			<= NOT(MONADC_CS);
n_MONADC_WR				<= NOT(MONADC_WR);
n_MONADC_RD				<= NOT(MONADC_RD);
MONADC_EOLC 			<= NOT(N_MONADC_EOLC);
MONADC_EOC				<= NOT(N_MONADC_EOC);
MONADC_Clk				<= iMONADC_Clk;
MONADC_CONVST			<= iMONADC_CONVST;

-- Slow ADC
n_SLOWADC_CS 				<= NOT(SLOWADC_CS);
n_SLOWADC_WR				<= NOT(SLOWADC_WR);
n_SLOWADC_RD				<= NOT(SLOWADC_RD);
SLOWADC_EOLC 				<= NOT(N_SLOWADC_EOLC);
SLOWADC_EOC					<= NOT(N_SLOWADC_EOC);
SLOWADC_Clk					<= iSLOWADC_Clk;
SLOWADC_CONVST				<= iSLOWADC_CONVST;

-- Temperature ADC
Temp_SClk					<= iTemp_SClk;
N_TEMP_OUT_CS 				<= NOT(TEMP_OUT_CS);
N_TEMP_IN_CS 				<= NOT(TEMP_IN_CS);
TempSDin						<= Temp_DIn_Rdy;     --  Input From external ADC
Temp_DOut					<= TempSDOut;			 -- Output to External ADC

N_FADC_CS					<= Not(iFADC_Cs);
FADC_SClk					<= iFADC_SClk;
FADC_SDIO					<= iFADC_SDIO;

N_RFATTN_SYNC 				<= NOT(iRFATTN_SYNC);

RFAttn_SClk					<= iRFAttn_SClk;
RFAttn_SDOut				<= iRFAttn_SDOut;

Focus_SClk 					<= iFocus_SClk;
N_Focus_Sync 				<= Not(iFocus_Sync);
Focus_SDout 				<= iFocus_SDOut;


SPI_CLK 						<= iSPI_Clk;
N_SPI_SS 					<= NOT(iSPI_SS);
SPI_MOSI 					<= iSPI_MOSI;



N_SPI_RESET 				<= Not(FPD_Reset OR SysReset);
N_SPI_DPOM 					<= not(FPD_DPOM);
iSPI_MISO					<= SPI_MISO;
iSPI_SBuf					<= NOT(N_SPI_SBuf);

-- RFDrive Temporaray tie
Local_Drive					<= x"00";
Local_Drive_Wr				<= '0';
SystemFault					<= '0';
BeamILowThres				<= '0';

Modulator_On				<= '0';
Fault_Reset					<= '0';


---- Flash Memory Control
N_FOE 						<= not(Flash_Oe);
N_FCS 						<= not(Flash_Cs);
N_FWE 						<= not(Flash_We);
VPP							<= Flash_VPP;

--
SW_TRIGEN 					<= NOT(N_SW_TRIGEN);
SW_FLT_RST 					<= NOT(N_SW_FLT_RST);
SW_TEST 				  		<= NOT(N_SW_TEST);
SW_SPARE2 					<= NOT(N_SW_SPARE2);
SW_SPARE1 					<= NOT(N_SW_SPARE1);
SW_POT2						<= NOT(N_POT2_SW);
SW_POT1 						<= NOT(N_POT1_SW);
SW_LOCAL 					<= NOT(N_SW_LOCAL);

--SLED_UPPER_TUNED 			<= NOT(N_SLED_UPPER_TUNED);
--SLED_UPPER_DETUNED 		<= NOT(N_SLED_UPPER_DETUNED);
--SLED_MOTOR_NOT_TUNED 	<= NOT(N_SLED_MOTOR_NOT_TUNED);
--SLED_MOTOR_NOT_DETUNED 	<= NOT(N_SLED_MOTOR_NOT_DETUNED);
--SLED_LOWER_TUNED 			<= NOT(N_SLED_LOWER_TUNED);
--SLED_LOWER_DETUNED 		<= NOT(N_SLED_LOWER_DETUNED);

TANK_LO						<= NOT(N_TANK_LO);
PUMPII						<= NOT(N_PUMPII);

MOD_HV_ON_MON 				<= NOT(N_MOD_HV_ON_MON);
MOD_FAULT_MON 				<= NOT(N_MOD_FAULT_MON);
MOD_EXT_INTLK_MON 		<= NOT(N_MOD_EXT_INTLK_MON);
MOD_HVOC_MON 				<= NOT(N_MOD_HVOC_MON);
MOD_EOLC_MON 				<= NOT(N_MOD_EOLC_MON);
MOD_TTOC_MON 				<= NOT(N_MOD_TTOC_MON);
MOD_HV_RDY_MON 			<= NOT(N_MOD_HV_RDY_MON);
MOD_AVAIL_MON 				<= NOT(N_MOD_AVAIL_MON);
MOD_INTLK_COMP_MON 		<= NOT(N_MOD_INTLK_COMP_MON);
MOD_CTRL_PWR_FLT_MON		<= NOT(N_MOD_CTRL_PWR_FLT_MON);
MOD_KLY_FIL_TD_MON 		<= NOT(N_MOD_KLY_FIL_TD_MON);
MOD_VVS_PWR_MON 			<= NOT(N_MOD_VVS_PWR_MON);
ACC2_FLOW_MON 				<= NOT(N_ACC2_FLOW_MON);
ACC1_FLOW_MON 				<= NOT(N_ACC1_FLOW_MON);
WG1_FLOW_MON 				<= NOT(N_WG1_FLOW_MON);
WG2_FLOW_MON 				<= NOT(N_WG2_FLOW_MON);
KLY_FLOW_MON 				<= NOT(N_KLY_FLOW_MON);
Flow_Sum_Fault				<= NOT(N_Flow_Summary);
WG_TCGUAGE_MON 			<= NOT(N_WG_TCGUAGE_MON);
WG_VALVE_MON 				<= NOT(N_WG_VALVE_MON);
LEGACY_AVAIL_MON 			<= NOT(N_LEGACY_AVAIL_MON);
ION_PUMP_MON 				<= NOT(N_ION_PUMP_MON);
WG_VAC_OK_MON 				<= NOT(N_WG_VAC_OK_MON);
WG_VAC_BAD_MON 			<= NOT(N_WG_VAC_BAD_MON);
MAG_I_INTLK_MON 			<= NOT(N_MAG_I_INTLK_MON);
MAG_I_OK_MON 				<= NOT(N_MAG_I_OK_MON);
MAG_KLIXON_MON 			<= NOT(N_MAG_KLIXON_MON);
N_Tank_Hi					<= NOT(Tank_Hi);

Wg_Vac_Fault 				<= (N_ION_PUMP_MON OR N_PUMPII);
--
---- Low True Outputs
--SYSTEM_FAULT 		<= System_Fault;

N_MAG_PS_ON 			<= MAG_PS_Off;
N_X_MOD_ON 				<= NOT(X_MOD_ON);
N_X_FAULT_RST_CMD 	<= NOT(X_FAULT_RST_CMD);
N_X_HV_OFF_CMD 		<= NOT(X_HV_OFF_CMD);
N_X_HV_ON_CMD 			<= NOT(X_HV_ON_CMD);
N_X_CTRL_PWR_ON_CMD 	<= NOT(X_CTRL_PWR_ON_CMD);


--N_SLED_ENABLE 			<= NOT(SLED_TuneENABLE);
--N_SLED_TUNE 				<= NOT(SLED_TUNE);
--N_SLED_DETUNE 			<= NOT(SLED_DETUNE);

tp(0) <= Flash_Oe;
tp(1) <= Flash_We;
tp(2) <= Flash_Cs;
tp(3) <= Lnk_Flash_EraseBlk;
tp(4) <= '0';
tp(5) <= '0';
tp(6) <= Lnk_Active;

TANK_Fault		<= N_TANK_LO or N_TANK_HI;
PUMPII_Fault 	<= PUMPII; 

FP_Led <= iFP_Led;

FlashIO_p : process(Flash_We, Flash_Cs, Flash_DOut)
begin
if ((Flash_We = '1') and (Flash_Cs = '1')) then
	MEM_DATA <= x"0000" & Flash_DOut;
else
	MEM_Data <= (Others => 'Z');
end if;
end process;

Flash_Din <= Mem_Data(15 downto 0);

MEM_Addr	<= Flash_Addr;

u_pon :  pon_rst
Port map (
	Clock			=> SysClk,
	sys_reset 	=> Reset,
	pon_reset   => SysReset
);

u_clk119Mhz : IBUFDS
port map (
	I 	=> CLK119MHZ_IN_p,
	IB => CLK119MHZ_IN_n,
	O	=> CLK119MHZ
);

u_clk119mhzbuf : bufg
port map (
	I => Clk119Mhz,
	O => Clk119MhzBuf
);
	
u_clkDet : ClkDet119Mhz
Port map (
	Clk125Mhz	=> Lnk_Clk,
	Reset 		=> Reset,
	Clk119Mhz 	=> Clk119MhzBuf,
	Clk119MhzOK => Clk119MhzOk
	);

u_clkMux : ClkMux
PORT MAP(
	CLKIN1_IN		=> Clk119MhzBuf,
	CLKIN2_IN 		=> Lnk_Clk,
	CLKINSEL_IN 	=> Clk119MhzOk,
	RST_IN		 	=> Reset,
	CLKOUT0_OUT 	=> SysClk,
	LOCKED_OUT 		=> ClkLocked
	);

--SysClk 	<= Lnk_Clk;

u_ClkGen : ClkEn_Gen
Port map (
	Clock 			=> SysClk,
	Reset 			=> Reset,
	CLk30MhzEn 		=> Clk30MhzEn,
	Clk1MhzEn		=> Clk1MhzEn,
	clk400KhzEn		=> clk400KhzEn,
	Clk100KhzEn		=> Clk100KhzEn,
	Clk10KhzEn		=> Clk10KhzEn,
	Clk1KhzEn		=> Clk1KhzEn,
	Clk100HzEn		=> Clk100HzEn,
	Clk10HzEn		=> Clk10HzEn,
	Clk2HzEn			=> Clk2HzEn,
	Clk1HzEn			=> Clk1HzEn
);

u_fp_In : FrontPanel_Input
Port map(
	Clock 	  					=> SysClk,
	Reset 	  					=> Reset,
	ClkEn							=> Clk100KHzEn,

	SW_TRIGEN 					=> SW_TRIGEN,
	SW_TEST 						=> SW_TEST,
	SW_SPARE2 					=> SW_SPARE2,
	SW_SPARE1 					=> SW_SPARE1,
	SW_FLT_RST 					=> SW_FLT_RST,
	SW_LOCAL 					=> SW_LOCAL,
	SW_POT2 						=> SW_POT2,
	SW_POT1 						=> SW_POT1,
	POT2_UP 						=> POT2_UP,
	POT2_DOWN 					=> POT2_DOWN,
	POT1_UP 						=> POT1_UP,
	POT1_DOWN 					=> POT1_DOWN,

	SW_Trigger_Enable_db		=> FP_Trigger_Enable,
	SW_Test_db			  		=> FP_Test,
	SW_Fault_Reset_db 	  	=> FP_Fault_Reset,
	SW_Fault_Reset_Le  	  	=> SW_Fault_Reset_Le,

	SW_Local_db			 	  	=> FP_Local,

	Delay_Up_db		 	  		=> FP_Delay_Up,
	Delay_Dn_db		 	  		=> FP_Delay_Dn,
	Delay_Sw_db		 	  		=> FP_Delay_Sw,

	Drive_Up_db		 	  		=> FP_Drive_Up,
	Drive_Dn_db		 	  		=> FP_Drive_Dn,
	Drive_Sw_db		 	  		=> FP_Drive_Sw,

	SW_Inc_db		 	  		=> FP_SW_Inc,
	SW_Dec_db		 	  		=> FP_SW_Dec
	);

u_Glink :  mksuii_GLink
port map (
	Reset 					=> Reset,
	Clock						=> SysClk,
--	Clock						=> Lnk_Clk,
	
	Lnk_Clk					=> Lnk_Clk,
	Active					=> Lnk_Active,
	Lnk_Error				=> Lnk_Error,
	Lnk_Locked				=> Lnk_Locked,

-- Rx Data
	Lnk_DataOut				=> Lnk_Rx_Data,
	Lnk_DataStrb			=> Lnk_Rx_Data_Strobe,
	Lnk_MessStrb			=> Lnk_Rx_Mess_Strobe,
	Lnk_MessType			=> Lnk_Rx_MessType,
	Lnk_TaskId				=> Lnk_Rx_TaskID,

-- Tx Data
	Tx_Start					=> Lnk_Tx_Start,
	Tx_MessType				=> Lnk_Tx_MessType,
	Tx_TaskId				=> Lnk_Tx_TaskID,
	Tx_Count					=> Lnk_Tx_Count,
	Tx_Data_In	     		=> Lnk_Tx_Data,
	Tx_Done					=> Lnk_Tx_Done,
	Tx_Rdy					=> Lnk_Tx_Ready,

-- Brd_Id used as LSByte of EMAC and IP Address and UDP Link Node ID
	BRD_ID					=> Board_ID,

--EMAC-MGT link status
 
	TXP_0						=> TX0_P,
-- 1000BASE-X PCS/PMA Interface - EMAC0
	TXN_0						=> TX0_N,
	RXP_0						=> RX0_P,
	RXN_0						=> RX0_N,
	
-- unused transceiver
	TXP_1_UNUSED			=> TX1_P,
	TXN_1_UNUSED			=> TX1_N,
	RXP_1_UNUSED			=> RX1_P,
	RXN_1_UNUSED			=> RX1_N,
	
-- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs
	MGTCLK_P					=> MGTCLK1_P,
	MGTCLK_N					=> MGTCLK1_N

);

u_Lnk_Decode :  Glink_Decode
Port map (
	Clock						=> SysClk,
	Reset	 					=> Reset,
	Clk1MhzEn				=> Clk1MhzEn,
	
	Lnk_Mess 				=> Lnk_Rx_MessType,				-- From Glink
	Lnk_MessStrb 			=> Lnk_Rx_Mess_Strobe,   	-- From Glink
	Lnk_TaskID				=> Lnk_Rx_TaskID,
	Lnk_DataIn 				=> Lnk_Rx_Data,				-- From Glink
	Lnk_DataStrb 			=> Lnk_Rx_Data_Strobe,		-- From Glink
	Lnk_AddrOut				=> Lnk_Addr2Reg,
	Lnk_DataOut 			=> Lnk_Data2Reg,

	Tx_Start					=> Lnk_Tx_Start,
	Tx_MessType				=> Lnk_Tx_MessType,							-- Transmit message type
	Tx_DataOut	     		=> Lnk_Tx_Data,								-- Data from external memory or registers
	Tx_TaskId	     		=> Lnk_Tx_TaskId,
	Tx_Count					=> Lnk_Tx_Count, 		-- Depends on Readout type
	Tx_Done					=> Lnk_Tx_Done,
	Tx_Rdy					=> Lnk_Tx_Ready,

	Lnk_SlowThres_Wr		=> Lnk_SlowThres_Wr,
	Lnk_SlowADC_Din		=> Lnk_SlowADC_DOut,

	Lnk_MONADC_Din			=> Lnk_MonADC_DOut,
	
	Lnk_TrigIntf_Wr 		=> Lnk_TrigIntf_Wr,
	Lnk_TrigIntf_Din 		=> Lnk_Trigger_DOut,

	Lnk_KlyTempMon_Wr		=> Lnk_KlyTempMon_Wr,
	Lnk_KlyTempMon_Din 	=> Lnk_KlyTempMon_DOut,

	Lnk_FastADC_Wr			=> Lnk_FastADC_Wr,
	Lnk_FastADC_WFM_Rd	=> Lnk_FastADC_WFM_Rd,
	Lnk_FastADC_DIn		=> Lnk_FastADC_DOut,

	Lnk_RFDrive_Wr 		=> Lnk_RFDrive_Wr,
	Lnk_RFDriveLkup_Wr	=> Lnk_RFDriveLkup_Wr,
	Lnk_RFDriveLkUp_Din 	=> Lnk_RFDriveLkUp_DOut,
	Lnk_RFDrive_Din 		=> Lnk_RFDrive_DOut,

	Lnk_FocusCoil_Wr 		=> Lnk_FocusCoil_Wr,
	Lnk_FocusCoil_Din 	=> Lnk_FocusCoil_DOut,

	Lnk_eDip_Wr	 			=> Lnk_eDisplay_Wr,
	Lnk_eDip_Din 			=> Lnk_eDisplay_DOut,

	Lnk_SLED_Wr	 			=> Lnk_SLED_Wr,
	Lnk_SLED_Din 			=> Lnk_SLED_DOut,

	Lnk_Mod_Intf_Wr		=> Lnk_Mod_Intf_Wr,
	Lnk_Mod_Intf_Din 		=> Lnk_Mod_Intf_DOut,

	Lnk_Water_Flow_Wr		=> Lnk_Water_Flow_Wr,
	Lnk_Water_Flow_Din 	=> Lnk_Water_Flow_DOut,

	Lnk_Legacy_Mod_Wr		=> Lnk_Legacy_Mod_Wr,
	Lnk_Legacy_Mod_Din 	=> Lnk_Legacy_Mod_DOut,

	Lnk_WG_Vac_Wr			=> Lnk_WG_Vac_Wr,
	Lnk_WG_Vac_Din 		=> Lnk_WG_Vac_DOut,

	Lnk_MagIntf_Wr			=> Lnk_MagIntf_Wr,
	Lnk_MagIntf_Din 		=> Lnk_MagIntf_DOut,

	Lnk_IonPump_Wr			=> Lnk_IonPump_Wr,
	Lnk_IonPump_Din 		=> Lnk_IonPump_DOut,

	Lnk_CntlIntf_Wr		=> Lnk_CntlIntf_Wr,
	Lnk_CntlIntf_Din		=> Lnk_CntlIntf_DOut,

	Lnk_FaultGen_Wr		=> Lnk_FaultGen_Wr,
	Lnk_FaultGen_Din		=> Lnk_FaultGen_DOut,
	
	Lnk_Flash_WriteBlk	=> Lnk_Flash_WriteBlk,
	Lnk_Flash_WriteAddr  => Lnk_Flash_WriteAddr,
	Lnk_Flash_ReadBlk		=> Lnk_Flash_ReadBlk,
	Lnk_Flash_EraseBlk	=> Lnk_Flash_EraseBlk, 
	Lnk_Flash_LockBlk		=> Lnk_Flash_LockBlk,
	Lnk_Flash_Din			=> Lnk_Flash_DOut,
	Lnk_Flash_DAV			=>	Lnk_Flash_DAV,	 

	
	Lnk_SFP_Din				=> Lnk_SFP_DOut,

	Lnk_SysInfo_Din		=> Lnk_SysInfo_DOut,

	Lnk_SysMon_Din			=> Lnk_SysMon_DOut,
	
	Lnk_FaultHistory_Rd	=> Lnk_FaultHistory_Rd,
	Lnk_FaultHistory_DIn	=> Lnk_FaultHistory_DOut

	);

u_LocalTrig : LocalTrigger
port map (
	Clock 				=> SysClk,
	Reset 				=> Reset,
	Clk_En				=> Clk1KhzEn,
	Mode_Local			=> Mode_Local,

	Delay_up				=> FP_Delay_Up,
	Delay_Dn 			=> FP_Delay_Dn,
	Delay_Sw				=> FP_Delay_Sw,

	FP_SW_Inc			=> FP_SW_Inc,
	FP_SW_Dec			=> FP_SW_Dec,


	LocalTrigDelay 	=> LocalTrigDelay,
	LocalRateDiv		=> LocalRateDiv,
	
	up						=> DelayUp,
	dn						=> DelayDn
);


u_Trigger : Trigger
Port map (
	Clock 	  				=> SysClk,
	Reset 	  				=> Reset,

	AccTrig_p 				=> TRIGGER_IN0_p,
	AccTrig_n 				=> TRIGGER_IN0_n,
	StbyTrig_p 				=> TRIGGER_IN1_p,
	StbyTrig_n 				=> TRIGGER_IN1_n,
	
	UseAccTrigger			=>	UseAccTrigger,
	
	SelfTriggerEn			=> SelfTriggerEn,
	
-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,				-- From Regiser Decoder
	Lnk_Wr		 			=> Lnk_TrigIntf_Wr,			-- From Regiser Decoder
	Lnk_DataIn				=> Lnk_Data2Reg,				-- From Regiser Decoder

	Reg_DataOut				=> Lnk_Trigger_DOut,			-- To Register Decoder

	Clk100KhzEn				=> Clk100KhzEn,					-- From Clock Enable Generator
	Local						=> Mode_Local,					
	LocalTrigDelay 		=> LocalTrigDelay,			-- From Front Panel Control
	LocalRateDiv			=> LocalRateDiv,				-- From Front Panel Control 
	TriggerEn				=> TriggerEn,
	TriggerDisable			=> TriggerDisable,			-- From Fault Gen Trigger Disable
	Mode_Maint				=> Mode_Maint,
	
	WFMTrigger				=> iWFMTrigger,					-- To WFM Interface
	ModTrigger				=> MOD_TRIGGER,				-- To Output
	RearTrigger				=> REAR_TRIGGER,				-- To Output
	FrontTrigger			=> FRONT_TRIGGER,				-- To Output

	DisplayTrigDelay	 	=> DisplayTrigDelay,

	InputRate				=> InputRate,					-- To Display
	OutputRate				=> OutputRate,					-- To Display

	EventCounter			=> EventCounter

	);

-- jjo 05/05/13
-- Removed MOD_TriggerEn_out from wfmtrigger
--

--WFMTrigger <= iWFMTrigger AND Mod_TriggerEn_Out;
WFMTrigger <= iWFMTrigger;

u_FastADC : FastADCIntf 
Port map (
	Clock						=> SysClk,
	Reset 	  				=> Reset,
	Clk1HzEn					=> Clk1HzEn,

-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,		-- From Link Decode
	Lnk_Wr		 			=> Lnk_FastADC_Wr,	-- From Link Decode
	Lnk_DataIn				=> Lnk_Data2Reg,		-- From Link Decode
	Lnk_WFMRd				=> Lnk_FastADC_WFM_Rd,
	Reg_DataOut				=> Lnk_FastADC_DOut,
	Status					=> FASTADC_Status,
	
	ArmWFM					=> ArmWFM,
	ArmAve					=> ArmAve,
	WFMArmed					=> WFMArmed,
	AveArmed					=> AveArmed,

-- Average
	Beam_V_Average 		=> Beam_V_Average,
	Beam_I_Average 		=> Beam_I_Average,
	FWD_PWR_Average 		=> FWD_PWR_Average,
	REFL_PWR_Average 		=> REFL_PWR_Average,

-- 
	Trigger					=> WfmTrigger,

	WFM_Avail				=> WFM_DAV,
	BeamILow					=> BeamILow,

-- Fast ADC Input 
	FADC_CLK_P 				=> FADC_Clk_p,
	FADC_CLK_N 				=> FADC_Clk_n,
	FADC_FRAME_CLK_P 		=> FADC_Frame_Clk_p,
	FADC_FRAME_CLK_N 		=> FADC_Frame_Clk_n,
	FADC_DATA_CLK_P 		=> FADC_Data_Clk_p,
	FADC_DATA_CLK_N 		=> FADC_Data_Clk_n,
	BEAM_V_P 				=> Beam_V_p,
	BEAM_V_N 				=> Beam_V_n,
	BEAM_I_P 				=> Beam_I_p,
	BEAM_I_N 				=> Beam_I_n,
	FWD_PWR_P 				=> Fwd_Pwr_p,
	FWD_PWR_N 				=> Fwd_Pwr_n,
	REFL_PWR_P 				=> Refl_Pwr_p,
	REFL_PWR_N 				=> Refl_Pwr_n,
	
--	Frameclk					=> FADC_Frame_Clk,
--	Dataclk					=> FADC_Data_clk,
	DataClkLocked			=> DataClkLocked

	);


SlowADC_p : process(SysClk, SysReset)
Begin
if (SysReset = '1') then
	StartMonADC 	<= '1';
	StartSlowADC 	<= '0';
elsif (SysClk'event and SysClk = '1') then
	if (SLOWADCDone = '1') then
		StartSlowADC 	<= '0';
		StartMonADC 	<= '1';
	elsif (MonADCDone = '1') then
		StartSlowADC 	<= '1';
		StartMonADC 	<= '0';
	else
		StartSlowADC 	<= '0';
		StartMonADC 	<= '0';
	end if;
end if;
end process;
		
u_SLOWADC : Slow_ADC_Cntl 
Port map ( 
-- System 
	Clock 				=> SysClk,
	Reset 				=> Reset,
	SlowClkEn 			=> Clk30MhzEn,
	StartCycle			=> StartSLOWADC,
	CycleDone			=> SLOWADCDone,
	
-- Link Interface
	Lnk_Addr		 		=> Lnk_Addr2Reg,			-- From Link Decode
	Lnk_Wr		 		=> Lnk_SlowThres_Wr,		-- From Link Decode
	Lnk_DataIn			=> Lnk_Data2Reg,			-- From Link Decode
	Lnk_RdThreshold	=> Lnk_RdThreshold,		-- From Link Decode
	Lnk_Dav				=> Lnk_Slow_DAV,			-- To Link Decode
	Lnk_DataOut			=> Lnk_SlowADC_DOut,		-- To Link Decode
	
-- ADC Control and Data
	Wr                => SLOWADC_WR,
	Cs                => SLOWADC_CS,
	Rd                => SLOWADC_RD,
	Convst            => iSLOWADC_CONVST,
	ADC_Clk				=> iSLOWADC_Clk,
	EOC               => SLOWADC_EOC,
	EOLC              => SLOWADC_EOLC,
	ADCDataIn         => SLOWADC_DATA,

	WGVac					=> WGVac,
	KlyVac				=> KlyVac,
	
	
-- System Status
--	Status           => SLOW_Adc_Status
	Status           => open

 );


-- jjo 
-- 4/23/13
-- Replace SLOW_Adc_Status from  Slow_ADC_Cntl with "0"s
SLOW_ADC_Status <= "0000000000000000";


u_MonADC : Mon_ADC_Cntl 
Port map ( 
-- System 
	Clock 				=> SysClk,
	Reset 				=> Reset,
	SlowClkEn 			=> Clk30MhzEn,
	StartCycle			=> StartMonADC,
	CycleDone			=> MonADCDone,
	
-- Link Interface
	Lnk_Addr		 		=> Lnk_Addr2Reg,			-- From Link Decode
	Lnk_Dav				=> Mon_ADC_Dav,			-- To Link Decode
	Lnk_DataOut			=> Lnk_MonADC_DOut,	-- To Link Decode
	
-- ADC Control and Data
	Wr                => MONADC_WR,
	Cs                => MONADC_CS,
	Rd                => MONADC_RD,
	Convst            => iMONADC_CONVST,
	ADC_Clk				=> iMONADC_Clk,
	EOC               => MONADC_EOC,
	EOLC              => MONADC_EOLC,
	ADCDataIn         => SLOWADC_DATA,
	
-- System Status
	Status           	=> MON_Adc_Status
 );

LED_Trigen	<= Mod_TriggerEn_Out;

u_FP :  FrontPanel_LED 
Port map (
	Clock 	  		=> SysClk,
	Reset 	  		=> Reset,
	ClkEn				=> Clk1kHzEn,
	FP_ClkEn			=> Clk1HzEn,

	Configured 		=> Configured,
	Sw_Local		 	=> FP_Local,
	Mode_Local 		=> Mode_Local,
	LED_Test	  		=> SW_TEST,
	
	LED_Out	  		=> iFP_LED,

	ACCEL2			=> N_ACC2_FLOW_MON,
	ACCEL1			=> N_ACC1_FLOW_MON,
	WG_WATER2  		=> N_WG2_FLOW_MON,
	WG_WATER1  		=> N_WG1_FLOW_MON,
	KLY_WATER  		=> N_KLY_FLOW_MON,
	WG_VAC_INTLK	=> N_WG_VAC_OK_MON,
	WG_VALVE			=> '0',
	KLY_VAC_INTLK	=> Wg_Vac_Fault,
	KLY_DELTA_T		=> KlyTempFault,
	KLY_MAG_INTLK	=> N_MAG_I_INTLK_MON,
	TANK_Fault		=> TANK_Fault,
	PUMPII_Fault	=> '0',
--	MOD_OV			=> FASTADC_Status(1),
	MOD_OV			=> BeamVRangeFault,
--	MOD_OI			=> FASTADC_Status(3),
	MOD_OI			=> BeamIOverFault,
--	FWR_PWR 			=> FASTADC_Status(5),
	FWR_PWR 			=> FwdPwrRangeFault,
	OFFLINE			=> Mode_OFFL,
--	RF_PWR 			=> FASTADC_Status(7),
	RF_PWR 			=> ReflPwrRangeFault,
	MAINTENANCE		=> Mode_Maint,
	TCVAC				=> '0',
	STANDBY 			=> Mode_Stndby,
	SPARE1 			=> '0',
	ACCELERATE 		=> Mode_Accel,
	SPARE2 			=> '0',
	DRIVE_FAULT 	=> FASTADC_Status(8),
	MOD_AVAIL		=> '0',
	TRIGGEREn		=> LED_Trigen,
	HEARTBEAT		=> Lnk_Active,
	BATTERY_FAULT 	=> M24VFault,
	FAULT_LIMIT 	=> '0'
	);


u_Sysmon : SysMon_Intf 
Port map( 
	Clock 					=> SysClk,
	Reset 					=> Reset,

	Start						=> Clk1HzEn,

	VP_IN						=> VP_in,					-- Dedicated Analog Input Pair
	VN_IN						=> VN_In,					-- Dedicated Analog Input Pair

-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,			-- From Link Decode
	Lnk_DataOut				=> Lnk_SysMon_DOut		-- To Link Decode

);

u_Temp :  TempADC
Port map (
	Clock                => SysClk,
	Reset                => SysReset,          
	Clk1MhzEn				=> Clk1MhzEn,

	Lnk_Addr		 			=> Lnk_Addr2Reg,	  		-- From Link Interface
	Lnk_Wr		 			=> Lnk_KlyTempMon_Wr,	-- From Link Decode
	Lnk_DataIn				=> Lnk_Data2Reg,			-- From Link Decode
	Lnk_DataOut				=> Lnk_KlyTempMon_DOut,	-- To Link Interface

	TempSClk					=> iTemp_SClk,
	TempSDOut				=> TempSDOut,
	TempSDIn					=> TempSDIn,
	Temp_Out_Cs				=> Temp_Out_Cs,
	Temp_In_Cs				=> Temp_In_Cs,

	InTemp					=> KlyInTemp,
	OutTemp					=> KlyOutTemp,

	DeltaTemp				=> DeltaTemp,
	
	Fault						=> KlyTempFault,

	Status					=> KlyTempStatus
	);

--FADC_SClk 	<= '0';
--FADSC_SDIO 	<= '0';
--FASC_Cs 		<= '0';

u_FADCSPI : FADCSpi 
Port map (
	Clock						=> SysClk,
	Reset 	  				=> Reset,
	Clk1MhzEn				=> Clk1MhzEn,
	FADCSClk					=> iFADC_SClk,
	FADCSIO					=> iFADC_SDIO,
	FADCCs					=> iFADC_Cs
	);

u_RFDrive :  RFDrive
Port map (
	Clock						=> SysClk,
	Reset 	  				=> Reset,
	FpReset 	  				=> FpReset,


-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,									-- From Link Interface
	Lnk_Wr		 			=> Lnk_RFDrive_Wr,								-- From Link Interface
	Lnk_DataIn				=> Lnk_Data2Reg,									-- From Link Interface

	Reg_DataOut				=> Lnk_RFDrive_DOut,
	LkUp_DataOut			=> Lnk_RFDriveLkUp_DOut,
	Ram_We					=> Lnk_RFDriveLkup_Wr,

	Clk1hzEn					=> Clk1hzEn,
	Clk10hzEn				=> Clk10hzEn,
	Clk10KhzEn				=> Clk10KhzEn,
	Clk1MhzEn				=> Clk1MhzEn,
	LocalMode				=> Mode_Local,
	LocalDrive				=> Local_Drive,
	LocalWr					=> Local_Drive_Wr,
	Fault3of5				=> Fault3of5,
	BeamILowFault			=> BeamILow10s,
	FwdPwrFault				=> FwdPwrFault,
	ReflPwrFault			=> ReflPwrFault,

--jjo 05/06/13
--add offline to ForceZero
	OFFLine					=> Mode_OFFL,
	
-- jjo 7/8/13
-- Add mag off
	MagRfOff					=> MagRfOff,
	
	Ramping					=> Ramping,
	Status					=> RFDriveStatus,

	DisplayRFDrive			=> DisplayRFDrive,

	RFAttnClk				=> iRFAttn_SClk,
	RFAttnSync				=> iRFAttn_Sync,
	RFAttnSDOut				=> iRFAttn_SDOut
	);

u_focuscoil : FocusCoil
Port  map (
	Clock						=> SysClk,
	Reset 	  				=> Reset,

-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,			-- From Link Interface
	Lnk_Wr		 			=> Lnk_FocusCoil_Wr,		-- From Link Interface
	Lnk_DataIn				=> Lnk_Data2Reg,			-- From Link Interface

	Reg_DataOut				=> Lnk_FocusCoil_DOut,

	Clk1MhzEn				=> Clk1MhzEn,
	FocusClk					=> iFocus_SClk,
	FocusSync				=> iFocus_Sync,
	FocusSDOut				=> iFocus_SDout
	);
	


u_TankPump : TankPump 
Port map (
	Clock						=> SysClk,
	Reset						=> Reset,
	
-- Link Interface
	Lnk_Addr		 			=> Lnk_Addr2Reg,		-- From Link Interface
	Lnk_Wr		 			=> Lnk_SLED_Wr,									-- From Link Interface
	Lnk_DataIn				=> Lnk_Data2Reg,		-- From Link Interface

	Reg_DataOut				=> Lnk_SLED_DOut,
	
	Fault_Reset				=> Fault_Reset,

	Modulator_On			=> Modulator_ON,

	PUMPII					=> PUMPII,
	TANK_LO					=> TANK_LO,
	TANK_HI					=> TANK_HI,

	PUMPII_Test				=> PUMPII_Test,
	TANK_HI_Test			=> TANK_HI_Test,

	TANK_LO_Test			=> TANK_LO_Test,

	Status 					=> SLED_Status
);


u_Modintf : ModCmd
Port map (
	Clock							=> SysClk,
	Reset 	  					=> Reset,

-- Link Interface
	Lnk_Addr		 				=> Lnk_Addr2Reg,			-- From Link Interface
	Lnk_Wr		 				=> Lnk_Mod_Intf_Wr,		-- From Link Interface
	Lnk_DataIn					=> Lnk_Data2Reg,			-- From Link Interface

	Reg_DataOut					=> Lnk_Mod_Intf_DOut,

	Clk10hzEn					=> Clk10HzEn,

	MOD_VVS_PWR_Mon 			=> MOD_VVS_PWR_Mon,
	MOD_KLY_FIL_TD_MON 		=> MOD_KLY_FIL_TD_MON,
	MOD_CTRL_PWR_FLT_MON 	=> MOD_CTRL_PWR_FLT_MON, 
	MOD_INTLK_COMP_MON		=> MOD_INTLK_COMP_MON,
	MOD_AVAIL_MON				=> MOD_AVAIL_MON,
	MOD_HV_RDY_MON 			=> MOD_HV_RDY_MON ,
	MOD_TTOC_MON				=> MOD_TTOC_MON,
	MOD_EOLC_MON				=> MOD_EOLC_MON,
	MOD_HVOC_MON				=> MOD_HVOC_MON,
	MOD_EXT_INTLK_MON 		=> MOD_EXT_INTLK_MON,
	MOD_FAULT_MON				=> MOD_FAULT_MON,
	MOD_HV_ON_MON				=> MOD_HV_ON_MON,

	MOD_VVS_PWR_Test 			=> MOD_VVS_PWR_Test,
	MOD_KLY_FIL_TD_Test 		=> MOD_KLY_FIL_TD_Test,
	MOD_CTRL_PWR_FLT_Test 	=> MOD_CTRL_PWR_FLT_Test,
	MOD_INTLK_COMP_Test		=> MOD_INTLK_COMP_Test,
	MOD_AVAIL_Test				=> MOD_AVAIL_Test,
	MOD_HV_RDY_Test 			=> MOD_HV_RDY_Test,
	MOD_TTOC_Test				=> MOD_TTOC_Test,
	MOD_EOLC_Test				=> MOD_EOLC_Test,
	MOD_HVOC_Test				=> MOD_HVOC_Test,
	MOD_EXT_INTLK_Test 		=> MOD_EXT_INTLK_Test,
	MOD_FAULT_Test				=> MOD_FAULT_Test,
	MOD_HV_ON_Test				=> MOD_HV_ON_Test,



	Reset_FP						=> FpReset,
	FaultHvOff					=> FaultHvOff,

	FaultReset_Cmd				=> X_FAULT_RST_CMD,
	CtrlPwr_On_Cmd				=> X_CTRL_PWR_ON_CMD,
	HV_ON_Cmd     				=> X_HV_ON_CMD,
	HV_OFF_Cmd     			=> X_HV_OFF_CMD,

	Status						=> Mod_Intf_Status

	);
	
	
u_Flow : flow_intf 
Port map (
	Clock						=> SysClk,
	Reset						=> Reset,
	FpReset					=> FpReset,
	Clk1KhzEn				=> Clk1KhzEn,
	
	Lnk_Addr		 			=> Lnk_Addr2Reg,									-- From Link Interface
	Lnk_Wr		 			=> Lnk_Water_Flow_Wr,								-- From Link Interface
	Lnk_DataIn				=> Lnk_Data2Reg,			-- From Link Interface
	
	Reg_DataOut				=> Lnk_Water_Flow_DOut,

	ACC2						=> ACC2_FLOW_MON,
	ACC1						=> ACC1_FLOW_MON,
	WG2						=> WG2_FLOW_MON,
	WG1						=> WG1_FLOW_MON,
	KLY						=> KLY_FLOW_MON,
	Flow_Sum_Fault			=> Flow_Sum_Fault,
	
	ACC2_Test				=> ACC2_FLOW_TEST,
	ACC1_Test				=> ACC1_FLOW_TEST,
	WG2_Test					=> WG2_FLOW_TEST,
	WG1_Test					=> WG1_FLOW_TEST,
	KLY_Test					=> KLY_FLOW_TEST,

	Status					=> Flow_Status,

	Fault						=> Flow_Fault
	
);	
	
u_Legacy : LegacyModCmd
Port map(
	Clock					=> SysClk,
	Reset 	  			=> Reset,

-- Link Interface
	Lnk_Addr		 		=> Lnk_Addr2Reg,			-- From Link Interface
	Lnk_Wr		 		=> Lnk_Legacy_Mod_Wr,	-- From Link Interface
	Lnk_DataIn			=> Lnk_Data2Reg,			-- From Link Interface

	Reg_DataOut			=> Lnk_Legacy_Mod_DOut,

	WG_TCGuage_Mon 	=> WG_TCGuage_Mon,
	WG_Valve_MON 		=> WG_Valve_MON,
	Avail_MON 			=> Legacy_Avail_MON,


	WG_TCGuage_Test 	=> Legacy_WGTC_Gauge_Test,
	
-- jjo 05/08/13 
-- use legacy_wg_valve_test for
-- Xilinx External Fault

--	WG_Valve_Test 		=> Legacy_WG_Valve_Test,
	WG_Valve_Test 		=> open,
	Avail_Test 			=> Legacy_ModAvail_Test,

	Status				=> Legacy_Mod_Status

	);

u_WG_Vac : WG_VAC
Port map (
	Clock					=> SysClk,
	Reset 	  			=> Reset,
                                                                     
-- Link Interface                                                    
	Lnk_Addr		 		=> Lnk_Addr2Reg,			-- From Link Interface
	Lnk_Wr		 		=> Lnk_WG_Vac_Wr,			-- From Link Interface
	Lnk_DataIn			=> Lnk_Data2Reg,			-- From Link Interface
                                                                     
	Reg_DataOut			=> Lnk_WG_Vac_DOut,

	WG_Vac_Bad_Mon	   => WG_Vac_Bad_Mon,
	WG_Vac_Ok_MON 	 	=> WG_Vac_Ok_MON,


	WG_Vac_Bad_Test 	=> WG_Vac_Bad_Test,
	WG_Vac_OK_Test 	=> WG_Vac_OK_Test,

	Status				=> WG_Vac_Status

	);

u_MagIntf : MagIntf 
Port map (
	Clock                   => SysClk,
	Reset                   => Reset,                                           
                                                                               
-- Link Interface                                                              
	Lnk_Addr                => Lnk_Addr2Reg,			-- From Link Interface      
	Lnk_Wr                  => Lnk_MagIntf_Wr,			-- From Link Interface
	Lnk_DataIn              => Lnk_Data2Reg,			-- From Link Interface      
                                                                               
	Reg_DataOut             => Lnk_MagIntf_DOut,

	Mag_I_Intlk_Mon 			=> Mag_I_Intlk_Mon,
	Mag_I_Ok_MON 				=> Mag_I_Ok_MON,
	Mag_Klixon_MON 			=> Mag_Klixon_MON,


	Mag_I_Intlk_Test 			=> Mag_I_Intlk_Test,
	Mag_I_Ok_Test 				=> Mag_I_Ok_Test,
	Mag_Klixon_Test 			=> Mag_Klixon_Test,

	Status						=> MagIntf_Status

	);


u_IonPump : IonPump 
Port map (
	Clock                   => SysClk,
	Reset                   => Reset,                                         
                                                                             
	Lnk_Addr                => Lnk_Addr2Reg,			-- From Link Interface
	Lnk_Wr                  => Lnk_IonPump_Wr,			-- From Link Interface
	Lnk_DataIn              => Lnk_Data2Reg,			-- From Link Interface    
                                                                             
	Reg_DataOut             => Lnk_IonPump_DOut,
                                                                             
	Ion_Pump_Mon 				=> Ion_Pump_Mon,

	Ion_Pump_Test 				=> Ion_Pump_Test,

	Status						=> IonPump_Status

	);

u_CntlIntf : control_intf
Port map (
	Clock                => SysClk,
	Reset                => Reset,                                         

	FP_Local					=> FP_Local,

	Lnk_Addr             => Lnk_Addr2Reg,				-- From Link Interface
	Lnk_Wr               => Lnk_CntlIntf_Wr,			-- From Link Interface
	Lnk_DataIn           => Lnk_Data2Reg,				-- From Link Interface    
                                                                          

	Reg_DataOut          => Lnk_CntlIntf_DOut,
	Locked					=> ClkLocked,
	Clk119MhzOk				=> Clk119MhzOk,
	
	DataClkLocked			=> DataClkLocked,

	TriggerEn				=> TriggerEn,
	Configured				=> Configured,
	Permit					=> Permit,
	UseAccTrigger			=> UseAccTrigger,

-- PICFault  will become an input from the link node
-- 05/06/13

	PICFault					=> '0',
	
	ArmWFM					=> ArmWFM,
	ArmAve					=> ArmAve,
	WFMArmed					=> WFMArmed,
	AveArmed					=> AveArmed,

	SelfTriggerEn			=> SelfTriggerEn,

	Accel						=> Mode_Accel,
	Stndby					=> Mode_Stndby,
	OFFL						=> Mode_OFFL,
	Maint						=> Mode_Maint,

	Local						=> Mode_Local,

	Status					=> CntlIntf_Status

);


u_SysInfo : SysInfo
Port map (
	Clock                => SysClk,
	Reset                => Reset, 

	Lnk_Addr             => Lnk_Addr2Reg,			-- From Link Interface

	Reg_DataOut          => Lnk_SysInfo_DOut		-- From Link Interface

);


-- jjo 05/30/13
-- Disable display updates

u_Display : displayIntf 
Port map ( 
	Clock          => SysClk,
	Reset          => Reset,
                                                                      
	Lnk_Addr       => Lnk_Addr2Reg,				-- From Link Interface
	Lnk_Wr         => Lnk_eDisplay_Wr,			-- From Link Interface
	Lnk_DataIn     => Lnk_Data2Reg,				-- From Link Interface
	Reg_DataOut	 	=> Lnk_eDisplay_DOut,

	clk400KhzEn		=> Clk400KhzEn,
	Clk119Pres		=> Clk119MhzOk,

	Refresh			=> Clk2HzEn,

-- Display IO
	SPI_SS         => iSPI_SS,
	SPI_Clk        => iSPI_Clk,
	SPI_MOSI       => iSPI_MOSI,
	SPI_MISO       => iSPI_MISO,
	SBUF        	=> iSPI_SBUF,
	FPD_Reset      => FPD_Reset,
	FPD_DPOM       => FPD_DPOM,

-- 16 Bit signed integers	
	TrigDel        =>	DisplayTrigDelay,
	RFDrive        =>	DisplayRFDrive,
	MicroPrev      =>	DisplayMicroPrev,
	BeamV 			=>	Beam_V_Average,
	BeamI          =>	Beam_I_Average,
	FwdPwr         =>	FWD_PWR_Average,
	RefPwr         =>	REFL_PWR_Average,
	DeltaTemp      =>	DeltaTemp,
	WgVac          =>	WgVac,
	KlyVac         =>	KlyVac,

--	MicroPrev      =>	x"0000",
--	BeamV 			=>	x"0000",
--	BeamI          =>	x"0000",
--	FwdPwr         =>	x"0000",
--	RefPwr         =>	x"0000",
--	DeltaTemp      =>	x"0000",
--	WgVac          =>	x"0000",
--	KlyVac         =>	x"0000",
	
	ModId         =>	Board_Id,
	
	ModRate        =>	OutputRate,
	AccRate        =>	InputRate,

	IP_Address		=> MyIp_Addr,

-- Inputs
	Assign         =>	Assign,
	HSTA           =>	HSTA,
	ModState       =>	ModState

	);

--KLYVACAna 			<= SLOW_ADC_Status(0) OR Slow_ADC_Status(1);
--WGVACAna 			<= SLOW_ADC_Status(2) OR Slow_ADC_Status(3);
KLYVACAna 			<= Slow_ADC_Status(1);
WGVACAna 			<= Slow_ADC_Status(3);
FocusCoilAnaFault <= SLOW_ADC_Status(4) OR Slow_ADC_Status(5);

BeamVRangeFault		<= FASTADC_Status(1) or FASTADC_Status(0); 
FwdPwrRangeFault		<= FASTADC_Status(5) or FASTADC_Status(4); 
ReflPwrRangeFault		<= FASTADC_Status(7) or FASTADC_Status(6); 
BeamIOverFault			<= FASTADC_Status(3); 
--BeamILow					<= FASTADC_Status(2); 

u_FaultGen :  FaultGen
Port map(
	Clock 	  			=> SysClk,
	Reset 	  			=> Reset,
	
-- Link Interface
	Lnk_Addr		 		=> Lnk_Addr2Reg,		-- From Link Interface
	Lnk_Wr		 		=> Lnk_FaultGen_Wr,	-- From Link Interface
	Lnk_DataIn			=> Lnk_Data2Reg,		-- From Link Interface
	Reg_DataOut			=> Lnk_FaultGen_DOut,

	SW_Fault_Reset_Le =>	SW_Fault_Reset_Le,


	Clk1HZEn				=> Clk1HzEn,
	Clk10HzEn			=> Clk10HzEn,
	Clk1KHzEn			=> Clk1kHzEn,

	Trigger_In			=> Mod_Trigger,
	TriggerEn_In		=> TriggerEn,

	Sw_Trigen			=> FP_Trigger_Enable,

	TriggerDisable		=> TriggerDisable,

-- Fault Inputs
	M24V					=> M24VFault,
	
-- Analog from Slow ADC
	KLYVACAna			=> KLYVACAna,
	WGVACAna				=> WGVACAna,
	FocusCoilIAna		=> FocusCoilAnaFault,
	FocusCoilGndAna	=> SLOW_Adc_Status(6),

-- Analog from FAST ADC
	REFLPWR				=> ReflPwrRangeFault,
	FWDPWR				=> FwdPwrRangeFault,
	BeamI					=> BeamIOverFault,
	BeamV					=> BeamVRangeFault,
	
	BeamILow				=> BeamILow,
	FwdPwrFault			=> FwdPwrFault,
	ReflPwrFault		=> ReflPwrFault,
 
		
-- Flow Switches
	ACC2Flow				=> Flow_Status(12),
	ACC1Flow				=> Flow_Status(11),
	WG2Flow				=> Flow_Status(10),
	WG1Flow				=> Flow_Status(9),
	KLYFlow				=> Flow_Status(8),

-- Temperature Monitor
	TDiff					=> KlyTempFault,

-- Legacy
	KLYVAC				=> IonPump_Status(0), -- ION Pump
	WGVACBAD				=> WG_Vac_Status(1),
	n_WGVACOK			=> WG_Vac_Status(0),
	WGTCGauge			=> Legacy_Mod_Status(2),
	WGValve				=> Legacy_Mod_Status(1),

-- Magnet
	MagIIntlk			=> MagIntf_Status(2),
	MagIOK				=> MagIntf_Status(1),
	MagKlixon			=> MagIntf_Status(0),

---- From SLED Interface
--	SLED_TimeOut		=> SLED_TimeOut,
--	SLED_Fault			=> SLED_Fault,
--	SLED_OK				=> SLED_OK,

-- From Tank and Pump
	Tank_Lo				=> N_Tank_Lo,
	Tank_Hi				=> N_Tank_Hi,
	PumpII				=> N_PumpII,

-- Outputs
	Trigger_Out			=> Mod_Trigger_Out,
	TriggerEn_Out		=> Mod_TriggerEn_Out,

	HVOff					=> FaultHvOff,
	ExtIntlk				=> iSystem_Fault,
	MagOff 				=> MAG_PS_Off,
	Fault3of5 			=> Fault3of5,
	BeamILow10s 		=> BeamILow10s,
	MagRfOff				=> MagRfOff,
	
	FaultBits			=> FaultBits,
	NewFault				=> NewFault,
	
	Status				=> FaultGen_Status
	
);

u_FaultHistory : FaultHistory
Port map ( 
	Clock 		=> SysClk,
	Reset 		=> Reset,

	-- Link Interface
	Lnk_Rd		=> Lnk_FaultHistory_Rd,
	Lnk_Addr		=> Lnk_Addr2Reg,
	Lnk_DataOut	=> Lnk_FaultHistory_DOut,

	WrEn 			=> NewFault,
	DataIn 		=> FaultBits,
	CountIn 		=> EventCounter
);

u_sfp : sfp_intf
Port map (
	Clock 			=> SysClk,
	Reset 		 	=> Reset,

-- Link Interface
	Lnk_Addr		 	=> Lnk_Addr2Reg,			-- From Link Interface

	Reg_DataOut		=> Lnk_SFP_DOut,

	Clk_En			=> Clk100KhzEn,
	SDA0				=> SDA0,
	SCL0				=> SCL0,
	
	SDA1				=> SDA1,
	SCL1				=> SCL1
	);


u_Flash : flash_intf
Port map (

	Clock        	=> SysClk,
	Reset        	=> Reset,
	
-- Link Interface                                                           
	Lnk_Addr       => Lnk_Addr2Reg,  
	Lnk_DataIn     => Lnk_Data2Reg,
	
	Lnk_WriteAddr  => Lnk_Flash_WriteAddr,
	Lnk_ReadBlk		=> Lnk_Flash_ReadBlk,
	Lnk_EraseBlk	=> Lnk_Flash_EraseBlk,
	Lnk_WriteBlk	=> Lnk_Flash_WriteBlk,
	Lnk_LockBlk		=> Lnk_Flash_LockBlk,
	Lnk_DAV			=> Lnk_Flash_DAV,                                                                          
	Reg_DataOut   	=> Lnk_Flash_DOut,
	
	Flash_We			=> Flash_We,
	Flash_Oe			=> Flash_Oe,
	Flash_Cs			=> Flash_Cs,
	Flash_VPP		=> Flash_VPP,
	Flash_AddrOut	=> Flash_Addr,
	Flash_DataIn	=> Flash_DIn,		   -- From Flash Memory
	Flash_DataOut	=> Flash_DOut			-- To Flash Memory
	
	); 

end Behavioral;
