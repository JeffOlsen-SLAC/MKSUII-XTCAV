------------------------------------------------------------------------
-- Title      : Demo testbench
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : demo_tb.vhd
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
------------------------------------------------------------------------
-- Description: This testbench will exercise the PHY ports of the EMAC
--              to demonstrate the functionality.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end testbench;


architecture behavioral of testbench is


  ----------------------------------------------------------------------
  -- Component Declaration for GBit2_example_design
  --                           (the top level EMAC example deisgn)
  ----------------------------------------------------------------------
  component GBit2_example_design
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

        -- Clock Signal - EMAC0

        -- 1000BASE-X PCS/PMA Interface - EMAC0
        TXP_0                           : out std_logic;
        TXN_0                           : out std_logic;
        RXP_0                           : in  std_logic;
        RXN_0                           : in  std_logic;
        PHYAD_0                         : in  std_logic_vector(4 downto 0); 
        EMAC0CLIENTSYNCACQSTATUS        : out std_logic;              
        EMAC0ANINTERRUPT                : out std_logic;


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

        -- Clock Signal - EMAC1

        -- 1000BASE-X PCS/PMA Interface - EMAC1
        TXP_1                           : out std_logic;
        TXN_1                           : out std_logic;
        RXP_1                           : in  std_logic;
        RXN_1                           : in  std_logic;
        PHYAD_1                         : in  std_logic_vector(4 downto 0); 
        EMAC1CLIENTSYNCACQSTATUS        : out std_logic;
        EMAC1ANINTERRUPT                : out std_logic;

        MGTCLK_P                        : in  std_logic;
        MGTCLK_N                        : in  std_logic;        




        -- Asynchronous Reset
        RESET                           : in  std_logic
        );
  end component;


  component configuration_tb is
    port(
      reset                       : out std_logic;
      ------------------------------------------------------------------
      -- Host Interface: host_clk is always required
      ------------------------------------------------------------------
      host_clk                    : out std_logic;

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      sync_acq_status_0           : in  std_logic;
      sync_acq_status_1           : in  std_logic;

      emac0_configuration_busy    : out boolean;
      emac0_monitor_finished_1g   : in  boolean;
      emac0_monitor_finished_100m : in  boolean;
      emac0_monitor_finished_10m  : in  boolean;

      emac1_configuration_busy    : out boolean;
      emac1_monitor_finished_1g   : in  boolean;
      emac1_monitor_finished_100m : in  boolean;
      emac1_monitor_finished_10m  : in  boolean

      );
  end component;


  ----------------------------------------------------------------------
  -- Component Declaration for the EMAC0 PHY stimulus and monitor
  ----------------------------------------------------------------------

  component emac0_phy_tb is
    port(
      clk125m                 : in std_logic;

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     : in  std_logic;
      txn                     : in  std_logic;
      rxp                     : out std_logic;
      rxn                     : out std_logic; 

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      : in  boolean;
      monitor_finished_1g     : out boolean;
      monitor_finished_100m   : out boolean;
      monitor_finished_10m    : out boolean
      );
  end component;



  ----------------------------------------------------------------------
  -- Component Declaration for the EMAC1 PHY stimulus and monitor
  ----------------------------------------------------------------------

  component emac1_phy_tb is
    port(
      clk125m                 : in std_logic;

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     : in  std_logic;
      txn                     : in  std_logic;
      rxp                     : out std_logic;
      rxn                     : out std_logic; 

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      : in  boolean;
      monitor_finished_1g     : out boolean;
      monitor_finished_100m   : out boolean;
      monitor_finished_10m    : out boolean
      );
  end component;


  ----------------------------------------------------------------------
  -- testbench signals
  ----------------------------------------------------------------------
    signal reset                : std_logic                     := '1';

    -- EMAC0
    signal tx_client_clk_0      : std_logic;
    signal tx_ifg_delay_0       : std_logic_vector(7 downto 0)  := (others => '0'); -- IFG stretching not used in demo.
    signal rx_client_clk_0      : std_logic;
    signal pause_val_0          : std_logic_vector(15 downto 0) := (others => '0');
    signal pause_req_0          : std_logic                     := '0';

    -- 1000BASE-X PCS/PMA Signals
    signal txp_0                : std_logic;
    signal txn_0                : std_logic;
    signal rxp_0                : std_logic;
    signal rxn_0                : std_logic;
    signal sync_acq_status_0    : std_logic;
    signal phyad_0              : std_logic_vector(4 downto 0);

 
    -- EMAC1
    signal tx_client_clk_1      : std_logic;
    signal tx_ifg_delay_1       : std_logic_vector(7 downto 0)  := (others => '0'); -- IFG stretching not used in demo.
    signal rx_client_clk_1      : std_logic;
    signal pause_val_1          : std_logic_vector(15 downto 0) := (others => '0');
    signal pause_req_1          : std_logic                     := '0';

    -- 1000BASE-X PCS/PMA Signals
    signal txp_1                : std_logic;
    signal txn_1                : std_logic;
    signal rxp_1                : std_logic;
    signal rxn_1                : std_logic;
    signal sync_acq_status_1    : std_logic;
    signal phyad_1              : std_logic_vector(4 downto 0);    


    -- Clock signals
    signal host_clk             : std_logic                     := '0';
    signal gtx_clk              : std_logic;

    signal mgtclk_p             : std_logic := '0';   
    signal mgtclk_n             : std_logic := '1';

    ------------------------------------------------------------------
    -- Test Bench Semaphores
    ------------------------------------------------------------------
    signal emac0_configuration_busy    : boolean := false;
    signal emac0_monitor_finished_1g   : boolean := false;
    signal emac0_monitor_finished_100m : boolean := false;
    signal emac0_monitor_finished_10m  : boolean := false;

    signal emac1_configuration_busy    : boolean := false;
    signal emac1_monitor_finished_1g   : boolean := false;
    signal emac1_monitor_finished_100m : boolean := false;
    signal emac1_monitor_finished_10m  : boolean := false;


