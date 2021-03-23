-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	displayIntf.vhd -
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 8/18/2011 3:21:24 PM
--	Last change: JO 8/19/2011 9:49:09 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:35:16 04/18/2011 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.mksuii.all;

entity displayIntf is
Port ( 
	Clock 			: in  std_logic;
	Reset 			: in  std_logic;

	Lnk_Addr 		: in  std_logic_vector(15 downto 0);
	Lnk_Wr	 		: in  std_logic;
	Lnk_DataIn 		: in  std_logic_vector(15 downto 0);
	Reg_DataOut 	: out  std_logic_vector(15 downto 0);

	clk400KhzEn		: in 	std_logic;
	Clk119Pres		: in std_logic;

	Refresh			: in std_logic;

-- Display IO
	SPI_SS 			: out std_logic;
	SPI_Clk 			: out std_logic;
	SPI_MOSI 		: out std_logic;
	SPI_MISO 		: in  std_logic;
	SBUF				: in  std_logic;
	FPD_Reset		: out std_logic;
	FPD_DPOM			: out std_logic;

-- 16 Bit signed integers	
	TrigDel 			: in std_logic_vector(15 downto 0);
	RFDrive 			: in std_logic_vector(15 downto 0);
	MicroPrev 		: in std_logic_vector(15 downto 0);
	BeamV 			: in std_logic_vector(15 downto 0);
	BeamI 			: in std_logic_vector(15 downto 0);
	FwdPwr 			: in std_logic_vector(15 downto 0);
	RefPwr 			: in std_logic_vector(15 downto 0);
	DeltaTemp 		: in std_logic_vector(15 downto 0);
	WgVac 			: in std_logic_vector(15 downto 0);
	KlyVac 			: in std_logic_vector(15 downto 0);
	ModRate 			: in std_logic_vector(15 downto 0);   
	AccRate			: in std_logic_vector(15 downto 0);
	
	ModId				: in std_logic_vector(7 downto 0);

	IP_Address		: in IPAddr_t;
	
-- Inputs
	Assign 			: in std_logic_vector(7 downto 0);
	HSTA 				: in std_logic_vector(7 downto 0);
	ModState			: in std_logic_vector(7 downto 0)

	);
end displayIntf;

architecture Behavioral of displayIntf is

signal NewData 		: std_logic;
signal cmd_Refresh 	: std_logic;
signal TxDone 			: std_logic;

signal X1				: std_logic_vector(15 downto 0);
signal Y1				: std_logic_vector(15 downto 0);
signal X2				: std_logic_vector(15 downto 0);
signal Y2				: std_logic_vector(15 downto 0);
signal ASCIIOut		: string(8 downto 1);

Begin

u_Display : eDipTFT43_intf
Port map (
	Clock       => Clock,
	Reset       => Reset,                                    
	clk400KhzEn => Clk400KhzEn,                                   
-- Link                                                        
	Lnk_Addr    => Lnk_Addr,	  			-- From Link Interface  
	Lnk_Wr      => Lnk_Wr,	  				-- From Link Decode
	Lnk_DataIn  => Lnk_DataIn,				-- From Link Decode     
	Reg_DataOut => Reg_DataOut,			-- To Link Interface


-- Display
	cmd_Refresh	=> cmd_Refresh,
	NewData		=> NewData,
	Tx_Done		=> TxDone,
	x1				=> X1,
	y1				=> Y1,
	x2				=> X2,
	y2				=> Y2,
	ASCIIIn		=> ASCIIOut,


-- Display IO
	SPI_SS		=> SPI_SS,
	SPI_Clk     => SPI_Clk,
	SPI_MOSI    => SPI_MOSI,
	SPI_MISO    => SPI_MISO,
	SBUF        => SBUF,
	FPD_Reset   => FPD_Reset,
	FPD_DPOM	   => FPD_DPOM

);

u_alu : alu
Port map (
	Clock				=> Clock,
	Reset				=> Reset,

-- 16 Bit signed integers	
	TrigDel			=> TrigDel,
	RFDrive        => RFDrive,
	MicroPrev      => MicroPrev,
	BeamV          => BeamV,
	BeamI          => BeamI,
	FwdPwr         => FwdPwr,
	RefPwr         => RefPwr,
	DeltaTemp      => DeltaTemp,
	WgVac          => WgVac,
	KlyVac         => KlyVac,
	ModRate        => ModRate,
	AccRate        => AccRate,
	
	ModId				=> ModID,
	Clk119Pres		=> Clk119Pres,

	IP_Address		=> IP_Address,

-- Text inputs 32 bits 4 characters
	Assign         => Assign,
	HSTA           => HSTA,
	ModState       => ModState,

-- Display XY location
	X1         		=> X1,
	Y1         		=> Y1,
	X2          	=> X2,
	Y2          	=> Y2,
	
-- Control IO	
	Refresh			=> Refresh,							--	Start Refresh Cycle
	cmd_Refresh		=> cmd_Refresh,							--	Start Refresh Cycle

	NewData			=> NewData,							-- Update Display
	TxDone			=> TxDone,							-- Display Done

-- Ascii output 8 characters
	ASCIIOut       => ASCIIOut
	);


end Behavioral;

