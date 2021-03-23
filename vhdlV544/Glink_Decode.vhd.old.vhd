-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	Glink_Decode.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 5/23/2011 2:10:24 PM
--	Last change: JO 6/28/2011 3:31:17 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:31:08 05/20/2011 
-- Design Name: 
-- Module Name:    Glink_Decode - Behavioral 
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

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


Library work;
use work.mksuii.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Glink_Decode is
Port ( 
	Clock 					: in  std_logic;
	Reset	 					: in  std_logic;
	Lnk_Mess 				: in  std_logic_vector(7 downto 0);
	Lnk_MessStrb 			: in  std_logic;
	Lnk_TaskId		 		: in  std_logic_vector(7 downto 0);
	Lnk_DataIn 				: in  std_logic_vector(7 downto 0);
	Lnk_DataStrb 			: in  std_logic;
	Lnk_AddrOut				: out  std_logic_vector(15 downto 0);
	Lnk_DataOut 			: out  std_logic_vector(15 downto 0);

	Tx_Start					: out std_logic;
	Tx_MessType				: out std_logic_vector(7 downto 0);			-- Transmit message type
	Tx_DataOut	     		: out std_logic_vector(7 downto 0);			-- Data from external memory or registers
	Tx_TaskId	     		: out std_logic_vector(7 downto 0);			-- Data from external memory or registers
	Tx_Count					: out std_logic_vector(15 downto 0); 		-- Depends on Readout type
	Tx_Done					: out std_logic;
	Tx_Rdy 					: in  std_logic;

	Lnk_SlowThres_Wr		: out std_logic;
	Lnk_SlowADC_Din		: in std_logic_vector(15 downto 0);

	Lnk_MonADC_Din			: in std_logic_vector(15 downto 0);

	Lnk_TrigIntf_Wr 		: out std_logic;
	Lnk_TrigIntf_DIn		: in std_logic_vector(15 downto 0);

	Lnk_KlyTempMon_Wr		: out std_logic;
	Lnk_KlyTempMon_DIn	: in std_logic_vector(15 downto 0);

	Lnk_FastADC_Wr			: out std_logic;
	Lnk_FastADC_WFM_Rd	: out std_logic;
	Lnk_FastADC_DIn		: in std_logic_vector(15 downto 0);

	Lnk_RfDrive_Wr			: out std_logic;
	Lnk_RfDrive_DIn		: in std_logic_vector(15 downto 0);

	Lnk_FocusCoil_Wr		: out std_logic;
	Lnk_FocusCoil_DIn		: in std_logic_vector(15 downto 0);

	Lnk_eDip_Wr				: out std_logic;
	Lnk_eDip_DIn			: in std_logic_vector(15 downto 0);
	
	Lnk_SLED_Wr				: out std_logic;
	Lnk_SLED_DIn			: in std_logic_vector(15 downto 0);
	
	Lnk_Mod_Intf_Wr		: out std_logic;
	Lnk_Mod_Intf_DIn		: in std_logic_vector(15 downto 0);
	
	Lnk_Water_Flow_Wr		: out std_logic;
	Lnk_Water_Flow_DIn	: in std_logic_vector(15 downto 0);
	
	Lnk_Legacy_Mod_Wr		: out std_logic;
	Lnk_Legacy_Mod_Din	: in std_logic_vector(15 downto 0);
	
	Lnk_SysMon_Din			: in std_logic_vector(15 downto 0)
	);
	
end Glink_Decode;

architecture Behavioral of Glink_Decode is

type Decode_t is
(
	Idle_s,
	AddressLo_s,
	AddressHi_s,
	WrdCountLo_s,
	WrdCountHi_s,
	Rx_DataLo_s,
	Rx_DataHi_s,
	Tx_AddrLo_s,
	Tx_AddrHi_s,
	Tx_WcLo_s,
	Tx_WcHi_s,
	Tx_ResponseLo_s,
	Tx_ResponseHi_s
);

signal Decode_State : Decode_t;

signal DataStrb 		: std_logic;
signal Address 		: std_logic_vector(15 downto 0);
signal WrdCounter 	: std_logic_vector(15 downto 0);
signal iTxCount		: std_logic_vector(15 downto 0); 
signal RegData			: std_logic_vector(15 downto 0); 
signal Tx_DataOutHi	: std_logic_vector(7 downto 0); 

constant Lnk_Mess_Write : std_logic_vector(1 downto 0) := "00";
constant Lnk_Mess_Read 	: std_logic_vector(1 downto 0) := "01";

begin

Tx_Count 	<= iTxCount(14 downto 0) & '0';
Tx_TaskId	<= Lnk_TaskId;
Lnk_AddrOut	<= Address;

