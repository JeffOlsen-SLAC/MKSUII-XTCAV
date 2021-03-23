-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      Pulse_Delay16.vhd -
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

entity pulse_delay16 is
  port (
    Clock     : in  std_logic;
    Reset     : in  std_logic;
    TriggerIn : in  std_logic;
    Delay     : in  std_logic_vector(15 downto 0);
    Pulse     : out std_logic
    );
end pulse_delay16;

architecture Behaviour of pulse_delay16 is

  type delay_t is
    (
      delayIdle,
      delayWait,
      delayWaitFall,
      delayOut
      );

  signal DelayState : delay_t;

  signal Counter   : std_logic_vector(15 downto 0);
  signal WidthCntr : std_logic_vector(15 downto 0);
  signal Width     : std_logic_vector(15 downto 0);
  signal TrigSr    : std_logic_vector(1 downto 0);


  signal DelayPulse : std_logic;

begin

  Pulse <= DelayPulse;

  DelayandPulse : process(CLock, Reset)
  begin

    if (Reset = '1') then
      DelayPulse <= '0';
      Counter    <= (others => '0');
      TrigSr     <= (others => '0');
      DelayState <= DelayIdle;
      WidthCntr  <= (others => '0');
      Width      <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      TrigSr <= TrigSr(0) & TriggerIn;
      case DelayState is
        when DelayIdle =>
          if (TrigSr = "01") then
            WidthCntr <= (others => '0');
            if (Delay = X"0000") then
              Counter    <= (others => '0');
              DelayPulse <= '1';
              DelayState <= delayWaitFall;
            else
              Counter    <= Delay -1;
              DelayState <= DelayWait;
            end if;
          else
            DelayState <= DelayIdle;
          end if;

        when DelayWait =>
          if (Counter = X"0000") then
            DelayPulse <= '1';
            Counter    <= Delay - 1;
            DelayState <= DelayWaitFall;
          else
            WidthCntr  <= WidthCntr + 1;
            Counter    <= Counter -1;
            DelayState <= DelayWait;
            if (TrigSr = "10") then
              Width <= WidthCntr;
            end if;
          end if;

        when DelayWaitFall =>
          if (TrigSr = "00") then
            if (Counter = x"0000") then
              DelayPulse <= '0';
              DelayState <= DelayIdle;
            else
              Counter    <= Width;
              DelayState <= DelayOut;
            end if;
          elsif (TrigSr = "10") then
            if (Delay = x"0000") then
              DelayPulse <= '0';
              DelayState <= DelayIdle;
            else
              DelayState <= DelayOut;
            end if;
          else
            DelayState <= DelayWaitFall;
          end if;

        when DelayOut =>
          if (Counter = x"0000") then
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
