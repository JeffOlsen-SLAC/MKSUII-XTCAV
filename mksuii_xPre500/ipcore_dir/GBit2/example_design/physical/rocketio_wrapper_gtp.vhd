-------------------------------------------------------------------------------
--$Date: 2009/12/17 21:16:09 $
--$RCSfile: rocketio_wrapper_gtp_vhdl_vhd.ejava,v $
--$Revision: 1.3 $
-------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 1.8 
--  \   \         Application : GTP Wizard 
--  /   /         Filename : rocketio_wrapper.vhd
-- /___/   /\     Timestamp : 02/08/2005 09:12:43
-- \   \  /  \ 
--  \___\/\___\ 
--
--
-- Module ROCKETIO_WRAPPER (a GTP Wrapper)
-- Generated by Xilinx GTP Wizard

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;


--***************************** Entity Declaration ****************************

entity ROCKETIO_WRAPPER_GTP is
generic
(
    -- Simulation attributes
    WRAPPER_SIM_GTPRESET_SPEEDUP    : integer   := 0; -- Set to 1 to speed up sim reset
    WRAPPER_SIM_PLL_PERDIV2         : bit_vector:= x"190" -- Set to the VCO Unit Interval time
);
port
(
    
    --_________________________________________________________________________
    --_________________________________________________________________________
    --TILE0  (Location)

    ------------------------ Loopback and Powerdown Ports ----------------------
    TILE0_LOOPBACK0_IN                      : in   std_logic_vector(2 downto 0);
    TILE0_LOOPBACK1_IN                      : in   std_logic_vector(2 downto 0);
    TILE0_RXPOWERDOWN0_IN                   : in   std_logic_vector(1 downto 0);
    TILE0_TXPOWERDOWN0_IN                   : in   std_logic_vector(1 downto 0);
    TILE0_RXPOWERDOWN1_IN                   : in   std_logic_vector(1 downto 0);
    TILE0_TXPOWERDOWN1_IN                   : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    TILE0_RXCHARISCOMMA0_OUT                : out  std_logic;
    TILE0_RXCHARISCOMMA1_OUT                : out  std_logic;
    TILE0_RXCHARISK0_OUT                    : out  std_logic;
    TILE0_RXCHARISK1_OUT                    : out  std_logic;
    TILE0_RXDISPERR0_OUT                    : out  std_logic;
    TILE0_RXDISPERR1_OUT                    : out  std_logic;
    TILE0_RXNOTINTABLE0_OUT                 : out  std_logic;
    TILE0_RXNOTINTABLE1_OUT                 : out  std_logic;
    TILE0_RXRUNDISP0_OUT                    : out  std_logic;
    TILE0_RXRUNDISP1_OUT                    : out  std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    TILE0_RXCLKCORCNT0_OUT                  : out  std_logic_vector(2 downto 0);
    TILE0_RXCLKCORCNT1_OUT                  : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    TILE0_RXENMCOMMAALIGN0_IN               : in   std_logic;
    TILE0_RXENMCOMMAALIGN1_IN               : in   std_logic;
    TILE0_RXENPCOMMAALIGN0_IN               : in   std_logic;
    TILE0_RXENPCOMMAALIGN1_IN               : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    TILE0_RXDATA0_OUT                       : out  std_logic_vector(7 downto 0);
    TILE0_RXDATA1_OUT                       : out  std_logic_vector(7 downto 0);
    TILE0_RXRECCLK0_OUT                     : out  std_logic;
    TILE0_RXRECCLK1_OUT                     : out  std_logic;
    TILE0_RXRESET0_IN                       : in   std_logic;
    TILE0_RXRESET1_IN                       : in   std_logic;
    TILE0_RXUSRCLK0_IN                      : in   std_logic;
    TILE0_RXUSRCLK1_IN                      : in   std_logic;
    TILE0_RXUSRCLK20_IN                     : in   std_logic;
    TILE0_RXUSRCLK21_IN                     : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    TILE0_RXELECIDLE0_OUT                   : out  std_logic;
    TILE0_RXELECIDLE1_OUT                   : out  std_logic;
    TILE0_RXN0_IN                           : in   std_logic;
    TILE0_RXN1_IN                           : in   std_logic;
    TILE0_RXP0_IN                           : in   std_logic;
    TILE0_RXP1_IN                           : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    TILE0_RXBUFRESET0_IN                    : in   std_logic;
    TILE0_RXBUFRESET1_IN                    : in   std_logic;
    TILE0_RXBUFSTATUS0_OUT                  : out  std_logic_vector(2 downto 0);
    TILE0_RXBUFSTATUS1_OUT                  : out  std_logic_vector(2 downto 0);
    --------------------- Shared Ports - Tile and PLL Ports --------------------
    TILE0_CLKIN_IN                          : in   std_logic;
    TILE0_GTPRESET_IN                       : in   std_logic;
    TILE0_PLLLKDET_OUT                      : out  std_logic;
    TILE0_REFCLKOUT_OUT                     : out  std_logic;
    TILE0_RESETDONE0_OUT                    : out  std_logic;
    TILE0_RESETDONE1_OUT                    : out  std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TILE0_TXCHARDISPMODE0_IN                : in   std_logic;
    TILE0_TXCHARDISPMODE1_IN                : in   std_logic;
    TILE0_TXCHARDISPVAL0_IN                 : in   std_logic;
    TILE0_TXCHARDISPVAL1_IN                 : in   std_logic;
    TILE0_TXCHARISK0_IN                     : in   std_logic;
    TILE0_TXCHARISK1_IN                     : in   std_logic;
    ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TILE0_TXBUFSTATUS0_OUT                  : out  std_logic_vector(1 downto 0);
    TILE0_TXBUFSTATUS1_OUT                  : out  std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    TILE0_TXDATA0_IN                        : in   std_logic_vector(7 downto 0);
    TILE0_TXDATA1_IN                        : in   std_logic_vector(7 downto 0);
    TILE0_TXOUTCLK0_OUT                     : out  std_logic;
    TILE0_TXOUTCLK1_OUT                     : out  std_logic;
    TILE0_TXRESET0_IN                       : in   std_logic;
    TILE0_TXRESET1_IN                       : in   std_logic;
    TILE0_TXUSRCLK0_IN                      : in   std_logic;
    TILE0_TXUSRCLK1_IN                      : in   std_logic;
    TILE0_TXUSRCLK20_IN                     : in   std_logic;
    TILE0_TXUSRCLK21_IN                     : in   std_logic;
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    TILE0_TXN0_OUT                          : out  std_logic;
    TILE0_TXN1_OUT                          : out  std_logic;
    TILE0_TXP0_OUT                          : out  std_logic;
    TILE0_TXP1_OUT                          : out  std_logic


);
end ROCKETIO_WRAPPER_GTP;

