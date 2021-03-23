//////////////////////////////////////////////////////////////////////////////
//$Date: 2009/12/17 21:16:09 $
//$RCSfile: rocketio_wrapper_gtp_ver_tile_v.ejava,v $
//$Revision: 1.3 $
///////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 1.9 
//  \   \         Application : GTP Wizard 
//  /   /         Filename : rocketio_wrapper_gtp_ver_tile.v
// /___/   /\     Timestamp : 02/08/2005 09:12:43
// \   \  /  \ 
//  \___\/\___\ 
//
//
// Module ROCKETIO_WRAPPER_GTP_VER_TILE (a GTP Tile Wrapper)
// Generated by Xilinx GTP Wizard



`timescale 1ns / 1ps


//***************************** Entity Declaration ****************************

module ROCKETIO_WRAPPER_GTP_TILE #
(
    // Simulation attributes
    parameter   TILE_SIM_GTPRESET_SPEEDUP  =   0,      // Set to 1 to speed up sim reset
    parameter   TILE_SIM_PLL_PERDIV2       =   9'h190,    // Set to the VCO Unit Interval time
    
    // Channel bonding attributes
    parameter   TILE_CHAN_BOND_MODE_0      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_0     =   0,      // 0 to 7. See UG for details
    
    parameter   TILE_CHAN_BOND_MODE_1      =   "OFF",  // "MASTER", "SLAVE", or "OFF"
    parameter   TILE_CHAN_BOND_LEVEL_1     =   0       // 0 to 7. See UG for details
)
(
    //---------------------- Loopback and Powerdown Ports ----------------------
    LOOPBACK0_IN,
    LOOPBACK1_IN,
    RXPOWERDOWN0_IN,
    TXPOWERDOWN0_IN,
    RXPOWERDOWN1_IN,
    TXPOWERDOWN1_IN,
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    RXCHARISCOMMA0_OUT,
    RXCHARISCOMMA1_OUT,
    RXCHARISK0_OUT,
    RXCHARISK1_OUT,
    RXDISPERR0_OUT,
    RXDISPERR1_OUT,
    RXNOTINTABLE0_OUT,
    RXNOTINTABLE1_OUT,
    RXRUNDISP0_OUT,
    RXRUNDISP1_OUT,
    //----------------- Receive Ports - Clock Correction Ports -----------------
    RXCLKCORCNT0_OUT,
    RXCLKCORCNT1_OUT,
    //------------- Receive Ports - Comma Detection and Alignment --------------
    RXENMCOMMAALIGN0_IN,
    RXENMCOMMAALIGN1_IN,
    RXENPCOMMAALIGN0_IN,
    RXENPCOMMAALIGN1_IN,
    //----------------- Receive Ports - RX Data Path interface -----------------
    RXDATA0_OUT,
    RXDATA1_OUT,
    RXRECCLK0_OUT,
    RXRECCLK1_OUT,
    RXRESET0_IN,
    RXRESET1_IN,
    RXUSRCLK0_IN,
    RXUSRCLK1_IN,
    RXUSRCLK20_IN,
    RXUSRCLK21_IN,
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    RXELECIDLE0_OUT,
    RXELECIDLE1_OUT,
    RXN0_IN,
    RXN1_IN,
    RXP0_IN,
    RXP1_IN,
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    RXBUFRESET0_IN,
    RXBUFRESET1_IN,
    RXBUFSTATUS0_OUT,
    RXBUFSTATUS1_OUT,
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    CLKIN_IN,
    GTPRESET_IN,
    PLLLKDET_OUT,
    REFCLKOUT_OUT,
    RESETDONE0_OUT,
    RESETDONE1_OUT,
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    TXCHARDISPMODE0_IN,
    TXCHARDISPMODE1_IN,
    TXCHARDISPVAL0_IN,
    TXCHARDISPVAL1_IN,
    TXCHARISK0_IN,
    TXCHARISK1_IN,
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    TXBUFSTATUS0_OUT,
    TXBUFSTATUS1_OUT,
    //---------------- Transmit Ports - TX Data Path interface -----------------
    TXDATA0_IN,
    TXDATA1_IN,
    TXOUTCLK0_OUT,
    TXOUTCLK1_OUT,
    TXRESET0_IN,
    TXRESET1_IN,
    TXUSRCLK0_IN,
    TXUSRCLK1_IN,
    TXUSRCLK20_IN,
    TXUSRCLK21_IN,
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    TXN0_OUT,
    TXN1_OUT,
    TXP0_OUT,
    TXP1_OUT


);

//***************************** Port Declarations *****************************
        

    //---------------------- Loopback and Powerdown Ports ----------------------
    input   [2:0]   LOOPBACK0_IN;
    input   [2:0]   LOOPBACK1_IN;
    input   [1:0]   RXPOWERDOWN0_IN;
    input   [1:0]   TXPOWERDOWN0_IN;
    input   [1:0]   RXPOWERDOWN1_IN;
    input   [1:0]   TXPOWERDOWN1_IN;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    output          RXCHARISCOMMA0_OUT;
    output          RXCHARISCOMMA1_OUT;
    output          RXCHARISK0_OUT;
    output          RXCHARISK1_OUT;
    output          RXDISPERR0_OUT;
    output          RXDISPERR1_OUT;
    output          RXNOTINTABLE0_OUT;
    output          RXNOTINTABLE1_OUT;
    output          RXRUNDISP0_OUT;
    output          RXRUNDISP1_OUT;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    output  [2:0]   RXCLKCORCNT0_OUT;
    output  [2:0]   RXCLKCORCNT1_OUT;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    input           RXENMCOMMAALIGN0_IN;
    input           RXENMCOMMAALIGN1_IN;
    input           RXENPCOMMAALIGN0_IN;
    input           RXENPCOMMAALIGN1_IN;
    //----------------- Receive Ports - RX Data Path interface -----------------
    output  [7:0]   RXDATA0_OUT;
    output  [7:0]   RXDATA1_OUT;
    output          RXRECCLK0_OUT;
    output          RXRECCLK1_OUT;
    input           RXRESET0_IN;
    input           RXRESET1_IN;
    input           RXUSRCLK0_IN;
    input           RXUSRCLK1_IN;
    input           RXUSRCLK20_IN;
    input           RXUSRCLK21_IN;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    output          RXELECIDLE0_OUT;
    output          RXELECIDLE1_OUT;
    input           RXN0_IN;
    input           RXN1_IN;
    input           RXP0_IN;
    input           RXP1_IN;
    //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    input           RXBUFRESET0_IN;
    input           RXBUFRESET1_IN;
    output  [2:0]   RXBUFSTATUS0_OUT;
    output  [2:0]   RXBUFSTATUS1_OUT;
    //------------------- Shared Ports - Tile and PLL Ports --------------------
    input           CLKIN_IN;
    input           GTPRESET_IN;
    output          PLLLKDET_OUT;
    output          REFCLKOUT_OUT;
    output          RESETDONE0_OUT;
    output          RESETDONE1_OUT;
    //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    input           TXCHARDISPMODE0_IN;
    input           TXCHARDISPMODE1_IN;
    input           TXCHARDISPVAL0_IN;
    input           TXCHARDISPVAL1_IN;
    input           TXCHARISK0_IN;
    input           TXCHARISK1_IN;
    //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
    output  [1:0]   TXBUFSTATUS0_OUT;
    output  [1:0]   TXBUFSTATUS1_OUT;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    input   [7:0]   TXDATA0_IN;
    input   [7:0]   TXDATA1_IN;
    output          TXOUTCLK0_OUT;
    output          TXOUTCLK1_OUT;
    input           TXRESET0_IN;
    input           TXRESET1_IN;
    input           TXUSRCLK0_IN;
    input           TXUSRCLK1_IN;
    input           TXUSRCLK20_IN;
    input           TXUSRCLK21_IN;
    //------------- Transmit Ports - TX Driver and OOB signalling --------------
    output          TXN0_OUT;
    output          TXN1_OUT;
    output          TXP0_OUT;
    output          TXP1_OUT;



//***************************** Wire Declarations *****************************

    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;


   

    //RX Datapath signals
    wire    [15:0]  rxdata0_i;       
    wire            rxchariscomma0_float_i;
    wire            rxcharisk0_float_i;
    wire            rxdisperr0_float_i;
    wire            rxnotintable0_float_i;
    wire            rxrundisp0_float_i;

    //TX Datapath signals
    wire    [15:0]  txdata0_i;           

    // Electrical idle reset logic signals
    wire    [2:0]   loopback0_i;
    wire            rxelecidle0_i;
    wire            resetdone0_i;
   
    //RX Datapath signals
    wire    [15:0]  rxdata1_i;       
    wire            rxchariscomma1_float_i;
    wire            rxcharisk1_float_i;
    wire            rxdisperr1_float_i;
    wire            rxnotintable1_float_i;
    wire            rxrundisp1_float_i;

    //TX Datapath signals
    wire    [15:0]  txdata1_i;           

    // Electrical idle reset logic signals
    wire    [2:0]   loopback1_i;
    wire            rxelecidle1_i;
    wire            resetdone1_i;

// 
//********************************* Main Body of Code**************************
                       
    //-------------------------  Static signal Assigments ---------------------   

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;
                                            

    


    //-------------------  GTP Datapath byte mapping  -----------------
    
    
    assign  RXDATA0_OUT    =   rxdata0_i[7:0];    
    
    assign  txdata0_i    =   {tied_to_ground_vec_i[7:0],TXDATA0_IN};    
    
    assign  RXDATA1_OUT    =   rxdata1_i[7:0];    
    
    assign  txdata1_i    =   {tied_to_ground_vec_i[7:0],TXDATA1_IN};    







    //-------------------------  Electrical Idle Reset Circuit  ---------------

    assign  RXELECIDLE0_OUT             =   rxelecidle0_i;
    assign  RESETDONE0_OUT              =   resetdone0_i;
    assign  loopback0_i                 =   LOOPBACK0_IN;
    assign  RXELECIDLE1_OUT             =   rxelecidle1_i;
    assign  RESETDONE1_OUT              =   resetdone1_i;
    assign  loopback1_i                 =   LOOPBACK1_IN;


    //------------------------- GT11 Instantiations  --------------------------   

    GTP_DUAL # 
    (
        //_______________________ Simulation-Only Attributes __________________
        .SIM_RECEIVER_DETECT_PASS0   ("TRUE"),
        .SIM_RECEIVER_DETECT_PASS1   ("TRUE"),
        .SIM_GTPRESET_SPEEDUP        (TILE_SIM_GTPRESET_SPEEDUP),
        .SIM_PLL_PERDIV2             (TILE_SIM_PLL_PERDIV2),
        .SIM_MODE                    ("FAST"),

        //___________________________ Shared Attributes _______________________

        //---------------------- Tile and PLL Attributes ----------------------

        .CLK25_DIVIDER               (5), 
        .CLKINDC_B                   ("TRUE"),   
        .OOB_CLK_DIVIDER             (4),
        .OVERSAMPLE_MODE             ("FALSE"),
        .PLL_DIVSEL_FB               (2),
        .PLL_DIVSEL_REF              (1),
        .PLL_TXDIVSEL_COMM_OUT       (1),
        .TX_SYNC_FILTERB             (1),


        //______________________ Transmit Interface Attributes ________________

        //----------------- TX Buffering and Phase Alignment ------------------   

        .TX_BUFFER_USE_0            ("TRUE"),
        .TX_XCLK_SEL_0              ("TXOUT"),
        .TXRX_INVERT_0              (5'b00000),        

        .TX_BUFFER_USE_1            ("TRUE"),
        .TX_XCLK_SEL_1              ("TXOUT"),
        .TXRX_INVERT_1              (5'b00000),        

        //------------------- TX Serial Line Rate settings --------------------   

        .PLL_TXDIVSEL_OUT_0         (2),

        .PLL_TXDIVSEL_OUT_1         (2),

        //------------------- TX Driver and OOB signalling --------------------  

         .TX_DIFF_BOOST_0           ("TRUE"),

         .TX_DIFF_BOOST_1           ("TRUE"),

        //---------------- TX Pipe Control for PCI Express/SATA ---------------

        .COM_BURST_VAL_0            (4'b1111),

        .COM_BURST_VAL_1            (4'b1111),

        //_______________________ Receive Interface Attributes ________________

        //---------- RX Driver,OOB signalling,Coupling and Eq.,CDR ------------  

        .AC_CAP_DIS_0               ("TRUE"),
        .OOBDETECT_THRESHOLD_0      (3'b001),
        .PMA_CDR_SCAN_0             (27'h6c07640), 
        .PMA_RX_CFG_0               (25'h09f0088),
        .RCV_TERM_GND_0             ("FALSE"),
        .RCV_TERM_MID_0             ("FALSE"),
        .RCV_TERM_VTTRX_0           ("FALSE"),
        .TERMINATION_IMP_0          (50),

        .AC_CAP_DIS_1               ("TRUE"),
        .OOBDETECT_THRESHOLD_1      (3'b001),
        .PMA_CDR_SCAN_1             (27'h6c07640), 
        .PMA_RX_CFG_1               (25'h09f0088),  
        .RCV_TERM_GND_1             ("FALSE"),
        .RCV_TERM_MID_1             ("FALSE"),
        .RCV_TERM_VTTRX_1           ("FALSE"),
        .TERMINATION_IMP_1          (50),

        .PCS_COM_CFG                (28'h1680a0e),
        .TERMINATION_CTRL           (5'b10100),
        .TERMINATION_OVRD           ("FALSE"),

        //------------------- RX Serial Line Rate Settings --------------------   

        .PLL_RXDIVSEL_OUT_0         (2),
        .PLL_SATA_0                 ("FALSE"),

        .PLL_RXDIVSEL_OUT_1         (2),
        .PLL_SATA_1                 ("FALSE"),


        //------------------------- PRBS Detection ----------------------------  

        .PRBS_ERR_THRESHOLD_0       (32'h00000001),

        .PRBS_ERR_THRESHOLD_1       (32'h00000001),

        //------------------- Comma Detection and Alignment -------------------  

        .ALIGN_COMMA_WORD_0         (1),
        .COMMA_10B_ENABLE_0         (10'b0001111111),
        .COMMA_DOUBLE_0             ("FALSE"),
        .DEC_MCOMMA_DETECT_0        ("TRUE"),
        .DEC_PCOMMA_DETECT_0        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_0     ("FALSE"),
        .MCOMMA_10B_VALUE_0         (10'b1010000011),
        .MCOMMA_DETECT_0            ("TRUE"),
        .PCOMMA_10B_VALUE_0         (10'b0101111100),
        .PCOMMA_DETECT_0            ("TRUE"),
        .RX_SLIDE_MODE_0            ("PCS"),

        .ALIGN_COMMA_WORD_1         (1),
        .COMMA_10B_ENABLE_1         (10'b0001111111),
        .COMMA_DOUBLE_1             ("FALSE"),
        .DEC_MCOMMA_DETECT_1        ("TRUE"),
        .DEC_PCOMMA_DETECT_1        ("TRUE"),
        .DEC_VALID_COMMA_ONLY_1     ("FALSE"),
        .MCOMMA_10B_VALUE_1         (10'b1010000011),
        .MCOMMA_DETECT_1            ("TRUE"),
        .PCOMMA_10B_VALUE_1         (10'b0101111100),
        .PCOMMA_DETECT_1            ("TRUE"),
        .RX_SLIDE_MODE_1            ("PCS"),


        //------------------- RX Loss-of-sync State Machine -------------------  

        .RX_LOSS_OF_SYNC_FSM_0      ("FALSE"),
        .RX_LOS_INVALID_INCR_0      (8),
        .RX_LOS_THRESHOLD_0         (128),

        .RX_LOSS_OF_SYNC_FSM_1      ("FALSE"),
        .RX_LOS_INVALID_INCR_1      (8),
        .RX_LOS_THRESHOLD_1         (128),

        //------------ RX Elastic Buffer and Phase alignment ports ------------   

        .RX_BUFFER_USE_0            ("TRUE"),
        .RX_XCLK_SEL_0              ("RXREC"),

        .RX_BUFFER_USE_1            ("TRUE"),
        .RX_XCLK_SEL_1              ("RXREC"),

        //--------------------- Clock Correction Attributes -------------------   

        .CLK_CORRECT_USE_0          ("TRUE"),
        .CLK_COR_ADJ_LEN_0          (2),
        .CLK_COR_DET_LEN_0          (2),
        .CLK_COR_INSERT_IDLE_FLAG_0 ("FALSE"),
        .CLK_COR_KEEP_IDLE_0        ("FALSE"),
        .CLK_COR_MAX_LAT_0          (18),
        .CLK_COR_MIN_LAT_0          (16),
        .CLK_COR_PRECEDENCE_0       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_0      (0),
        .CLK_COR_SEQ_1_1_0          (10'b0110111100),
        .CLK_COR_SEQ_1_2_0          (10'b0001010000),
        .CLK_COR_SEQ_1_3_0          (10'b0000000000),
        .CLK_COR_SEQ_1_4_0          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_0     (4'b0011),
        .CLK_COR_SEQ_2_1_0          (10'b0110111100),
        .CLK_COR_SEQ_2_2_0          (10'b0010110101),
        .CLK_COR_SEQ_2_3_0          (10'b0000000000),
        .CLK_COR_SEQ_2_4_0          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_0     (4'b0011),
        .CLK_COR_SEQ_2_USE_0        ("TRUE"),
        .RX_DECODE_SEQ_MATCH_0      ("TRUE"),

        .CLK_CORRECT_USE_1          ("TRUE"),
        .CLK_COR_ADJ_LEN_1          (2),
        .CLK_COR_DET_LEN_1          (2),
        .CLK_COR_INSERT_IDLE_FLAG_1 ("FALSE"),
        .CLK_COR_KEEP_IDLE_1        ("FALSE"),
        .CLK_COR_MAX_LAT_1          (18),
        .CLK_COR_MIN_LAT_1          (16),
        .CLK_COR_PRECEDENCE_1       ("TRUE"),
        .CLK_COR_REPEAT_WAIT_1      (0),
        .CLK_COR_SEQ_1_1_1          (10'b0110111100),
        .CLK_COR_SEQ_1_2_1          (10'b0001010000),
        .CLK_COR_SEQ_1_3_1          (10'b0000000000),
        .CLK_COR_SEQ_1_4_1          (10'b0000000000),
        .CLK_COR_SEQ_1_ENABLE_1     (4'b0011),
        .CLK_COR_SEQ_2_1_1          (10'b0110111100),
        .CLK_COR_SEQ_2_2_1          (10'b0010110101),
        .CLK_COR_SEQ_2_3_1          (10'b0000000000),
        .CLK_COR_SEQ_2_4_1          (10'b0000000000),
        .CLK_COR_SEQ_2_ENABLE_1     (4'b0011),
        .CLK_COR_SEQ_2_USE_1        ("TRUE"),
        .RX_DECODE_SEQ_MATCH_1      ("TRUE"),

        //-------------------- Channel Bonding Attributes ---------------------   

        .CHAN_BOND_1_MAX_SKEW_0     (7),
        .CHAN_BOND_2_MAX_SKEW_0     (7),
        .CHAN_BOND_LEVEL_0          (TILE_CHAN_BOND_LEVEL_0),
        .CHAN_BOND_MODE_0           (TILE_CHAN_BOND_MODE_0),
        .CHAN_BOND_SEQ_1_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_1_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_0        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_0   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_0      ("FALSE"),  
        .CHAN_BOND_SEQ_LEN_0        (1),
        .PCI_EXPRESS_MODE_0         ("FALSE"),     
     
        .CHAN_BOND_1_MAX_SKEW_1     (7),
        .CHAN_BOND_2_MAX_SKEW_1     (7),
        .CHAN_BOND_LEVEL_1          (TILE_CHAN_BOND_LEVEL_1),
        .CHAN_BOND_MODE_1           (TILE_CHAN_BOND_MODE_1),
        .CHAN_BOND_SEQ_1_1_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_1_ENABLE_1   (4'b0000),
        .CHAN_BOND_SEQ_2_1_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_2_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_3_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_4_1        (10'b0000000000),
        .CHAN_BOND_SEQ_2_ENABLE_1   (4'b0000),
        .CHAN_BOND_SEQ_2_USE_1      ("FALSE"),  
        .CHAN_BOND_SEQ_LEN_1        (1),
        .PCI_EXPRESS_MODE_1         ("FALSE"),

        //---------------- RX Attributes for PCI Express/SATA ---------------

        .RX_STATUS_FMT_0            ("PCIE"),
        .SATA_BURST_VAL_0           (3'b100),
        .SATA_IDLE_VAL_0            (3'b100),
        .SATA_MAX_BURST_0           (9),
        .SATA_MAX_INIT_0            (27),
        .SATA_MAX_WAKE_0            (9),
        .SATA_MIN_BURST_0           (5),
        .SATA_MIN_INIT_0            (15),
        .SATA_MIN_WAKE_0            (5),
        .TRANS_TIME_FROM_P2_0       (16'h003c),
        .TRANS_TIME_NON_P2_0        (16'h0019),
        .TRANS_TIME_TO_P2_0         (16'h0064),

        .RX_STATUS_FMT_1            ("PCIE"),
        .SATA_BURST_VAL_1           (3'b100),
        .SATA_IDLE_VAL_1            (3'b100),
        .SATA_MAX_BURST_1           (9),
        .SATA_MAX_INIT_1            (27),
        .SATA_MAX_WAKE_1            (9),
        .SATA_MIN_BURST_1           (5),
        .SATA_MIN_INIT_1            (15),
        .SATA_MIN_WAKE_1            (5),
        .TRANS_TIME_FROM_P2_1       (16'h003c),
        .TRANS_TIME_NON_P2_1        (16'h0019),
        .TRANS_TIME_TO_P2_1         (16'h0064)         
     ) 
     gtp_dual_i 
     (

        //---------------------- Loopback and Powerdown Ports ----------------------
        .LOOPBACK0                      (loopback0_i),
        .LOOPBACK1                      (loopback1_i),
        .RXPOWERDOWN0                   (RXPOWERDOWN0_IN),
        .RXPOWERDOWN1                   (RXPOWERDOWN1_IN),
        .TXPOWERDOWN0                   (TXPOWERDOWN0_IN),
        .TXPOWERDOWN1                   (TXPOWERDOWN1_IN),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .RXCHARISCOMMA0                 ({rxchariscomma0_float_i,RXCHARISCOMMA0_OUT}),
        .RXCHARISCOMMA1                 ({rxchariscomma1_float_i,RXCHARISCOMMA1_OUT}),
        .RXCHARISK0                     ({rxcharisk0_float_i,RXCHARISK0_OUT}),
        .RXCHARISK1                     ({rxcharisk1_float_i,RXCHARISK1_OUT}),
        .RXDEC8B10BUSE0                 (tied_to_vcc_i),
        .RXDEC8B10BUSE1                 (tied_to_vcc_i),
        .RXDISPERR0                     ({rxdisperr0_float_i,RXDISPERR0_OUT}),
        .RXDISPERR1                     ({rxdisperr1_float_i,RXDISPERR1_OUT}),
        .RXNOTINTABLE0                  ({rxnotintable0_float_i,RXNOTINTABLE0_OUT}),
        .RXNOTINTABLE1                  ({rxnotintable1_float_i,RXNOTINTABLE1_OUT}),
        .RXRUNDISP0                     ({rxrundisp0_float_i,RXRUNDISP0_OUT}),
        .RXRUNDISP1                     ({rxrundisp1_float_i,RXRUNDISP1_OUT}),
        //----------------- Receive Ports - Channel Bonding Ports ------------------
        .RXCHANBONDSEQ0                 (),
        .RXCHANBONDSEQ1                 (),
        .RXCHBONDI0                     (tied_to_ground_vec_i[2:0]),
        .RXCHBONDI1                     (tied_to_ground_vec_i[2:0]),
        .RXCHBONDO0                     (),
        .RXCHBONDO1                     (),
        .RXENCHANSYNC0                  (tied_to_ground_i),
        .RXENCHANSYNC1                  (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT0                   (RXCLKCORCNT0_OUT),
        .RXCLKCORCNT1                   (RXCLKCORCNT1_OUT),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .RXBYTEISALIGNED0               (),
        .RXBYTEISALIGNED1               (),
        .RXBYTEREALIGN0                 (),
        .RXBYTEREALIGN1                 (),
        .RXCOMMADET0                    (),
        .RXCOMMADET1                    (),
        .RXCOMMADETUSE0                 (tied_to_vcc_i),
        .RXCOMMADETUSE1                 (tied_to_vcc_i),
        .RXENMCOMMAALIGN0               (RXENMCOMMAALIGN0_IN),
        .RXENMCOMMAALIGN1               (RXENMCOMMAALIGN1_IN),
        .RXENPCOMMAALIGN0               (RXENPCOMMAALIGN0_IN),
        .RXENPCOMMAALIGN1               (RXENPCOMMAALIGN1_IN),
        .RXSLIDE0                       (tied_to_ground_i),
        .RXSLIDE1                       (tied_to_ground_i),
        //--------------------- Receive Ports - PRBS Detection ---------------------
        .PRBSCNTRESET0                  (tied_to_ground_i),
        .PRBSCNTRESET1                  (tied_to_ground_i),
        .RXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .RXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        .RXPRBSERR0                     (),
        .RXPRBSERR1                     (),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .RXDATA0                        (rxdata0_i),
        .RXDATA1                        (rxdata1_i),
        .RXDATAWIDTH0                   (tied_to_ground_i),
        .RXDATAWIDTH1                   (tied_to_ground_i),
        .RXRECCLK0                      (RXRECCLK0_OUT),
        .RXRECCLK1                      (RXRECCLK1_OUT),
        .RXRESET0                       (RXRESET0_IN),
        .RXRESET1                       (RXRESET1_IN),
        .RXUSRCLK0                      (RXUSRCLK0_IN),
        .RXUSRCLK1                      (RXUSRCLK1_IN),
        .RXUSRCLK20                     (RXUSRCLK20_IN),
        .RXUSRCLK21                     (RXUSRCLK21_IN),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .RXCDRRESET0                    (tied_to_ground_i),
        .RXCDRRESET1                    (tied_to_ground_i),
        .RXELECIDLE0                    (rxelecidle0_i),
        .RXELECIDLE1                    (rxelecidle1_i),
        .RXELECIDLERESET0               (tied_to_ground_i),
        .RXELECIDLERESET1               (tied_to_ground_i),
        .RXENEQB0                       (tied_to_vcc_i),
        .RXENEQB1                       (tied_to_vcc_i),
        .RXEQMIX0                       (tied_to_ground_vec_i[1:0]),
        .RXEQMIX1                       (tied_to_ground_vec_i[1:0]),
        .RXEQPOLE0                      (tied_to_ground_vec_i[3:0]),
        .RXEQPOLE1                      (tied_to_ground_vec_i[3:0]),
        .RXN0                           (RXN0_IN),
        .RXN1                           (RXN1_IN),
        .RXP0                           (RXP0_IN),
        .RXP1                           (RXP1_IN),
        //------ Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
        .RXBUFRESET0                    (RXBUFRESET0_IN),
        .RXBUFRESET1                    (RXBUFRESET1_IN),
        .RXBUFSTATUS0                   (RXBUFSTATUS0_OUT),
        .RXBUFSTATUS1                   (RXBUFSTATUS1_OUT),
        .RXCHANISALIGNED0               (),
        .RXCHANISALIGNED1               (),
        .RXCHANREALIGN0                 (),
        .RXCHANREALIGN1                 (),
        .RXPMASETPHASE0                 (tied_to_ground_i),
        .RXPMASETPHASE1                 (tied_to_ground_i),
        .RXSTATUS0                      (),
        .RXSTATUS1                      (),
        //------------- Receive Ports - RX Loss-of-sync State Machine --------------
        .RXLOSSOFSYNC0                  (),
        .RXLOSSOFSYNC1                  (),
        //-------------------- Receive Ports - RX Oversampling ---------------------
        .RXENSAMPLEALIGN0               (tied_to_ground_i),
        .RXENSAMPLEALIGN1               (tied_to_ground_i),
        .RXOVERSAMPLEERR0               (),
        .RXOVERSAMPLEERR1               (),
        //------------ Receive Ports - RX Pipe Control for PCI Express -------------
        .PHYSTATUS0                     (),
        .PHYSTATUS1                     (),
        .RXVALID0                       (),
        .RXVALID1                       (),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY0                    (tied_to_ground_i),
        .RXPOLARITY1                    (tied_to_ground_i),
        //----------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
        .DADDR                          (tied_to_ground_vec_i[6:0]),
        .DCLK                           (tied_to_ground_i),
        .DEN                            (tied_to_ground_i),
        .DI                             (tied_to_ground_vec_i[15:0]),
        .DO                             (),
        .DRDY                           (),
        .DWE                            (tied_to_ground_i),
        //------------------- Shared Ports - Tile and PLL Ports --------------------
        .CLKIN                          (CLKIN_IN),
        .GTPRESET                       (GTPRESET_IN),
        .GTPTEST                        (tied_to_ground_vec_i[3:0]),
        .INTDATAWIDTH                   (tied_to_vcc_i),
        .PLLLKDET                       (PLLLKDET_OUT),
        .PLLLKDETEN                     (tied_to_vcc_i),
        .PLLPOWERDOWN                   (tied_to_ground_i),
        .REFCLKOUT                      (REFCLKOUT_OUT),
        .REFCLKPWRDNB                   (tied_to_vcc_i),
        .RESETDONE0                     (resetdone0_i),
        .RESETDONE1                     (resetdone1_i),
        .RXENELECIDLERESETB             (tied_to_vcc_i),
        .TXENPMAPHASEALIGN              (tied_to_ground_i),
        .TXPMASETPHASE                  (tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXBYPASS8B10B0                 (tied_to_ground_vec_i[1:0]),
        .TXBYPASS8B10B1                 (tied_to_ground_vec_i[1:0]),
        .TXCHARDISPMODE0                ({tied_to_ground_i,TXCHARDISPMODE0_IN}),
        .TXCHARDISPMODE1                ({tied_to_ground_i,TXCHARDISPMODE1_IN}),
        .TXCHARDISPVAL0                 ({tied_to_ground_i,TXCHARDISPVAL0_IN}),
        .TXCHARDISPVAL1                 ({tied_to_ground_i,TXCHARDISPVAL1_IN}),
        .TXCHARISK0                     ({tied_to_ground_i,TXCHARISK0_IN}),
        .TXCHARISK1                     ({tied_to_ground_i,TXCHARISK1_IN}),
        .TXENC8B10BUSE0                 (tied_to_vcc_i),
        .TXENC8B10BUSE1                 (tied_to_vcc_i),
        .TXKERR0                        (),
        .TXKERR1                        (),
        .TXRUNDISP0                     (),
        .TXRUNDISP1                     (),
        //----------- Transmit Ports - TX Buffering and Phase Alignment ------------
        .TXBUFSTATUS0                   (TXBUFSTATUS0_OUT),
        .TXBUFSTATUS1                   (TXBUFSTATUS1_OUT),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA0                        (txdata0_i),
        .TXDATA1                        (txdata1_i),
        .TXDATAWIDTH0                   (tied_to_ground_i),
        .TXDATAWIDTH1                   (tied_to_ground_i),
        .TXOUTCLK0                      (TXOUTCLK0_OUT),
        .TXOUTCLK1                      (TXOUTCLK1_OUT),
        .TXRESET0                       (TXRESET0_IN),
        .TXRESET1                       (TXRESET1_IN),
        .TXUSRCLK0                      (TXUSRCLK0_IN),
        .TXUSRCLK1                      (TXUSRCLK1_IN),
        .TXUSRCLK20                     (TXUSRCLK20_IN),
        .TXUSRCLK21                     (TXUSRCLK21_IN),
        //------------- Transmit Ports - TX Driver and OOB signalling --------------
        .TXBUFDIFFCTRL0                 (3'b000),
        .TXBUFDIFFCTRL1                 (3'b000),
        .TXDIFFCTRL0                    (3'b000),
        .TXDIFFCTRL1                    (3'b000),
        .TXINHIBIT0                     (tied_to_ground_i),
        .TXINHIBIT1                     (tied_to_ground_i),
        .TXN0                           (TXN0_OUT),
        .TXN1                           (TXN1_OUT),
        .TXP0                           (TXP0_OUT),
        .TXP1                           (TXP1_OUT),
        .TXPREEMPHASIS0                 (3'b000),
        .TXPREEMPHASIS1                 (3'b000),
        //------------------- Transmit Ports - TX PRBS Generator -------------------
        .TXENPRBSTST0                   (tied_to_ground_vec_i[1:0]),
        .TXENPRBSTST1                   (tied_to_ground_vec_i[1:0]),
        //------------------ Transmit Ports - TX Polarity Control ------------------
        .TXPOLARITY0                    (tied_to_ground_i),
        .TXPOLARITY1                    (tied_to_ground_i),
        //--------------- Transmit Ports - TX Ports for PCI Express ----------------
        .TXDETECTRX0                    (tied_to_ground_i),
        .TXDETECTRX1                    (tied_to_ground_i),
        .TXELECIDLE0                    (tied_to_ground_i),
        .TXELECIDLE1                    (tied_to_ground_i),
        //------------------- Transmit Ports - TX Ports for SATA -------------------
        .TXCOMSTART0                    (tied_to_ground_i),
        .TXCOMSTART1                    (tied_to_ground_i),
        .TXCOMTYPE0                     (tied_to_ground_i),
        .TXCOMTYPE1                     (tied_to_ground_i)

     );
     
endmodule

    
