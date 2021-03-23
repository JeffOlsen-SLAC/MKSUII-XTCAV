-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      prog_strobe.vhd - 
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 08/23/05 
--      Last change: JO 5/23/2011 8:50:59 AM
--
-- 
-- Created by Jeff Olsen 08/23/05
--
--  Filename: prog_strobe.vhd
--
--  Function:
--  Generate delayed  Pulse
--
--  Modifications:
--  04/21/06 jjo
--  Changed to 24 bit registers
--  Use only 1 counter for both delay and width
--



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity prog_strobe is
  port (
    Clock     : in  std_logic;
    Reset     : in  std_logic;
    TriggerIn : in  std_logic;
    Delay     : in  std_logic_vector(19 downto 0);
    Width     : in  std_logic_vector(19 downto 0);
    Pulse     : out std_logic
    );
end prog_strobe;

architecture Behaviour of prog_strobe is

  type delay_t is
    (
      delayIdle,
      delayWait,
      delayOut
      );

  signal DelayState : delay_t;

  signal Counter : std_logic_vector(19 downto 0);
  signal iWidth  : std_logic_vector(19 downto 0);

  signal DelayPulse : std_logic;

begin

  Pulse <= DelayPulse;

  DelayandPulse : process(CLock, Reset)
  begin

    if (Reset = '1') then
      DelayPulse <= '0';
      Counter    <= (others => '0');
      iWidth     <= (others => '0');
      DelayState <= DelayIdle;
    elsif (Clock'event and Clock = '1') then
      case DelayState is
        when DelayIdle =>
          if (TriggerIn = '1') then
            if (Width = X"00000") then
              DelayPulse <= '0';
              DelayState <= DelayIdle;
            elsif (Delay = X"00000") then
              DelayPulse <= '1';
              Counter    <= Width -1;
              iWidth     <= Width -1;
              DelayState <= DelayOut;
            else
              Counter    <= Delay -1;
              DelayState <= DelayWait;
            end if;
          else
            DelayState <= DelayIdle;
          end if;

        when DelayWait =>
          if (Counter = X"00000") then
            DelayPulse <= '1';
            Counter    <= iWidth;
            DelayState <= DelayOut;
          else
            Counter    <= Counter -1;
            DelayState <= DelayWait;
          end if;

        when DelayOut =>
          if (Counter = X"00000") then
            DelayPulse <= '0';
            DelayState <= DelayIdle;
          else
            Counter    <= Counter -1;
            DelayState <= DelayOut;
          end if;

        when others =>
          DelayState <= DelayIdle;

      end case;
    end if;
  end process;  --DelayandPulse

end Behaviour;
