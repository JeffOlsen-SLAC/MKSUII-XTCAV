------------------------------------------------------------------------------
--$Date: 2009/12/17 21:16:09 $
--$RCSfile: rocketio_wrapper_gtp_vhdl_tile_vhd.ejava,v $
--$Revision: 1.3 $
-------------------------------------------------------------------------------
--   __  __ 
--  /   /\/   / 
-- /__/  \   /    Vendor: Xilinx 
-- \   \   \/     Version : 1.9
--  \   \         Application : GTP Wizard 
--  /   /         Filename : rocketio_wrapper_gtp_vhdl_tile.vhd
-- /__/   /\      Timestamp : 02/08/2005 09:12:43
-- \   \  /  \ 
--  \__\/\__\ 
--
--
-- Module ROCKETIO_WRAPPER_GTP_VHDL_TILE (a GTP Tile Wrapper)
-- Generated by Xilinx GTP Wizard

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

--***************************** Entity Declaration ****************************

entity ROCKETIO_WRAPPER_GTP_TILE is
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
end ROCKETIO_WRAPPER_GTP_TILE;

architecture RTL of ROCKETIO_WRAPPER_GTP_TILE is
    
--**************************** Signal Declarations ****************************

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;
    signal  tied_to_vcc_vec_i               :   std_logic_vector(63 downto 0);

   

    -- RX Datapath signals
    signal rxdata0_i                        :   std_logic_vector(15 downto 0);      
    signal rxchariscomma0_float_i           :   std_logic;
    signal rxcharisk0_float_i               :   std_logic;
    signal rxdisperr0_float_i               :   std_logic;
    signal rxnotintable0_float_i            :   std_logic;
    signal rxrundisp0_float_i               :   std_logic;

    -- TX Datapath signals
    signal txdata0_i                        :   std_logic_vector(15 downto 0);

    -- Electrical idle reset logic signals
    signal loopback0_i                      :   std_logic_vector(2 downto 0);
    signal rxelecidle0_i                    :   std_logic;
    signal resetdone0_i                     :   std_logic;
   

    -- RX Datapath signals
    signal rxdata1_i                        :   std_logic_vector(15 downto 0);      
    signal rxchariscomma1_float_i           :   std_logic;
    signal rxcharisk1_float_i               :   std_logic;
    signal rxdisperr1_float_i               :   std_logic;
    signal rxnotintable1_float_i            :   std_logic;
    signal rxrundisp1_float_i               :   std_logic;

    -- TX Datapath signals
    signal txdata1_i                        :   std_logic_vector(15 downto 0);

    -- Electrical idle reset logic signals
    signal loopback1_i                      :   std_logic_vector(2 downto 0);
    signal rxelecidle1_i                    :   std_logic;
    signal resetdone1_i                     :   std_logic;


--******************************** Main Body of Code***************************
                       
