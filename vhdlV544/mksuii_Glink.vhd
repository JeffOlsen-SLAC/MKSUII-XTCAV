-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	MKSUII_GLink.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: Jeff Olsen
--	Created on: 12/20/2007 9:07:06 AM
--	Last change: JO 3/23/2010 11:31:37 AM
--
-- Glink Control
-- Connectes my GLINK Iterfacer to the TMEC Local Link fifo


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
Library work;
use work.mksuii.all;


entity MKSUII_GLink is
port (
	Reset 					: in std_logic;
	Clock						: in std_logic;
	
	Lnk_Clk					: out std_logic;
	Active					: out std_logic;
	Lnk_Error				: out std_logic;		

	Lnk_Locked				: out std_logic;

	Lnk_DataOut				: out  std_logic_vector(7 downto 0);
	Lnk_DataStrb			: out  std_logic;
	Lnk_MessType			: out  std_logic_vector(7 downto 0);
	Lnk_MessStrb			: out  std_logic;
	Lnk_TaskId				: out  std_logic_vector(7 downto 0);

-- Tx Data
	Tx_Start					: in std_logic;
	Tx_MessType				: in std_logic_vector(7 downto 0);		-- Transmit message type
	Tx_TaskId				: in  std_logic_vector(7 downto 0);
	Tx_Count					: in std_logic_vector(15 downto 0);		-- Number of byte of data
	Tx_Data_In	     		: in std_logic_vector(7 downto 0);		-- Data from external memory or registers
	Tx_Done					: in std_logic;
	Tx_Rdy					: out std_logic;

-- Brd_Id used as LSByte of EMAC and IP Address and UDP Link Node ID
	BRD_ID					: in std_logic_vector(7 downto 0);


--EMAC-MGT link status
 
-- 1000BASE-X PCS/PMA Interface - EMAC0
	TXP_0						: out std_logic;
	TXN_0						: out std_logic;
	RXP_0						: in  std_logic;
	RXN_0						: in  std_logic;

-- unused transceiver
	TXN_1_UNUSED			: out std_logic;
	TXP_1_UNUSED			: out std_logic;
	RXN_1_UNUSED			: in  std_logic;
	RXP_1_UNUSED			: in  std_logic;
-- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs
	MGTCLK_P					: in  std_logic;
	MGTCLK_N					: in  std_logic
);

end MKSUII_GLink;

architecture Behavioral of MKSUII_GLink is

signal ll_reset_0_i 			: std_logic;
signal ll_clk_0_i   			: std_logic;
signal rx_ll_data_0_i		: std_logic_vector(7 downto 0);
signal rx_ll_sof_n_0_i 		: std_logic;
signal rx_ll_eof_n_0_i 		: std_logic;
signal rx_ll_src_rdy_n_0_i : std_logic;
signal rx_ll_dst_rdy_n_0_i : std_logic;

signal tx_ll_data_0_i		: std_logic_vector(7 downto 0);
signal tx_ll_sof_n_0_i 		: std_logic;
signal tx_ll_eof_n_0_i 		: std_logic;
signal tx_ll_src_rdy_n_0_i : std_logic;
signal tx_ll_dst_rdy_n_0_i : std_logic;

signal resetdone_0_i 		: std_logic;
signal ll_pre_reset_0_i    : std_logic_vector(5 downto 0);
signal Clk_DS	 				: std_logic;
signal Clk125_o	 			: std_logic;
signal Clk125		 			: std_logic;
signal clk125_x		 		: std_logic;
signal Clk250Mhz		 		: std_logic;

Begin

