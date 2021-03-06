----------------------------------------------------------------
----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  mksuii_x_pkg.vhd -
--
--  Copyright(c) SLAC 2000
--
--  Author: Jeff Olsen
--  Created on: 10/30/09
--  Last change: JO 7/2/2013 7:06:40 AM
--
----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      MKSUII_x_pkg.vhd -
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 10/30/09
-- 
--
-- 
-- Created by Jeff Olsen 10/30/09
--
--  Filename: HardwareManager_x_pkg.vhd
--
--  Function:
--  Package declarations for HardwareManager
--  
--

-- 03/08/21 jjo
-- For SXR and HXR line to run, the Accelerate and Standby signals from 2 different
-- EVR channels were externally ORd together. This introduced the posibility of accedentally 
-- getting triggers faster that 120Hz. A one-shot was added to prevent triggers > 120hz
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library work;
package mksuii is

  constant MKSUII_ProtoCol_Version : std_logic_vector(7 downto 0) := x"01";
  constant MKSUII_Version          : string(8 downto 1)           := "5.50    ";
  constant System_ID               : string(6 downto 1)           := "MKSUII";
  constant SubType_ID              : string(4 downto 1)           := "CVTY";
  constant Date_ID                 : string(8 downto 1)           := "03/22/21";

  type IPAddr_t is array(3 downto 0) of std_logic_vector(7 downto 0);
-- Last byte will be the board dip switch address
--   192, 168, 0, 0                                             -- IP Address 

  constant MyIP_Addr : IPAddr_t :=
    (
--       x"C0", x"A8", x"00", x"01"     -- 192-168-00-01
      x"AC", x"1B", x"0D", x"47"        -- 172-27-13-71  Production MKSUII
--    x"AC", x"1B", x"0D", x"48"  -- 172-27-13-72  B921 Test Address
--       x"86", x"4F", x"DA", x"40"  -- 134-79-218-64  Test MKSUII
--       x"86", x"4F", x"DA", x"90"  -- 134-79-218-144  LCLS Dev Cavity BPM

      );

  constant MyIP_Addr1 : IPAddr_t :=
    (
      x"86", x"4F", x"DA", x"40"        -- 134-79-218-64  Test MKSUII

      );

  constant Mess_Write_Cntlintf    : std_logic_vector(7 downto 0)  := x"01";
  constant Mess_Read_Cntlintf     : std_logic_vector(7 downto 0)  := x"41";
  constant Mess_Read_Cntlintf_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_SlowADC_Thres : std_logic_vector(7 downto 0)  := x"03";
  constant Mess_Read_SlowADC        : std_logic_vector(7 downto 0)  := x"43";
  constant Mess_Read_SlowADC_Cnt    : std_logic_vector(15 downto 0) := x"000D";

  constant Mess_Write_FastADC    : std_logic_vector(7 downto 0)  := x"04";
  constant Mess_Read_FastADC     : std_logic_vector(7 downto 0)  := x"44";
  constant Mess_Read_FastADC_Cnt : std_logic_vector(15 downto 0) := x"001A";

  constant Mess_Write_Trigger    : std_logic_vector(7 downto 0)  := x"05";
  constant Mess_Read_Trigger     : std_logic_vector(7 downto 0)  := x"45";
  constant Mess_Read_Trigger_Cnt : std_logic_vector(15 downto 0) := x"000E";

  constant Mess_Write_RfDrive    : std_logic_vector(7 downto 0)  := x"06";
  constant Mess_Read_RfDrive     : std_logic_vector(7 downto 0)  := x"46";
  constant Mess_Read_RfDrive_Cnt : std_logic_vector(15 downto 0) := x"0006";

  constant Mess_Write_RfDriveLkup    : std_logic_vector(7 downto 0)  := x"27";
  constant Mess_Read_RfDriveLkup     : std_logic_vector(7 downto 0)  := x"67";
  constant Mess_Read_RfDriveLkup_Cnt : std_logic_vector(15 downto 0) := x"0200";

  constant Mess_Write_FocusCoil    : std_logic_vector(7 downto 0)  := x"07";
  constant Mess_Read_FocusCoil     : std_logic_vector(7 downto 0)  := x"47";
  constant Mess_Read_FocusCoil_Cnt : std_logic_vector(15 downto 0) := x"0001";

  constant Mess_Write_SLED    : std_logic_vector(7 downto 0)  := x"08";
  constant Mess_Read_SLED     : std_logic_vector(7 downto 0)  := x"48";
  constant Mess_Read_SLED_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_Mod_intf    : std_logic_vector(7 downto 0)  := x"0A";
  constant Mess_Read_Mod_intf     : std_logic_vector(7 downto 0)  := x"4A";
  constant Mess_Read_Mod_intf_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_Water_Flow    : std_logic_vector(7 downto 0)  := x"0B";
  constant Mess_Read_Water_Flow     : std_logic_vector(7 downto 0)  := x"4B";
  constant Mess_Read_Water_Flow_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_KlyTempMon    : std_logic_vector(7 downto 0)  := x"10";
  constant Mess_Read_KlyTempMon     : std_logic_vector(7 downto 0)  := x"50";
  constant Mess_Read_KlyTempMon_Cnt : std_logic_vector(15 downto 0) := x"0006";

  constant Mess_Write_Legacy_Mod    : std_logic_vector(7 downto 0)  := x"11";
  constant Mess_Read_Legacy_Mod     : std_logic_vector(7 downto 0)  := x"51";
  constant Mess_Read_Legacy_Mod_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_ION_Pump    : std_logic_vector(7 downto 0)  := x"12";
  constant Mess_Read_ION_Pump     : std_logic_vector(7 downto 0)  := x"52";
  constant Mess_Read_ION_Pump_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_WaveGuideVac    : std_logic_vector(7 downto 0)  := x"13";
  constant Mess_Read_WaveGuideVac     : std_logic_vector(7 downto 0)  := x"53";
  constant Mess_Read_WaveGuideVac_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Write_Magnet_int    : std_logic_vector(7 downto 0)  := x"14";
  constant Mess_Read_Magnet_int     : std_logic_vector(7 downto 0)  := x"54";
  constant Mess_Read_Magnet_int_Cnt : std_logic_vector(15 downto 0) := x"0003";

  constant Mess_Read_FaultHistory     : std_logic_vector(7 downto 0)  := x"55";
  constant Mess_Read_FaultHistory_Cnt : std_logic_vector(15 downto 0) := x"0201";


  constant Mess_Write_FpDisplay    : std_logic_vector(7 downto 0)  := x"20";
  constant Mess_Read_FpDisplay     : std_logic_vector(7 downto 0)  := x"60";
  constant Mess_Read_FpDisplay_Cnt : std_logic_vector(15 downto 0) := x"0002";

  constant Mess_Write_FaultGen    : std_logic_vector(7 downto 0)  := x"09";
  constant Mess_Read_FaultGen     : std_logic_vector(7 downto 0)  := x"49";
  constant Mess_Read_FaultGen_Cnt : std_logic_vector(15 downto 0) := x"0008";

  constant Mess_Read_FastADC_WFM     : std_logic_vector(7 downto 0)  := x"61";
  constant Mess_Read_FastADC_WFM_Cnt : std_logic_vector(15 downto 0) := x"0200";

  constant Mess_Read_MonADC     : std_logic_vector(7 downto 0)  := x"62";
  constant Mess_Read_MonADC_Cnt : std_logic_vector(15 downto 0) := x"0008";

  constant Mess_Read_SysMon     : std_logic_vector(7 downto 0)  := x"63";
  constant Mess_Read_SysMon_Cnt : std_logic_vector(15 downto 0) := x"0009";

  constant Mess_Read_Sysinfo     : std_logic_vector(7 downto 0)  := x"64";
  constant Mess_Read_Sysinfo_Cnt : std_logic_vector(15 downto 0) := x"000D";

  constant Mess_Read_SFP     : std_logic_vector(7 downto 0)  := x"65";
  constant Mess_Read_SFP_Cnt : std_logic_vector(15 downto 0) := x"0200";

  constant Mess_Lock_FlashBlk        : std_logic_vector(7 downto 0)  := x"79";
  constant Mess_Read_FlashStatus     : std_logic_vector(7 downto 0)  := x"7A";
  constant Mess_Read_FlashStatus_Cnt : std_logic_vector(15 downto 0) := x"0001";
  constant Mess_Write_FlashAddr      : std_logic_vector(7 downto 0)  := x"7B";
  constant Mess_Erase_FlashBlk       : std_logic_vector(7 downto 0)  := x"7C";
  constant Mess_Write_FlashBlk       : std_logic_vector(7 downto 0)  := x"7D";
  constant Mess_Read_FlashBlk        : std_logic_vector(7 downto 0)  := x"7E";
  constant Mess_Read_FlashBlk_Cnt    : std_logic_vector(15 downto 0) := x"0200";

  constant SLED_TimeoutMax : std_logic_vector(15 downto 0) := x"2710";  -- 10s @ 1Khz

  constant RegSet : std_logic_vector(1 downto 0) := "01";
  constant RegClr : std_logic_vector(1 downto 0) := "10";


  type FBoot_t is array(1 downto 0) of std_logic_vector(31 downto 0);
  constant FErase_Addr : FBoot_t :=
    (
      x"00100000",                      -- 2nd 2Meg Byte
      x"00000000"                       -- 1st 2Meg Byte
      );

  constant FErase_Blkinc : std_logic_vector(31 downto 0) := x"00010000";

  constant FUnlock_Setup   : std_logic_vector(15 downto 0) := x"0060";
  constant FUnlock_Confirm : std_logic_vector(15 downto 0) := x"00D0";
  constant FErase_Setup    : std_logic_vector(15 downto 0) := x"0020";
  constant FErase_Confirm  : std_logic_vector(15 downto 0) := x"00D0";
  constant FRead_Status    : std_logic_vector(15 downto 0) := x"0070";
  constant FClear_Status   : std_logic_vector(15 downto 0) := x"0050";
  constant FWrite_Setup    : std_logic_vector(15 downto 0) := x"00E8";
  constant FWrite_Confirm  : std_logic_vector(15 downto 0) := x"00D0";
  constant FRead_ArrayEn   : std_logic_vector(15 downto 0) := x"00FF";

  constant EraseBlkDone       : std_logic_vector(15 downto 0) := x"0080";  -- SR[7] = 1, OK
  constant WriteBlkRdy        : std_logic_vector(15 downto 0) := x"0080";  -- SR[7] = 1, OK
  constant WriteBlkDone       : std_logic_vector(15 downto 0) := x"0080";  -- SR[7] = 1, OK
  constant EraseBlkErr        : std_logic_vector(15 downto 0) := x"003A";  -- SR[5,4,3,1] "00111010"
  constant FlashEraseTOMax    : std_logic_vector(27 downto 0) := x"3000000";  --  6.4S 125/16
