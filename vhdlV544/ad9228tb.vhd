--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:52:55 03/22/2011
-- Design Name:   
-- Module Name:   V:/CD/EIE/projects/LINAC_UPGRADE/MKSU/MKSUII/chassis/vhdl/ad9228tb.vhd
-- Project Name:  mksuii_x
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ad9228Input
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vectorfor the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
use work.mksuii_x.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ad9228tb IS
END ad9228tb;
 
ARCHITECTURE behavior OF ad9228tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ad9228Input
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         FADC_CLK_P : OUT  std_logic;
         FADC_CLK_N : OUT  std_logic;
         FADC_FRAME_CLK_P : IN  std_logic;
         FADC_FRAME_CLK_N : IN  std_logic;
         FADC_DATA_CLK_P : IN  std_logic;
         FADC_DATA_CLK_N : IN  std_logic;
         BEAM_V_P : IN  std_logic;
         BEAM_V_N : IN  std_logic;
         BEAM_I_P : IN  std_logic;
         BEAM_I_N : IN  std_logic;
         FWD_PWR_P : IN  std_logic;
         FWD_PWR_N : IN  std_logic;
         REFL_PWR_P : IN  std_logic;
         REFL_PWR_N : IN  std_logic;
         BeamV_Data : OUT  std_logic_vector(11 downto 0);
         BeamI_Data : OUT  std_logic_vector(11 downto 0);
         FWD_Data : OUT  std_logic_vector(11 downto 0);
         REFL_Data : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal ClockB : std_logic := '0';
   signal Reset : std_logic := '0';
   signal FADC_FRAME_CLK_P : std_logic := '0';
   signal FADC_FRAME_CLK_N : std_logic := '0';
   signal FADC_DATA_CLK_P : std_logic := '0';
   signal FADC_DATA_CLK_N : std_logic := '0';
   signal BEAM_V_P : std_logic := '0';
   signal BEAM_V_N : std_logic := '0';
   signal BEAM_I_P : std_logic := '0';
   signal BEAM_I_N : std_logic := '0';
   signal FWD_PWR_P : std_logic := '0';
   signal FWD_PWR_N : std_logic := '0';
   signal REFL_PWR_P : std_logic := '0';
   signal REFL_PWR_N : std_logic := '0';

 	--Outputs
   signal FADC_CLK_P : std_logic;
   signal FADC_CLK_N : std_logic;
   signal BeamV_Data : std_logic_vector(11 downto 0);
   signal BeamI_Data : std_logic_vector(11 downto 0);
   signal FWD_Data : std_logic_vector(11 downto 0);
   signal REFL_Data : std_logic_vector(11 downto 0);

   signal Q : std_logic_vector(3 downto 0);
   signal QB : std_logic_vector(3 downto 0);

 
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
uut: ad9228Input PORT MAP (
	Clock 				=> Clock,
	Reset 				=> Reset,
	FADC_CLK_P 			=> FADC_CLK_P,
	FADC_CLK_N 			=> FADC_CLK_N,
	FADC_FRAME_CLK_P 	=> FADC_FRAME_CLK_P,
	FADC_FRAME_CLK_N 	=> FADC_FRAME_CLK_N,
	FADC_DATA_CLK_P 	=> FADC_DATA_CLK_P,
	FADC_DATA_CLK_N 	=> FADC_DATA_CLK_N,
	BEAM_V_P 			=> BEAM_V_P,
	BEAM_V_N 			=> BEAM_V_N,
	BEAM_I_P 			=> BEAM_I_P,
	BEAM_I_N 			=> BEAM_I_N,
	FWD_PWR_P 			=> FWD_PWR_P,
	FWD_PWR_N 			=> FWD_PWR_N,
	REFL_PWR_P 			=> REFL_PWR_P,
	REFL_PWR_N 			=> REFL_PWR_N,
	BeamV_Data 			=> BeamV_Data,
	BeamI_Data 			=> BeamI_Data,
	FWD_Data 			=> FWD_Data,
	REFL_Data 			=> REFL_Data
);

ClockB 		<= not(Clock);


BEAM_V_P 	<= Q(0);
BEAM_V_N 	<= QB(0);
BEAM_I_P 	<= Q(1);
BEAM_I_N 	<= QB(1);
FWD_PWR_P 	<= Q(2);
FWD_PWR_N 	<= QB(2);
REFL_PWR_P 	<= Q(3);
REFL_PWR_N 	<= QB(3);

u_Tstr : ad9228_tstr 
Port map ( 
  clock 	=> Clock,
  clockB => ClockB,
  Reset 	=> Reset,
  

  FC 		=> FADC_FRAME_CLK_P,
  FCB 	=> FADC_FRAME_CLK_N,
  
  DC 		=> FADC_DATA_CLK_P,
  DCB 	=> FADC_DATA_CLK_N,
  
  Q 		=> Q,
  QB 		=> QB
  );

END;