architecture RTL of ROCKETIO_WRAPPER_GTP is

--***************************** Signal Declarations *****************************

    -- Channel Bonding Signals
    signal  tile0_rxchbondo0_i   : std_logic_vector(2 downto 0);
    signal  tile0_rxchbondo1_i   : std_logic_vector(2 downto 0);


    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;
    



--*************************** Component Declarations **************************

component ROCKETIO_WRAPPER_GTP_TILE 
generic
(
    -- Simulation attributes
    TILE_SIM_GTPRESET_SPEEDUP    : integer   := 0; -- Set to 1 to speed up sim reset
    TILE_SIM_PLL_PERDIV2         : bit_vector:= x"190"; -- Set to the VCO Unit Interval time 

    -- Channel bonding attributes
    TILE_CHAN_BOND_MODE_0        : string    := "OFF";  -- "MASTER", "SLAVE", or "OFF"
    TILE_CHAN_BOND_LEVEL_0       : integer   := 0;     -- 0 to 7. See UG for details
    
    TILE_CHAN_BOND_MODE_1        : string    := "OFF";  -- "MASTER", "SLAVE", or "OFF"
    TILE_CHAN_BOND_LEVEL_1       : integer   := 0      -- 0 to 7. See UG for details
);
port 
(   
    ------------------------ Loopback and Powerdown Ports ----------------------
    LOOPBACK0_IN                            : in   std_logic_vector(2 downto 0);
    LOOPBACK1_IN                            : in   std_logic_vector(2 downto 0);
    RXPOWERDOWN0_IN                         : in   std_logic_vector(1 downto 0);
    TXPOWERDOWN0_IN                         : in   std_logic_vector(1 downto 0);
    RXPOWERDOWN1_IN                         : in   std_logic_vector(1 downto 0);    
    TXPOWERDOWN1_IN                         : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA0_OUT                      : out  std_logic;
    RXCHARISCOMMA1_OUT                      : out  std_logic;
    RXCHARISK0_OUT                          : out  std_logic;
    RXCHARISK1_OUT                          : out  std_logic;
    RXDISPERR0_OUT                          : out  std_logic;
    RXDISPERR1_OUT                          : out  std_logic;
    RXNOTINTABLE0_OUT                       : out  std_logic;
    RXNOTINTABLE1_OUT                       : out  std_logic;
    RXRUNDISP0_OUT                          : out  std_logic;
    RXRUNDISP1_OUT                          : out  std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT0_OUT                        : out  std_logic_vector(2 downto 0);
    RXCLKCORCNT1_OUT                        : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    RXENMCOMMAALIGN0_IN                     : in   std_logic;
    RXENMCOMMAALIGN1_IN                     : in   std_logic;
    RXENPCOMMAALIGN0_IN                     : in   std_logic;
    RXENPCOMMAALIGN1_IN                     : in   std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    RXDATA0_OUT                             : out  std_logic_vector(7 downto 0);
    RXDATA1_OUT                             : out  std_logic_vector(7 downto 0);
    RXRECCLK0_OUT                           : out  std_logic;
    RXRECCLK1_OUT                           : out  std_logic;
    RXRESET0_IN                             : in   std_logic;
    RXRESET1_IN                             : in   std_logic;
    RXUSRCLK0_IN                            : in   std_logic;
    RXUSRCLK1_IN                            : in   std_logic;
    RXUSRCLK20_IN                           : in   std_logic;
    RXUSRCLK21_IN                           : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    RXELECIDLE0_OUT                         : out  std_logic;
    RXELECIDLE1_OUT                         : out  std_logic;
    RXN0_IN                                 : in   std_logic;
    RXN1_IN                                 : in   std_logic;
    RXP0_IN                                 : in   std_logic;
    RXP1_IN                                 : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    RXBUFRESET0_IN                          : in   std_logic;
    RXBUFRESET1_IN                          : in   std_logic;
    RXBUFSTATUS0_OUT                        : out  std_logic_vector(2 downto 0);
    RXBUFSTATUS1_OUT                        : out  std_logic_vector(2 downto 0);
    --------------------- Shared Ports - Tile and PLL Ports --------------------
    CLKIN_IN                                : in   std_logic;
    GTPRESET_IN                             : in   std_logic;
    PLLLKDET_OUT                            : out  std_logic;
    REFCLKOUT_OUT                           : out  std_logic;
    RESETDONE0_OUT                          : out  std_logic;
    RESETDONE1_OUT                          : out  std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARDISPMODE0_IN                      : in   std_logic;
    TXCHARDISPMODE1_IN                      : in   std_logic;
    TXCHARDISPVAL0_IN                       : in   std_logic;
    TXCHARDISPVAL1_IN                       : in   std_logic;
    TXCHARISK0_IN                           : in   std_logic;
    TXCHARISK1_IN                           : in   std_logic;
    ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TXBUFSTATUS0_OUT                        : out  std_logic_vector(1 downto 0);
    TXBUFSTATUS1_OUT                        : out  std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    TXDATA0_IN                              : in   std_logic_vector(7 downto 0);
    TXDATA1_IN                              : in   std_logic_vector(7 downto 0);
    TXOUTCLK0_OUT                           : out  std_logic;
    TXOUTCLK1_OUT                           : out  std_logic;
    TXRESET0_IN                             : in   std_logic;
    TXRESET1_IN                             : in   std_logic;
    TXUSRCLK0_IN                            : in   std_logic;
    TXUSRCLK1_IN                            : in   std_logic;
    TXUSRCLK20_IN                           : in   std_logic;
    TXUSRCLK21_IN                           : in   std_logic;
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    TXN0_OUT                                : out  std_logic;
    TXN1_OUT                                : out  std_logic;
    TXP0_OUT                                : out  std_logic;
    TXP1_OUT                                : out  std_logic


);
end component;



