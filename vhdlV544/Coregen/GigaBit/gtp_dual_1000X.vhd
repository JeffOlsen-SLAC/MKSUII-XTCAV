-------------------------------------------------------------------------------
-- Title      : 1000BASE-X RocketIO wrapper
-- Project    : Virtex-5 Ethernet MAC Wrappers
-------------------------------------------------------------------------------
-- File       : gtp_dual_1000X.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Copyright (c) 2004-2007 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you
-- a license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as is" solely for use in developing programs and
-- solutions for Xilinx devices. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications are
-- expressly prohibited.
--
-- This copyright and support notice must be retained as part
-- of this text at all times. (c) Copyright 2004-2007 Xilinx, Inc.
-- All rights reserved.

------------------------------------------------------------------------
-- Description:  This is the VHDL instantiation of a Virtex-5 GTP    
--               RocketIO tile for the Embedded Ethernet MAC.
--
--               Two GTP's must be instantiated regardless of how many  
--               GTPs are used in the MGT tile. 
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

library UNISIM;
use UNISIM.Vcomponents.ALL;


entity GTP_dual_1000X is
   port (
          RESETDONE_0           : out   std_logic;
          ENMCOMMAALIGN_0       : in    std_logic; 
          ENPCOMMAALIGN_0       : in    std_logic; 
          LOOPBACK_0            : in    std_logic; 
          RXUSRCLK_0            : in    std_logic;
          RXUSRCLK2_0           : in    std_logic;
          RXRESET_0             : in    std_logic;          
          TXCHARDISPMODE_0      : in    std_logic; 
          TXCHARDISPVAL_0       : in    std_logic; 
          TXCHARISK_0           : in    std_logic; 
          TXDATA_0              : in    std_logic_vector (7 downto 0); 
          TXUSRCLK_0            : in    std_logic; 
          TXUSRCLK2_0           : in    std_logic; 
          TXRESET_0             : in    std_logic; 
          RXCHARISCOMMA_0       : out   std_logic; 
          RXCHARISK_0           : out   std_logic;
          RXCLKCORCNT_0         : out   std_logic_vector (2 downto 0);           
          RXCOMMADET_0          : out   std_logic; 
          RXDATA_0              : out   std_logic_vector (7 downto 0); 
          RXDISPERR_0           : out   std_logic; 
          RXNOTINTABLE_0        : out   std_logic;
          RXREALIGN_0           : out   std_logic; 
          RXRUNDISP_0           : out   std_logic; 
          RXBUFERR_0            : out   std_logic;
          TXBUFERR_0            : out   std_logic; 
          PLLLKDET_0            : out   std_logic; 
          TXOUTCLK_0            : out   std_logic; 
          TXRUNDISP_0           : out   std_logic; 
          RXELECIDLE_0    	: out   std_logic;
          TX1N_0                : out   std_logic; 
          TX1P_0                : out   std_logic;
          RX1N_0                : in    std_logic; 
          RX1P_0                : in    std_logic;

          TX1N_1_UNUSED         : out   std_logic;
          TX1P_1_UNUSED         : out   std_logic;
          RX1N_1_UNUSED         : in    std_logic;
          RX1P_1_UNUSED         : in    std_logic;


          CLK_DS                : in    std_logic;
          REFCLKOUT             : out   std_logic;
          PMARESET              : in    std_logic;
          DCM_LOCKED            : in    std_logic
          );
end GTP_dual_1000X;