--constant FlashEraseTOMax              :       std_logic_vector(27 downto 0) := x"0000005"; --  6.4S 125/16
  constant FlashEraseTO       : std_logic_vector(15 downto 0) := x"0100";  -- Status[8] = Timeout
  constant FlashWriteRdyTOMax : std_logic_vector(27 downto 0) := x"00FFFFF";  -- 1048575 Counts at 125Mhz 8ms
  constant FlashWriteRdyTO    : std_logic_vector(15 downto 0) := x"0200";  -- Status[9] = Timeout
  constant FlashWriteTOMax    : std_logic_vector(27 downto 0) := x"00FFFFF";  -- 1048575 Counts at 125Mhz 8ms
  constant FlashWriteTO       : std_logic_vector(15 downto 0) := x"0100";  -- Status[8] = Timeout
  constant FlashOpDone        : std_logic_vector(15 downto 0) := x"0400";  -- Status[10] = Done
  constant FlashEraseDelay1   : std_logic_vector(27 downto 0) := x"0100000";  -- 

  function Character_to_StdLogicVector(MyString   : in character) return std_logic_vector;
--function SignExt12to16(Vin : in std_logic_vector) return std_logic_vector;
  function StdLogicVector_to_Character(MyStdLogic : in std_logic_vector(3 downto 0)) return character;

  component DPot
    port (
      Clock    : in  std_logic;
      Reset    : in  std_logic;
      Clock_En : in  std_logic;
      Enable   : in  std_logic;
      Pot_A    : in  std_logic;
      Pot_B    : in  std_logic;
      UP       : out std_logic;
      Down     : out std_logic;
      KnobCntr : out std_logic_vector(15 downto 0)
      );
  end component;  --DPot;

  component bcd
    port (
      CLK     : in  std_logic;
      Reset   : in  std_logic;
      Conv    : in  std_logic;
      SignBit : in  std_logic;
      Value   : in  std_logic_vector(15 downto 0);
      BCDout  : out std_logic_vector(39 downto 0);
      SignExt : out std_logic_vector(3 downto 0);
      Done    : out std_logic
      );

  end component;  --bcd;

  component clk12clk2 is
    port (
      Clk1  : in  std_logic;
      Reset : in  std_logic;
      Din   : in  std_logic;
      Clk2  : in  std_logic;
      Dout  : out std_logic
      );
  end component;  --clk12clk2;

  type IPHeader_t is array(11 downto 0) of std_logic_vector(7 downto 0);
  signal IP_Header : IPHeader_t :=
    (
      x"45",                            -- Version/Length
      x"00",                            -- Type of Service
      x"00", x"00",                     -- Length Placeholder
      x"00", x"00",                     -- Identification
      x"00", x"00",                     -- Fragment Flags and Offset
      x"FF",                            -- Time to Live
      x"11",                            -- Protocol 17 == UDP
      x"00", x"00"                      -- Checksum place holder
      );



-- Constants for the Ethernet interface
  type Ether_Type_t is array(1 downto 0) of std_logic_vector(7 downto 0);

  constant Ether_Type_IPV4 : std_logic_vector(15 downto 0) := x"0800";
  constant Ether_Type_ARP  : std_logic_vector(15 downto 0) := x"0806";
  constant UDP_Protocol    : std_logic_vector(7 downto 0)  := x"11";

  type MACAddr_t is array(5 downto 0) of std_logic_vector(7 downto 0);
-- Last byte will be the board dip switch address
  constant MyEMAC_Addr : MACAddr_t :=
    (
--      x"02", x"00", x"00", x"00", x"00", x"00"                --Nonsense default MAC Address
      x"08", x"00", x"56", x"00", x"06", x"00"  --08:00:56 is Stanford's VID, and LLRF is using 00:02:xx.
      );

--Node Name:      MKSU-LI28-RF21.SLAC.Stanford.EDU.
--IP Address:     172.27.13.71  (AC:1B:D:47)
--Primary User:   PICCOLI, LUCIANO
--System Admin:   BROBECK, KENNETH C.

--Node Name:      MKSU-B34-RF21.SLAC.Stanford.EDU.
--IP Address:     134.79.218.64-
--User:   OLSEN, JEFF J.
--System Admin:   BROBECK, KENNETH C.





  signal BSAEMAC_Addr : MACAddr_t :=
    (
--      x"02", x"00", x"00", x"00", x"00", x"00"                --Nonsense default MAC Address
      x"08", x"00", x"56", x"00", x"03", x"00"  --08:00:56 is Stanford's VID, and LLRF is using 00:02:xx.
      );
  signal BSAIP_Addr : IPAddr_t :=
    (
      x"C0", x"A8", x"01", x"01"        -- C0:A8:01:00 is Link Node Default
      );                                -- C0:A8:01:01 is BSA Default Address



  type UDPAddr_t is array(1 downto 0) of std_logic_vector(7 downto 0);
  constant myUDP_Addr : UDPAddr_t :=
    (
      x"DD", x"D5"                      -- UDP port number 56789
      );

  type UDPHeader_t is array(7 downto 0) of std_logic_vector(7 downto 0);
  signal UDP_Header : UDPHeader_t :=

    (
      myUDP_Addr(0), myUDP_Addr(1),     -- UDP Source Address
      myUDP_Addr(0), myUDP_Addr(1),     -- UDP Destination Address
      x"00", x"00",                     -- Length Placeholder
      x"00", x"00"                      -- Checksum place holder
      );

  type Common_Data_t is array(59 downto 0) of std_logic_vector(7 downto 0);
  type ARP_Reply_t is array(59 downto 0) of std_logic_vector(7 downto 0);
  type ARP_Data_t is array(20 downto 0) of std_logic_vector(7 downto 0);

-- version/length  service
-- 4500
-- Length
-- 0000
-- id
-- 0000
-- flags
-- 0000
-- TTL
-- 0611
-- source address
-- xxxx
-- xxxx
-- Destination address
-- 0000
-- 0000

  constant Constant_IP_ChkSum : std_logic_vector(31 downto 0) := x"00004b11";



