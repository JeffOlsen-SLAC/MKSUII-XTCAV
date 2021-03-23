-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	glnktest.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 10/1/2013 9:03:08 AM
--	Last change: JO 10/1/2013 9:08:56 AM
--
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:02:28 10/01/2013
-- Design Name:   
-- Module Name:   V:/CD/EIE/projects/XTCAV/MKSUII/chassis/xilinx/mksuii_x/glnktest.vhd
-- Project Name:  mksuii_x
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MKSUII_GLink
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY glnktest IS
END glnktest;
 
ARCHITECTURE behavior OF glnktest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MKSUII_GLink
    PORT(
         Reset : IN  std_logic;
         Clock : IN  std_logic;
         Lnk_Clk : OUT  std_logic;
         Active : OUT  std_logic;
         Lnk_Error : OUT  std_logic;
         Lnk_Locked : OUT  std_logic;
         Lnk_DataOut : OUT  std_logic_vector(7 downto 0);
         Lnk_DataStrb : OUT  std_logic;
         Lnk_MessType : OUT  std_logic_vector(7 downto 0);
         Lnk_MessStrb : OUT  std_logic;
         Lnk_TaskId : OUT  std_logic_vector(7 downto 0);
         Tx_Start : IN  std_logic;
         Tx_MessType : IN  std_logic_vector(7 downto 0);
         Tx_TaskId : IN  std_logic_vector(7 downto 0);
         Tx_Count : IN  std_logic_vector(15 downto 0);
         Tx_Data_In : IN  std_logic_vector(7 downto 0);
         Tx_Done : IN  std_logic;
         Tx_Rdy : OUT  std_logic;
         BRD_ID : IN  std_logic_vector(7 downto 0);
         TXP_0 : OUT  std_logic;
         TXN_0 : OUT  std_logic;
         RXP_0 : IN  std_logic;
         RXN_0 : IN  std_logic;
         TXN_1_UNUSED : OUT  std_logic;
         TXP_1_UNUSED : OUT  std_logic;
         RXN_1_UNUSED : IN  std_logic;
         RXP_1_UNUSED : IN  std_logic;
         MGTCLK_P : IN  std_logic;
         MGTCLK_N : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Reset : std_logic := '0';
   signal Clock : std_logic := '0';
   signal Tx_Start : std_logic := '0';
   signal Tx_MessType : std_logic_vector(7 downto 0) := (others => '0');
   signal Tx_TaskId : std_logic_vector(7 downto 0) := (others => '0');
   signal Tx_Count : std_logic_vector(15 downto 0) := (others => '0');
   signal Tx_Data_In : std_logic_vector(7 downto 0) := (others => '0');
   signal Tx_Done : std_logic := '0';
   signal BRD_ID : std_logic_vector(7 downto 0) := (others => '0');
   signal RXP_0 : std_logic := '0';
   signal RXN_0 : std_logic := '0';
   signal RXN_1_UNUSED : std_logic := '0';
   signal RXP_1_UNUSED : std_logic := '0';
   signal MGTCLK_P : std_logic := '0';
   signal MGTCLK_N : std_logic := '0';

 	--Outputs
   signal Lnk_Clk : std_logic;
   signal Active : std_logic;
   signal Lnk_Error : std_logic;
   signal Lnk_Locked : std_logic;
   signal Lnk_DataOut : std_logic_vector(7 downto 0);
   signal Lnk_DataStrb : std_logic;
   signal Lnk_MessType : std_logic_vector(7 downto 0);
   signal Lnk_MessStrb : std_logic;
   signal Lnk_TaskId : std_logic_vector(7 downto 0);
   signal Tx_Rdy : std_logic;
   signal TXP_0 : std_logic;
   signal TXN_0 : std_logic;
   signal TXN_1_UNUSED : std_logic;
   signal TXP_1_UNUSED : std_logic;


signal tx_clk 						:  std_logic;
signal tx_locked 					:  std_logic;

signal tstr_data 					:  std_logic_vector(7 downto 0);
signal tstr_DataStrb 			:  std_logic;
signal tstr_MessType 			:  std_logic_vector(7 downto 0);
signal tstr_TaskId 				:  std_logic_vector(7 downto 0);
signal tstr_MessStrb 			:  std_logic;

signal TX0_p 		 				:  std_logic;
signal TX0_n 						:  std_logic;
signal RX0_n 						:  std_logic;
signal RX0_p 						:  std_logic;

signal Tx_Data 					:  std_logic_vector(7 downto 0);
signal MGTCLK 						:  std_logic;
signal clk119mhz 					:  std_logic;
signal TstrReset 					:  std_logic;


BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
uut: MKSUII_GLink PORT MAP (
	Reset 			=> Reset,
	Clock 			=> Clock,
	Lnk_Clk 			=> Lnk_Clk,
	Active 			=> Active,
	Lnk_Error 		=> Lnk_Error,
	Lnk_Locked 		=> Lnk_Locked,
	Lnk_DataOut 	=> Lnk_DataOut,
	Lnk_DataStrb 	=> Lnk_DataStrb,
	Lnk_MessType 	=> Lnk_MessType,
	Lnk_MessStrb 	=> Lnk_MessStrb,
	Lnk_TaskId 		=> Lnk_TaskId,
	Tx_Start 		=> Tx_Start,
	Tx_MessType 	=> Tx_MessType,
	Tx_TaskId 		=> Tx_TaskId,
	Tx_Count 		=> Tx_Count,
	Tx_Data_In 		=> Tx_Data_In,
	Tx_Done 			=> Tx_Done,
	Tx_Rdy 			=> Tx_Rdy,
	BRD_ID 			=> BRD_ID,
	TXP_0 			=> Rx0_p,
	TXN_0 			=> Rx0_n, 
	RXP_0 			=> Tx0_p, 
	RXN_0 			=> Tx0_n, 
	TXN_1_UNUSED 	=> TXN_1_UNUSED,
	TXP_1_UNUSED 	=> TXP_1_UNUSED,
	RXN_1_UNUSED 	=> RXN_1_UNUSED,
	RXP_1_UNUSED 	=> RXP_1_UNUSED,
	MGTCLK_P 		=> MGTCLK_P,
	MGTCLK_N 		=> MGTCLK_N
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

		  

END;