u_intf : glink_intf
Port Map (
	Clock					=> Clock,
	Reset 				=> Reset,

--Register stuff
	Active				=> Active,
	Lnk_Error			=> Lnk_Error,
	

	Lnk_DataOut			=> Lnk_DataOut,
	Lnk_DataStrb		=> Lnk_DataStrb,
	Lnk_MessType		=> Lnk_MessType,
	Lnk_MessStrb		=> Lnk_MessStrb,
	Lnk_TaskID			=> Lnk_TaskID,


-- Tx Data
	Tx_Start				=> Tx_Start,
	Tx_MessType			=> Tx_MessType,
	Tx_TaskID			=> Tx_TaskID,

	Tx_Data_In	     	=> Tx_Data_In,
	Tx_Count				=> Tx_Count,
	Tx_Done				=> Tx_Done,
	Tx_Rdy				=> Tx_Rdy,

-- Board ID from Dip Switches
-- Used as LSByte of the EMAC and IP Address
	Brd_ID				=> Brd_ID,


-- Local Link Fifo
-- Local link Receiver Interface - EMAC0
	RX_LL_DATA			=> rx_ll_data_0_i,
	RX_LL_SOF_N			=> rx_ll_sof_n_0_i,
	RX_LL_EOF_N			=> rx_ll_eof_n_0_i,
	RX_LL_SRC_RDY_N	=> rx_ll_src_rdy_n_0_i,
	RX_LL_DST_RDY_N	=> rx_ll_dst_rdy_n_0_i,

-- Local link Transmitter Interface - EMAC0
	TX_LL_DATA		   => tx_ll_data_0_i,
	TX_LL_SOF_N			=> tx_ll_sof_n_0_i,
	TX_LL_EOF_N			=> tx_ll_eof_n_0_i,
	TX_LL_SRC_RDY_N	=> tx_ll_src_rdy_n_0_i,
	TX_LL_DST_RDY_N	=> tx_ll_dst_rdy_n_0_i

);

    ---------------------------------------------------------------------------
    -- Reset Input Buffer
    ---------------------------------------------------------------------------

    -- EMAC0 Clocking

    -- Generate the clock input to the GTP
    -- clk_ds can be shared between multiple MAC instances.
    clkingen : IBUFDS port map (
      I  => MGTCLK_P,
      IB => MGTCLK_N,
      O  => Clk_Ds);


    -- 125MHz from transceiver is routed through a BUFG and 
    -- input to the MAC wrappers.
    -- This clock can be shared between multiple MAC instances.
    bufg_clk125 : BUFG port map (I => clk125_o, O => clk125_x);

	clk125		<= clk125_x;
	Lnk_Clk 		<= clk125_x;
	ll_clk_0_i 	<= clk125_x;

    ------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper with LL FIFO 
    -- (gbit_locallink.v)
    ------------------------------------------------------------------------
    v5_emac_ll : gigabit_locallink
    port map (
      -- EMAC0 Clocking
      -- 125MHz clock output from transceiver
      CLK125_OUT                      => clk125_o,
      -- 125MHz clock input from BUFG
      CLK125                          => clk125_x,

      -- Local link Receiver Interface - EMAC0
 --     RX_LL_CLOCK_0                   => ll_clk_0_i,
      RX_LL_CLOCK_0                   => Clock,
      RX_LL_RESET_0                   => ll_reset_0_i,
      RX_LL_DATA_0                    => rx_ll_data_0_i,
      RX_LL_SOF_N_0                   => rx_ll_sof_n_0_i,
      RX_LL_EOF_N_0                   => rx_ll_eof_n_0_i,
      RX_LL_SRC_RDY_N_0               => rx_ll_src_rdy_n_0_i,
      RX_LL_DST_RDY_N_0               => rx_ll_dst_rdy_n_0_i,
      RX_LL_FIFO_STATUS_0             => open,

      -- Local link Transmitter Interface - EMAC0
--      TX_LL_CLOCK_0                   => ll_clk_0_i,
      TX_LL_CLOCK_0                   => Clock,
      TX_LL_RESET_0                   => ll_reset_0_i,
      TX_LL_DATA_0                    => tx_ll_data_0_i,
      TX_LL_SOF_N_0                   => tx_ll_sof_n_0_i,
      TX_LL_EOF_N_0                   => tx_ll_eof_n_0_i,
      TX_LL_SRC_RDY_N_0               => tx_ll_src_rdy_n_0_i,
      TX_LL_DST_RDY_N_0               => tx_ll_dst_rdy_n_0_i,
 
      --EMAC-MGT link status
      
      CLIENTEMAC0TXIFGDELAY          	=> X"00",
		CLIENTEMAC0PAUSEREQ   				=> '0',
		CLIENTEMAC0PAUSEVAL   				=> X"0000",
		EMAC0CLIENTSYNCACQSTATUS			=> Lnk_Locked,

      -- Clock Signals - EMAC0
      -- 1000BASE-X PCS/PMA Interface - EMAC0
      TXP_0                           => TXP_0,
      TXN_0                           => TXN_0,
      RXP_0                           => RXP_0,
      RXN_0                           => RXN_0,
      PHYAD_0                         => "00001", 
      RESETDONE_0                     => resetdone_0_i,

      -- unused transceiver
      TXN_1_UNUSED                    => TXN_1_UNUSED,
      TXP_1_UNUSED                    => TXP_1_UNUSED,
      RXN_1_UNUSED                    => RXN_1_UNUSED,
      RXP_1_UNUSED                    => RXP_1_UNUSED,

      -- 1000BASE-X PCS/PMA RocketIO Reference Clock buffer inputs
      CLK_DS                         => Clk_Ds,


      -- Asynchronous Reset
      RESET                           => Reset

    );

    -- Create synchronous reset in the transmitter clock domain.
--    gen_ll_reset_emac0 : process (ll_clk_0_i, reset)
    gen_ll_reset_emac0 : process (clock, reset)
    begin
      if reset = '1' then
        ll_pre_reset_0_i <= (others => '1');
        ll_reset_0_i     <= '1';
      elsif clock'event and clock = '1' then
      if resetdone_0_i = '1' then
        ll_pre_reset_0_i(0)          <= '0';
        ll_pre_reset_0_i(5 downto 1) <= ll_pre_reset_0_i(4 downto 0);
        ll_reset_0_i                 <= ll_pre_reset_0_i(5);
      end if;
      end if;
    end process gen_ll_reset_emac0;

end Behavioral;