-------------------------------------------------------------------------------
-- component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------

  component mksuii_x
    port (
---- MKSKII Permit, Start of Daisy Chain
      N_PERMIT : out std_logic;

-- PCB Pushbutton Reset
      N_BRD_RST : in std_logic;

      VP_in : in std_logic;             -- Dedicated Analog input Pair
      VN_in : in std_logic;

      N_MODID : in std_logic_vector(7 downto 0);

---- External Memory interface
      MEM_CLK      : out   std_logic;
      N_MEM_OE     : out   std_logic;
      N_MEM_GW     : out   std_logic;
      N_MEM_BWE    : out   std_logic;
      N_MEM_BW     : out   std_logic_vector(4 downto 1);
      N_MEM_ADSC   : out   std_logic;
      MEM_ADDR     : out   std_logic_vector(24 downto 0);
      MEM_DATA     : inout std_logic_vector(31 downto 0);
      MEM_PARITY   : out   std_logic_vector(4 downto 1);
      Mem_WAIT     : in    std_logic;
      RS1          : out   std_logic;
      RS0          : out   std_logic;
      VPP          : out   std_logic;
--      
---- Flash Memory Control
      N_FOE        : out   std_logic;
      N_FCS        : out   std_logic;
      N_FWE        : out   std_logic;
--      
---- Front Panel        Local control
      N_SW_TRIGEN  : in    std_logic;
      N_SW_TEST    : in    std_logic;
      N_SW_SPARE2  : in    std_logic;
      N_SW_SPARE1  : in    std_logic;
      N_SW_LOCAL   : in    std_logic;
      N_SW_FLT_RST : out   std_logic;
      N_POT2_SW    : in    std_logic;
      N_POT1_SW    : in    std_logic;
      POT2_UP      : in    std_logic;
      POT2_DOWN    : in    std_logic;
      POT1_UP      : in    std_logic;
      POT1_DOWN    : in    std_logic;
--      
-- Front Panel LED's    
      FP_LED       : out   std_logic_vector(28 downto 0);

---- Front Panel LCD Display
      SPI_CLK     : out std_logic;
      N_SPI_SS    : out std_logic;
      SPI_MISO    : in  std_logic;
      SPI_MOSI    : out std_logic;
      N_SPI_SBUF  : in  std_logic;
      N_SPI_RESET : out std_logic;
      N_SPI_DPOM  : out std_logic;

-- Slow ADC interface   
      SLOWADC_CLK    : out std_logic;
      N_SLOWADC_CS   : out std_logic;
      N_SLOWADC_WR   : out std_logic;
      N_SLOWADC_RD   : out std_logic;
      SLOWADC_CONVST : out std_logic;
      N_SLOWADC_EOLC : in  std_logic;
      N_SLOWADC_EOC  : in  std_logic;

-- Voltage Monitor ADC interface        
      MONADC_CLK    : out std_logic;
      N_MONADC_CS   : out std_logic;
      N_MONADC_WR   : out std_logic;
      N_MONADC_RD   : out std_logic;
      MONADC_CONVST : out std_logic;
      N_MONADC_EOLC : in  std_logic;
      N_MONADC_EOC  : in  std_logic;

-- Mon and Slow ADC Data controlled with CS
      SLOWADC_DATA : in std_logic_vector(11 downto 0);

---- SLED Monitor interface
--      N_SLED_UPPER_TUNED              : in std_logic;
--      N_SLED_UPPER_DETUNED    : in std_logic;
--      N_SLED_MOTOR_TUNED              : in std_logic;
--      N_SLED_MOTOR_DETUNED    : in std_logic;
--      N_SLED_LOWER_TUNED              : in std_logic;
--      N_SLED_LOWER_DETUNED    : in std_logic;
--

      N_TANK_LO : in std_logic;
      TANK_HI   : in std_logic;
      N_PUMPII  : in std_logic;

------ SLED Control interface
--      N_SLED_ENABLE                           : out std_logic;
--      N_SLED_TUNE                             : out std_logic;
--      N_SLED_DETUNE                           : out std_logic;
--
------ SLED Test interface      
--      SLED_U_TUNED_TEST               : out std_logic;
--      SLED_U_DETUNED_TEST             : out std_logic;
--      SLED_M_TUNED_TEST               : out std_logic;
--      SLED_M_DETUNED_TEST             : out std_logic;
--      SLED_L_TUNED_TEST               : out std_logic;
--      SLED_L_DETUNED_TEST             : out std_logic;

      TANK_LO_TEST : out std_logic;
      TANK_HI_TEST : out std_logic;
      PUMPII_TEST  : out std_logic;


-- GBit Transceiver interface
      MGTCLK1_n : in std_logic;
      MGTCLK1_p : in std_logic;

      TX0_p : out std_logic;
      TX0_n : out std_logic;
      RX0_n : in  std_logic;
      RX0_p : in  std_logic;

--      N_MOD_PRES0                             : in std_logic;
      TX_DISABLE0 : out std_logic;
--      SCL0                                                    : out std_logic;
--      SDA0                                                    : inout std_logic;
--      RX_LOS0                                                 : in std_logic;
--      TX_FAULT0                                       : in std_logic;

      TX1_p : out std_logic;
      TX1_n : out std_logic;
      RX1_n : in  std_logic;
      RX1_p : in  std_logic;

--      N_MOD_PRES1                             : in std_logic;
      TX_DISABLE1 : out std_logic;
--      SCL1                                                    : out std_logic;
--      SDA1                                                    : inout std_logic;
--      RX_LOS1                                                 : in std_logic;
--      TX_FAULT1                                       : in std_logic;
--

-- Temperature Monitor interface
      TEMP_ADC_CLK  : in  std_logic;
      N_TEMP_out_CS : out std_logic;
      N_TEMP_in_CS  : out std_logic;
      TEMP_Din_RDY  : in  std_logic;
      TEMP_SCLK     : out std_logic;
      TEMP_Dout     : out std_logic;

---- RF Attenuator interface    
      RFATTN_SCLK    : out std_logic;
      RFATTN_SDout   : out std_logic;
      RFATTN_SDin    : in  std_logic;
      N_RFATTN_SYNC  : out std_logic;
--      
-- Trigger IO   
      CLK119MHZ_in_p : in  std_logic;
      CLK119MHZ_in_n : in  std_logic;
      TRIGGER_in1_p  : in  std_logic;
      TRIGGER_in1_n  : in  std_logic;
      TRIGGER_in0_p  : in  std_logic;
      TRIGGER_in0_n  : in  std_logic;


      N_MOD_TRIGGER_EN : out std_logic;
      N_MOD_TRIGGER    : out std_logic;
      N_REAR_TRIGGER   : out std_logic;
      N_FRONT_TRIGGER  : out std_logic;

---- Focus Coil interface       
      FOCUS_SCLK   : out   std_logic;
      N_FOCUS_SYNC : out   std_logic;
      FOCUS_SDout  : out   std_logic;
      FOCUS_SDin   : in    std_logic;
--      
-- Fast ADC interface
      FADC_SCLK    : out   std_logic;
      N_FADC_CS    : out   std_logic;
      FADC_SDIO    : inout std_logic;

      FADC_CLK_P       : out std_logic;
      FADC_CLK_N       : out std_logic;
      FADC_FRAME_CLK_P : in  std_logic;
      FADC_FRAME_CLK_N : in  std_logic;
      FADC_DATA_CLK_P  : in  std_logic;
      FADC_DATA_CLK_N  : in  std_logic;
      BEAM_V_P         : in  std_logic;
      BEAM_V_N         : in  std_logic;
      BEAM_I_P         : in  std_logic;
      BEAM_I_N         : in  std_logic;
      FWD_PWR_P        : in  std_logic;
      FWD_PWR_N        : in  std_logic;
      REFL_PWR_P       : in  std_logic;
      REFL_PWR_N       : in  std_logic;

---- Modulator Command interface
--      N_SYSTEM_FAULT                  : out std_logic;
      N_X_FAULT_RST_CMD   : out std_logic;
      N_X_HV_OFF_CMD      : out std_logic;
      N_X_HV_ON_CMD       : out std_logic;
      N_X_CTRL_PWR_ON_CMD : out std_logic;

---- Modulator Monitor interface        
      N_MOD_HV_ON_MON        : in std_logic;
      N_MOD_FAULT_MON        : in std_logic;
      N_MOD_EXT_inTLK_MON    : in std_logic;
      N_MOD_HVOC_MON         : in std_logic;
      N_MOD_EOLC_MON         : in std_logic;
      N_MOD_TTOC_MON         : in std_logic;
      N_MOD_HV_RDY_MON       : in std_logic;
      N_MOD_AVAIL_MON        : in std_logic;
      N_MOD_inTLK_COMP_MON   : in std_logic;
      N_MOD_CTRL_PWR_FLT_MON : in std_logic;
      N_MOD_KLY_FIL_TD_MON   : in std_logic;
      N_MOD_VVS_PWR_MON      : in std_logic;

---- Modulator Monitor Test interface   
      MOD_HV_ON_TEST        : out std_logic;
      MOD_FAULT_TEST        : out std_logic;
      MOD_EXT_inTLK_TEST    : out std_logic;
      MOD_HVOC_TEST         : out std_logic;
      MOD_EOLC_TEST         : out std_logic;
      MOD_TTOC_TEST         : out std_logic;
      MOD_HV_RDY_TEST       : out std_logic;
      MOD_AVAIL_TEST        : out std_logic;
      MOD_inTLK_COMP_TEST   : out std_logic;
      MOD_CTRL_PWR_FLT_TEST : out std_logic;
      MOD_VVS_PWR_TEST      : out std_logic;
      MOD_KLY_FIL_TD_TEST   : out std_logic;

---- Flow Switch Monitor        
      N_ACC2_FLOW_MON : in std_logic;
      N_ACC1_FLOW_MON : in std_logic;
      N_WG1_FLOW_MON  : in std_logic;
      N_WG2_FLOW_MON  : in std_logic;
      N_KLY_FLOW_MON  : in std_logic;
      N_FLOW_SUMMARY  : in std_logic;

--      
---- Flow Switch Test   
      ACC2_FLOW_TEST         : out std_logic;
      ACC1_FLOW_TEST         : out std_logic;
      WG1_FLOW_TEST          : out std_logic;
      WG2_FLOW_TEST          : out std_logic;
      KLY_FLOW_TEST          : out std_logic;
--      
---- Legacy IO Monitor
      N_X_MOD_ON             : out std_logic;
      N_WG_TCGUAGE_MON       : in  std_logic;
      N_WG_VALVE_MON         : in  std_logic;
      N_LEGACY_AVAIL_MON     : in  std_logic;
--      
---- Legacy IO Test
      LEGACY_WG_VALVE_TEST   : out std_logic;
      LEGACY_WGTC_GAUGE_TEST : out std_logic;
      LEGACY_MODAVAIL_TEST   : out std_logic;
--      
---- ION Pump Monitor
      N_ION_PUMP_MON         : in  std_logic;

---- ION Pump Test
      ION_Pump_TEST : out std_logic;

---- Wave Guide Vacuum Monitor
      N_WG_VAC_OK_MON  : in std_logic;
      N_WG_VAC_BAD_MON : in std_logic;

---- Wave Guide Vacuum Test
      WG_VAC_OK_TEST  : out std_logic;
      WG_VAC_BAD_TEST : out std_logic;

----Magnet Monitor
      N_MAG_I_inTLK_MON : in  std_logic;
      N_MAG_I_OK_MON    : in  std_logic;
      N_MAG_KLIXON_MON  : in  std_logic;
      N_MAG_PS_ON       : out std_logic;
--
----Magnet Test
      MAG_I_inTLK_TEST  : out std_logic;
      MAG_I_OK_TEST     : out std_logic;
      MAG_KLIXON_TEST   : out std_logic;

      TP : out std_logic_vector(6 downto 0)
      );

  end component;



  -- component Declaration for the TEMAC wrapper with 
  -- Local Link FIFO.
  component gigabit_locallink
    port(
      -- EMAC0 Clocking
      -- 125MHz clock out put from transceiver
      CLK125_out : out std_logic;
      -- 125MHz clock input from BUFG
      CLK125     : in  std_logic;

      -- Local link Receiver interface - EMAC0
      RX_LL_CLOCK_0       : in  std_logic;
      RX_LL_RESET_0       : in  std_logic;
      RX_LL_DATA_0        : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_0       : out std_logic;
      RX_LL_EOF_N_0       : out std_logic;
      RX_LL_SRC_RDY_N_0   : out std_logic;
      RX_LL_DST_RDY_N_0   : in  std_logic;
      RX_LL_FIFO_STATUS_0 : out std_logic_vector(3 downto 0);

      -- Local link Transmitter interface - EMAC0
      TX_LL_CLOCK_0     : in  std_logic;
      TX_LL_RESET_0     : in  std_logic;
      TX_LL_DATA_0      : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_0     : in  std_logic;
      TX_LL_EOF_N_0     : in  std_logic;
      TX_LL_SRC_RDY_N_0 : in  std_logic;
      TX_LL_DST_RDY_N_0 : out std_logic;

      -- Client Receiver interface - EMAC0
      EMAC0CLIENTRXDVLD         : out std_logic;
      EMAC0CLIENTRXFRAMEDROP    : out std_logic;
      EMAC0CLIENTRXSTATS        : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD     : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD : out std_logic;

      -- Client Transmitter interface - EMAC0
      CLIENTEMAC0TXIFGDELAY     : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS        : out std_logic;
      EMAC0CLIENTTXSTATSVLD     : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD : out std_logic;

      -- MAC Control interface - EMAC0
      CLIENTEMAC0PAUSEREQ : in std_logic;
      CLIENTEMAC0PAUSEVAL : in std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS : out std_logic;
      -- EMAC0 interrupt
      EMAC0ANinTERRUPT         : out std_logic;


      -- Clock Signals - EMAC0

      -- 1000BASE-X PCS/PMA interface - EMAC0
      TXP_0       : out std_logic;
      TXN_0       : out std_logic;
      RXP_0       : in  std_logic;
      RXN_0       : in  std_logic;
      PHYAD_0     : in  std_logic_vector(4 downto 0);
      RESETDONE_0 : out std_logic;

      -- unused transceiver
      TXN_1_UNUSED : out std_logic;
      TXP_1_UNUSED : out std_logic;
      RXN_1_UNUSED : in  std_logic;
      RXP_1_UNUSED : in  std_logic;

      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      CLK_DS : in std_logic;



      -- Asynchronous Reset
      RESET : in std_logic
      );
  end component;

  component glink_intf
    port (
      Clock : in std_logic;
      Reset : in std_logic;             -- System Reset

      Active    : out std_logic;        -- Valid Link Node Message
      Lnk_Error : out std_logic;        -- inValid Link Node Message  

      Lnk_Dataout  : out std_logic_vector(7 downto 0);
      Lnk_DataStrb : out std_logic;
      Lnk_MessType : out std_logic_vector(7 downto 0);
      Lnk_MessStrb : out std_logic;
      Lnk_TaskID   : out std_logic_vector(7 downto 0);  -- Transmit Task ID type

-- Tx Data
      Tx_Start    : in  std_logic;
      Tx_MessType : in  std_logic_vector(7 downto 0);  -- Transmit message type
      Tx_TaskID   : in  std_logic_vector(7 downto 0);  -- Transmit Task ID type
      Tx_Data_in  : in  std_logic_vector(7 downto 0);  -- Data from external memory or registers
      Tx_Count    : in  std_logic_vector(15 downto 0);  -- Number of byte of data
      Tx_Done     : in  std_logic;
      Tx_Rdy      : out std_logic;

-- Board ID from Dip Switches
-- Used as LSByte of the EMAC and IP Address
      Brd_ID : in std_logic_vector(7 downto 0);  -- Dip switch board ID
		MyIP : out IPAddr_t;

-- Local link Receiver interface - EMAC0
      RX_LL_DATA      : in  std_logic_vector(7 downto 0);
      RX_LL_SOF_N     : in  std_logic;
      RX_LL_EOF_N     : in  std_logic;
      RX_LL_SRC_RDY_N : in  std_logic;
      RX_LL_DST_RDY_N : out std_logic;

-- Local link Transmitter interface - EMAC0
      TX_LL_DATA      : out std_logic_vector(7 downto 0);
      TX_LL_SOF_N     : out std_logic;
      TX_LL_EOF_N     : out std_logic;
      TX_LL_SRC_RDY_N : out std_logic;
      TX_LL_DST_RDY_N : in  std_logic
      );
  end component;  --glink_intf;

  component mksuii_Glink
    port (
      Reset : in std_logic;
      Clock : in std_logic;

      Lnk_Clk   : out std_logic;
      Active    : out std_logic;
      Lnk_Error : out std_logic;

      Lnk_Locked : out std_logic;

      Lnk_Dataout  : out std_logic_vector(7 downto 0);
      Lnk_DataStrb : out std_logic;
      Lnk_MessType : out std_logic_vector(7 downto 0);
      Lnk_TaskId   : out std_logic_vector(7 downto 0);
      Lnk_MessStrb : out std_logic;

-- Tx Data
      Tx_Start    : in  std_logic;
      Tx_MessType : in  std_logic_vector(7 downto 0);  -- Transmit message type
      Tx_TaskID   : in  std_logic_vector(7 downto 0);  -- Transmit message type
      Tx_Count    : in  std_logic_vector(15 downto 0);  -- Number of byte of data
      Tx_Data_in  : in  std_logic_vector(7 downto 0);  -- Data from external memory or registers
      Tx_Done     : in  std_logic;
      Tx_Rdy      : out std_logic;

-- Brd_Id used as LSByte of EMAC and IP Address and UDP Link Node ID
      BRD_ID : in std_logic_vector(7 downto 0);
		MyIp : out IPAddr_t;



--EMAC-MGT link status

-- 1000BASE-X PCS/PMA interface - EMAC0
      TXP_0 : out std_logic;
      TXN_0 : out std_logic;
      RXP_0 : in  std_logic;
      RXN_0 : in  std_logic;

-- unused transceiver
      TXN_1_UNUSED : out std_logic;
      TXP_1_UNUSED : out std_logic;
      RXN_1_UNUSED : in  std_logic;
      RXP_1_UNUSED : in  std_logic;
-- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs
      MGTCLK_P     : in  std_logic;
      MGTCLK_N     : in  std_logic

      );
  end component;  --HM_Glink

  component SPI_Fifo
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(7 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(7 downto 0);
      full  : out std_logic;
      empty : out std_logic);
  end component;




  component DeBounce
    port (
      Clock   : in  std_logic;
      Reset   : in  std_logic;
      ClockEn : in  std_logic;
      Din     : in  std_logic;
      Dout    : out std_logic
      );
  end component;  --Debounce;


  component oneshot is
    port (
      Clock    : in  std_logic;
      Reset    : in  std_logic;
      Start    : in  std_logic;
      RetrigEn : in  std_logic;
      Level    : in  std_logic;
      OS_Time  : in  std_logic_vector(31 downto 0);
      OS_out   : out std_logic
      );
  end component;  --oneshot;

  component oneshotCen is
    generic (N : positive);             -- number of BITS
    port (
      Clock    : in  std_logic;
      Reset    : in  std_logic;
      ClockEn  : in  std_logic;
      Start    : in  std_logic;
      RetrigEn : in  std_logic;
      Level    : in  std_logic;
      OS_Time  : in  std_logic_vector(N-1 downto 0);
      OS_out   : out std_logic
      );
  end component;  --oneshotCEn;



  component oneshotCen4Bit is
    port (
      Clock    : in  std_logic;
      Reset    : in  std_logic;
      ClockEn  : in  std_logic;
      Start    : in  std_logic;
      RetrigEn : in  std_logic;
      Level    : in  std_logic;
      OS_Time  : in  std_logic_vector(3 downto 0);
      OS_out   : out std_logic
      );
  end component;  --oneshotCEn;


  component ISERDES_NODELAY is
    generic (
      BITSLIP_ENABLE : boolean := true;  -- TRUE/FALSE to enable bitslip controller
      -- Must be "FALSE" in interface type is "MEMORY"
      DATA_RATE      : string  := "DDR";  -- Specify data rate of "DDR" or "SDR"
      DATA_WIDTH     : integer := 6;    -- Specify data width -
      -- NETWORKinG SDR: 2, 3, 4, 5, 6, 7, 8 : DDR 4, 6, 8, 10
      -- MEMORY SDR N/A : DDR 4
      inTERFACE_TYPE : string  := "NETWORKinG";  -- Use model - "MEMORY" or "NETWORKinG"
      NUM_CE         : integer := 1;  -- Define number or clock enables to an integer of 1 or 2
      SERDES_MODE    : string  := "MASTER"  --Set SERDES mode to "MASTER" or "SLAVE"
      );
    port (
      Q1        : out std_logic;        -- 1-bit registered SERDES out put
      Q2        : out std_logic;        -- 1-bit registered SERDES out put
      Q3        : out std_logic;        -- 1-bit registered SERDES out put
      Q4        : out std_logic;        -- 1-bit registered SERDES out put
      Q5        : out std_logic;        -- 1-bit registered SERDES out put
      Q6        : out std_logic;        -- 1-bit registered SERDES out put
      SHIFTout1 : out std_logic;        -- 1-bit cascade Master/Slave out put
      SHIFTout2 : out std_logic;        -- 1-bit cascade Master/Slave out put
      BITSLIP   : in  std_logic;        -- 1-bit Bitslip enable input
      CE1       : in  std_logic;        -- 1-bit clock enable input
      CE2       : in  std_logic;        -- 1-bit clock enable input
      CLK       : in  std_logic;        -- 1-bit master clock input
      CLKB      : in  std_logic;  -- 1-bit secondary clock input for DATA_RATE=DDR
      CLKDIV    : in  std_logic;        -- 1-bit divided clock input
      D         : in  std_logic;  -- 1-bit data input, connects to IODELAY or input buffer
      OCLK      : in  std_logic;        -- 1-bit fast out put clock input
      RST       : in  std_logic;        -- 1-bit asynchronous reset input
      SHIFTin1  : in  std_logic;        -- 1-bit cascade Master/Slave input
      SHIFTin2  : in  std_logic         -- 1-bit cascade Master/Slave input
      );
  end component;  --oneshot;


  component ThresComp
    port (
      a        : in  std_logic_vector(11 downto 0);
      b        : in  std_logic_vector(11 downto 0);
      LessThan : out std_logic;
      GrtrThan : out std_logic;
      Equal    : out std_logic
      );
  end component;  --ThresComp;


  component Acc12x16
    port (
      a      : in  std_logic_vector(15 downto 0);
      b      : in  std_logic_vector(11 downto 0);
      clk    : in  std_logic;
      ce     : in  std_logic;
      bypass : in  std_logic;
      s      : out std_logic_vector(15 downto 0)
      );
  end component;

  component ram16x16
    port (
      a   : in  std_logic_vector(3 downto 0);
      d   : in  std_logic_vector(15 downto 0);
      clk : in  std_logic;
      we  : in  std_logic;
      spo : out std_logic_vector(15 downto 0)
      );
  end component;

  component Ram16x16dp
    port (
      a    : in  std_logic_vector(3 downto 0);
      d    : in  std_logic_vector(15 downto 0);
      dpra : in  std_logic_vector(3 downto 0);
      clk  : in  std_logic;
      we   : in  std_logic;
      spo  : out std_logic_vector(15 downto 0);
      dpo  : out std_logic_vector(15 downto 0)
      );
  end component;

  component Max1308intf
    port (
      Clock   : in  std_logic;
      reset   : in  std_logic;
      ClkEn   : in  std_logic;
      Start   : in  std_logic;
-- ADC Control and Data
      Wr      : out std_logic;
      Cs      : out std_logic;
      Rd      : out std_logic;
      Convst  : out std_logic;
      EOC     : in  std_logic;
      EOLC    : in  std_logic;
      Datain  : in  std_logic_vector(11 downto 0);
-- ADC Data out 
      DAV     : out std_logic;
      Addrout : out std_logic_vector(2 downto 0);
      Dataout : out std_logic_vector(11 downto 0)
      );
  end component;  --Max1308intf;

  component Ram512x12dp
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(8 downto 0);
      dina  : in  std_logic_vector(11 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(8 downto 0);
      doutb : out std_logic_vector(11 downto 0));
  end component;

  component Div20x8
    port (
      clk        : in  std_logic;
      ce         : in  std_logic;
      rfd        : out std_logic;
      dividend   : in  std_logic_vector(19 downto 0);
      divisor    : in  std_logic_vector(9 downto 0);
      quotient   : out std_logic_vector(19 downto 0);
      fractional : out std_logic_vector(8 downto 0)
      );
  end component;


  component Acc12x20
    port (
      b      : in  std_logic_vector(11 downto 0);
      clk    : in  std_logic;
      ce     : in  std_logic;
      bypass : in  std_logic;
      q      : out std_logic_vector(19 downto 0)
      );
  end component;


  component prog_strobe16
    port (
      Clock     : in  std_logic;
      Reset     : in  std_logic;
      Triggerin : in  std_logic;
      Delay     : in  std_logic_vector(15 downto 0);
      Width     : in  std_logic_vector(15 downto 0);
      Pulse     : out std_logic
      );
  end component;  --prog_strobe16 ;


  component pulse_delay16
    port (
      Clock     : in  std_logic;
      Reset     : in  std_logic;
      Triggerin : in  std_logic;
      Delay     : in  std_logic_vector(15 downto 0);
      Pulse     : out std_logic
      );
  end component;  -- pulse_delay16 ;

  component Trigger
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      AccTrig_p  : in std_logic;
      AccTrig_n  : in std_logic;
      StbyTrig_p : in std_logic;
      StbyTrig_n : in std_logic;

      UseAccTrigger : in std_logic;

      SelfTriggerEn : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Clk100KhzEn    : in  std_logic;
      Local          : in  std_logic;
      LocalTrigDelay : in  std_logic_vector(15 downto 0);
      LocalRateDiv   : in  std_logic_vector(2 downto 0);
      TriggerEn      : in  std_logic;
      TriggerDisable : in  std_logic;   -- From Fault Gen Trigger Disable
      Mode_Maint     : in  std_logic;
      Gt120Hz        : out std_logic;

      WFMTrigger   : out std_logic;
      ModTrigger   : out std_logic;
      RearTrigger  : out std_logic;
      FrontTrigger : out std_logic;

      DisplayTrigDelay : out std_logic_vector(15 downto 0);

      inputRate  : out std_logic_vector(15 downto 0);
      outputRate : out std_logic_vector(15 downto 0);

      EventCounter : out std_logic_vector(31 downto 0)

      );

  end component;


  component Drive_LKUP
    port (
      clka  : in  std_logic;
      addra : in  std_logic_vector(7 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;


  component ad9228_tstr
    port (
      clock  : in std_logic;
      clockB : in std_logic;
      Reset  : in std_logic;

      --Q               : out std_logic;
      FC  : out std_logic;
      FCB : out std_logic;

      DC  : out std_logic;
      DCB : out std_logic;

      Q  : out std_logic_vector(3 downto 0);
      QB : out std_logic_vector(3 downto 0)
      );

  end component;  --ad9228_tstr;

  component ad9228input
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      FADC_CLK_P : out std_logic;
      FADC_CLK_N : out std_logic;

      FADC_FRAME_CLK_P : in std_logic;
      FADC_FRAME_CLK_N : in std_logic;

      FADC_DATA_CLK_P : in std_logic;
      FADC_DATA_CLK_N : in std_logic;

      BEAM_V_P : in std_logic;
      BEAM_V_N : in std_logic;

      BEAM_I_P : in std_logic;
      BEAM_I_N : in std_logic;

      FWD_PWR_P : in std_logic;
      FWD_PWR_N : in std_logic;

      REFL_PWR_P : in std_logic;
      REFL_PWR_N : in std_logic;

      Beam_V_Data   : out std_logic_vector(11 downto 0);
      Beam_I_Data   : out std_logic_vector(11 downto 0);
      FWD_PWR_Data  : out std_logic_vector(11 downto 0);
      REFL_PWR_Data : out std_logic_vector(11 downto 0);

--      FrameClk                                                : out std_logic;
--      DataClk                                         : out std_logic;
      DataClkLocked : out std_logic



      );
  end component;  -- ad9228input;

  component FastChannel
    port (
      Clock  : in std_logic;
      Reset  : in std_logic;
      ADCClk : in std_logic;

      Datain : in std_logic_vector(11 downto 0);  -- From FAST ADC

      Trigger        : in std_logic;
      TimeCntr       : in std_logic_vector(8 downto 0);   -- From Control
      Lo_Thres       : in std_logic_vector(11 downto 0);  -- From Control
      Hi_Thres       : in std_logic_vector(11 downto 0);  -- From Control
      Start          : in std_logic_vector(8 downto 0);   -- From Control
      Stop           : in std_logic_vector(8 downto 0);   -- From Control
      Num_AveSamples : in std_logic_vector(8 downto 0);   -- From Control

      ArmWFM   : in  std_logic;
      ArmAve   : in  std_logic;
      WFMArmed : out std_logic;
      AveArmed : out std_logic;


      WFM_RAddr : in  std_logic_vector(8 downto 0);   -- From Control
      WFM_Dout  : out std_logic_vector(15 downto 0);  -- To Control
      AVE_Dout  : out std_logic_vector(15 downto 0);
      Average   : out std_logic_vector(15 downto 0);  -- To Control
      Status    : out std_logic_vector(1 downto 0);   -- To Control
      Done      : out std_logic

      );
  end component;  --FastChannel;

  component sign32div16
    port (
      clk      : in  std_logic;
      nd       : in  std_logic;
      rdy      : out std_logic;
      rfd      : out std_logic;
      dividend : in  std_logic_vector(31 downto 0);
      divisor  : in  std_logic_vector(15 downto 0);
      quotient : out std_logic_vector(31 downto 0)
      );
  end component;  -- sign32div16

  component sign16xsign16
    port (
      clk : in  std_logic;
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(15 downto 0);
      p   : out std_logic_vector(63 downto 0)
      );
  end component;  --sign16xsign16

  component sign16plussign16
    port (
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(15 downto 0);
      clk : in  std_logic;
      s   : out std_logic_vector(15 downto 0)
      );
  end component;  --sign16plussign16

  component Ram32X32
    port (
      a   : in  std_logic_vector(4 downto 0);
      d   : in  std_logic_vector(31 downto 0);
      clk : in  std_logic;
      we  : in  std_logic;
      spo : out std_logic_vector(31 downto 0)
      );
  end component;  --Ram32X32

  component Digit
    port (
      Clock  : in  std_logic;
      Reset  : in  std_logic;
      init   : in  std_logic;
      Modin  : in  std_logic;
      Modout : out std_logic;
      Q      : out std_logic_vector(3 downto 0)
      );
  end component;  -- Digit

  component BCDConv
    port (
      Clock  : in  std_logic;
      Reset  : in  std_logic;
      init   : in  std_logic;                     -- initialise conversion
      Decin  : in  std_logic_vector(19 downto 0);
      Modout : out std_logic;                     -- carry out 
      Done   : out std_logic;
      BCDout : out std_logic_vector(31 downto 0)  -- BCD result
      );
  end component;  --BCDConv 


  component alu
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- 16 Bit signed integers       
      TrigDel   : in std_logic_vector(15 downto 0);
      RFDrive   : in std_logic_vector(15 downto 0);
      MicroPrev : in std_logic_vector(15 downto 0);
      BeamV     : in std_logic_vector(15 downto 0);
      BeamI     : in std_logic_vector(15 downto 0);
      FwdPwr    : in std_logic_vector(15 downto 0);
      RefPwr    : in std_logic_vector(15 downto 0);
      DeltaTemp : in std_logic_vector(15 downto 0);
      WgVac     : in std_logic_vector(15 downto 0);
      KlyVac    : in std_logic_vector(15 downto 0);

      ModRate : in std_logic_vector(15 downto 0);
      AccRate : in std_logic_vector(15 downto 0);

      ModId : in std_logic_vector(7 downto 0);

      Clk119Pres : in std_logic;

      IP_Address : in IPAddr_t;

-- Text inputs 32 bits 4 characters
      Assign   : in std_logic_vector(7 downto 0);  --  ACC/STBY
      HSTA     : in std_logic_vector(7 downto 0);  --  MNT/ TBR/ ARU/ OFF 
      ModState : in std_logic_vector(7 downto 0);  --  FLT/ HVR/AVAL/  ON



-- Display XY location
      X1 : out std_logic_vector(15 downto 0);
      Y1 : out std_logic_vector(15 downto 0);
      X2 : out std_logic_vector(15 downto 0);
      Y2 : out std_logic_vector(15 downto 0);

-- Control IO   
      Refresh     : in std_logic;       --       Start Refresh Cycle
      cmd_Refresh : in std_logic;       --   Start Refresh Cycle

      NewData : out std_logic;          -- Update Display
      TxDone  : in  std_logic;          -- Display Done

-- Ascii out put 8 characters
      ASCIIout : out string(8 downto 1)
      );
  end component;  --alu; 

  component Mon_ADC_Cntl
    port (
-- System 
      Clock      : in  std_logic;
      Reset      : in  std_logic;
      SlowClkEn  : in  std_logic;
      StartCycle : in  std_logic;
      CycleDone  : out std_logic;

-- Link interface
      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Dav     : out std_logic;                      -- To Link interface
      Lnk_Dataout : out std_logic_vector(15 downto 0);  -- To Link interface

-- ADC Control and Data
      Wr        : out std_logic;
      Cs        : out std_logic;
      Rd        : out std_logic;
      Convst    : out std_logic;
      ADC_Clk   : out std_logic;
      EOC       : in  std_logic;
      EOLC      : in  std_logic;
      ADCDatain : in  std_logic_vector(11 downto 0);

-- System Status
      Status : out std_logic_vector(15 downto 0)
      );
  end component;  -- Mon_ADC_Cntl;

  component Slow_ADC_Cntl
    port (
-- System 
      Clock      : in  std_logic;
      Reset      : in  std_logic;
      SlowClkEn  : in  std_logic;
      StartCycle : in  std_logic;
      CycleDone  : out std_logic;

-- Link interface
      Lnk_Addr        : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr          : in  std_logic;  -- From Link interface
      Lnk_Datain      : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_RdThreshold : in  std_logic;  -- From Link interface
      Lnk_Dav         : out std_logic;  -- To Link interface
      Lnk_Dataout     : out std_logic_vector(15 downto 0);  -- To Link interface

-- ADC Control and Data
      Wr        : out std_logic;
      Cs        : out std_logic;
      Rd        : out std_logic;
      Convst    : out std_logic;
      ADC_Clk   : out std_logic;
      EOC       : in  std_logic;
      EOLC      : in  std_logic;
      ADCDatain : in  std_logic_vector(11 downto 0);

      WGVac  : out std_logic_vector(15 downto 0);
      KlyVac : out std_logic_vector(15 downto 0);


-- System Status
      Status : out std_logic_vector(15 downto 0)
      );
  end component;  -- Mon_ADC_Cntl;



  component ClkEn_Gen
    port (
      Clock       : in  std_logic;
      Reset       : in  std_logic;
      CLk30MhzEn  : out std_logic;
      Clk1MhzEn   : out std_logic;
      clk400KhzEn : out std_logic;
      CLk100KhzEn : out std_logic;
      CLk10KhzEn  : out std_logic;
      CLk1KhzEn   : out std_logic;
      CLk100hzEn  : out std_logic;
      CLk10hzEn   : out std_logic;
      CLk2hzEn    : out std_logic;
      CLk1hzEn    : out std_logic
      );
  end component;  -- ClkEn_Gen;

  component FastADCintf
    port (
      Clock    : in std_logic;
      Reset    : in std_logic;
      Clk1HzEn : in std_logic;

-- Link interface
      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr      : in  std_logic;                      -- From Link interface
      Lnk_Datain  : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_WFMRd   : in  std_logic;
      Reg_Dataout : out std_logic_vector(15 downto 0);
      Status      : out std_logic_vector(15 downto 0);

      ArmWFM   : in  std_logic;
      ArmAve   : in  std_logic;
      WFMArmed : out std_logic;
      AveArmed : out std_logic;

-- Average
      Beam_V_Average   : out std_logic_vector(15 downto 0);
      Beam_I_Average   : out std_logic_vector(15 downto 0);
      FWD_PWR_Average  : out std_logic_vector(15 downto 0);
      REFL_PWR_Average : out std_logic_vector(15 downto 0);

-- 
      Trigger : in std_logic;

      WFM_Avail : out std_logic;
      BeamILow  : out std_logic;

-- Fast ADC input 
      FADC_CLK_P       : out std_logic;
      FADC_CLK_N       : out std_logic;
      FADC_FRAME_CLK_P : in  std_logic;
      FADC_FRAME_CLK_N : in  std_logic;
      FADC_DATA_CLK_P  : in  std_logic;
      FADC_DATA_CLK_N  : in  std_logic;
      BEAM_V_P         : in  std_logic;
      BEAM_V_N         : in  std_logic;
      BEAM_I_P         : in  std_logic;
      BEAM_I_N         : in  std_logic;
      FWD_PWR_P        : in  std_logic;
      FWD_PWR_N        : in  std_logic;
      REFL_PWR_P       : in  std_logic;
      REFL_PWR_N       : in  std_logic;

--      Frameclk                                        : out std_logic;
--      Dataclk                                 : out std_logic;
      DataClkLocked : out std_logic

      );
  end component;  --FastADCintf

  component FrontPanel_LED
    port (
      Clock    : in std_logic;
      Reset    : in std_logic;
      ClkEn    : in std_logic;
      FP_ClkEn : in std_logic;

      Configured : in std_logic;
      Sw_Local   : in std_logic;
      Mode_Local : in std_logic;
      LED_Test   : in std_logic;

      LED_out : out std_logic_vector(28 downto 0);

      ACCEL1        : in std_logic;
      ACCEL2        : in std_logic;
      WG_WATER1     : in std_logic;
      WG_WATER2     : in std_logic;
      KLY_WATER     : in std_logic;
      WG_VAC_inTLK  : in std_logic;
      WG_VALVE      : in std_logic;
      KLY_VAC_inTLK : in std_logic;
      KLY_DELTA_T   : in std_logic;
      KLY_MAG_inTLK : in std_logic;

--      SLED_FAULT              : in std_logic;
--      SLED_TUNE               : in std_logic;
      TANK_Fault   : in std_logic;
      PUMPII_Fault : in std_logic;

      MOD_OV        : in std_logic;
      MOD_OI        : in std_logic;
      FWR_PWR       : in std_logic;
      OFFLinE       : in std_logic;
      RF_PWR        : in std_logic;
      MAinTENANCE   : in std_logic;
      TCVAC         : in std_logic;
      STANDBY       : in std_logic;
      SPARE1        : in std_logic;
      ACCELERATE    : in std_logic;
      SPARE2        : in std_logic;
      DRIVE_FAULT   : in std_logic;
      MOD_AVAIL     : in std_logic;
      TRIGGEREN     : in std_logic;
      HEARTBEAT     : in std_logic;
      BATTERY_FAULT : in std_logic;
      FAULT_LIMIT   : in std_logic
      );

  end component;  --FrontPanel_LED;


  component SysMon_intf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      Start : in std_logic;

      VP_in : in std_logic;             -- Dedicated Analog input Pair
      VN_in : in std_logic;