MessMux_p : process(Lnk_Mess, DataStrb, 
						Lnk_TrigIntf_Din, Lnk_SlowADC_Din, 
						Lnk_MonADC_Din, Lnk_SysMon_Din, Lnk_FastADC_Din,
						Lnk_RfDrive_Din, Lnk_FocusCoil_DIn)
begin
Case Lnk_Mess is
	When Mess_Write_Trigger =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= DataStrb;
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Read_Trigger =>
		RegData					<= Lnk_TrigIntf_Din;
		iTxCount					<= Mess_Read_Trigger_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';		
		Lnk_Legacy_Mod_wr		<= '0';
			
	when Mess_Write_SlowADC_Thres =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= DataStrb;
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	when Mess_Read_SlowADC =>
		RegData					<= Lnk_SlowADC_Din;
		iTxCount					<= Mess_Read_SlowADC_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	when Mess_Read_MonADC =>
		RegData					<= Lnk_MonADC_Din;
		iTxCount					<= Mess_Read_MonADC_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Read_SysMon =>
		RegData					<= Lnk_SysMon_Din;
		iTxCount					<= Mess_Read_SysMon_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Read_KlyTempMon =>
		RegData					<= Lnk_KlyTempMon_Din;
		iTxCount					<= Mess_Read_KlyTempMon_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_KlyTempMon =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= DataStrb;
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Read_FastADC =>
		RegData					<= Lnk_FastADC_Din;
		iTxCount					<= Mess_Read_FastADC_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_FastADC =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= DataStrb;
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Read_FastADC_WFM =>
		RegData					<= Lnk_FastADC_Din;
		iTxCount					<= Mess_Read_FastADC_WFM_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '1';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_RfDrive =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= DataStrb;
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Read_RfDrive =>
		RegData					<= Lnk_RfDrive_Din;
		iTxCount					<= Mess_Read_RfDrive_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_FocusCoil =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= DataStrb;
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Read_FocusCoil =>
		RegData					<= Lnk_FocusCoil_Din;
		iTxCount					<= Mess_Read_FocusCoil_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Write_FpDisplay =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= DataStrb;
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Read_FpDisplay =>
		RegData					<= Lnk_eDip_Din;
		iTxCount					<= Mess_Read_FpDisplay_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_SLED =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= DataStrb;
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Read_SLED =>
		RegData					<= Lnk_SLED_Din;
		iTxCount					<= Mess_Read_SLED_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	When Mess_Write_Mod_Intf =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= DataStrb;
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Read_Mod_Intf =>
		RegData					<= Lnk_Mod_Intf_Din;
		iTxCount					<= Mess_Read_Mod_Intf_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Write_Water_Flow =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= DataStrb;
		Lnk_Legacy_Mod_wr		<= '0';
				
	When Mess_Read_Water_Flow =>
		RegData					<= Lnk_Water_Flow_Din;
		iTxCount					<= Mess_Read_Water_Flow_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	When Mess_Write_Legacy_Mod =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<=	'0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= DataStrb;
				
	When Mess_Read_Legacy_Mod =>
		RegData					<= Lnk_Legacy_Mod_Din;
		iTxCount					<= Mess_Read_Legacy_Mod_Cnt;
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';
		
	when others =>
		RegData					<= x"BADD";
		iTxCount 				<= x"0001";
		Lnk_TrigIntf_wr		<= '0';
		Lnk_SlowThres_Wr		<= '0';
		Lnk_KlyTempMon_Wr		<= '0';
		Lnk_FastADC_Wr			<= '0';
		Lnk_FastADC_WFM_Rd	<= '0';
		Lnk_RfDrive_Wr			<= '0';
		Lnk_FocusCoil_Wr		<= '0';
		Lnk_eDip_Wr				<= '0';
		Lnk_SLED_wr				<= '0';
		Lnk_Mod_Intf_wr		<= '0';
		Lnk_Water_Flow_wr		<= '0';
		Lnk_Legacy_Mod_wr		<= '0';

	end case;
end process;


Link_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	DataStrb 			<= '0';
	Tx_Start				<= '0';
	Tx_Done				<= '0';
	Address 				<= (Others => '0');
	WrdCounter 			<= (Others => '0');
	Lnk_DataOut 		<= (Others => '0');
	Tx_MessType 		<= (Others => '0');
	Tx_DataOut 			<= (Others => '0');
	Tx_dataOutHi		<= (Others => '0');
	Decode_State 		<= Idle_s;
