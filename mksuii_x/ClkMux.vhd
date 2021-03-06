--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : xaw2vhdl
--  /   /         Filename : ClkMux.vhd
-- /___/   /\     Timestamp : 03/19/2021 16:02:51
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-intstyle /home/ise/XilinxShare/XTCAV/xilinx/mksuii_x/ipcore_dir/ClkMux.xaw -st ClkMux.vhd
--Design Name: ClkMux
--Device: xc5vlx30t-1ff665
--
-- Module ClkMux
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- For block PLL_ADV_INST, Estimated PLL Jitter for CLKOUT0 = 0.143 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ClkMux is
   port ( CLKINSEL_IN : in    std_logic; 
          CLKIN1_IN   : in    std_logic; 
          CLKIN2_IN   : in    std_logic; 
          RST_IN      : in    std_logic; 
          CLKOUT0_OUT : out   std_logic; 
          LOCKED_OUT  : out   std_logic);
end ClkMux;

architecture BEHAVIORAL of ClkMux is
   signal CLKFBOUT_CLKFBIN : std_logic;
   signal CLKOUT0_BUF      : std_logic;
   signal GND_BIT          : std_logic;
   signal GND_BUS_5        : std_logic_vector (4 downto 0);
   signal GND_BUS_16       : std_logic_vector (15 downto 0);
begin
   GND_BIT <= '0';
   GND_BUS_5(4 downto 0) <= "00000";
   GND_BUS_16(15 downto 0) <= "0000000000000000";
   CLKOUT0_BUFG_INST : BUFG
      port map (I=>CLKOUT0_BUF,
                O=>CLKOUT0_OUT);
   
   PLL_ADV_INST : PLL_ADV
   generic map( BANDWIDTH => "OPTIMIZED",
            CLKIN1_PERIOD => 8.403,
            CLKIN2_PERIOD => 8.000,
            CLKOUT0_DIVIDE => 8,
            CLKOUT0_PHASE => 0.000,
            CLKOUT0_DUTY_CYCLE => 0.500,
            COMPENSATION => "SYSTEM_SYNCHRONOUS",
            DIVCLK_DIVIDE => 1,
            CLKFBOUT_MULT => 8,
            CLKFBOUT_PHASE => 0.0,
            REF_JITTER => 0.000000)
      port map (CLKFBIN=>CLKFBOUT_CLKFBIN,
                CLKINSEL=>CLKINSEL_IN,
                CLKIN1=>CLKIN1_IN,
                CLKIN2=>CLKIN2_IN,
                DADDR(4 downto 0)=>GND_BUS_5(4 downto 0),
                DCLK=>GND_BIT,
                DEN=>GND_BIT,
                DI(15 downto 0)=>GND_BUS_16(15 downto 0),
                DWE=>GND_BIT,
                REL=>GND_BIT,
                RST=>RST_IN,
                CLKFBDCM=>open,
                CLKFBOUT=>CLKFBOUT_CLKFBIN,
                CLKOUTDCM0=>open,
                CLKOUTDCM1=>open,
                CLKOUTDCM2=>open,
                CLKOUTDCM3=>open,
                CLKOUTDCM4=>open,
                CLKOUTDCM5=>open,
                CLKOUT0=>CLKOUT0_BUF,
                CLKOUT1=>open,
                CLKOUT2=>open,
                CLKOUT3=>open,
                CLKOUT4=>open,
                CLKOUT5=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>LOCKED_OUT);
   
end BEHAVIORAL;