--********************************* Main Body of Code**************************

begin                       

    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';

    --------------------------- Tile Instances  -------------------------------   


    --_________________________________________________________________________
    --_________________________________________________________________________
    --TILE0  (Location)

    tile0_rocketio_wrapper_i : ROCKETIO_WRAPPER_GTP_TILE
    generic map
    (
        -- Simulation attributes
        TILE_SIM_GTPRESET_SPEEDUP    => WRAPPER_SIM_GTPRESET_SPEEDUP,
        TILE_SIM_PLL_PERDIV2         => WRAPPER_SIM_PLL_PERDIV2,

        -- Channel bonding attributes
        TILE_CHAN_BOND_MODE_0        => "OFF",
        TILE_CHAN_BOND_LEVEL_0       => 0,
    
        TILE_CHAN_BOND_MODE_1        => "OFF",
        TILE_CHAN_BOND_LEVEL_1       => 0
    )
    port map
    (
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK0_IN                    =>      TILE0_LOOPBACK0_IN,
        LOOPBACK1_IN                    =>      TILE0_LOOPBACK1_IN,
        RXPOWERDOWN0_IN                 =>      TILE0_RXPOWERDOWN0_IN,
        TXPOWERDOWN0_IN                 =>      TILE0_TXPOWERDOWN0_IN,
        RXPOWERDOWN1_IN                 =>      TILE0_RXPOWERDOWN1_IN,
        TXPOWERDOWN1_IN                 =>      TILE0_TXPOWERDOWN1_IN,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA0_OUT              =>      TILE0_RXCHARISCOMMA0_OUT,
        RXCHARISCOMMA1_OUT              =>      TILE0_RXCHARISCOMMA1_OUT,
        RXCHARISK0_OUT                  =>      TILE0_RXCHARISK0_OUT,
        RXCHARISK1_OUT                  =>      TILE0_RXCHARISK1_OUT,
        RXDISPERR0_OUT                  =>      TILE0_RXDISPERR0_OUT,
        RXDISPERR1_OUT                  =>      TILE0_RXDISPERR1_OUT,
        RXNOTINTABLE0_OUT               =>      TILE0_RXNOTINTABLE0_OUT,
        RXNOTINTABLE1_OUT               =>      TILE0_RXNOTINTABLE1_OUT,
        RXRUNDISP0_OUT                  =>      TILE0_RXRUNDISP0_OUT,
        RXRUNDISP1_OUT                  =>      TILE0_RXRUNDISP1_OUT,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT0_OUT                =>      TILE0_RXCLKCORCNT0_OUT,
        RXCLKCORCNT1_OUT                =>      TILE0_RXCLKCORCNT1_OUT,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        RXENMCOMMAALIGN0_IN             =>      TILE0_RXENMCOMMAALIGN0_IN,
        RXENMCOMMAALIGN1_IN             =>      TILE0_RXENMCOMMAALIGN1_IN,
        RXENPCOMMAALIGN0_IN             =>      TILE0_RXENPCOMMAALIGN0_IN,
        RXENPCOMMAALIGN1_IN             =>      TILE0_RXENPCOMMAALIGN1_IN,
        ------------------- Receive Ports - RX Data Path interface -----------------
        RXDATA0_OUT                     =>      TILE0_RXDATA0_OUT,
        RXDATA1_OUT                     =>      TILE0_RXDATA1_OUT,
        RXRECCLK0_OUT                   =>      TILE0_RXRECCLK0_OUT,
        RXRECCLK1_OUT                   =>      TILE0_RXRECCLK1_OUT,
        RXRESET0_IN                     =>      TILE0_RXRESET0_IN,
        RXRESET1_IN                     =>      TILE0_RXRESET1_IN,
        RXUSRCLK0_IN                    =>      TILE0_RXUSRCLK0_IN,
        RXUSRCLK1_IN                    =>      TILE0_RXUSRCLK1_IN,
        RXUSRCLK20_IN                   =>      TILE0_RXUSRCLK20_IN,
        RXUSRCLK21_IN                   =>      TILE0_RXUSRCLK21_IN,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXELECIDLE0_OUT                 =>      TILE0_RXELECIDLE0_OUT,
        RXELECIDLE1_OUT                 =>      TILE0_RXELECIDLE1_OUT,
        RXN0_IN                         =>      TILE0_RXN0_IN,
        RXN1_IN                         =>      TILE0_RXN1_IN,
        RXP0_IN                         =>      TILE0_RXP0_IN,
        RXP1_IN                         =>      TILE0_RXP1_IN,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        RXBUFRESET0_IN                  =>      TILE0_RXBUFRESET0_IN,
        RXBUFRESET1_IN                  =>      TILE0_RXBUFRESET1_IN,
        RXBUFSTATUS0_OUT                =>      TILE0_RXBUFSTATUS0_OUT,
        RXBUFSTATUS1_OUT                =>      TILE0_RXBUFSTATUS1_OUT,
        --------------------- Shared Ports - Tile and PLL Ports --------------------
        CLKIN_IN                        =>      TILE0_CLKIN_IN,
        GTPRESET_IN                     =>      TILE0_GTPRESET_IN,
        PLLLKDET_OUT                    =>      TILE0_PLLLKDET_OUT,
        REFCLKOUT_OUT                   =>      TILE0_REFCLKOUT_OUT,
        RESETDONE0_OUT                  =>      TILE0_RESETDONE0_OUT,
        RESETDONE1_OUT                  =>      TILE0_RESETDONE1_OUT,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TXCHARDISPMODE0_IN              =>      TILE0_TXCHARDISPMODE0_IN,
        TXCHARDISPMODE1_IN              =>      TILE0_TXCHARDISPMODE1_IN,
        TXCHARDISPVAL0_IN               =>      TILE0_TXCHARDISPVAL0_IN,
        TXCHARDISPVAL1_IN               =>      TILE0_TXCHARDISPVAL1_IN,
        TXCHARISK0_IN                   =>      TILE0_TXCHARISK0_IN,
        TXCHARISK1_IN                   =>      TILE0_TXCHARISK1_IN,
        ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
        TXBUFSTATUS0_OUT                =>      TILE0_TXBUFSTATUS0_OUT,
        TXBUFSTATUS1_OUT                =>      TILE0_TXBUFSTATUS1_OUT,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TXDATA0_IN                      =>      TILE0_TXDATA0_IN,
        TXDATA1_IN                      =>      TILE0_TXDATA1_IN,
        TXOUTCLK0_OUT                   =>      TILE0_TXOUTCLK0_OUT,
        TXOUTCLK1_OUT                   =>      TILE0_TXOUTCLK1_OUT,
        TXRESET0_IN                     =>      TILE0_TXRESET0_IN,
        TXRESET1_IN                     =>      TILE0_TXRESET1_IN,
        TXUSRCLK0_IN                    =>      TILE0_TXUSRCLK0_IN,
        TXUSRCLK1_IN                    =>      TILE0_TXUSRCLK1_IN,
        TXUSRCLK20_IN                   =>      TILE0_TXUSRCLK20_IN,
        TXUSRCLK21_IN                   =>      TILE0_TXUSRCLK21_IN,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TXN0_OUT                        =>      TILE0_TXN0_OUT,
        TXN1_OUT                        =>      TILE0_TXN1_OUT,
        TXP0_OUT                        =>      TILE0_TXP0_OUT,
        TXP1_OUT                        =>      TILE0_TXP1_OUT

    );

    
     
end RTL;
