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
--	Last change: JO 10/4/2013 7:38:26 AM
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
	Clk1MhzEn				: in  std_logic;
	
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
	Lnk_RfDriveLkup_Wr	: out std_logic;
	Lnk_RfDrive_DIn		: in std_logic_vector(15 downto 0);
	Lnk_RfDriveLkUp_DIn	: in std_logic_vector(15 downto 0);

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
	
	Lnk_WG_Vac_Wr			: out std_logic;
	Lnk_WG_Vac_Din			: in std_logic_vector(15 downto 0);
	
	Lnk_MagIntf_Wr			: out std_logic;
	Lnk_MagIntf_Din		: in std_logic_vector(15 downto 0);
	
	Lnk_IonPump_Wr			: out std_logic;
	Lnk_IonPump_Din		: in std_logic_vector(15 downto 0);

	Lnk_CntlIntf_Wr		: out std_logic;
	Lnk_CntlIntf_Din		: in std_logic_vector(15 downto 0);

	Lnk_FaultGen_Wr		: out std_logic;
	Lnk_FaultGen_Din		: in std_logic_vector(15 downto 0);
	
	Lnk_Flash_WriteBlk	: out std_logic; 
	Lnk_Flash_ReadBlk		: out std_logic; 
	Lnk_Flash_WriteAddr	: out std_logic;
	Lnk_Flash_EraseBlk	: out std_logic; 
	Lnk_Flash_LockBlk		: out std_logic; 
	Lnk_Flash_Din			: in std_logic_vector(15 downto 0); 
	Lnk_Flash_DAV			: in std_logic;
	
	Lnk_SFP_Din				: in std_logic_vector(15 downto 0);
	
	Lnk_SysInfo_Din		: in std_logic_vector(15 downto 0);
	
	Lnk_SysMon_Din			: in std_logic_vector(15 downto 0);
	
	Lnk_FaultHistory_Rd	: out std_logic;
	Lnk_FaultHistory_DIn	: in std_logic_vector(15 downto 0)

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
	Wait_DAV_s,
	Tx_AddrLo_s,
	Tx_AddrHi_s,
	Tx_WcLo_s,
	Tx_WcHi_s,
	Tx_ResponseLo_s,
	Tx_ResponseHi_s
);

signal Decode_State : Decode_t;

signal DataStrb 			: std_logic;
signal DAV 					: std_logic;
signal Address 			: std_logic_vector(15 downto 0);
signal WrdCounter 		: std_logic_vector(11 downto 0);
signal iTxCount			: std_logic_vector(15 downto 0); 
signal RegData				: std_logic_vector(15 downto 0); 
signal Tx_DataOutHi		: std_logic_vector(7 downto 0); 

signal Lnk_Mess_Write 	: std_logic;
signal Lnk_Active		 	: std_logic;
signal Lnk_TimeOutCntr	: std_logic_vector(15 downto 0); 
signal Lnk_Timeout	 	: std_logic;

begin

Tx_Count 	<= iTxCount(14 downto 0) & '0';
Tx_TaskId	<= Lnk_TaskId;
Lnk_AddrOut	<= Address;

MessMux_p : process(Lnk_Mess, DataStrb, 
						Lnk_TrigIntf_Din, Lnk_SlowADC_Din, 
						Lnk_MonADC_Din, Lnk_SysMon_Din, Lnk_FastADC_Din,
						Lnk_RfDrive_Din, Lnk_FocusCoil_DIn, Lnk_KlyTempMon_DIn, 
						Lnk_eDip_DIn, Lnk_SLED_DIn, Lnk_Mod_Intf_DIn, 
						Lnk_Water_Flow_DIn, Lnk_Legacy_Mod_Din, Lnk_WG_Vac_Din, 
						Lnk_MagIntf_Din, Lnk_IonPump_Din, Lnk_CntlIntf_Din, 
						Lnk_FaultGen_Din, Lnk_SysInfo_Din, Lnk_SFP_Din, Lnk_Flash_Din,
						Lnk_FaultHistory_Din, Lnk_RfDriveLkUp_DIn, Lnk_MessStrb, Lnk_Flash_DAV)