-- Link interface
      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link Decode
      Lnk_Dataout : out std_logic_vector(15 downto 0)   -- To Link Decode

      );
  end component;  --SysMon_intf;


  component sysmon_dpram
    port (
      a    : in  std_logic_vector(3 downto 0);
      d    : in  std_logic_vector(15 downto 0);
      dpra : in  std_logic_vector(3 downto 0);
      clk  : in  std_logic;
      we   : in  std_logic;
      dpo  : out std_logic_vector(15 downto 0)
      );
  end component;

  component xsysmon
    port (
      DADDR_in : in  std_logic_vector (6 downto 0);  -- Address bus for the dynamic reconfiguration port
      DCLK_in  : in  std_logic;  -- Clock input for the dynamic reconfiguration port
      DEN_in   : in  std_logic;  -- Enable Signal for the dynamic reconfiguration port
      DI_in    : in  std_logic_vector (15 downto 0);  -- input data bus for the dynamic reconfiguration port
      DWE_in   : in  std_logic;  -- Write Enable for the dynamic reconfiguration port
      RESET_in : in  std_logic;  -- Reset signal for the System Monitor control logic
      DO_out   : out std_logic_vector (15 downto 0);  -- out put data bus for dynamic reconfiguration port
      DRDY_out : out std_logic;  -- Data ready signal for the dynamic reconfiguration port
      VP_in    : in  std_logic;         -- Dedicated Analog input Pair
      VN_in    : in  std_logic
      );
  end component;

  component TempADC
    port (
      Clock     : in std_logic;
      Reset     : in std_logic;
      Clk1MhzEn : in std_logic;

      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr      : in  std_logic;                      -- From Link interface
      Lnk_Datain  : in  std_logic_vector(15 downto 0);  -- From Link Decode
      Lnk_Dataout : out std_logic_vector(15 downto 0);  -- To Link interface

      TempSClk    : out std_logic;
      TempSDout   : out std_logic;
      TempSDin    : in  std_logic;
      Temp_out_Cs : out std_logic;
      Temp_in_Cs  : out std_logic;

      inTemp  : out std_logic_vector(15 downto 0);
      outTemp : out std_logic_vector(15 downto 0);

      DeltaTemp : out std_logic_vector(15 downto 0);

      Fault : out std_logic;

      Status : out std_logic_vector(4 downto 0)
      );

  end component;  --TempADC;



  component Glink_Decode
    port (
      Clock     : in std_logic;
      Reset     : in std_logic;
      Clk1MhzEn : in std_logic;

      Lnk_Mess     : in  std_logic_vector(7 downto 0);
      Lnk_MessStrb : in  std_logic;
      Lnk_TaskId   : in  std_logic_vector(7 downto 0);
      Lnk_Datain   : in  std_logic_vector(7 downto 0);
      Lnk_DataStrb : in  std_logic;
      Lnk_Addrout  : out std_logic_vector(15 downto 0);
      Lnk_Dataout  : out std_logic_vector(15 downto 0);

      Tx_Start    : out std_logic;
      Tx_MessType : out std_logic_vector(7 downto 0);  -- Transmit message type
      Tx_Dataout  : out std_logic_vector(7 downto 0);  -- Data from external memory or registers
      Tx_TaskId   : out std_logic_vector(7 downto 0);
      Tx_Count    : out std_logic_vector(15 downto 0);  -- Depends on Readout type
      Tx_Done     : out std_logic;
      Tx_Rdy      : in  std_logic;

      Lnk_SlowThres_Wr : out std_logic;
      Lnk_SlowADC_Din  : in  std_logic_vector(15 downto 0);

      Lnk_MonADC_Din : in std_logic_vector(15 downto 0);


      Lnk_Trigintf_Wr  : out std_logic;
      Lnk_Trigintf_Din : in  std_logic_vector(15 downto 0);

      Lnk_KlyTempMon_Wr  : out std_logic;
      Lnk_KlyTempMon_Din : in  std_logic_vector(15 downto 0);

      Lnk_FastADC_Wr     : out std_logic;
      Lnk_FastADC_WFM_Rd : out std_logic;
      Lnk_FastADC_Din    : in  std_logic_vector(15 downto 0);

      Lnk_RfDrive_Wr      : out std_logic;
      Lnk_RfDriveLkup_Wr  : out std_logic;
      Lnk_RfDrive_Din     : in  std_logic_vector(15 downto 0);
      Lnk_RfDriveLkUp_DIn : in  std_logic_vector(15 downto 0);

      Lnk_FocusCoil_Wr  : out std_logic;
      Lnk_FocusCoil_Din : in  std_logic_vector(15 downto 0);

      Lnk_eDip_Wr  : out std_logic;
      Lnk_eDip_Din : in  std_logic_vector(15 downto 0);

      Lnk_SLED_Wr  : out std_logic;
      Lnk_SLED_Din : in  std_logic_vector(15 downto 0);

      Lnk_Mod_intf_Wr  : out std_logic;
      Lnk_Mod_intf_Din : in  std_logic_vector(15 downto 0);

      Lnk_Water_Flow_Wr  : out std_logic;
      Lnk_Water_Flow_Din : in  std_logic_vector(15 downto 0);

      Lnk_Legacy_Mod_Wr  : out std_logic;
      Lnk_Legacy_Mod_Din : in  std_logic_vector(15 downto 0);

      Lnk_WG_Vac_Wr  : out std_logic;
      Lnk_WG_Vac_Din : in  std_logic_vector(15 downto 0);

      Lnk_Magintf_Wr  : out std_logic;
      Lnk_Magintf_Din : in  std_logic_vector(15 downto 0);

      Lnk_IonPump_Wr  : out std_logic;
      Lnk_IonPump_Din : in  std_logic_vector(15 downto 0);

      Lnk_Cntlintf_Wr  : out std_logic;
      Lnk_Cntlintf_Din : in  std_logic_vector(15 downto 0);

      Lnk_FaultGen_Wr  : out std_logic;
      Lnk_FaultGen_Din : in  std_logic_vector(15 downto 0);

      Lnk_Flash_WriteBlk  : out std_logic;
      Lnk_Flash_ReadBlk   : out std_logic;
      Lnk_Flash_WriteAddr : out std_logic;
      Lnk_Flash_EraseBlk  : out std_logic;
      Lnk_Flash_LockBlk   : out std_logic;
      Lnk_Flash_Din       : in  std_logic_vector(15 downto 0);
      Lnk_Flash_DAV       : in  std_logic;

      Lnk_SFP_Din : in std_logic_vector(15 downto 0);

      Lnk_Sysinfo_Din : in std_logic_vector(15 downto 0);

      Lnk_SysMon_Din : in std_logic_vector(15 downto 0);

      Lnk_FaultHistory_Rd  : out std_logic;
      Lnk_FaultHistory_DIn : in  std_logic_vector(15 downto 0)


      );
  end component;  --Glink_Decode;

  component FaultHistory
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      -- Link Interface
      Lnk_Rd      : in  std_logic;
      Lnk_Addr    : in  std_logic_vector(15 downto 0);
      Lnk_DataOut : out std_logic_vector(15 downto 0);

      WrEn    : in std_logic;
      DataIn  : in std_logic_vector(31 downto 0);
      CountIn : in std_logic_vector(31 downto 0)
      );
  end component;  --FaultHistory;

  component adds16s16
    port (
      clk : in  std_logic;
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(15 downto 0);
      ce  : in  std_logic;
      s   : out std_logic_vector(15 downto 0)
      );
  end component;

  component subs16s16
    port (
      clk : in  std_logic;
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(15 downto 0);
      ce  : in  std_logic;
      s   : out std_logic_vector(15 downto 0)
      );
  end component;

  component subu16u16
    port (
      clk : in  std_logic;
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(15 downto 0);
      ce  : in  std_logic;
      s   : out std_logic_vector(16 downto 0)
      );
  end component;

  component lkup44004
    port (
      clka  : in  std_logic;
      addra : in  std_logic_vector(8 downto 0);
      douta : out std_logic_vector(15 downto 0)
      );
  end component;

  component pon_rst
    port (
      Clock     : in  std_logic;
      sys_reset : in  std_logic;
      pon_reset : out std_logic
      );
  end component;  --pon_rst;

  component FastDiffin
    port (
      Clock  : in  std_logic;
      Reset  : in  std_logic;
      Din_P  : in  std_logic;
      Din_N  : in  std_logic;
      Qout_1 : out std_logic;
      Qout_2 : out std_logic
      );
  end component;  --FastDiffin; 


  component FADCClkDCM
    port(
      CLKin_N_in        : in  std_logic;
      CLKin_P_in        : in  std_logic;
      RST_in            : in  std_logic;
      CLKin_IBUFGDS_out : out std_logic;
      CLK0_out          : out std_logic;
      CLK90_out         : out std_logic;
      CLK180_out        : out std_logic;
      CLK270_out        : out std_logic;
      LOCKED_out        : out std_logic
      );
  end component;

  component FADCSpi
    port (
      Clock     : in    std_logic;
      Reset     : in    std_logic;
      Clk1MhzEn : in    std_logic;
      FADCSClk  : out   std_logic;
      FADCSIO   : inout std_logic;
      FADCCs    : out   std_logic
      );
  end component;  --FADCSpi;

  component ClkMux
    port(
      CLKinSEL_in : in  std_logic;
      CLKin1_in   : in  std_logic;
      CLKin2_in   : in  std_logic;
      RST_in      : in  std_logic;
      CLKout0_out : out std_logic;
      LOCKED_out  : out std_logic
      );
  end component;



  component ClkDet119Mhz
    port (
      Clk125Mhz   : in  std_logic;
      Reset       : in  std_logic;
      Clk119Mhz   : in  std_logic;
      Clk119MhzOK : out std_logic
      );
  end component;  --ClkDet119Mhz;

  component RFDrive
    port (
      Clock   : in std_logic;
      Reset   : in std_logic;
      FpReset : in std_logic;


-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout  : out std_logic_vector(15 downto 0);
      LkUp_DataOut : out std_logic_vector(15 downto 0);
      Ram_We       : in  std_logic;     -- From Link interface

      Clk1hzEn      : in std_logic;
      Clk10hzEn     : in std_logic;
      Clk10KhzEn    : in std_logic;
      Clk1MhzEn     : in std_logic;
      LocalMode     : in std_logic;
      LocalDrive    : in std_logic_vector(7 downto 0);
      LocalWr       : in std_logic;
      Fault3of5     : in std_logic;
      BeamILowFault : in std_logic;
      FwdPwrFault   : in std_logic;
      ReflPwrFault  : in std_logic;

--jjo 05/06/13
--add offline to ForceZero
      OFFLine : in std_logic;

-- jjo 7/8/13
      MagRfOff : in std_logic;

      Ramping : out std_logic;
      Status  : out std_logic_vector(15 downto 0);

      DisplayRFDrive : out std_logic_vector(15 downto 0);

      RFAttnClk   : out std_logic;
      RFAttnSync  : out std_logic;
      RFAttnSDout : out std_logic
      );

  end component;  -- RFDrive;

  component FocusCoil
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Clk1MhzEn  : in  std_logic;
      FocusClk   : out std_logic;
      FocusSync  : out std_logic;
      FocusSDout : out std_logic
      );

  end component;  --FocusCoil;


  component eDipTFT43_intf
    port (
      Clock       : in  std_logic;
      Reset       : in  std_logic;
      Lnk_Addr    : in  std_logic_vector(15 downto 0);
      Lnk_Wr      : in  std_logic;
      Lnk_Datain  : in  std_logic_vector(15 downto 0);
      Reg_Dataout : out std_logic_vector(15 downto 0);

      clk400KhzEn : in std_logic;

      cmd_Refresh : out std_logic;

-- Display update
      NewData : in  std_logic;
      Tx_Done : out std_logic;
      x1      : in  std_logic_vector(15 downto 0);
      y1      : in  std_logic_vector(15 downto 0);
      x2      : in  std_logic_vector(15 downto 0);
      y2      : in  std_logic_vector(15 downto 0);
      ASCIIin : in  string(8 downto 1);

      SPI_SS    : out std_logic;
      SPI_Clk   : out std_logic;
      SPI_MOSI  : out std_logic;
      SPI_MISO  : in  std_logic;
      SBUF      : in  std_logic;
      FPD_Reset : out std_logic;
      FPD_DPOM  : out std_logic
      );
  end component;  --eDipTFT43_intf;


  component TankPump
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link Interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
      Lnk_Wr     : in std_logic;                      -- From Link Interface
      Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

      Reg_DataOut : out std_logic_vector(15 downto 0);

      Fault_Reset : in std_logic;

      Modulator_On : in std_logic;

