library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity FastDiffIn is
  port (
    Clock  : in  std_logic;
    Reset  : in  std_logic;
    Din_P  : in  std_logic;
    Din_N  : in  std_logic;
    QOut_1 : out std_logic;
    QOut_2 : out std_logic
    );
end FastDiffIn;

architecture Behavioral of FastDiffIn is

  signal Sdin  : std_logic;
  signal SdOut : std_logic;

begin
  u_ibufds : IBUFDS
    generic map (
      IOSTANDARD => "DEFAULT"
      )
    port map (
      I  => Din_P,  -- Diff_p buffer input (connect directly to top-level port)
      IB => Din_N,  -- Diff_n buffer input (connect directly to top-level port)
      O  => SDOut                       -- Buffer output
      );

-- IODELAY: Input and/or Output Fixed/Variable Delay Element
-- Virtex-5
-- Xilinx HDL Libraries Guide, version 13.1
  BeamVibufds_IODELAY : IODELAY
    generic map (
      DELAY_SRC             => "I",     -- Specify which input port to be used
                               -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
      HIGH_PERFORMANCE_MODE => true,    -- TRUE specifies lower jitter
                                        -- at expense of more power
      IDELAY_TYPE           => "DEFAULT",  -- "FIXED" or "VARIABLE"
      IDELAY_VALUE          => 0,       -- 0 to 63 tap values
      ODELAY_VALUE          => 0,       -- 0 to 63 tap values
      REFCLK_FREQUENCY      => 200.0,   -- Frequency used for IDELAYCTRL
                                        -- 175.0 to 225.0
      SIGNAL_PATTERN        => "DATA"
      )                                 -- Input signal type, "CLOCK" or "DATA"
    port map (
      DATAOUT => SDIn,                  -- 1-bit delayed data output
      C       => '0',                   -- 1-bit clock input
      CE      => '0',                   -- 1-bit clock enable input
      DATAIN  => '0',                   -- 1-bit internal data input
      IDATAIN => SDOut,  -- 1-bit input data input (connect to port)
      INC     => '0',                   -- 1-bit increment/decrement input
      ODATAIN => '0',                   -- 1-bit output data input
      RST     => '0',                   -- 1-bit active high, synch reset input
      T       => '1'                    -- 1-bit 3-state control input
      );

  BEAM_Viddr : IDDR
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",  -- "OPPOSITE_EDGE", "SAME_EDGE"
                                              -- or "SAME_EDGE_PIPELINED"
      INIT_Q1      => '0',              -- Initial value of Q1: '0' or '1'
      INIT_Q2      => '0',              -- Initial value of Q2: '0' or '1'
      SRTYPE       => "SYNC"            -- Set/Reset type: "SYNC" or "ASYNC"
      )
    port map (
      Q1 => Qout_1,           -- 1-bit output for positive edge of clock
      Q2 => QOut_2,           -- 1-bit output for negative edge of clock
      C  => Clock,                      -- 1-bit clock input
      CE => '1',                        -- 1-bit clock enable input
      D  => SDIn,                       -- 1-bit DDR data input
      R  => Reset,                      -- 1-bit reset
      S  => '0'                         -- 1-bit set
      );
end;