begin


  ----------------------------------------------------------------------
  -- Wire up Device Under Test
  ----------------------------------------------------------------------
  dut : GBit2_example_design
  port map (
    -- Client Receiver Interface - EMAC0
    EMAC0CLIENTRXDVLD               => open,
    EMAC0CLIENTRXFRAMEDROP          => open,
    EMAC0CLIENTRXSTATS              => open,
    EMAC0CLIENTRXSTATSVLD           => open,
    EMAC0CLIENTRXSTATSBYTEVLD       => open,

    -- Client Transmitter Interface - EMAC0
    CLIENTEMAC0TXIFGDELAY           => tx_ifg_delay_0,
    EMAC0CLIENTTXSTATS              => open,
    EMAC0CLIENTTXSTATSVLD           => open,
    EMAC0CLIENTTXSTATSBYTEVLD       => open,

    -- MAC Control Interface - EMAC0
    CLIENTEMAC0PAUSEREQ             => pause_req_0,
    CLIENTEMAC0PAUSEVAL             => pause_val_0,

    EMAC0CLIENTSYNCACQSTATUS        => sync_acq_status_0,
    EMAC0ANINTERRUPT                => open,

    -- 1000BASE-X PCS/PMA Interface - EMAC0
    TXP_0                           => txp_0,
    TXN_0                           => txn_0,
    RXP_0                           => rxp_0,
    RXN_0                           => rxn_0,
    PHYAD_0                         => phyad_0, 
           
    -- Client Receiver Interface - EMAC1
    EMAC1CLIENTRXDVLD               => open,
    EMAC1CLIENTRXFRAMEDROP          => open,
    EMAC1CLIENTRXSTATS              => open,
    EMAC1CLIENTRXSTATSVLD           => open,
    EMAC1CLIENTRXSTATSBYTEVLD       => open,

    -- Client Transmitter Interface - EMAC1
    CLIENTEMAC1TXIFGDELAY           => tx_ifg_delay_1,
    EMAC1CLIENTTXSTATS              => open,
    EMAC1CLIENTTXSTATSVLD           => open,
    EMAC1CLIENTTXSTATSBYTEVLD       => open,

    -- MAC Control Interface - EMAC1								   
    CLIENTEMAC1PAUSEREQ             => pause_req_1,
    CLIENTEMAC1PAUSEVAL             => pause_val_1,

    EMAC1CLIENTSYNCACQSTATUS        => sync_acq_status_1,
    EMAC1ANINTERRUPT                => open,

    -- 1000BASE-X PCS/PMA Interface - EMAC1
    TXP_1                           => txp_1,
    TXN_1                           => txn_1,
    RXP_1                           => rxp_1,
    RXN_1                           => rxn_1,
    PHYAD_1                         => phyad_1,
       
    MGTCLK_P                        =>  mgtclk_p,   
    MGTCLK_N                        =>  mgtclk_n,
    


        
    -- Asynchronous Reset
    RESET                           => reset
    );


    ----------------------------------------------------------------------------
    -- Flow Control is unused in this demonstration
    ----------------------------------------------------------------------------
    pause_req_0 <= '0';
    pause_val_0 <= "0000000000000000";
    pause_req_1 <= '0';
    pause_val_1 <= "0000000000000000";




    -- Tie-off EMAC0 PHY address to a default value
    phyad_0 <= "00001";
    -- Tie-off EMAC1 PHY address to a default value
    phyad_1 <= "00010";

    ----------------------------------------------------------------------------
    -- Clock drivers
    ----------------------------------------------------------------------------

    -- Drive GTX_CLK at 125 MHz
    p_gtx_clk : process 
    begin
        gtx_clk <= '0';
        wait for 10 ns;
        loop
            wait for 4 ns;
            gtx_clk <= '1';
            wait for 4 ns;
            gtx_clk <= '0';
        end loop;
    end process p_gtx_clk;



    -- Drive Gigabit Transceiver differential clock with 125MHz
    mgtclk_p <= gtx_clk;
    mgtclk_n <= not gtx_clk;

  ----------------------------------------------------------------------
  -- Instantiate the EMAC0 PHY stimulus and monitor
  ----------------------------------------------------------------------

  phy0_test: emac0_phy_tb
    port map (
      clk125m                 => gtx_clk,

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     => txp_0,
      txn                     => txn_0,
      rxp                     => rxp_0,
      rxn                     => rxn_0, 

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      => emac0_configuration_busy,
      monitor_finished_1g     => emac0_monitor_finished_1g,
      monitor_finished_100m   => emac0_monitor_finished_100m,
      monitor_finished_10m    => emac0_monitor_finished_10m
      );



  ----------------------------------------------------------------------
  -- Instantiate the EMAC1 PHY stimulus and monitor
  ----------------------------------------------------------------------

  phy1_test: emac1_phy_tb
    port map (
      clk125m                 => gtx_clk,

      ------------------------------------------------------------------
      -- GMII Interface
      ------------------------------------------------------------------
      txp                     => txp_1,
      txn                     => txn_1,
      rxp                     => rxp_1,
      rxn                     => rxn_1, 

      ------------------------------------------------------------------
      -- Test Bench Semaphores
      ------------------------------------------------------------------
      configuration_busy      => emac1_configuration_busy,
      monitor_finished_1g     => emac1_monitor_finished_1g,
      monitor_finished_100m   => emac1_monitor_finished_100m,
      monitor_finished_10m    => emac1_monitor_finished_10m
      );



  
  ----------------------------------------------------------------------
  -- Instantiate the No-Host Configuration Stimulus
  ----------------------------------------------------------------------

  config_test: configuration_tb
    port map (
      reset                       => reset,
      ------------------------------------------------------------------
      -- Host Interface: host_clk is always required
      ------------------------------------------------------------------
      host_clk                    => host_clk,

      sync_acq_status_0           => sync_acq_status_0,
      sync_acq_status_1           => sync_acq_status_1,

      emac0_configuration_busy    => emac0_configuration_busy,
      emac0_monitor_finished_1g   => emac0_monitor_finished_1g,
      emac0_monitor_finished_100m => emac0_monitor_finished_100m,
      emac0_monitor_finished_10m  => emac0_monitor_finished_10m,

      emac1_configuration_busy    => emac1_configuration_busy,
      emac1_monitor_finished_1g   => emac1_monitor_finished_1g,
      emac1_monitor_finished_100m => emac1_monitor_finished_100m,
      emac1_monitor_finished_10m  => emac1_monitor_finished_10m 

      );



end behavioral;