--      SLED_U_DT                               : in std_logic;
      PUMPII  : in std_logic;
      TANK_LO : in std_logic;
      TANK_HI : in std_logic;
--      SLED_MN_DT                              : in std_logic;
--      SLED_MN_T                               : in std_logic;

--      SLED_TuneEnable         : out std_logic;
--      SLED_DeTune                             : out std_logic;
--      SLED_Tune                               : out std_logic;

--      SLED_TimeOut                    : out std_logic;
--      SLED_Fault                              : out std_logic;
--      SLED_OK                                 : out std_logic;

      PUMPII_Test  : out std_logic;
      TANK_HI_Test : out std_logic;
--      MN_T_Test                               : out std_logic;
--      U_DT_Test                               : out std_logic;
      TANK_LO_Test : out std_logic;
--      MN_DT_Test                              : out std_logic;

      Status : out std_logic_vector(15 downto 0)
      );
  end component;  --component

  component Sled_intf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);


      Clk1KhzEn   : in std_logic;
      Fault_Reset : in std_logic;

      Modulator_On : in std_logic;

      SLED_U_DT  : in std_logic;
      SLED_U_T   : in std_logic;
      SLED_L_DT  : in std_logic;
      SLED_L_T   : in std_logic;
      SLED_MN_DT : in std_logic;
      SLED_MN_T  : in std_logic;

      SLED_TuneEnable : out std_logic;
      SLED_DeTune     : out std_logic;
      SLED_Tune       : out std_logic;

      SLED_Timeout : out std_logic;
      SLED_Fault   : out std_logic;
      SLED_OK      : out std_logic;

      U_T_Test   : out std_logic;
      L_T_Test   : out std_logic;
      MN_T_Test  : out std_logic;
      U_DT_Test  : out std_logic;
      L_DT_Test  : out std_logic;
      MN_DT_Test : out std_logic;

      Status : out std_logic_vector(15 downto 0)
      );
  end component;  -- SLED_intf



  component ModCmd
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Clk10hzEn : in std_logic;

      MOD_VVS_PWR_Mon      : in std_logic;
      MOD_KLY_FIL_TD_MON   : in std_logic;
      MOD_CTRL_PWR_FLT_MON : in std_logic;
      MOD_inTLK_COMP_MON   : in std_logic;
      MOD_AVAIL_MON        : in std_logic;
      MOD_HV_RDY_MON       : in std_logic;
      MOD_TTOC_MON         : in std_logic;
      MOD_EOLC_MON         : in std_logic;
      MOD_HVOC_MON         : in std_logic;
      MOD_EXT_inTLK_MON    : in std_logic;
      MOD_FAULT_MON        : in std_logic;
      MOD_HV_ON_MON        : in std_logic;

      MOD_VVS_PWR_Test      : out std_logic;
      MOD_KLY_FIL_TD_Test   : out std_logic;
      MOD_CTRL_PWR_FLT_Test : out std_logic;
      MOD_inTLK_COMP_Test   : out std_logic;
      MOD_AVAIL_Test        : out std_logic;
      MOD_HV_RDY_Test       : out std_logic;
      MOD_TTOC_Test         : out std_logic;
      MOD_EOLC_Test         : out std_logic;
      MOD_HVOC_Test         : out std_logic;
      MOD_EXT_inTLK_Test    : out std_logic;
      MOD_FAULT_Test        : out std_logic;
      MOD_HV_ON_Test        : out std_logic;



      Reset_FP   : in std_logic;
      FaultHvOff : in std_logic;

      FaultReset_Cmd : out std_logic;
      CtrlPwr_On_Cmd : out std_logic;
      HV_ON_Cmd      : out std_logic;
      HV_OFF_Cmd     : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );
  end component;  -- ModCmd


  component flow_intf
    port (
      Clock     : in std_logic;
      Reset     : in std_logic;
      FpReset   : in std_logic;
      Clk1KhzEn : in std_logic;

      Lnk_Wr      : in  std_logic;                      -- From Link interface
      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Datain  : in  std_logic_vector(15 downto 0);  -- From Link interface
      Reg_Dataout : out std_logic_vector(15 downto 0);


      ACC2           : in std_logic;
      ACC1           : in std_logic;
      WG2            : in std_logic;
      WG1            : in std_logic;
      KLY            : in std_logic;
      Flow_Sum_Fault : in std_logic;

      ACC2_Test : out std_logic;
      ACC1_Test : out std_logic;
      WG2_Test  : out std_logic;
      WG1_Test  : out std_logic;
      KLY_Test  : out std_logic;


      Status : out std_logic_vector(15 downto 0);

      Fault : out std_logic

      );
  end component;  -- Flow_intf

  component LegacyModCmd
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      WG_TCGuage_Mon : in std_logic;
      WG_Valve_MON   : in std_logic;
      Avail_MON      : in std_logic;


      WG_TCGuage_Test : out std_logic;
      WG_Valve_Test   : out std_logic;
      Avail_Test      : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  --LegacyModCmd;

  component Magintf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Mag_I_intlk_Mon : in std_logic;
      Mag_I_Ok_MON    : in std_logic;
      Mag_Klixon_MON  : in std_logic;


      Mag_I_intlk_Test : out std_logic;
      Mag_I_Ok_Test    : out std_logic;
      Mag_Klixon_Test  : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  -- Magintf;


  component IonPump
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Ion_Pump_Mon : in std_logic;

      Ion_Pump_Test : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  --IonPump;


  component WG_VAC
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      WG_Vac_Bad_Mon : in std_logic;
      WG_Vac_Ok_MON  : in std_logic;


      WG_Vac_Bad_Test : out std_logic;
      WG_Vac_OK_Test  : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  --WG_VAC;

  component Sysinfo
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Reg_Dataout : out std_logic_vector(15 downto 0)
      );
  end component;  --Sysinfo;

  component control_intf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      FP_Local : in std_logic;

      Lnk_Wr      : in  std_logic;                      -- From Link interface
      Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Datain  : in  std_logic_vector(15 downto 0);  -- From Link interface
      Reg_Dataout : out std_logic_vector(15 downto 0);

      Locked      : in std_logic;
      Clk119MhzOk : in std_logic;
      Gt120Hz     : in std_logic;

      DataClkLocked : in std_logic;

      TriggerEn     : out std_logic;
      Configured    : out std_logic;
      Permit        : out std_logic;
      UseAccTrigger : out std_logic;

      PICFault : in std_logic;

      ArmWFM   : out std_logic;
      ArmAve   : out std_logic;
      WFMArmed : in  std_logic;
      AveArmed : in  std_logic;

      SelfTriggerEn : out std_logic;

      Accel  : out std_logic;
      Stndby : out std_logic;
      OFFL   : out std_logic;
      Maint  : out std_logic;

      Local : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  --control_intf;

  component displayintf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

      Lnk_Addr    : in  std_logic_vector(15 downto 0);
      Lnk_Wr      : in  std_logic;
      Lnk_Datain  : in  std_logic_vector(15 downto 0);
      Reg_Dataout : out std_logic_vector(15 downto 0);

      clk400KhzEn : in std_logic;
      Clk119Pres  : in std_logic;

      Refresh : in std_logic;