architecture structural of GTP_dual_1000X is

  component rx_elastic_buffer
   port (
      -- Signals received from the RocketIO on RXRECCLK.
      rxrecclk                  : in  std_logic;
      reset                     : in  std_logic;
      rxchariscomma_rec         : in  std_logic;
      rxcharisk_rec             : in  std_logic;
      rxdisperr_rec             : in  std_logic;
      rxnotintable_rec          : in  std_logic;
      rxrundisp_rec             : in  std_logic;
      rxdata_rec                : in  std_logic_vector(7 downto 0);

      -- Signals reclocked onto RXUSRCLK2.
      rxusrclk2                 : in  std_logic;
      rxreset                   : in  std_logic;
      rxchariscomma_usr         : out std_logic;
      rxcharisk_usr             : out std_logic;
      rxdisperr_usr             : out std_logic;
      rxnotintable_usr          : out std_logic;
      rxrundisp_usr             : out std_logic;
      rxclkcorcnt_usr           : out std_logic_vector(2 downto 0);
      rxbuferr                  : out std_logic;
      rxdata_usr                : out std_logic_vector(7 downto 0)
   );
  end component;
  
  component ROCKETIO_WRAPPER_GTP_TILE 
  generic
  (
    -- Simulation attributes
    TILE_SIM_GTPRESET_SPEEDUP    : integer   := 0; -- Set to 1 to speed up sim reset
    TILE_SIM_PLL_PERDIV2         : bit_vector:= x"190" -- Set to the VCO Unit Interval time
  );
  port
  (
    
    ------------------------ Loopback and Powerdown Ports ----------------------
    LOOPBACK0_IN                      : in   std_logic_vector(2 downto 0);
    LOOPBACK1_IN                      : in   std_logic_vector(2 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA0_OUT                : out  std_logic;
    RXCHARISCOMMA1_OUT                : out  std_logic;
    RXCHARISK0_OUT                    : out  std_logic;
    RXCHARISK1_OUT                    : out  std_logic;
    RXDISPERR0_OUT                    : out  std_logic;
    RXDISPERR1_OUT                    : out  std_logic;
    RXNOTINTABLE0_OUT                 : out  std_logic;
    RXNOTINTABLE1_OUT                 : out  std_logic;
    RXRUNDISP0_OUT                    : out  std_logic;
    RXRUNDISP1_OUT                    : out  std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT0_OUT                  : out  std_logic_vector(2 downto 0);
    RXCLKCORCNT1_OUT                  : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    RXBYTEREALIGN0_OUT                : out  std_logic;
    RXBYTEREALIGN1_OUT                : out  std_logic;
    RXCOMMADET0_OUT                   : out  std_logic;
    RXCOMMADET1_OUT                   : out  std_logic;
    RXENMCOMMAALIGN0_IN               : in   std_logic;
    RXENMCOMMAALIGN1_IN               : in   std_logic;
    RXENPCOMMAALIGN0_IN               : in   std_logic;
    RXENPCOMMAALIGN1_IN               : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    RXDATA0_OUT                       : out  std_logic_vector(7 downto 0);
    RXDATA1_OUT                       : out  std_logic_vector(7 downto 0);
    RXRECCLK0_OUT                     : out  std_logic;
    RXRECCLK1_OUT                     : out  std_logic;
    RXRESET0_IN                       : in   std_logic;
    RXRESET1_IN                       : in   std_logic;
    RXUSRCLK0_IN                      : in   std_logic;
    RXUSRCLK1_IN                      : in   std_logic;
    RXUSRCLK20_IN                     : in   std_logic;
    RXUSRCLK21_IN                     : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    RXELECIDLE0_OUT                   : out  std_logic;
    RXELECIDLE1_OUT                   : out  std_logic;
    RXN0_IN                           : in   std_logic;
    RXN1_IN                           : in   std_logic;
    RXP0_IN                           : in   std_logic;
    RXP1_IN                           : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    RXBUFRESET0_IN                    : in   std_logic;
    RXBUFRESET1_IN                    : in   std_logic;
    RXBUFSTATUS0_OUT                  : out  std_logic_vector(2 downto 0);
    RXBUFSTATUS1_OUT                  : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    RXLOSSOFSYNC0_OUT                 : out  std_logic_vector(1 downto 0);
    RXLOSSOFSYNC1_OUT                 : out  std_logic_vector(1 downto 0);
    --------------------- Shared Ports - Tile and PLL Ports --------------------
    CLKIN_IN                          : in   std_logic;
    GTPRESET_IN                       : in   std_logic;
    PLLLKDET_OUT                      : out  std_logic;
    REFCLKOUT_OUT                     : out  std_logic;
    RESETDONE0_OUT                    : out  std_logic;
    RESETDONE1_OUT                    : out  std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARDISPMODE0_IN                : in   std_logic;
    TXCHARDISPMODE1_IN                : in   std_logic;
    TXCHARDISPVAL0_IN                 : in   std_logic;
    TXCHARDISPVAL1_IN                 : in   std_logic;
    TXCHARISK0_IN                     : in   std_logic;
    TXCHARISK1_IN                     : in   std_logic;
    TXRUNDISP0_OUT                    : out  std_logic;
    TXRUNDISP1_OUT                    : out  std_logic;
    ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TXBUFSTATUS0_OUT                  : out  std_logic_vector(1 downto 0);
    TXBUFSTATUS1_OUT                  : out  std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    TXDATA0_IN                        : in   std_logic_vector(7 downto 0);
    TXDATA1_IN                        : in   std_logic_vector(7 downto 0);
    TXOUTCLK0_OUT                     : out  std_logic;
    TXOUTCLK1_OUT                     : out  std_logic;
    TXRESET0_IN                       : in   std_logic;
    TXRESET1_IN                       : in   std_logic;
    TXUSRCLK0_IN                      : in   std_logic;
    TXUSRCLK1_IN                      : in   std_logic;
    TXUSRCLK20_IN                     : in   std_logic;
    TXUSRCLK21_IN                     : in   std_logic;
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    TXN0_OUT                          : out  std_logic;
    TXN1_OUT                          : out  std_logic;
    TXP0_OUT                          : out  std_logic;
    TXP1_OUT                          : out  std_logic
  );
  end component;


  ----------------------------------------------------------------------
  -- Signal declarations for GTP
  ----------------------------------------------------------------------

   signal GND_BUS               : std_logic_vector (55 downto 0);
   signal PLLLOCK               : std_logic;

            
   signal RXNOTINTABLE_0_INT    : std_logic;   
   signal RXDATA_0_INT          : std_logic_vector (7 downto 0);
   signal RXCHARISK_0_INT       : std_logic;   
   signal RXDISPERR_0_INT       : std_logic;
   signal RXRUNDISP_0_INT       : std_logic;
         
   signal RXBUFSTATUS_float0    : std_logic_vector(1 downto 0);
   signal TXBUFSTATUS_float0    : std_logic;
   signal gt_txoutclk1_0        : std_logic;

   signal rxelecidle0_i         : std_logic;
   signal resetdone0_i          : std_logic;


   signal pma_reset_i   : std_logic;
   signal reset_r       : std_logic_vector(3 downto 0);
   signal refclk_out    : std_logic;
   attribute ASYNC_REG                        : string;
   attribute ASYNC_REG of reset_r             : signal is "TRUE";

begin

   GND_BUS(55 downto 0) <= (others => '0');

   ----------------------------------------------------------------------
   -- Wait for both PLL's to lock   
   ----------------------------------------------------------------------

   
   PLLLKDET_0        <=   PLLLOCK;


   ----------------------------------------------------------------------
   -- Wire internal signals to outputs   
   ----------------------------------------------------------------------

   RXNOTINTABLE_0  <=   RXNOTINTABLE_0_INT;
   RXDISPERR_0     <=   RXDISPERR_0_INT;
   TXOUTCLK_0      <=   gt_txoutclk1_0;

   RESETDONE_0          <= resetdone0_i;
   RXELECIDLE_0         <= rxelecidle0_i;

  
 

   REFCLKOUT <= refclk_out;

   --------------------------------------------------------------------
   -- RocketIO PMA reset circuitry
   --------------------------------------------------------------------
   process(PMARESET, refclk_out)
   begin
     if (PMARESET = '1') then
       reset_r <= "1111";
     elsif refclk_out'event and refclk_out = '1' then
       reset_r <= reset_r(2 downto 0) & PMARESET;
     end if;
   end process;
  
   pma_reset_i <= reset_r(3);

   ----------------------------------------------------------------------
   -- Instantiate the Virtex-5 GTP
   -- EMAC0 connects to GTP 0 and EMAC1 connects to GTP 1
   ----------------------------------------------------------------------

   -- Direct from the RocketIO Wizard output
   GTP_1000X : ROCKETIO_WRAPPER_GTP_TILE
    generic map (
        TILE_SIM_GTPRESET_SPEEDUP           => 1,
        TILE_SIM_PLL_PERDIV2                => x"190"
    )    
    port map (
        ------------------- Shared Ports - Tile and PLL Ports --------------------
        CLKIN_IN                 => CLK_DS,
        GTPRESET_IN              => pma_reset_i,
        PLLLKDET_OUT             => PLLLOCK,
        REFCLKOUT_OUT            => refclk_out,
        ---------------------- Loopback and Powerdown Ports ----------------------
	LOOPBACK0_IN(2 downto 1) => "00",
        LOOPBACK0_IN(0)          => LOOPBACK_0,
        --------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA0_OUT       => RXCHARISCOMMA_0,
        RXCHARISK0_OUT           => RXCHARISK_0_INT,
        RXDISPERR0_OUT           => RXDISPERR_0_INT,
        RXNOTINTABLE0_OUT        => RXNOTINTABLE_0_INT,
        RXRUNDISP0_OUT           => RXRUNDISP_0_INT,
        ----------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT0_OUT         => RXCLKCORCNT_0,
        ------------- Receive Ports - Comma Detection and Alignment --------------
        RXBYTEREALIGN0_OUT       => RXREALIGN_0,
        RXCOMMADET0_OUT          => RXCOMMADET_0,
        RXENMCOMMAALIGN0_IN      => ENMCOMMAALIGN_0,
        RXENPCOMMAALIGN0_IN      => ENPCOMMAALIGN_0,
        ----------------- Receive Ports - RX Data Path interface -----------------
        RXDATA0_OUT              => RXDATA_0_INT,
        RXRECCLK0_OUT            => open,
        RXRESET0_IN              => RXRESET_0,
        RXUSRCLK0_IN             => RXUSRCLK_0,
        RXUSRCLK20_IN            => RXUSRCLK_0,
        ------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        RXBUFSTATUS0_OUT(2)      => RXBUFERR_0,
        RXBUFSTATUS0_OUT(1 downto 0) => RXBUFSTATUS_float0,
        RXBUFRESET0_IN           => RXRESET_0,
        ----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXELECIDLE0_OUT          => rxelecidle0_i,
        RXN0_IN                  => RX1N_0,
        RXP0_IN                  => RX1P_0,       
        ------------- Receive Ports - RX Loss-of-sync State Machine --------------
        RXLOSSOFSYNC0_OUT        => open,
        ------------- ResetDone Ports --------------------------------------------
        RESETDONE0_OUT           => resetdone0_i,
        -------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TXCHARDISPMODE0_IN       => TXCHARDISPMODE_0,
        TXCHARDISPVAL0_IN        => TXCHARDISPVAL_0,
        TXCHARISK0_IN            => TXCHARISK_0,
        TXRUNDISP0_OUT           => TXRUNDISP_0,
        ----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        TXBUFSTATUS0_OUT(1)      => TXBUFERR_0, 
        TXBUFSTATUS0_OUT(0)      => TXBUFSTATUS_float0,
        ---------------- Transmit Ports - TX Data Path interface -----------------
        TXDATA0_IN               => TXDATA_0,
        TXOUTCLK0_OUT            => gt_txoutclk1_0,
        TXRESET0_IN              => TXRESET_0,
        TXUSRCLK0_IN             => TXUSRCLK_0,
        TXUSRCLK20_IN            => TXUSRCLK2_0,
        ------------- Transmit Ports - TX Driver and OOB signalling --------------
        TXN0_OUT                 => TX1N_0,
        TXP0_OUT                 => TX1P_0,
        LOOPBACK1_IN             => "000",
        RXCHARISCOMMA1_OUT       => open,
        RXCHARISK1_OUT           => open,
        RXDISPERR1_OUT           => open,
        RXNOTINTABLE1_OUT        => open,
        RXRUNDISP1_OUT           => open,
        RXCLKCORCNT1_OUT         => open,
        RXBYTEREALIGN1_OUT       => open,
        RXCOMMADET1_OUT          => open,
        RXENMCOMMAALIGN1_IN      => '0',
        RXENPCOMMAALIGN1_IN      => '0',
        RXDATA1_OUT              => open,
        RXRECCLK1_OUT            => open,
        RXRESET1_IN              => '0',
        RXUSRCLK1_IN             => '0',
        RXUSRCLK21_IN            => '0',
        RXBUFRESET1_IN           => '0',
        RXBUFSTATUS1_OUT         => open,
        RXELECIDLE1_OUT          => open,
        RXN1_IN                  => RX1N_1_UNUSED,
        RXP1_IN                  => RX1P_1_UNUSED,       
        RXLOSSOFSYNC1_OUT        => open,
        RESETDONE1_OUT           => open,
        TXCHARDISPMODE1_IN       => '0',
        TXCHARDISPVAL1_IN        => '0',
        TXCHARISK1_IN            => '0',
        TXRUNDISP1_OUT           => open,
        TXBUFSTATUS1_OUT         => open,
        TXDATA1_IN               => "00000000",
        TXOUTCLK1_OUT            => open,
        TXRESET1_IN              => '0',
        TXUSRCLK1_IN             => '0',
        TXUSRCLK21_IN            => '0',
        TXN1_OUT                 => TX1N_1_UNUSED,
        TXP1_OUT                 => TX1P_1_UNUSED	
   );

                       
   -------------------------------------------------------------------------------
   -- EMAC0 to GTP logic shim
   -------------------------------------------------------------------------------

   -- When the RXNOTINTABLE condition is detected, the Virtex5 RocketIO
   -- GTP outputs the raw 10B code in a bit swapped order to that of the
   -- Virtex-II Pro RocketIO.
   gen_rxdata0 : process (RXNOTINTABLE_0_INT, RXDISPERR_0_INT, RXCHARISK_0_INT, RXDATA_0_INT,
                         RXRUNDISP_0_INT)
   begin
      if RXNOTINTABLE_0_INT = '1' then
         RXDATA_0(0) <= RXDISPERR_0_INT;
         RXDATA_0(1) <= RXCHARISK_0_INT;
         RXDATA_0(2) <= RXDATA_0_INT(7);
         RXDATA_0(3) <= RXDATA_0_INT(6);
         RXDATA_0(4) <= RXDATA_0_INT(5);
         RXDATA_0(5) <= RXDATA_0_INT(4);
         RXDATA_0(6) <= RXDATA_0_INT(3);
         RXDATA_0(7) <= RXDATA_0_INT(2);
         RXRUNDISP_0 <= RXDATA_0_INT(1);
         RXCHARISK_0 <= RXDATA_0_INT(0);

      else
         RXDATA_0    <= RXDATA_0_INT;
         RXRUNDISP_0 <= RXRUNDISP_0_INT;
         RXCHARISK_0 <= RXCHARISK_0_INT;

      end if;
   end process gen_rxdata0;



end structural;