elsif (Clock'event and Clock = '1') then
	case Decode_State is
		when Idle_s => 
			Tx_Done				<= '0';
			Tx_Start				<= '0';
			if (Lnk_MessStrb = '1') then
				Tx_MessType 	<= Lnk_Mess OR x"80";
				Decode_State 	<= AddressLo_s;
			else
				Decode_State 	<= Idle_s;
			end if;
												
		When AddressLo_s =>
			if (Lnk_DataStrb = '1') then
				Address(7 downto 0)	 	<= Lnk_DataIn;
				Decode_State 				<= AddressHi_s;
			else
				Decode_State 				<= AddressLo_s;
			end if;
			
		When AddressHi_s =>
			if (Lnk_DataStrb = '1') then
				Address(15 downto 8) 	<= Lnk_DataIn;
				Decode_State 				<= WrdCountLo_s;
			else
				Decode_State 				<= AddressHi_s;
			end if;
			
		When WrdCountLo_s =>
			if (Lnk_DataStrb = '1') then
				WrdCounter(7 downto 0) 	<= Lnk_DataIn;
				Decode_State 				<= WrdCountHi_s;
			else
				Decode_State 				<= WrdCountLo_s;
			end if;
			
		When WrdCountHi_s =>
			if (Lnk_DataStrb = '1') then
				if (Lnk_Mess(7 downto 6) = Lnk_Mess_Write) then
					WrdCounter(15 downto 8)	<= Lnk_DataIn;
					Decode_State 				<= Rx_DataLo_s;
				else
					WrdCounter 					<= iTxCount;
					Tx_Start 					<= '1';
					Decode_State				<= Tx_AddrLo_s;
				end if;
			else
				Decode_State			 	<= WrdCountHi_s;
			end if;
			
		When Rx_DataLo_s =>
			if (Lnk_DataStrb = '1') then
				if (DataStrb = '1') then
					Address <= Address + 1;
				end if;
				Lnk_DataOut(7 downto 0) 	<= Lnk_DataIn;
				DataStrb 						<= '0';
				WrdCounter						<= WrdCounter - 1;
				Decode_State 					<= Rx_DataHi_s;
			else
				Decode_State 					<= Rx_DataLo_s;
			end if;
			
		When Rx_DataHi_s =>
			if (Lnk_DataStrb = '1') then
				Lnk_DataOut(15 downto 8) 	<= Lnk_DataIn;
				DataStrb 						<= '1';
				if (WrdCounter = x"0000") then
					Tx_Start 					<= '1';
					Tx_DataOut					<= x"00";
					Decode_State 				<= Tx_AddrLo_s;
				else
					Decode_State				<= Rx_DataLo_s;
				end if;
			else
				Decode_State 					<= Rx_DataHi_s;
			end if;
			
		when Tx_AddrLo_s	=>
			DataStrb 		<= '0';
			Tx_Start 		<= '0';
			if (Tx_Rdy = '1') then
				Tx_DataOut		<= x"00";
				Decode_State 	<= Tx_AddrHi_s;
			else
				Decode_State 	<= Tx_AddrLo_s;
			end if;
			
		when Tx_AddrHi_s	=>
			if (Tx_Rdy = '1') then
				Tx_DataOut		<= iTxCount(7 downto 0);
				Decode_State 	<= Tx_WcLo_s;
			else
				Decode_State 	<= Tx_AddrHi_s;
			end if;
			
		when Tx_WcLo_s	=>
			if (Tx_Rdy = '1') then
				Tx_DataOut		<= iTxCount(15 downto 8);
				Decode_State 	<= Tx_WcHi_s;
			else
				Decode_State 	<= Tx_WcLo_s;
			end if;
			
		when Tx_WcHi_s	=>
			if (Tx_Rdy = '1') then
				Tx_DataOut		<= RegData(7 downto 0);
				Tx_DataOutHi	<= RegData(15 downto 8);
				if (iTxCount = x"0000") then
					Tx_Done 			<= '1';
					Decode_State 	<= Idle_s;
				else
					WrdCounter 		<= iTxCount -1;
					Address			<= Address + 1;
					Decode_State 	<= Tx_ResponseLo_s;
				end if;
			else
				Decode_State 	<= Tx_AddrHi_s;
			end if;
			
		when Tx_ResponseLo_s =>
			if (Tx_Rdy = '1') then
				if (WrdCounter = x"0000") then
					Tx_Done 			<= '1';
				end if;
				Tx_DataOut		<= Tx_DataOutHi;
				Decode_State 	<= Tx_ResponseHi_s;
			else
				Decode_State 	<= Tx_ResponseLo_s;
			end if;
			
		when Tx_ResponseHi_s =>
			Tx_Done 			<= '0';
			if (Tx_Rdy = '1') then
				Address		<= Address + 1;
				WrdCounter	<= WrdCounter - 1;
				if (WrdCounter = x"0000") then
					Decode_State 	<= Idle_s;
				else
					Tx_DataOut		<= RegData(7 downto 0);
					Tx_DataOutHi	<= RegData(15 downto 8);
					Decode_State 	<= Tx_ResponseLo_s;
				end if;
			else
				Decode_State <= Tx_ResponseHi_s;
			end if;
		
		when others =>
			Decode_State <= Idle_s;
			
		end case;
end if;
end process;
end Behavioral;

