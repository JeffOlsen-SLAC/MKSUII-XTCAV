-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      TestReg -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 5/23/2011 8:51:01 AM
--
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity TestReg is
  Port (
    Clock : in std_logic;
    Reset : in std_logic;

-- Link Interface
    Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr     : in std_logic;  -- From Link Interface
    Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

    RegDataOut : in std_logic_vector(15 downto 0);

    ACC1_FLOW : out std_logic;
    ACC2_FLOW : out std_logic;
    WG1_FLOW  : out std_logic;
    WG2_FLOW  : out std_logic;
    KLY_FLOW  : out std_logic;

    SLED_U_TUNED   : out std_logic;
    SLED_U_DETUNED : out std_logic;
    SLED_M_TUNED   : out std_logic;
    SLED_M_DETUNED : out std_logic;
    SLED_L_TUNED   : out std_logic;
    SLED_L_DETUNED : out std_logic;

    MOD_HV_ON        : out std_logic;
    MOD_FAULT        : out std_logic;
    MOD_EXT_INTLK    : out std_logic;
    MOD_HVOC         : out std_logic;
    MOD_EOLC         : out std_logic;
    MOD_TTOC         : out std_logic;
    MOD_HV_RDY       : out std_logic;
    MOD_AVAIL        : out std_logic;
    MOD_INTLK_COMP   : out std_logic;
    MOD_CTRL_PWR_FLT : out std_logic;
    MOD_VVS_PWR      : out std_logic;
    MOD_KLY_FIL_TD   : out std_logic;


    MAG_I_INTLK : out std_logic;
    MAG_I_OK    : out std_logic;
    MAG_KLIXON  : out std_logic;

    WG_VAC_OK  : out std_logic;
    WG_VAC_BAD : out std_logic;

    LEGACY_WG_VALVE   : out std_logic;
    LEGACY_WGTC_GAUGE : out std_logic;
    LEGACY_MODAVAIL   : out std_logic

    );

end TestReg;

architecture Behavioral of TestReg is

-- Test bits
  signal FlowTestReg : std_logic_vector(9 downto 0);
  signal SLEDTestReg : std_logic_vector(11 downto 0);
  signal ModTestReg  : std_logic_vector(23 downto 0);
  signal MagTestReg  : std_logic_vector(5 downto 0);
  signal WGTestReg   : std_logic_vector(3 downto 0);
  signal LGTestReg   : std_logic_vector(5 downto 0);

  signal FlowBits : std_logic_vector(4 downto 0);
  signal SLEDBits : std_logic_vector(5 downto 0);
  signal ModBits  : std_logic_vector(11 downto 0);
  signal MagBits  : std_logic_vector(3 downto 0);
  signal WGBits   : std_logic_vector(1 downto 0);
  signal LGBits   : std_logic_vector(2 downto 0);

