-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      ModCmd -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 8/5/2011 3:09:29 PM
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;

library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity LegacyModCmd is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

-- Link Interface
    Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr     : in std_logic;                      -- From Link Interface
    Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

    Reg_DataOut : out std_logic_vector(15 downto 0);

    WG_TCGuage_Mon : in std_logic;
    WG_Valve_MON   : in std_logic;
    Avail_MON      : in std_logic;


    WG_TCGuage_Test : out std_logic;
    WG_Valve_Test   : out std_logic;
    Avail_Test      : out std_logic;

    Status : out std_logic_vector(15 downto 0)

    );

end LegacyModCmd;

architecture behaviour of LegacyModCmd is

  signal TestReg : std_logic_vector(15 downto 0);
  signal iStatus : std_logic_vector(15 downto 0);

begin

  WG_TCGuage_Test <= TestReg(2);
  WG_Valve_Test   <= TestReg(1);
  Avail_Test      <= TestReg(0);

  Status <= iStatus;

  istatus(15 downto 3) <= (others => '0');
  istatus(2)           <= not(WG_TCGuage_Mon);
  istatus(1)           <= not(WG_Valve_MON);
  istatus(0)           <= not(Avail_MON);

  WrReg : process(Clock, Reset)
  begin
    if (reset = '1') then
      TestReg <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        case Lnk_Addr is
          when x"0003" =>
            TestReg(2 downto 0) <= Lnk_DataIn(2 downto 0) or TestReg(2 downto 0);

          when x"0004" =>
            TestReg(2 downto 0) <= not(Lnk_DataIn(2 downto 0)) and TestReg(2 downto 0);

          when others =>
        end case;
      end if;
    end if;
  end process;

  Rd_Reg : process(Lnk_Addr, TestReg, iStatus)
  begin
    case Lnk_Addr(3 downto 0) is
      when x"0"   => Reg_DataOut <= iStatus;
      when x"2"   => Reg_DataOut <= TestReg;
      when others => Reg_DataOut <= (others => '0');
    end case;
  end process;


end behaviour;
