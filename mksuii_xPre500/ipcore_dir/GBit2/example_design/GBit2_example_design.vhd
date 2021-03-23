-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Example Design Wrapper
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : GBit2_example_design.vhd
-- Version    : 1.7
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Description:  This is the VHDL example design for the Virtex-5 
--               Embedded Ethernet MAC.  It is intended that
--               this example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               This level:
--
--               * instantiates the TEMAC local link file that instantiates 
--                 the TEMAC top level together with a RX and TX FIFO with a 
--                 local link interface;
--
--               * instantiates a simple client I/F side example design,
--                 providing an address swap and a simple
--                 loopback function;
--
--               * Instantiates IBUFs on the GTX_CLK, REFCLK and HOSTCLK inputs 
--                 if required;
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
--
--
--
--    ---------------------------------------------------------------------
--    | EXAMPLE DESIGN WRAPPER                                            |
--    |           --------------------------------------------------------|
--    |           |LOCAL LINK WRAPPER                                     |
--    |           |              -----------------------------------------|
--    |           |              |BLOCK LEVEL WRAPPER                     |
--    |           |              |    ---------------------               |
--    | --------  |  ----------  |    | ETHERNET MAC      |               |
--    | |      |  |  |        |  |    | WRAPPER           |  ---------    |
--    | |      |->|->|        |--|--->| Tx            Tx  |--|       |--->|
--    | |      |  |  |        |  |    | client        PHY |  |       |    |
--    | | ADDR |  |  | LOCAL  |  |    | I/F           I/F |  |       |    |  
--    | | SWAP |  |  |  LINK  |  |    |                   |  | PHY   |    |
--    | |      |  |  |  FIFO  |  |    |                   |  | I/F   |    |
--    | |      |  |  |        |  |    |                   |  |       |    |
--    | |      |  |  |        |  |    | Rx            Rx  |  |       |    |
--    | |      |  |  |        |  |    | client        PHY |  |       |    |
--    | |      |<-|<-|        |<-|----| I/F           I/F |<-|       |<---|
--    | |      |  |  |        |  |    |                   |  ---------    |
--    | --------  |  ----------  |    ---------------------               |
--    |           |              -----------------------------------------|
--    |           --------------------------------------------------------|
--    ---------------------------------------------------------------------
--
-------------------------------------------------------------------------------


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;



