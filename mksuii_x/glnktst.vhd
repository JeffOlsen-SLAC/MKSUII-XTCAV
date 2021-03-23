-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	glnktst.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 10/1/2013 8:47:02 AM
--	Last change: JO 10/1/2013 8:49:49 AM
--
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:22:58 10/01/2013
-- Design Name:   
-- Module Name:   V:/CD/EIE/projects/XTCAV/MKSUII/chassis/xilinx/mksuii_x/glnktst.vhd
-- Project Name:  mksuii_x
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: glink_intf
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

library work;
use work.mksuii.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY glnktst IS
END glnktst;
 
ARCHITECTURE behavior OF glnktst IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT glink_intf
PORT(
	Clock 				: IN	std_logic;
	Reset 				: IN	std_logic;
	Active 				: OUT  std_logic;
	Lnk_Error 			: OUT  std_logic;
	Lnk_DataOut 		: OUT	 std_logic_vector(7 downto 0);
	Lnk_DataStrb 		: OUT  std_logic;
	Lnk_MessType 		: OUT  std_logic_vector(7 downto 0);
	Lnk_MessStrb 		: OUT  std_logic;
	Lnk_TaskId 			: OUT	std_logic_vector(7 downto 0);
	Tx_Start 			: IN	std_logic;
	Tx_MessType 		: IN	std_logic_vector(7 downto 0);
	Tx_TaskID 			: IN	 std_logic_vector(7 downto 0);
	Tx_Data_In 			: IN  std_logic_vector(7 downto 0);
	Tx_Count 			: IN	std_logic_vector(15 downto 0);
	Tx_Done 				: IN  std_logic;
	Tx_Rdy 				: OUT  std_logic;
	Brd_ID 				: IN	 std_logic_vector(7 downto 0);
	RX_LL_DATA 			: IN  std_logic_vector(7 downto 0);
	RX_LL_SOF_N 		: IN	std_logic;
	RX_LL_EOF_N 		: IN	std_logic;
	RX_LL_SRC_RDY_N 	: IN	 std_logic;
	RX_LL_DST_RDY_N 	: OUT  std_logic;
	TX_LL_DATA 			: OUT	std_logic_vector(7 downto 0);
	TX_LL_SOF_N 		: OUT	 std_logic;
	TX_LL_EOF_N 		: OUT	 std_logic;
	TX_LL_SRC_RDY_N 	: OUT  std_logic;
	TX_LL_DST_RDY_N 	: IN	 std_logic
);
END COMPONENT;
    

--Inputs
signal Clock 				: std_logic := '0';
signal Reset 				: std_logic := '0';
signal Tx_Start 			: std_logic := '0';
signal Tx_MessType 		: std_logic_vector(7 downto 0) := (others => '0');
signal Tx_TaskID 			: std_logic_vector(7 downto 0) := (others => '0');
signal Tx_Data_In 		: std_logic_vector(7 downto 0) := (others => '0');
signal Tx_Count 			: std_logic_vector(15 downto 0) := (others => '0');
signal Tx_Done 			: std_logic := '0';
signal Brd_ID 				: std_logic_vector(7 downto 0) := (others => '0');
signal RX_LL_DATA 		: std_logic_vector(7 downto 0) := (others => '0');
signal RX_LL_SOF_N 		: std_logic := '0';
signal RX_LL_EOF_N 		: std_logic := '0';
signal RX_LL_SRC_RDY_N 	: std_logic := '0';
signal TX_LL_DST_RDY_N 	: std_logic := '0';

--Outputs
signal Active 				: std_logic;
signal Lnk_Error 			: std_logic;
signal Lnk_DataOut 		: std_logic_vector(7 downto 0);
signal Lnk_DataStrb 		: std_logic;
signal Lnk_MessType 		: std_logic_vector(7 downto 0);
signal Lnk_MessStrb 		: std_logic;
signal Lnk_TaskId 		: std_logic_vector(7 downto 0);
signal Tx_Rdy 				: std_logic;
signal RX_LL_DST_RDY_N 	: std_logic;
signal TX_LL_DATA 		: std_logic_vector(7 downto 0);
signal TX_LL_SOF_N 		: std_logic;
signal TX_LL_EOF_N 		: std_logic;
signal TX_LL_SRC_RDY_N 	: std_logic;

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
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
uut: glink_intf PORT MAP (
	Clock 				=> Clock,
	Reset 				=> Reset,
	Active 				=> Active,
	Lnk_Error 			=> Lnk_Error,
	Lnk_DataOut 		=> Lnk_DataOut,
	Lnk_DataStrb 		=> Lnk_DataStrb,
	Lnk_MessType 		=> Lnk_MessType,
	Lnk_MessStrb 		=> Lnk_MessStrb,
	Lnk_TaskId 			=> Lnk_TaskId,
	Tx_Start 			=> Tx_Start,
	Tx_MessType 		=> Tx_MessType,
	Tx_TaskID 			=> Tx_TaskID,
	Tx_Data_In 			=> Tx_Data_In,
	Tx_Count 			=> Tx_Count,
	Tx_Done 				=> Tx_Done,
	Tx_Rdy 				=> Tx_Rdy,
	Brd_ID 				=> Brd_ID,
	RX_LL_DATA 			=> RX_LL_DATA,
	RX_LL_SOF_N 		=> RX_LL_SOF_N,
	RX_LL_EOF_N 		=> RX_LL_EOF_N,
	RX_LL_SRC_RDY_N 	=> RX_LL_SRC_RDY_N,
	RX_LL_DST_RDY_N 	=> RX_LL_DST_RDY_N,
	TX_LL_DATA 			=> TX_LL_DATA,
	TX_LL_SOF_N 		=> TX_LL_SOF_N,
	TX_LL_EOF_N 		=> TX_LL_EOF_N,
	TX_LL_SRC_RDY_N 	=> TX_LL_SRC_RDY_N,
	TX_LL_DST_RDY_N 	=> TX_LL_DST_RDY_N
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
	Tx_Count					=> tx_count,			-- Number of byte of data
	Tx_Data_in     		=> tx_data,				-- Data from external memory or registers
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