-- Display IO
      SPI_SS    : out std_logic;
      SPI_Clk   : out std_logic;
      SPI_MOSI  : out std_logic;
      SPI_MISO  : in  std_logic;
      SBUF      : in  std_logic;
      FPD_Reset : out std_logic;
      FPD_DPOM  : out std_logic;

-- 16 Bit signed integers       
      TrigDel   : in std_logic_vector(15 downto 0);
      RFDrive   : in std_logic_vector(15 downto 0);
      MicroPrev : in std_logic_vector(15 downto 0);
      BeamV     : in std_logic_vector(15 downto 0);
      BeamI     : in std_logic_vector(15 downto 0);
      FwdPwr    : in std_logic_vector(15 downto 0);
      RefPwr    : in std_logic_vector(15 downto 0);
      DeltaTemp : in std_logic_vector(15 downto 0);
      WgVac     : in std_logic_vector(15 downto 0);
      KlyVac    : in std_logic_vector(15 downto 0);
      ModRate   : in std_logic_vector(15 downto 0);
      AccRate   : in std_logic_vector(15 downto 0);

      MyIp : in IPAddr_t;

      ModId : in std_logic_vector(7 downto 0);

-- inputs
      Assign   : in std_logic_vector(7 downto 0);
      HSTA     : in std_logic_vector(7 downto 0);
      ModState : in std_logic_vector(7 downto 0)

      );
  end component;  --displayintf;

  component div54x16x32
    port (
      clk      : in  std_logic;
      nd       : in  std_logic;
      rdy      : out std_logic;
      rfd      : out std_logic;
      dividend : in  std_logic_vector(53 downto 0);
      divisor  : in  std_logic_vector(16 downto 0);
      quotient : out std_logic_vector(53 downto 0)
      );
  end component;

  component mults16s16x54
    port (
      clk : in  std_logic;
      a   : in  std_logic_vector(15 downto 0);
      b   : in  std_logic_vector(16 downto 0);
      p   : out std_logic_vector(54 downto 0)
      );
  end component;



  component FaultGen
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link interface
      Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link interface
      Lnk_Wr     : in std_logic;                      -- From Link interface
      Lnk_Datain : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      SW_Fault_Reset_Le : in std_logic;

      Clk1HZEn  : in std_logic;
      Clk10HzEn : in std_logic;
      Clk1KHzEn : in std_logic;

      Trigger_in   : in std_logic;
      TriggerEn_in : in std_logic;

      Sw_Trigen : in std_logic;

      TriggerDisable : out std_logic;   -- To Trigger logic