-------------------------------------------------------------------------------
-- The entity declaration for the example design.
-------------------------------------------------------------------------------
entity GBit2_example_design is
   port(
      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS        : out std_logic;
      -- EMAC0 Interrupt
      EMAC0ANINTERRUPT                : out std_logic;

 
      -- Clock Signals - EMAC0

      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                           : out std_logic;
      TXN_0                           : out std_logic;
      RXP_0                           : in  std_logic;
      RXN_0                           : in  std_logic;
      PHYAD_0                         : in  std_logic_vector(4 downto 0);

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS        : out std_logic;
      -- EMAC1 Interrupt
      EMAC1ANINTERRUPT                : out std_logic;

           
      -- Clock Signals - EMAC1

      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1                           : out std_logic;
      TXN_1                           : out std_logic;
      RXP_1                           : in  std_logic;
      RXN_1                           : in  std_logic;
      PHYAD_1                         : in  std_logic_vector(4 downto 0);

      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      MGTCLK_P                        : in  std_logic;
      MGTCLK_N                        : in  std_logic;

        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
end GBit2_example_design;


architecture TOP_LEVEL of GBit2_example_design is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the TEMAC wrapper with 
  -- Local Link FIFO.
  component GBit2_locallink is
   port(
      -- EMAC0 Clocking
      -- 125MHz clock output from transceiver
      CLK125_OUT                       : out std_logic;
      -- 125MHz clock input from BUFG
      CLK125                           : in  std_logic;

      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_0                   : in  std_logic; 
      RX_LL_RESET_0                   : in  std_logic;
      RX_LL_DATA_0                    : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_0                   : out std_logic;
      RX_LL_EOF_N_0                   : out std_logic;
      RX_LL_SRC_RDY_N_0               : out std_logic;
      RX_LL_DST_RDY_N_0               : in  std_logic;
      RX_LL_FIFO_STATUS_0             : out std_logic_vector(3 downto 0);

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_0                   : in  std_logic;
      TX_LL_RESET_0                   : in  std_logic;
      TX_LL_DATA_0                    : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_0                   : in  std_logic;
      TX_LL_EOF_N_0                   : in  std_logic;
      TX_LL_SRC_RDY_N_0               : in  std_logic;
      TX_LL_DST_RDY_N_0               : out std_logic;

      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS        : out std_logic;
      -- EMAC0 Interrupt
      EMAC0ANINTERRUPT                : out std_logic;

 
      -- Clock Signals - EMAC0

      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                           : out std_logic;
      TXN_0                           : out std_logic;
      RXP_0                           : in  std_logic;
      RXN_0                           : in  std_logic;
      PHYAD_0                         : in  std_logic_vector(4 downto 0);
      RESETDONE_0                     : out std_logic;

      -- EMAC1 Clocking

      -- Local link Receiver Interface - EMAC1
      RX_LL_CLOCK_1                   : in  std_logic; 
      RX_LL_RESET_1                   : in  std_logic;
      RX_LL_DATA_1                    : out std_logic_vector(7 downto 0);
      RX_LL_SOF_N_1                   : out std_logic;
      RX_LL_EOF_N_1                   : out std_logic;
      RX_LL_SRC_RDY_N_1               : out std_logic;
      RX_LL_DST_RDY_N_1               : in  std_logic;
      RX_LL_FIFO_STATUS_1             : out std_logic_vector(3 downto 0);

      -- Local link Transmitter Interface - EMAC1
      TX_LL_CLOCK_1                   : in  std_logic;
      TX_LL_RESET_1                   : in  std_logic;
      TX_LL_DATA_1                    : in  std_logic_vector(7 downto 0);
      TX_LL_SOF_N_1                   : in  std_logic;
      TX_LL_EOF_N_1                   : in  std_logic;
      TX_LL_SRC_RDY_N_1               : in  std_logic;
      TX_LL_DST_RDY_N_1               : out std_logic;

      -- Client Receiver Interface - EMAC1
      EMAC1CLIENTRXDVLD               : out std_logic;
      EMAC1CLIENTRXFRAMEDROP          : out std_logic;
      EMAC1CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC1CLIENTRXSTATSVLD           : out std_logic;
      EMAC1CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC1
      CLIENTEMAC1TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC1CLIENTTXSTATS              : out std_logic;
      EMAC1CLIENTTXSTATSVLD           : out std_logic;
      EMAC1CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             : in  std_logic;
      CLIENTEMAC1PAUSEVAL             : in  std_logic_vector(15 downto 0);

      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS        : out std_logic;
      -- EMAC1 Interrupt
      EMAC1ANINTERRUPT                : out std_logic;

           
      -- Clock Signals - EMAC1

      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1                           : out std_logic;
      TXN_1                           : out std_logic;
      RXP_1                           : in  std_logic;
      RXN_1                           : in  std_logic;
      PHYAD_1                         : in  std_logic_vector(4 downto 0);
      RESETDONE_1                     : out std_logic;

      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      CLK_DS                          : in  std_logic;

      -- RocketIO Reset input
      GTRESET                         : in  std_logic;      

        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
  end component;
 
   ---------------------------------------------------------------------
   --  Component Declaration for 8-bit address swapping module
   ---------------------------------------------------------------------
   component address_swap_module_8
   port (
      rx_ll_clock         : in  std_logic;                     -- Input CLK from MAC Reciever
      rx_ll_reset         : in  std_logic;                     -- Synchronous reset signal
      rx_ll_data_in       : in  std_logic_vector(7 downto 0);  -- Input data
      rx_ll_sof_in_n      : in  std_logic;                     -- Input start of frame
      rx_ll_eof_in_n      : in  std_logic;                     -- Input end of frame
      rx_ll_src_rdy_in_n  : in  std_logic;                     -- Input source ready
      rx_ll_data_out      : out std_logic_vector(7 downto 0);  -- Modified output data
      rx_ll_sof_out_n     : out std_logic;                     -- Output start of frame
      rx_ll_eof_out_n     : out std_logic;                     -- Output end of frame
      rx_ll_src_rdy_out_n : out std_logic;                     -- Output source ready
      rx_ll_dst_rdy_in_n  : in  std_logic                      -- Input destination ready
      );
   end component;

-----------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------

    -- Global asynchronous reset
    signal reset_i               : std_logic;

    -- client interface clocking signals - EMAC0
    signal ll_clk_0_i            : std_logic;

    -- address swap transmitter connections - EMAC0
    signal tx_ll_data_0_i      : std_logic_vector(7 downto 0);
    signal tx_ll_sof_n_0_i     : std_logic;
    signal tx_ll_eof_n_0_i     : std_logic;
    signal tx_ll_src_rdy_n_0_i : std_logic;
    signal tx_ll_dst_rdy_n_0_i : std_logic;

   -- address swap receiver connections - EMAC0
    signal rx_ll_data_0_i           : std_logic_vector(7 downto 0);
    signal rx_ll_sof_n_0_i          : std_logic;
    signal rx_ll_eof_n_0_i          : std_logic;
    signal rx_ll_src_rdy_n_0_i      : std_logic;
    signal rx_ll_dst_rdy_n_0_i      : std_logic;

    -- create a synchronous reset in the transmitter clock domain
    signal ll_pre_reset_0_i          : std_logic_vector(5 downto 0);
    signal ll_reset_0_i              : std_logic;

    attribute async_reg : string;
    attribute async_reg of ll_pre_reset_0_i : signal is "true";

    signal resetdone_0_i             : std_logic;

    -- client interface clocking signals - EMAC1
    signal ll_clk_1_i            : std_logic;

    -- address swap transmitter connections - EMAC1
    signal tx_ll_data_1_i      : std_logic_vector(7 downto 0);
    signal tx_ll_sof_n_1_i     : std_logic;
    signal tx_ll_eof_n_1_i     : std_logic;
    signal tx_ll_src_rdy_n_1_i : std_logic;
    signal tx_ll_dst_rdy_n_1_i : std_logic;

    -- address swap receiver connections - EMAC1
    signal rx_ll_data_1_i           : std_logic_vector(7 downto 0);
    signal rx_ll_sof_n_1_i          : std_logic;
    signal rx_ll_eof_n_1_i          : std_logic;
    signal rx_ll_src_rdy_n_1_i      : std_logic;
    signal rx_ll_dst_rdy_n_1_i      : std_logic;

    -- create a synchronous reset in the transmitter clock domain
    signal ll_pre_reset_1_i          : std_logic_vector(5 downto 0);
    signal ll_reset_1_i              : std_logic;

    signal resetdone_1_i             : std_logic;

    attribute async_reg of ll_pre_reset_1_i : signal is "true";


    -- EMAC0 Clocking signals

    -- Transceiver output clock (REFCLKOUT at 125MHz)
    signal clk125_o                  : std_logic;
    -- 125MHz clock input to wrappers
    signal clk125                    : std_logic;
    -- Input 125MHz differential clock for transceiver
    signal clk_ds                    : std_logic;

    -- GT reset signal
   signal gtreset                    : std_logic;
   signal reset_r                    : std_logic_vector(3 downto 0);
   attribute async_reg of reset_r    : signal is "TRUE";



    -- EMAC1 Clocking signals







-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------


begin

    ---------------------------------------------------------------------------
    -- Reset Input Buffer
    ---------------------------------------------------------------------------
    reset_ibuf : IBUF port map (I => RESET, O => reset_i);

    -- EMAC0 Clocking

    -- Generate the clock input to the GTP
    -- clk_ds can be shared between multiple MAC instances.
    clkingen : IBUFDS port map (
      I  => MGTCLK_P,
      IB => MGTCLK_N,
      O  => clk_ds);

    -- 125MHz from transceiver is routed through a BUFG and 
    -- input to the MAC wrappers.
    -- This clock can be shared between multiple MAC instances.
    bufg_clk125 : BUFG port map (I => clk125_o, O => clk125);

    
    ll_clk_0_i <= clk125; 

   --------------------------------------------------------------------
   -- RocketIO PMA reset circuitry
   --------------------------------------------------------------------
   process(reset_i, clk125)
   begin
     if (reset_i = '1') then
       reset_r <= "1111";
     elsif clk125'event and clk125 = '1' then
       reset_r <= reset_r(2 downto 0) & reset_i;
     end if;
   end process;
  
   gtreset <= reset_r(3);


    -- EMAC1 Clocking

    ll_clk_1_i <= clk125;

    ------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper with LL FIFO 
    -- (GBit2_locallink.v)
    ------------------------------------------------------------------------
    v5_emac_ll : GBit2_locallink
    port map (
      -- EMAC0 Clocking
      -- 125MHz clock output from transceiver
      CLK125_OUT                      => clk125_o,
      -- 125MHz clock input from BUFG
      CLK125                          => clk125,
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_0                   => ll_clk_0_i,
      RX_LL_RESET_0                   => ll_reset_0_i,
      RX_LL_DATA_0                    => rx_ll_data_0_i,
      RX_LL_SOF_N_0                   => rx_ll_sof_n_0_i,
      RX_LL_EOF_N_0                   => rx_ll_eof_n_0_i,
      RX_LL_SRC_RDY_N_0               => rx_ll_src_rdy_n_0_i,
      RX_LL_DST_RDY_N_0               => rx_ll_dst_rdy_n_0_i,
      RX_LL_FIFO_STATUS_0             => open,

      -- Unused Receiver signals - EMAC0
      EMAC0CLIENTRXDVLD               => EMAC0CLIENTRXDVLD,
      EMAC0CLIENTRXFRAMEDROP          => EMAC0CLIENTRXFRAMEDROP,
      EMAC0CLIENTRXSTATS              => EMAC0CLIENTRXSTATS,
      EMAC0CLIENTRXSTATSVLD           => EMAC0CLIENTRXSTATSVLD,
      EMAC0CLIENTRXSTATSBYTEVLD       => EMAC0CLIENTRXSTATSBYTEVLD,

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_0                   => ll_clk_0_i,
      TX_LL_RESET_0                   => ll_reset_0_i,
      TX_LL_DATA_0                    => tx_ll_data_0_i,
      TX_LL_SOF_N_0                   => tx_ll_sof_n_0_i,
      TX_LL_EOF_N_0                   => tx_ll_eof_n_0_i,
      TX_LL_SRC_RDY_N_0               => tx_ll_src_rdy_n_0_i,
      TX_LL_DST_RDY_N_0               => tx_ll_dst_rdy_n_0_i,

      -- Unused Transmitter signals - EMAC0
      CLIENTEMAC0TXIFGDELAY           => CLIENTEMAC0TXIFGDELAY,
      EMAC0CLIENTTXSTATS              => EMAC0CLIENTTXSTATS,
      EMAC0CLIENTTXSTATSVLD           => EMAC0CLIENTTXSTATSVLD,
      EMAC0CLIENTTXSTATSBYTEVLD       => EMAC0CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             => CLIENTEMAC0PAUSEREQ,
      CLIENTEMAC0PAUSEVAL             => CLIENTEMAC0PAUSEVAL,

      --EMAC-MGT link status
      EMAC0CLIENTSYNCACQSTATUS        => EMAC0CLIENTSYNCACQSTATUS,
      -- EMAC0 Interrupt
      EMAC0ANINTERRUPT                => EMAC0ANINTERRUPT,

 
      -- Clock Signals - EMAC0
      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                           => TXP_0,
      TXN_0                           => TXN_0,
      RXP_0                           => RXP_0,
      RXN_0                           => RXN_0,
      PHYAD_0                         => PHYAD_0,
      RESETDONE_0                     => resetdone_0_i,

      -- EMAC1 Clocking
      -- Local link Receiver Interface - EMAC0
      RX_LL_CLOCK_1                   => ll_clk_1_i,
      RX_LL_RESET_1                   => ll_reset_1_i,
      RX_LL_DATA_1                    => rx_ll_data_1_i,
      RX_LL_SOF_N_1                   => rx_ll_sof_n_1_i,
      RX_LL_EOF_N_1                   => rx_ll_eof_n_1_i,
      RX_LL_SRC_RDY_N_1               => rx_ll_src_rdy_n_1_i,
      RX_LL_DST_RDY_N_1               => rx_ll_dst_rdy_n_1_i,
      RX_LL_FIFO_STATUS_1             => open,

      -- Unused Receiver signals - EMAC1
      EMAC1CLIENTRXDVLD               => EMAC1CLIENTRXDVLD,
      EMAC1CLIENTRXFRAMEDROP          => EMAC1CLIENTRXFRAMEDROP,
      EMAC1CLIENTRXSTATS              => EMAC1CLIENTRXSTATS,
      EMAC1CLIENTRXSTATSVLD           => EMAC1CLIENTRXSTATSVLD,
      EMAC1CLIENTRXSTATSBYTEVLD       => EMAC1CLIENTRXSTATSBYTEVLD,

      -- Local link Transmitter Interface - EMAC0
      TX_LL_CLOCK_1                   => ll_clk_1_i,
      TX_LL_RESET_1                   => ll_reset_1_i,
      TX_LL_DATA_1                    => tx_ll_data_1_i,
      TX_LL_SOF_N_1                   => tx_ll_sof_n_1_i,
      TX_LL_EOF_N_1                   => tx_ll_eof_n_1_i,
      TX_LL_SRC_RDY_N_1               => tx_ll_src_rdy_n_1_i,
      TX_LL_DST_RDY_N_1               => tx_ll_dst_rdy_n_1_i,

      -- Unused Transmitter signals - EMAC1
      CLIENTEMAC1TXIFGDELAY           => CLIENTEMAC1TXIFGDELAY,
      EMAC1CLIENTTXSTATS              => EMAC1CLIENTTXSTATS,
      EMAC1CLIENTTXSTATSVLD           => EMAC1CLIENTTXSTATSVLD,
      EMAC1CLIENTTXSTATSBYTEVLD       => EMAC1CLIENTTXSTATSBYTEVLD,

      -- MAC Control Interface - EMAC1
      CLIENTEMAC1PAUSEREQ             => CLIENTEMAC1PAUSEREQ,
      CLIENTEMAC1PAUSEVAL             => CLIENTEMAC1PAUSEVAL,

      --EMAC-MGT link status
      EMAC1CLIENTSYNCACQSTATUS        => EMAC1CLIENTSYNCACQSTATUS,
      -- EMAC0 Interrupt
      EMAC1ANINTERRUPT                => EMAC1ANINTERRUPT,

           
      -- Clock Signals - EMAC1
      -- 1000BASE-X PCS/PMA Interface - EMAC1
      TXP_1                           => TXP_1,
      TXN_1                           => TXN_1,
      RXP_1                           => RXP_1,
      RXN_1                           => RXN_1,
      PHYAD_1                         => PHYAD_1,
      RESETDONE_1                     => resetdone_1_i,

      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs 
      CLK_DS                          => clk_ds,

      -- RocketIO Reset input
      GTRESET                         => gtreset,

        
        
      -- Asynchronous Reset
      RESET                           => reset_i
    );

    ---------------------------------------------------------------------
    --  Instatiate the address swapping module
    ---------------------------------------------------------------------
    client_side_asm_emac0 : address_swap_module_8
      port map (
        rx_ll_clock         => ll_clk_0_i,
        rx_ll_reset         => ll_reset_0_i,
        rx_ll_data_in       => rx_ll_data_0_i,
        rx_ll_sof_in_n      => rx_ll_sof_n_0_i,
        rx_ll_eof_in_n      => rx_ll_eof_n_0_i,
        rx_ll_src_rdy_in_n  => rx_ll_src_rdy_n_0_i,
        rx_ll_data_out      => tx_ll_data_0_i,
        rx_ll_sof_out_n     => tx_ll_sof_n_0_i,
        rx_ll_eof_out_n     => tx_ll_eof_n_0_i,
        rx_ll_src_rdy_out_n => tx_ll_src_rdy_n_0_i,
        rx_ll_dst_rdy_in_n  => tx_ll_dst_rdy_n_0_i
    );

    rx_ll_dst_rdy_n_0_i     <= tx_ll_dst_rdy_n_0_i;


    -- Create synchronous reset in the transmitter clock domain.
    gen_ll_reset_emac0 : process (ll_clk_0_i, reset_i)
    begin
      if reset_i = '1' then
        ll_pre_reset_0_i <= (others => '1');
        ll_reset_0_i     <= '1';
      elsif ll_clk_0_i'event and ll_clk_0_i = '1' then
      if resetdone_0_i = '1' then
        ll_pre_reset_0_i(0)          <= '0';
        ll_pre_reset_0_i(5 downto 1) <= ll_pre_reset_0_i(4 downto 0);
        ll_reset_0_i                 <= ll_pre_reset_0_i(5);
      end if;
      end if;
    end process gen_ll_reset_emac0;
 
    ---------------------------------------------------------------------
    --  Instatiate the address swapping module
    ---------------------------------------------------------------------
    client_side_asm_emac1 : address_swap_module_8
      port map (
        rx_ll_clock         => ll_clk_1_i,
        rx_ll_reset         => ll_reset_1_i,
        rx_ll_data_in       => rx_ll_data_1_i,
        rx_ll_sof_in_n      => rx_ll_sof_n_1_i,
        rx_ll_eof_in_n      => rx_ll_eof_n_1_i,
        rx_ll_src_rdy_in_n  => rx_ll_src_rdy_n_1_i,
        rx_ll_data_out      => tx_ll_data_1_i,
        rx_ll_sof_out_n     => tx_ll_sof_n_1_i,
        rx_ll_eof_out_n     => tx_ll_eof_n_1_i,
        rx_ll_src_rdy_out_n => tx_ll_src_rdy_n_1_i,
        rx_ll_dst_rdy_in_n  => tx_ll_dst_rdy_n_1_i
    );

    rx_ll_dst_rdy_n_1_i     <= tx_ll_dst_rdy_n_1_i;


    -- Create synchronous reset in the transmitter clock domain.
    gen_ll_reset_emac1 : process (ll_clk_1_i, reset_i)
    begin
      if reset_i = '1' then
        ll_pre_reset_1_i <= (others => '1');
        ll_reset_1_i     <= '1';
      elsif ll_clk_1_i'event and ll_clk_1_i = '1' then
      if resetdone_1_i = '1' then
        ll_pre_reset_1_i(0)          <= '0';
        ll_pre_reset_1_i(5 downto 1) <= ll_pre_reset_1_i(4 downto 0);
        ll_reset_1_i                 <= ll_pre_reset_1_i(5);
      end if;
      end if;
    end process gen_ll_reset_emac1;
 



 
end TOP_LEVEL;