begin                      

    ---------------------------  Static signal Assignments ---------------------   

    tied_to_ground_i                    <= '0';
    tied_to_ground_vec_i(63 downto 0)   <= (others => '0');
    tied_to_vcc_i                       <= '1';
    tied_to_vcc_vec_i(63 downto 0)      <= (others => '1');
     
    

    -------------------  GTP Datapath byte mapping  -----------------    
    
    RXDATA0_OUT    <=   rxdata0_i(7 downto 0);
    
    txdata0_i    <=   (tied_to_ground_vec_i(7 downto 0) & TXDATA0_IN);    
    
    RXDATA1_OUT    <=   rxdata1_i(7 downto 0);
    
    txdata1_i    <=   (tied_to_ground_vec_i(7 downto 0) & TXDATA1_IN);    




    ---------------------------  Electrical Idle Reset Circuit  ---------------
    
    RXELECIDLE0_OUT            <=   rxelecidle0_i;
    RESETDONE0_OUT             <=   resetdone0_i;
    loopback0_i                <=   LOOPBACK0_IN;
    RXELECIDLE1_OUT            <=   rxelecidle1_i;
    RESETDONE1_OUT             <=   resetdone1_i;
    loopback1_i                <=   LOOPBACK1_IN;
    

    ----------------------------- GTP_DUAL Instance  --------------------------   

    gtp_dual_i:GTP_DUAL
    generic map
    (

        --_______________________ Simulation-Only Attributes ___________________
        SIM_RECEIVER_DETECT_PASS0   =>       TRUE,
        SIM_RECEIVER_DETECT_PASS1   =>       TRUE,
        SIM_GTPRESET_SPEEDUP        =>       TILE_SIM_GTPRESET_SPEEDUP,
        SIM_PLL_PERDIV2             =>       TILE_SIM_PLL_PERDIV2,
        SIM_MODE                    =>       "FAST",

        --___________________________ Shared Attributes ________________________

        -------------------------- Tile and PLL Attributes ---------------------

        CLK25_DIVIDER               =>       5, 
        CLKINDC_B                   =>       TRUE,
        OOB_CLK_DIVIDER             =>       4,
        OVERSAMPLE_MODE             =>       FALSE,
        PLL_DIVSEL_FB               =>       2,
        PLL_DIVSEL_REF              =>       1,
        PLL_TXDIVSEL_COMM_OUT       =>       1,
        TX_SYNC_FILTERB             =>       1,   


        --____________________ Transmit Interface Attributes ___________________

        ------------------- TX Buffering and Phase Alignment -------------------   

        TX_BUFFER_USE_0             =>       TRUE,
        TX_XCLK_SEL_0               =>       "TXOUT",
        TXRX_INVERT_0               =>       "00000",        

        TX_BUFFER_USE_1             =>       TRUE,
        TX_XCLK_SEL_1               =>       "TXOUT",
        TXRX_INVERT_1               =>       "00000",        

        --------------------- TX Serial Line Rate settings ---------------------   

        PLL_TXDIVSEL_OUT_0          =>       2,

        PLL_TXDIVSEL_OUT_1          =>       2,

        --------------------- TX Driver and OOB signalling --------------------  

        TX_DIFF_BOOST_0             =>       TRUE,

        TX_DIFF_BOOST_1             =>       TRUE,

        ------------------ TX Pipe Control for PCI Express/SATA ---------------

        COM_BURST_VAL_0             =>       "1111",

        COM_BURST_VAL_1             =>       "1111",
        --_______________________ Receive Interface Attributes ________________

        ------------ RX Driver,OOB signalling,Coupling and Eq,CDR -------------  

        AC_CAP_DIS_0                =>       TRUE,
        OOBDETECT_THRESHOLD_0       =>       "001",
        PMA_CDR_SCAN_0              =>       x"6c07640",
        PMA_RX_CFG_0                =>       x"09f0088",
        RCV_TERM_GND_0              =>       FALSE,
        RCV_TERM_MID_0              =>       FALSE,
        RCV_TERM_VTTRX_0            =>       FALSE,
        TERMINATION_IMP_0           =>       50,

        AC_CAP_DIS_1                =>       TRUE,
        OOBDETECT_THRESHOLD_1       =>       "001",
        PMA_CDR_SCAN_1              =>       x"6c07640",
        PMA_RX_CFG_1                =>       x"09f0088",  
        RCV_TERM_GND_1              =>       FALSE,
        RCV_TERM_MID_1              =>       FALSE,
        RCV_TERM_VTTRX_1            =>       FALSE,
        TERMINATION_IMP_1           =>       50,

        PCS_COM_CFG                 =>       x"1680a0e",
        TERMINATION_CTRL            =>       "10100",
        TERMINATION_OVRD            =>       FALSE,

        --------------------- RX Serial Line Rate Attributes ------------------   

        PLL_RXDIVSEL_OUT_0          =>       2,
        PLL_SATA_0                  =>       FALSE,

        PLL_RXDIVSEL_OUT_1          =>       2,
        PLL_SATA_1                  =>       FALSE,

        ----------------------- PRBS Detection Attributes ---------------------  

        PRBS_ERR_THRESHOLD_0        =>       x"00000001",

        PRBS_ERR_THRESHOLD_1        =>       x"00000001",

        ---------------- Comma Detection and Alignment Attributes -------------  

        ALIGN_COMMA_WORD_0          =>       1,
        COMMA_10B_ENABLE_0          =>       "0001111111",
        COMMA_DOUBLE_0              =>       FALSE,
        DEC_MCOMMA_DETECT_0         =>       TRUE,
        DEC_PCOMMA_DETECT_0         =>       TRUE,
        DEC_VALID_COMMA_ONLY_0      =>       FALSE,
        MCOMMA_10B_VALUE_0          =>       "1010000011",
        MCOMMA_DETECT_0             =>       TRUE,
        PCOMMA_10B_VALUE_0          =>       "0101111100",
        PCOMMA_DETECT_0             =>       TRUE,
        RX_SLIDE_MODE_0             =>       "PCS",

        ALIGN_COMMA_WORD_1          =>       1,
        COMMA_10B_ENABLE_1          =>       "0001111111",
        COMMA_DOUBLE_1              =>       FALSE,
        DEC_MCOMMA_DETECT_1         =>       TRUE,
        DEC_PCOMMA_DETECT_1         =>       TRUE,
        DEC_VALID_COMMA_ONLY_1      =>       FALSE,
        MCOMMA_10B_VALUE_1          =>       "1010000011",
        MCOMMA_DETECT_1             =>       TRUE,
        PCOMMA_10B_VALUE_1          =>       "0101111100",
        PCOMMA_DETECT_1             =>       TRUE,
        RX_SLIDE_MODE_1             =>       "PCS",

        ------------------ RX Loss-of-sync State Machine Attributes -----------  

        RX_LOSS_OF_SYNC_FSM_0       =>       FALSE,
        RX_LOS_INVALID_INCR_0       =>       8,
        RX_LOS_THRESHOLD_0          =>       128,

        RX_LOSS_OF_SYNC_FSM_1       =>       FALSE,
        RX_LOS_INVALID_INCR_1       =>       8,
        RX_LOS_THRESHOLD_1          =>       128,

        -------------- RX Elastic Buffer and Phase alignment Attributes -------   

        RX_BUFFER_USE_0             =>       TRUE,
        RX_XCLK_SEL_0               =>       "RXREC",

        RX_BUFFER_USE_1             =>       TRUE,
        RX_XCLK_SEL_1               =>       "RXREC",                   

        ------------------------ Clock Correction Attributes ------------------   

        CLK_CORRECT_USE_0           =>       TRUE,
        CLK_COR_ADJ_LEN_0           =>       2,
        CLK_COR_DET_LEN_0           =>       2,
        CLK_COR_INSERT_IDLE_FLAG_0  =>       FALSE,
        CLK_COR_KEEP_IDLE_0         =>       FALSE,
        CLK_COR_MAX_LAT_0           =>       18,
        CLK_COR_MIN_LAT_0           =>       16,
        CLK_COR_PRECEDENCE_0        =>       TRUE,
        CLK_COR_REPEAT_WAIT_0       =>       0,
        CLK_COR_SEQ_1_1_0           =>       "0110111100",
        CLK_COR_SEQ_1_2_0           =>       "0001010000",
        CLK_COR_SEQ_1_3_0           =>       "0000000000",
        CLK_COR_SEQ_1_4_0           =>       "0000000000",
        CLK_COR_SEQ_1_ENABLE_0      =>       "0011",
        CLK_COR_SEQ_2_1_0           =>       "0110111100",
        CLK_COR_SEQ_2_2_0           =>       "0010110101",
        CLK_COR_SEQ_2_3_0           =>       "0000000000",
        CLK_COR_SEQ_2_4_0           =>       "0000000000",
        CLK_COR_SEQ_2_ENABLE_0      =>       "0011",
        CLK_COR_SEQ_2_USE_0         =>       TRUE,
        RX_DECODE_SEQ_MATCH_0       =>       TRUE,

        CLK_CORRECT_USE_1           =>       TRUE,
        CLK_COR_ADJ_LEN_1           =>       2,
        CLK_COR_DET_LEN_1           =>       2,
        CLK_COR_INSERT_IDLE_FLAG_1  =>       FALSE,
        CLK_COR_KEEP_IDLE_1         =>       FALSE,
        CLK_COR_MAX_LAT_1           =>       18,
        CLK_COR_MIN_LAT_1           =>       16,
        CLK_COR_PRECEDENCE_1        =>       TRUE,
        CLK_COR_REPEAT_WAIT_1       =>       0,
        CLK_COR_SEQ_1_1_1           =>       "0110111100",
        CLK_COR_SEQ_1_2_1           =>       "0001010000",
        CLK_COR_SEQ_1_3_1           =>       "0000000000",
        CLK_COR_SEQ_1_4_1           =>       "0000000000",
        CLK_COR_SEQ_1_ENABLE_1      =>       "0011",
        CLK_COR_SEQ_2_1_1           =>       "0110111100",
        CLK_COR_SEQ_2_2_1           =>       "0010110101",
        CLK_COR_SEQ_2_3_1           =>       "0000000000",
        CLK_COR_SEQ_2_4_1           =>       "0000000000",
        CLK_COR_SEQ_2_ENABLE_1      =>       "0011",
        CLK_COR_SEQ_2_USE_1         =>       TRUE,
        RX_DECODE_SEQ_MATCH_1       =>       TRUE,

        ------------------------ Channel Bonding Attributes -------------------   

        CHAN_BOND_1_MAX_SKEW_0      =>       7,
        CHAN_BOND_2_MAX_SKEW_0      =>       7,
        CHAN_BOND_LEVEL_0           =>       TILE_CHAN_BOND_LEVEL_0,
        CHAN_BOND_MODE_0            =>       TILE_CHAN_BOND_MODE_0,
        CHAN_BOND_SEQ_1_1_0         =>       "0000000000",
        CHAN_BOND_SEQ_1_2_0         =>       "0000000000",
        CHAN_BOND_SEQ_1_3_0         =>       "0000000000",
        CHAN_BOND_SEQ_1_4_0         =>       "0000000000",
        CHAN_BOND_SEQ_1_ENABLE_0    =>       "0000",
        CHAN_BOND_SEQ_2_1_0         =>       "0000000000",
        CHAN_BOND_SEQ_2_2_0         =>       "0000000000",
        CHAN_BOND_SEQ_2_3_0         =>       "0000000000",
        CHAN_BOND_SEQ_2_4_0         =>       "0000000000",
        CHAN_BOND_SEQ_2_ENABLE_0    =>       "0000",
        CHAN_BOND_SEQ_2_USE_0       =>       FALSE,  
        CHAN_BOND_SEQ_LEN_0         =>       1,
        PCI_EXPRESS_MODE_0          =>       FALSE,   
     
        CHAN_BOND_1_MAX_SKEW_1      =>       7,
        CHAN_BOND_2_MAX_SKEW_1      =>       7,
        CHAN_BOND_LEVEL_1           =>       TILE_CHAN_BOND_LEVEL_1,
        CHAN_BOND_MODE_1            =>       TILE_CHAN_BOND_MODE_1,
        CHAN_BOND_SEQ_1_1_1         =>       "0000000000",
        CHAN_BOND_SEQ_1_2_1         =>       "0000000000",
        CHAN_BOND_SEQ_1_3_1         =>       "0000000000",
        CHAN_BOND_SEQ_1_4_1         =>       "0000000000",
        CHAN_BOND_SEQ_1_ENABLE_1    =>       "0000",
        CHAN_BOND_SEQ_2_1_1         =>       "0000000000",
        CHAN_BOND_SEQ_2_2_1         =>       "0000000000",
        CHAN_BOND_SEQ_2_3_1         =>       "0000000000",
        CHAN_BOND_SEQ_2_4_1         =>       "0000000000",
        CHAN_BOND_SEQ_2_ENABLE_1    =>       "0000",
        CHAN_BOND_SEQ_2_USE_1       =>       FALSE,  
        CHAN_BOND_SEQ_LEN_1         =>       1,
        PCI_EXPRESS_MODE_1          =>       FALSE,

        ------------------ RX Attributes for PCI Express/SATA ---------------

        RX_STATUS_FMT_0             =>       "PCIE",
        SATA_BURST_VAL_0            =>       "100",
        SATA_IDLE_VAL_0             =>       "100",
        SATA_MAX_BURST_0            =>       9,
        SATA_MAX_INIT_0             =>       27,
        SATA_MAX_WAKE_0             =>       9,
        SATA_MIN_BURST_0            =>       5,
        SATA_MIN_INIT_0             =>       15,
        SATA_MIN_WAKE_0             =>       5,
        TRANS_TIME_FROM_P2_0        =>       x"0060",
        TRANS_TIME_NON_P2_0         =>       x"0025",
        TRANS_TIME_TO_P2_0          =>       x"0100",

        RX_STATUS_FMT_1             =>       "PCIE",
        SATA_BURST_VAL_1            =>       "100",
        SATA_IDLE_VAL_1             =>       "100",
        SATA_MAX_BURST_1            =>       9,
        SATA_MAX_INIT_1             =>       27,
        SATA_MAX_WAKE_1             =>       9,
        SATA_MIN_BURST_1            =>       5,
        SATA_MIN_INIT_1             =>       15,
        SATA_MIN_WAKE_1             =>       5,
        TRANS_TIME_FROM_P2_1        =>       x"0060",
        TRANS_TIME_NON_P2_1         =>       x"0025",
        TRANS_TIME_TO_P2_1          =>       x"0100"
    ) 
    port map 
    (
        ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK0                       =>      loopback0_i,
        LOOPBACK1                       =>      loopback1_i,
        RXPOWERDOWN0                    =>      RXPOWERDOWN0_IN,
        RXPOWERDOWN1                    =>      RXPOWERDOWN1_IN,
        TXPOWERDOWN0                    =>      TXPOWERDOWN0_IN,
        TXPOWERDOWN1                    =>      TXPOWERDOWN1_IN,
        ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISCOMMA0(1)               =>      rxchariscomma0_float_i,
        RXCHARISCOMMA0(0)               =>      RXCHARISCOMMA0_OUT,
        RXCHARISCOMMA1(1)               =>      rxchariscomma1_float_i,
        RXCHARISCOMMA1(0)               =>      RXCHARISCOMMA1_OUT,
        RXCHARISK0(1)                   =>      rxcharisk0_float_i,
        RXCHARISK0(0)                   =>      RXCHARISK0_OUT,
        RXCHARISK1(1)                   =>      rxcharisk1_float_i,
        RXCHARISK1(0)                   =>      RXCHARISK1_OUT,
        RXDEC8B10BUSE0                  =>      tied_to_vcc_i,
        RXDEC8B10BUSE1                  =>      tied_to_vcc_i,
        RXDISPERR0(1)                   =>      rxdisperr0_float_i,
        RXDISPERR0(0)                   =>      RXDISPERR0_OUT,
        RXDISPERR1(1)                   =>      rxdisperr1_float_i,
        RXDISPERR1(0)                   =>      RXDISPERR1_OUT,
        RXNOTINTABLE0(1)                =>      rxnotintable0_float_i,
        RXNOTINTABLE0(0)                =>      RXNOTINTABLE0_OUT,
        RXNOTINTABLE1(1)                =>      rxnotintable1_float_i,
        RXNOTINTABLE1(0)                =>      RXNOTINTABLE1_OUT,
        RXRUNDISP0(1)                   =>      rxrundisp0_float_i,
        RXRUNDISP0(0)                   =>      RXRUNDISP0_OUT,
        RXRUNDISP1(1)                   =>      rxrundisp1_float_i,
        RXRUNDISP1(0)                   =>      RXRUNDISP1_OUT,
        ------------------- Receive Ports - Channel Bonding Ports ------------------
        RXCHANBONDSEQ0                  =>      open,
        RXCHANBONDSEQ1                  =>      open,
        RXCHBONDI0                      =>      tied_to_ground_vec_i(2 downto 0),
        RXCHBONDI1                      =>      tied_to_ground_vec_i(2 downto 0),
        RXCHBONDO0                      =>      open,
        RXCHBONDO1                      =>      open,
        RXENCHANSYNC0                   =>      tied_to_ground_i,
        RXENCHANSYNC1                   =>      tied_to_ground_i,
        ------------------- Receive Ports - Clock Correction Ports -----------------
        RXCLKCORCNT0                    =>      RXCLKCORCNT0_OUT,
        RXCLKCORCNT1                    =>      RXCLKCORCNT1_OUT,
        --------------- Receive Ports - Comma Detection and Alignment --------------
        RXBYTEISALIGNED0                =>      open,
        RXBYTEISALIGNED1                =>      open,
        RXBYTEREALIGN0                  =>      open,
        RXBYTEREALIGN1                  =>      open,
        RXCOMMADET0                     =>      open,
        RXCOMMADET1                     =>      open,
        RXCOMMADETUSE0                  =>      tied_to_vcc_i,
        RXCOMMADETUSE1                  =>      tied_to_vcc_i,
        RXENMCOMMAALIGN0                =>      RXENMCOMMAALIGN0_IN,
        RXENMCOMMAALIGN1                =>      RXENMCOMMAALIGN1_IN,
        RXENPCOMMAALIGN0                =>      RXENPCOMMAALIGN0_IN,
        RXENPCOMMAALIGN1                =>      RXENPCOMMAALIGN1_IN,
        RXSLIDE0                        =>      tied_to_ground_i,
        RXSLIDE1                        =>      tied_to_ground_i,
        ----------------------- Receive Ports - PRBS Detection ---------------------
        PRBSCNTRESET0                   =>      tied_to_ground_i,
        PRBSCNTRESET1                   =>      tied_to_ground_i,
        RXENPRBSTST0                    =>      tied_to_ground_vec_i(1 downto 0),
        RXENPRBSTST1                    =>      tied_to_ground_vec_i(1 downto 0),
        RXPRBSERR0                      =>      open,
        RXPRBSERR1                      =>      open,
        ------------------- Receive Ports - RX Data Path interface -----------------
        RXDATA0                         =>      rxdata0_i,
        RXDATA1                         =>      rxdata1_i,
        RXDATAWIDTH0                    =>      tied_to_ground_i,
        RXDATAWIDTH1                    =>      tied_to_ground_i,
        RXRECCLK0                       =>      RXRECCLK0_OUT,
        RXRECCLK1                       =>      RXRECCLK1_OUT,
        RXRESET0                        =>      RXRESET0_IN,
        RXRESET1                        =>      RXRESET1_IN,
        RXUSRCLK0                       =>      RXUSRCLK0_IN,
        RXUSRCLK1                       =>      RXUSRCLK1_IN,
        RXUSRCLK20                      =>      RXUSRCLK20_IN,
        RXUSRCLK21                      =>      RXUSRCLK21_IN,
        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXCDRRESET0                     =>      tied_to_ground_i,
        RXCDRRESET1                     =>      tied_to_ground_i,
        RXELECIDLE0                     =>      rxelecidle0_i,
        RXELECIDLE1                     =>      rxelecidle1_i,
        RXELECIDLERESET0                =>      tied_to_ground_i,
        RXELECIDLERESET1                =>      tied_to_ground_i,
        RXENEQB0                        =>      tied_to_vcc_i,
        RXENEQB1                        =>      tied_to_vcc_i,
        RXEQMIX0                        =>      tied_to_ground_vec_i(1 downto 0),
        RXEQMIX1                        =>      tied_to_ground_vec_i(1 downto 0),
        RXEQPOLE0                       =>      tied_to_ground_vec_i(3 downto 0),
        RXEQPOLE1                       =>      tied_to_ground_vec_i(3 downto 0),
        RXN0                            =>      RXN0_IN,
        RXN1                            =>      RXN1_IN,
        RXP0                            =>      RXP0_IN,
        RXP1                            =>      RXP1_IN,
        -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        RXBUFRESET0                     =>      RXBUFRESET0_IN,
        RXBUFRESET1                     =>      RXBUFRESET1_IN,
        RXBUFSTATUS0                    =>      RXBUFSTATUS0_OUT,
        RXBUFSTATUS1                    =>      RXBUFSTATUS1_OUT,
        RXCHANISALIGNED0                =>      open,
        RXCHANISALIGNED1                =>      open,
        RXCHANREALIGN0                  =>      open,
        RXCHANREALIGN1                  =>      open,
        RXPMASETPHASE0                  =>      tied_to_ground_i,
        RXPMASETPHASE1                  =>      tied_to_ground_i,
        RXSTATUS0                       =>      open,
        RXSTATUS1                       =>      open,
        --------------- Receive Ports - RX Loss-of-sync State Machine --------------
        RXLOSSOFSYNC0                   =>      open,
        RXLOSSOFSYNC1                   =>      open,
        ---------------------- Receive Ports - RX Oversampling ---------------------
        RXENSAMPLEALIGN0                =>      tied_to_ground_i,
        RXENSAMPLEALIGN1                =>      tied_to_ground_i,
        RXOVERSAMPLEERR0                =>      open,
        RXOVERSAMPLEERR1                =>      open,
        -------------- Receive Ports - RX Pipe Control for PCI Express -------------
        PHYSTATUS0                      =>      open,
        PHYSTATUS1                      =>      open,
        RXVALID0                        =>      open,
        RXVALID1                        =>      open,
        ----------------- Receive Ports - RX Polarity Control Ports ----------------
        RXPOLARITY0                     =>      tied_to_ground_i,
        RXPOLARITY1                     =>      tied_to_ground_i,
        ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        DADDR                           =>      tied_to_ground_vec_i(6 downto 0),
        DCLK                            =>      tied_to_ground_i,
        DEN                             =>      tied_to_ground_i,
        DI                              =>      tied_to_ground_vec_i(15 downto 0),
        DO                              =>      open,
        DRDY                            =>      open,
        DWE                             =>      tied_to_ground_i,
        --------------------- Shared Ports - Tile and PLL Ports --------------------
        CLKIN                           =>      CLKIN_IN,
        GTPRESET                        =>      GTPRESET_IN,
        GTPTEST                         =>      tied_to_ground_vec_i(3 downto 0),
        INTDATAWIDTH                    =>      tied_to_vcc_i,
        PLLLKDET                        =>      PLLLKDET_OUT,
        PLLLKDETEN                      =>      tied_to_vcc_i,
        PLLPOWERDOWN                    =>      tied_to_ground_i,
        REFCLKOUT                       =>      REFCLKOUT_OUT,
        REFCLKPWRDNB                    =>      tied_to_vcc_i,
        RESETDONE0                      =>      resetdone0_i,
        RESETDONE1                      =>      resetdone1_i,
        RXENELECIDLERESETB              =>      tied_to_vcc_i,
        TXENPMAPHASEALIGN               =>      tied_to_ground_i,
        TXPMASETPHASE                   =>      tied_to_ground_i,
        ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        TXBYPASS8B10B0                  =>      tied_to_ground_vec_i(1 downto 0),
        TXBYPASS8B10B1                  =>      tied_to_ground_vec_i(1 downto 0),
        TXCHARDISPMODE0(1)              =>      tied_to_ground_i,
        TXCHARDISPMODE0(0)              =>      TXCHARDISPMODE0_IN,
        TXCHARDISPMODE1(1)              =>      tied_to_ground_i,
        TXCHARDISPMODE1(0)              =>      TXCHARDISPMODE1_IN,
        TXCHARDISPVAL0(1)               =>      tied_to_ground_i,
        TXCHARDISPVAL0(0)               =>      TXCHARDISPVAL0_IN,
        TXCHARDISPVAL1(1)               =>      tied_to_ground_i,
        TXCHARDISPVAL1(0)               =>      TXCHARDISPVAL1_IN,
        TXCHARISK0(1)                   =>      tied_to_ground_i,
        TXCHARISK0(0)                   =>      TXCHARISK0_IN,
        TXCHARISK1(1)                   =>      tied_to_ground_i,
        TXCHARISK1(0)                   =>      TXCHARISK1_IN,
        TXENC8B10BUSE0                  =>      tied_to_vcc_i,
        TXENC8B10BUSE1                  =>      tied_to_vcc_i,
        TXKERR0                         =>      open,
        TXKERR1                         =>      open,
        TXRUNDISP0                      =>      open,
        TXRUNDISP1                      =>      open,
        ------------- Transmit Ports - TX Buffering and Phase Alignment ------------
        TXBUFSTATUS0                    =>      TXBUFSTATUS0_OUT,
        TXBUFSTATUS1                    =>      TXBUFSTATUS1_OUT,
        ------------------ Transmit Ports - TX Data Path interface -----------------
        TXDATA0                         =>      txdata0_i,
        TXDATA1                         =>      txdata1_i,
        TXDATAWIDTH0                    =>      tied_to_ground_i,
        TXDATAWIDTH1                    =>      tied_to_ground_i,
        TXOUTCLK0                       =>      TXOUTCLK0_OUT,
        TXOUTCLK1                       =>      TXOUTCLK1_OUT,
        TXRESET0                        =>      TXRESET0_IN,
        TXRESET1                        =>      TXRESET1_IN,
        TXUSRCLK0                       =>      TXUSRCLK0_IN,
        TXUSRCLK1                       =>      TXUSRCLK1_IN,
        TXUSRCLK20                      =>      TXUSRCLK20_IN,
        TXUSRCLK21                      =>      TXUSRCLK21_IN,
        --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TXBUFDIFFCTRL0                  =>      "000",
        TXBUFDIFFCTRL1                  =>      "000",
        TXDIFFCTRL0                     =>      "000",
        TXDIFFCTRL1                     =>      "000",
        TXINHIBIT0                      =>      tied_to_ground_i,
        TXINHIBIT1                      =>      tied_to_ground_i,
        TXN0                            =>      TXN0_OUT,
        TXN1                            =>      TXN1_OUT,
        TXP0                            =>      TXP0_OUT,
        TXP1                            =>      TXP1_OUT,
        TXPREEMPHASIS0                  =>      "000",
        TXPREEMPHASIS1                  =>      "000",
        --------------------- Transmit Ports - TX PRBS Generator -------------------
        TXENPRBSTST0                    =>      tied_to_ground_vec_i(1 downto 0),
        TXENPRBSTST1                    =>      tied_to_ground_vec_i(1 downto 0),
        -------------------- Transmit Ports - TX Polarity Control ------------------
        TXPOLARITY0                     =>      tied_to_ground_i,
        TXPOLARITY1                     =>      tied_to_ground_i,
        ----------------- Transmit Ports - TX Ports for PCI Express ----------------
        TXDETECTRX0                     =>      tied_to_ground_i,
        TXDETECTRX1                     =>      tied_to_ground_i,
        TXELECIDLE0                     =>      tied_to_ground_i,
        TXELECIDLE1                     =>      tied_to_ground_i,
        --------------------- Transmit Ports - TX Ports for SATA -------------------
        TXCOMSTART0                     =>      tied_to_ground_i,
        TXCOMSTART1                     =>      tied_to_ground_i,
        TXCOMTYPE0                      =>      tied_to_ground_i,
        TXCOMTYPE1                      =>      tied_to_ground_i

    );

end RTL;