begin

		Lnk_Mess_Write			<= '0';
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
		Lnk_WG_Vac_Wr			<= '0';
		Lnk_MagIntf_Wr			<= '0';
		Lnk_IonPump_Wr			<= '0';
		Lnk_CntlIntf_Wr		<= '0';
		Lnk_FaultGen_Wr		<= '0';
		Lnk_RFDriveLkup_Wr	<= '0';

		Lnk_Flash_WriteBlk	<= '0'; 
		Lnk_Flash_ReadBlk		<= '0';
		Lnk_Flash_EraseBlk	<= '0'; 
		Lnk_Flash_WriteAddr	<= '0'; 
		Lnk_FaultHistory_Rd	<= '0';
		Lnk_Flash_LockBlk		<= '0';
		DAV						<= '0';
		
Case Lnk_Mess is
	When Mess_Write_Trigger =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_TrigIntf_wr		<= DataStrb;
		
	When Mess_Read_Trigger =>
		RegData					<= Lnk_TrigIntf_Din;
		iTxCount					<= Mess_Read_Trigger_Cnt;
		DAV						<= '1';
			
	when Mess_Write_SlowADC_Thres =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_SlowThres_Wr		<= DataStrb;
		
	when Mess_Read_SlowADC =>
		RegData					<= Lnk_SlowADC_Din;
		iTxCount					<= Mess_Read_SlowADC_Cnt;
		DAV						<= '1';

	when Mess_Read_MonADC =>
		RegData					<= Lnk_MonADC_Din;
		iTxCount					<= Mess_Read_MonADC_Cnt;
		DAV						<= '1';

	When Mess_Read_SysMon =>
		RegData					<= Lnk_SysMon_Din;
		iTxCount					<= Mess_Read_SysMon_Cnt;
		DAV						<= '1';

	When Mess_Read_KlyTempMon =>
		RegData					<= Lnk_KlyTempMon_Din;
		iTxCount					<= Mess_Read_KlyTempMon_Cnt;
		DAV						<= '1';

	When Mess_Write_KlyTempMon =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_KlyTempMon_Wr		<= DataStrb;

	When Mess_Read_FastADC =>
		RegData					<= Lnk_FastADC_Din;
		iTxCount					<= Mess_Read_FastADC_Cnt;
		DAV						<= '1';

	When Mess_Write_FastADC =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_FastADC_Wr			<= DataStrb;

	When Mess_Read_FastADC_WFM =>
		RegData					<= Lnk_FastADC_Din;
		iTxCount					<= Mess_Read_FastADC_WFM_Cnt;
		Lnk_FastADC_WFM_Rd	<= '1';
		DAV						<= '1';

	When Mess_Write_RfDrive =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_RfDrive_Wr			<= DataStrb;
		
	When Mess_Read_RfDrive =>
		RegData					<= Lnk_RfDrive_Din;
		iTxCount					<= Mess_Read_RfDrive_Cnt;
		DAV						<= '1';

	When Mess_Write_RfDriveLkup =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_RfDriveLkup_Wr	<= DataStrb;
		
	When Mess_Read_RfDriveLkup =>
		RegData					<= Lnk_RfDriveLkup_Din;
		iTxCount					<= Mess_Read_RfDriveLkup_Cnt;
		DAV						<= '1';

	When Mess_Write_FocusCoil =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_FocusCoil_Wr		<= DataStrb;
		
	When Mess_Read_FocusCoil =>
		RegData					<= Lnk_FocusCoil_Din;
		iTxCount					<= Mess_Read_FocusCoil_Cnt;
		DAV						<= '1';
		
	When Mess_Write_FpDisplay =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_eDip_Wr				<= DataStrb;

	When Mess_Read_FpDisplay =>
		RegData					<= Lnk_eDip_Din;
		iTxCount					<= Mess_Read_FpDisplay_Cnt;
		DAV						<= '1';

	When Mess_Write_SLED =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_SLED_wr				<= DataStrb;
		
	When Mess_Read_SLED =>
		RegData					<= Lnk_SLED_Din;
		iTxCount					<= Mess_Read_SLED_Cnt;
		DAV						<= '1';

	When Mess_Write_Mod_Intf =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Mod_Intf_wr		<= DataStrb;
		
	When Mess_Read_Mod_Intf =>
		RegData					<= Lnk_Mod_Intf_Din;
		iTxCount					<= Mess_Read_Mod_Intf_Cnt;
		DAV						<= '1';
		
	When Mess_Write_Water_Flow =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Water_Flow_wr		<= DataStrb;
				
	When Mess_Read_Water_Flow =>
		RegData					<= Lnk_Water_Flow_Din;
		iTxCount					<= Mess_Read_Water_Flow_Cnt;
		DAV						<= '1';
		
	When Mess_Write_Legacy_Mod =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Legacy_Mod_wr		<= DataStrb;
				
	When Mess_Read_Legacy_Mod =>
		RegData					<= Lnk_Legacy_Mod_Din;
		iTxCount					<= Mess_Read_Legacy_Mod_Cnt;
		DAV						<= '1';
		
	When Mess_Write_WaveGuideVac =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_WG_Vac_Wr			<= DataStrb;
				
	When Mess_Read_WaveGuideVac =>
		RegData					<= Lnk_WG_Vac_Din;
		iTxCount					<= Mess_Read_WaveGuideVac_Cnt;
		DAV						<= '1';
		
	When Mess_Write_Magnet_Int =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_MagIntf_Wr			<= DataStrb;
				
	When Mess_Read_Magnet_Int =>
		RegData					<= Lnk_MagIntf_Din;
		iTxCount					<= Mess_Read_Magnet_Int_Cnt;
		DAV						<= '1';
		
	When Mess_Write_ION_Pump =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_IonPump_Wr			<= DataStrb;
				
	When Mess_Read_ION_Pump =>
		RegData					<= Lnk_IonPump_Din;
		iTxCount					<= Mess_Read_ION_Pump_Cnt;
		DAV						<= '1';
		
	When Mess_Write_CntlIntf =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_CntlIntf_wr		<= DataStrb;
		
	When Mess_Read_CntlIntf =>
		RegData					<= Lnk_CntlIntf_Din;
		iTxCount					<= Mess_Read_CntlIntf_Cnt;
		DAV						<= '1';
		
	When Mess_Write_FaultGen =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_FaultGen_wr		<= DataStrb;
		
	When Mess_Read_FaultGen =>
		RegData					<= Lnk_FaultGen_Din;
		iTxCount					<= Mess_Read_FaultGen_Cnt;
		DAV						<= '1';
		
	When Mess_Read_SFP =>
		RegData					<= Lnk_SFP_Din;
		iTxCount					<= Mess_Read_SFP_Cnt;
		DAV						<= '1';
	
	When Mess_Read_SysInfo =>
		RegData					<= Lnk_SysInfo_Din;
		iTxCount					<= Mess_Read_SysInfo_Cnt;
		DAV						<= '1';
				
	When Mess_Read_FlashStatus =>
		RegData					<= Lnk_Flash_Din;
		iTxCount					<= Mess_Read_FlashStatus_Cnt;
		DAV						<= '1';
		
	When Mess_Erase_FlashBlk =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Flash_EraseBlk	<= DataStrb;
		
	When Mess_Write_FlashBlk =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Flash_WriteBlk	<= DataStrb;
		
	When Mess_Read_FlashBlk =>
		RegData					<= Lnk_Flash_Din;
		iTxCount					<= Mess_Read_FlashBlk_Cnt;
		Lnk_Flash_ReadBlk		<= Lnk_MessStrb;
		DAV						<= Lnk_Flash_DAV;
		
	when Mess_Lock_FlashBlk =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Flash_LockBlk		<= DataStrb;
		
	when Mess_Write_FlashAddr =>
		RegData					<= x"0000";
		iTxCount					<= x"0000";
		Lnk_Mess_Write			<= '1';
		Lnk_Flash_WriteAddr	<= DataStrb;
	
	When Mess_Read_FaultHistory =>
		RegData					<= Lnk_FaultHistory_Din;
		iTxCount					<= Mess_Read_FaultHistory_Cnt;
		Lnk_FaultHistory_Rd	<= Lnk_MessStrb;
		DAV						<= '1';

	when others =>
		RegData					<= x"BADD";
		iTxCount 				<= x"0001";
		DAV						<= '1';
		
		
	end case;
	