-- Fault inputs
      M24V : in std_logic;

-- Analog from Slow ADC
      KLYVACAna       : in std_logic;
      WGVACAna        : in std_logic;
      FocusCoilIAna   : in std_logic;
      FocusCoilGndAna : in std_logic;

-- Analog from FAST ADC
      BeamI   : in std_logic;
      BeamV   : in std_logic;
      FWDPWR  : in std_logic;
      REFLPWR : in std_logic;

      BeamILow : in std_logic;

-- Flow Switches
      ACC1Flow : in std_logic;
      ACC2Flow : in std_logic;
      WG1Flow  : in std_logic;
      WG2Flow  : in std_logic;
      KLYFlow  : in std_logic;

-- Temperature Monitor
      TDiff : in std_logic;

-- Legacy
      KLYVAC    : in std_logic;
      WGVACBAD  : in std_logic;
      n_WGVACOK : in std_logic;
      WGTCGauge : in std_logic;
      WGValve   : in std_logic;

-- Magnet
      MagIintlk : in std_logic;
      MagIOK    : in std_logic;
      MagKlixon : in std_logic;

---- From SLED interface
--      SLED_Timeout            : in std_logic;
--      SLED_Fault                      : in std_logic;
--      SLED_OK                         : in std_logic;

-- From Tank and Pump
      Tank_Lo : in std_logic;
      Tank_Hi : in std_logic;
      PumpII  : in std_logic;