begin

  ACC1_FLOW <= FlowBits(0);
  ACC2_FLOW <= FlowBits(1);
  WG1_FLOW  <= FlowBits(2);
  WG2_FLOW  <= FlowBits(3);
  KLY_FLOW  <= FlowBits(4);

  SLED_U_DETUNED <= SLEDBits(0);
  SLED_U_TUNED   <= SLEDBits(1);
  SLED_L_DETUNED <= SLEDBits(2);
  SLED_L_TUNED   <= SLEDBits(3);
  SLED_M_DETUNED <= SLEDBits(4);
  SLED_M_TUNED   <= SLEDBits(5);

  MOD_HV_ON        <= ModBits(0);
  MOD_FAULT        <= ModBits(1);
  MOD_EXT_INTLK    <= ModBits(2);
  MOD_HVOC         <= ModBits(3);
  MOD_EOLC         <= ModBits(4);
  MOD_TTOC         <= ModBits(5);
  MOD_HV_RDY       <= ModBits(6);
  MOD_AVAIL        <= ModBits(7);
  MOD_INTLK_COMP   <= ModBits(8);
  MOD_CTRL_PWR_FLT <= ModBits(9);
  MOD_KLY_FIL_TD   <= ModBits(10);
  MOD_VVS_PWR      <= ModBits(11);


  MAG_I_INTLK <= MagBits(0);
  MAG_I_OK    <= MagBits(1);
  MAG_KLIXON  <= MagBits(2);

  WG_VAC_BAD <= WGBits(0);
  WG_VAC_OK  <= WGBits(1);

  LEGACY_WG_VALVE   <= LGBits(0);
  LEGACY_WGTC_GAUGE <= LGBits(1);
  LEGACY_MODAVAIL   <= LGBits(2);

  WrReg : process(Clock, Reset)
  Begin
    if (reset = '1') then
      FlowTestReg <= (Others => '0');
      SLEDTestReg <= (Others => '0');
      ModTestReg  <= (Others => '0');
      MagTestReg  <= (Others => '0');
      WGTestReg   <= (Others => '0');
      LGTestReg   <= (Others => '0');
      FlowBits    <= (Others => '0');
      SLEDBits    <= (Others => '0');
      ModBits     <= (Others => '0');
      MagBits     <= (Others => '0');
      WGBits      <= (Others => '0');
      LGBits      <= (Others => '0');

    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        Case Lnk_Addr(3 downto 0) is
          when x"0" =>
            FlowTestReg <= Lnk_DataIn(9 downto 0);
            for i in 0 to 4 loop
              if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                    FlowBits(i) <= '1';
                  elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                         FlowBits(i) <= '0';
                         end if;
                         end loop;

                         when x"1" =>
                         SLEDTestReg <= Lnk_DataIn(5 downto 0);
                         for i in 0 to 2 loop
                           if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                 SLEDBits(i) <= '1';
                               elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                      SLEDBits(i) <= '0';
                                      end if;
                                      end loop;

                                      when x"2" =>
                                      ModTestReg(15 downto 0) <= Lnk_DataIn(15 downto 0);
                                      for i in 0 to 7 loop
					if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                              MODBits(i) <= '1';
                                            elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                                   MODBits(i) <= '0';
                                                   end if;
                                                   end loop;

                                                   when x"3" =>
                                                   ModTestReg(23 downto 16) <= Lnk_DataIn(7 downto 0);
                                                   for i in 0 to 3 loop
                                                     if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                                           MODBits(i+8) <= '1';
                                                         elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                                                MODBits(i+8) <= '0';
                                                                end if;
                                                                end loop;

                                                                when x"4" =>
                                                                MagTestReg <= Lnk_DataIn(5 downto 0);
                                                                for i in 0 to 2 loop
                                                                  if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                                                        MagBits(i) <= '1';
                                                                      elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                                                             MagBits(i) <= '0';
                                                                             end if;
                                                                             end loop;

                                                                             when x"5" =>
                                                                             WGTestReg <= Lnk_DataIn(3 downto 0);
                                                                             for i in 0 to 1 loop
                                                                               if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                                                                     WGBits(i) <= '1';
                                                                                   elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                                                                          WGBits(i) <= '0';
                                                                                          end if;

                                                                                          when x"6" =>
                                                                                          LGTestReg <= Lnk_DataIn(5 downto 0);
                                                                                          for i in 0 to 2 loop
                                                                                            if (Lnk_DataIn((i*2)+1 downto i*2) = "01" then
                                                                                                  LGBits(i) <= '1';
                                                                                                elsif (Lnk_DataIn((i*2)+1 downto i*2) = "10"
                                                                                                       LGBits(i) <= '0';
                                                                                                       end if;
                                                                                                       end loop;

                                                                                                       when others =>
                                                                                                       end case;
                                                                                                       end if;
                                                                                                       end process;


                                                                                                       RdREg : process(Lnk_Rd, FlowTestReg, SLEDTestReg, ModTestReg, MagTestReg, WGTestReg, LGTestReg)
                                                                                                       Begin
                                                                                                         Case Lnk_Addr(3 downto 0) is
                                                                                                           when x"0" => RegDataOut <= "000000" & FlowTestReg;
                                                                                                           when x"1" => RegDataOut <= "0000000000" & SLEDTestReg;
                                                                                                           when x"2" => RegDataOut <= ModTestReg(15 downto 0);
                                                                                                           when x"3" => RegDataOut <= "00000000" & ModTestReg(23 downto 16);
                                                                                                           when x"4" => RegDataOut <= "0000000000" & MagTestReg;
                                                                                                           when x"5" => RegDataOut <= "000000000000" & WGTestReg;
                                                                                                           when x"6" => RegDataOut <= "0000000000" & LGTestReg;
                                                                                                           when others =>
                                                                                                         end case;
                                                                                                       end process;