end process;

lnk_To_p :  process(Clock, Reset)
Begin
if (Reset = '1') then
	Lnk_TimeOutCntr	<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if (Lnk_MessStrb = '1') then
		Lnk_TimeoutCntr 	<= x"2000"; -- 8.2mx at 1Mhz
		Lnk_Timeout 		<= '0';
	elsif (Lnk_TimeoutCntr = x"0000") then
		Lnk_TimeoutCntr 	<= x"2000"; -- 8.2ms at 1Mhz
		Lnk_Timeout 		<= '1';
	elsif ((Lnk_Active = '1') and (Clk1MhzEn = '1')) then
		Lnk_TimeoutCntr 	<= Lnk_TimeoutCntr - 1 ;
	else
		Lnk_Timeout 		<= '0';
	end if;
	
	
end if;
end process;

		
Link_p : process(Clock, Reset, Lnk_Timeout)
Begin
if ((Reset = '1') or (Lnk_Timeout = '1'))then
	DataStrb 			<= '0';
	Tx_Start				<= '0';
	Tx_Done				<= '0';
	Lnk_Active			<= '0';
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
				Lnk_Active 		<= '1';
				Tx_MessType 	<= Lnk_Mess OR x"80";
				Decode_State 	<= AddressLo_s;
			else
				Lnk_Active		<= '0';
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
				if (Lnk_Mess_Write = '1') then
					WrdCounter(11 downto 8)	<= Lnk_DataIn(3 downto 0);
					Decode_State 				<= Rx_DataLo_s;
				else
					Decode_State				<= Wait_DAV_s;
				end if;
			else
				Decode_State			 		<= WrdCountHi_s;
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
				if (WrdCounter = x"000") then
					Tx_Start 					<= '1';
					Tx_DataOut					<= x"00";
					Decode_State 				<= Tx_AddrLo_s;
				else
					Decode_State				<= Rx_DataLo_s;
				end if;
			else
				Decode_State 					<= Rx_DataHi_s;
			end if;

		when Wait_DAV_s	=>
			if (DAV = '1') then 
				WrdCounter 					<= iTxCount(11 downto 0);
				Tx_Start 					<= '1';
				Decode_State				<= Tx_AddrLo_s;
			else
				Decode_State				<= Wait_DAV_s;
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
					WrdCounter 		<= iTxCount(11 downto 0) - 1;
					Address			<= Address + 1;
					Decode_State 	<= Tx_ResponseLo_s;
				end if;
			else
-- jjo 10/04/13
-- Changed Tx_AddrHi_s to Tx_WcHi_s
--				Decode_State 	<= Tx_AddrHi_s;
				Decode_State 	<= Tx_WcHi_s;
			end if;
			
		when Tx_ResponseLo_s =>
			if (Tx_Rdy = '1') then
				if (WrdCounter = x"000") then
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
				if (WrdCounter = x"000") then
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