-- out puts
      Trigger_out   : out std_logic;
      TriggerEn_out : out std_logic;

      HVOff       : out std_logic;
      Extintlk    : out std_logic;
      MagOff      : out std_logic;
      Fault3of5   : out std_logic;
      BeamILow10s : out std_logic;
-- jjo 7/8/13
      MagRfOff    : out std_logic;

      FwdPwrFault  : out std_logic;
      ReflPwrFault : out std_logic;

      FaultBits : out std_logic_vector(31 downto 0);
      NewFault  : out std_logic;

      Status : out std_logic_vector(15 downto 0)

      );

  end component;  --FaultGen;


  component RFDriveDPMem
    port (
      a    : in  std_logic_vector(7 downto 0);
      d    : in  std_logic_vector(15 downto 0);
      dpra : in  std_logic_vector(7 downto 0);
      clk  : in  std_logic;
      we   : in  std_logic;
      spo  : out std_logic_vector(15 downto 0);
      dpo  : out std_logic_vector(15 downto 0)
      );
  end component;


  component sfp_intf
    port (
      Clock    : in std_logic;
      Reset    : in std_logic;
-- Link interface
      Lnk_Addr : in std_logic_vector(15 downto 0);  -- From Link interface

      Reg_Dataout : out std_logic_vector(15 downto 0);

      Clk_En : in    std_logic;
      SDA0   : inout std_logic;
      SCL0   : out   std_logic;

      SDA1 : inout std_logic;
      SCL1 : out   std_logic
      );
  end component;  --sfp_intf;

  component dpram_fo is
    port (
      addra : in  std_logic_vector(9 downto 0);
      addrb : in  std_logic_vector(7 downto 0);
      clka  : in  std_logic;
      clkb  : in  std_logic;
      dina  : in  std_logic_vector(7 downto 0);
      doutb : out std_logic_vector(31 downto 0);
      wea   : in  std_logic
      );
  end component;  --dpram_fo;


  component FrontPanel_input
    port (
      Clock : in std_logic;
      Reset : in std_logic;
      ClkEn : in std_logic;

      SW_TRIGEN  : in std_logic;
      SW_TEST    : in std_logic;
      SW_SPARE2  : in std_logic;
      SW_SPARE1  : in std_logic;
      SW_FLT_RST : in std_logic;
      SW_LOCAL   : in std_logic;
      SW_POT2    : in std_logic;
      SW_POT1    : in std_logic;
      POT2_UP    : in std_logic;
      POT2_DOWN  : in std_logic;
      POT1_UP    : in std_logic;
      POT1_DOWN  : in std_logic;

      SW_Trigger_Enable_db : out std_logic;
      SW_Test_db           : out std_logic;
      SW_Fault_Reset_db    : out std_logic;
      SW_Fault_Reset_Le    : out std_logic;
      SW_Local_db          : out std_logic;

      Delay_Up_db : out std_logic;
      Delay_Dn_db : out std_logic;
      Delay_Sw_db : out std_logic;

      Drive_Up_db : out std_logic;
      Drive_Dn_db : out std_logic;
      Drive_Sw_db : out std_logic;

      SW_inc_db : out std_logic;
      SW_Dec_db : out std_logic

      );

  end component;  --FrontPanel_input;

  component LocalTrigger
    port (
      Clock      : in std_logic;
      Reset      : in std_logic;
      Clk_En     : in std_logic;
      Mode_Local : in std_logic;

      Delay_up : in std_logic;
      Delay_Dn : in std_logic;
      Delay_Sw : in std_logic;

      FP_SW_inc : in std_logic;
      FP_SW_Dec : in std_logic;

      LocalTrigDelay : out std_logic_vector(15 downto 0);
      LocalRateDiv   : out std_logic_vector(2 downto 0);

      up : out std_logic;
      dn : out std_logic
      );

  end component;  --mksuii;


  component flash_intf
    port (
      Clock : in std_logic;
      Reset : in std_logic;

-- Link Interface                                                           
      Lnk_Addr      : in  std_logic_vector(15 downto 0);
      Lnk_DataIn    : in  std_logic_vector(15 downto 0);
      Lnk_WriteAddr : in  std_logic;
      Lnk_ReadBlk   : in  std_logic;
      Lnk_EraseBlk  : in  std_logic;
      Lnk_WriteBlk  : in  std_logic;
      Lnk_LockBlk   : in  std_logic;
      Lnk_DAV       : out std_logic;

      Reg_DataOut : out std_logic_vector(15 downto 0);

      Flash_We      : out std_logic;
      Flash_Oe      : out std_logic;
      Flash_Cs      : out std_logic;
      Flash_VPP     : out std_logic;
      Flash_AddrOut : out std_logic_vector(24 downto 0);
      Flash_DataIn  : in  std_logic_vector(15 downto 0);  -- From Flash Memory
      Flash_DataOut : out std_logic_vector(15 downto 0)   -- To Flash Memory

      );
  end component;  --flash_intf;

  component flash_fifo
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(31 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(31 downto 0);
      full  : out std_logic;
      empty : out std_logic
      );
  end component;

  component Flash_Fifo512x16
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      din   : in  std_logic_vector(15 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(15 downto 0);
      full  : out std_logic;
      empty : out std_logic
      );
  end component;


  component Flash_Fifo_DPRam512x15
    port (
      a    : in  std_logic_vector(8 downto 0);
      d    : in  std_logic_vector(15 downto 0);
      dpra : in  std_logic_vector(8 downto 0);
      clk  : in  std_logic;
      we   : in  std_logic;
      dpo  : out std_logic_vector(15 downto 0)
      );
  end component;

  component FaultHistoryRam
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(6 downto 0);
      dina  : in  std_logic_vector(63 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(8 downto 0);
      doutb : out std_logic_vector(15 downto 0)
      );
  end component;

end mksuii;

package body mksuii is

  function Character_to_StdLogicVector(MyString : in character) return std_logic_vector is
    variable Test1 : std_logic_vector(7 downto 0);
  begin
    case MyString is
      when '0' => Test1 := x"30";
      when '1' => Test1 := x"31";
      when '2' => Test1 := x"32";
      when '3' => Test1 := x"33";
      when '4' => Test1 := x"34";
      when '5' => Test1 := x"35";
      when '6' => Test1 := x"36";
      when '7' => Test1 := x"37";
      when '8' => Test1 := x"38";
      when '9' => Test1 := x"39";

      when 'a' => Test1 := x"61";
      when 'b' => Test1 := x"62";
      when 'c' => Test1 := x"63";
      when 'd' => Test1 := x"64";
      when 'e' => Test1 := x"65";
      when 'f' => Test1 := x"66";
      when 'g' => Test1 := x"67";
      when 'h' => Test1 := x"68";
      when 'i' => Test1 := x"69";
      when 'j' => Test1 := x"6A";
      when 'k' => Test1 := x"6B";
      when 'l' => Test1 := x"6C";
      when 'm' => Test1 := x"6D";
      when 'n' => Test1 := x"6E";
      when 'o' => Test1 := x"6F";
      when 'p' => Test1 := x"70";
      when 'q' => Test1 := x"71";
      when 'r' => Test1 := x"72";
      when 's' => Test1 := x"73";
      when 't' => Test1 := x"74";
      when 'u' => Test1 := x"75";
      when 'v' => Test1 := x"76";
      when 'w' => Test1 := x"77";
      when 'x' => Test1 := x"78";
      when 'y' => Test1 := x"79";
      when 'z' => Test1 := x"7A";

      when 'A' => Test1 := x"41";
      when 'B' => Test1 := x"42";
      when 'C' => Test1 := x"43";
      when 'D' => Test1 := x"44";
      when 'E' => Test1 := x"45";
      when 'F' => Test1 := x"46";
      when 'G' => Test1 := x"47";
      when 'H' => Test1 := x"48";
      when 'I' => Test1 := x"49";
      when 'J' => Test1 := x"4A";
      when 'K' => Test1 := x"4B";
      when 'L' => Test1 := x"4C";
      when 'M' => Test1 := x"4D";
      when 'N' => Test1 := x"4E";
      when 'O' => Test1 := x"4F";
      when 'P' => Test1 := x"50";
      when 'Q' => Test1 := x"51";
      when 'R' => Test1 := x"52";
      when 'S' => Test1 := x"53";
      when 'T' => Test1 := x"54";
      when 'U' => Test1 := x"55";
      when 'V' => Test1 := x"56";
      when 'W' => Test1 := x"57";
      when 'X' => Test1 := x"58";
      when 'Y' => Test1 := x"59";
      when 'Z' => Test1 := x"5A";

      when ' ' => Test1 := x"20";
      when '-' => Test1 := x"2D";
      when '.' => Test1 := x"2E";
      when '/' => Test1 := x"2F";

      when others => Test1 := x"20";
    end case;
    return Test1;
  end Character_to_StdLogicVector;

  function StdLogicVector_to_Character(MyStdLogic : in std_logic_vector(3 downto 0)) return character is
    variable MyChar : character;
  begin
    case MyStdLogic(3 downto 0) is
      when x"0" => MyChar := '0';
      when x"1" => MyChar := '1';
      when x"2" => MyChar := '2';
      when x"3" => MyChar := '3';
      when x"4" => MyChar := '4';
      when x"5" => MyChar := '5';
      when x"6" => MyChar := '6';
      when x"7" => MyChar := '7';
      when x"8" => MyChar := '8';
      when x"9" => MyChar := '9';
      when others =>
    end case;
    return MyChar;
  end StdLogicVector_to_Character;

--
--function SignExt12to16(Vin : in std_logic_vector) return std_logic_vector is
--begin
--      Return Vin(11) & Vin(11) & Vin(11) & Vin(11) & Vin;
--end SignExt12to16;


end mksuii;
