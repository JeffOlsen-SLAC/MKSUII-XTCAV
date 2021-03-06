                                        -----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      max1308Intf.vhd - 
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 2/7/2011 4:03:54 PM
--      Last change: JO 2/7/2011 4:46:47 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:42:26 12/11/2008 
-- Design Name: 
-- Module Name:    Max1308
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;

--Library work;
--use work.mpsnode.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Max1308Intf is
  port (
    Clock   : in  std_logic;
    reset   : in  std_logic;
    ClkEn   : in  std_logic;
    Start   : in  std_logic;
-- ADC Control and Data
    Wr      : out std_logic;
    Cs      : out std_logic;
    Rd      : out std_logic;
    Convst  : out std_logic;
    EOC     : in  std_logic;
    EOLC    : in  std_logic;
    DataIn  : in  std_logic_vector(11 downto 0);
-- ADC Data Out
    DAV     : out std_logic;
    ADC_To  : out std_logic;
    AddrOut : out std_logic_vector(2 downto 0);
    DataOut : out std_logic_vector(11 downto 0)
    );
end Max1308Intf;

architecture Behavioral of Max1308Intf is

  signal EOCSr   : std_logic_vector(2 downto 0);
  signal EOLCSr  : std_logic_vector(2 downto 0);
  signal EOLC_TO : std_logic_vector(7 downto 0);

  signal StartLatch : std_logic;
  signal ClrStart   : std_logic;
  signal ClrDRdy    : std_logic;
  signal DataReady  : std_logic;
  signal iRd        : std_logic;
  signal iConvst    : std_logic;

  type ADCState_t is
    (Idle_s,
     Tacq1_s,
     Tacq2_s,
     Tacq3_s,
     WaitEOLC_s,
     RdData_s
     );

  signal ADCState : ADCState_t;
  signal RdCntr   : std_logic_vector(2 downto 0);

begin

  Wr     <= '0';
  Convst <= not(iConvst);

  StartLatch_p : process(Clock, reset)
  begin
    if (Reset = '1') then
      StartLatch <= '0';
    elsif (clock'event and clock = '1') then
      if (Start = '1') then
        StartLatch <= '1';
      elsif (ClrStart = '1') then
        StartLatch <= '0';
      end if;
    end if;
  end process;


  EOCSync_p : process(Clock, reset)
  begin
    if (Reset = '1') then
      DataReady <= '0';
      EOCSr     <= (others => '0');
      EOLCSr    <= (others => '0');
    elsif (clock'event and clock = '1') then
      EOCSr  <= EOCsr(1 downto 0) & EOC;
      EOLCSr <= EOLCsr(1 downto 0) & EOLC;

      if (EOLCSr(2 downto 1) = "01") then
        DataReady <= '1';
      elsif (ClrDRdy = '1') then
        DataReady <= '0';
      end if;
    end if;
  end process;

  ADCState_p : process(Clock, reset)
  begin
    if (Reset = '1') then
      ADCState <= Idle_s;
      ClrStart <= '0';
      ClrDRdy  <= '0';
      DAV      <= '0';
      Cs       <= '0';
      iRd      <= '0';
      Rd       <= '0';
      iConvst  <= '0';
      ADC_To   <= '0';
      EOLC_TO  <= (others => '0');
      RdCntr   <= (others => '0');
      AddrOut  <= (others => '0');
      DataOut  <= (others => '0');
    elsif (clock'event and clock = '1') then
      Rd <= iRd;
      if (ClkEn = '1') then
        case ADCState is
          when Idle_s =>
            Cs      <= '0';
            iRd     <= '0';
            ADC_To  <= '0';
            DAV     <= '0';
            EOLC_TO <= (others => '0');
            if (StartLatch = '1') then
              ClrStart <= '1';
              iConvst  <= '1';
              ADCState <= TAcq1_s;
            else
              ClrStart <= '0';
              iConvst  <= '0';
              ADCState <= Idle_s;
            end if;

          when TAcq1_s =>
            ADCState <= TAcq2_s;

          when TAcq2_s =>
            ADCState <= TAcq3_s;

          when TAcq3_s =>
            ADCState <= WaitEOLC_s;

          when WaitEOLC_s =>
            EOLC_TO  <= EOLC_TO + 1;
            ClrStart <= '0';
            iConvst  <= '0';
            Cs       <= '0';
            iRd      <= '0';
            if (DataReady = '1') then
              RdCntr   <= "000";
              ClrDRdy  <= '1';
              Cs       <= '1';
              ADCState <= RdData_s;
            elsif (EOLC_To = x"FF") then
              ADC_To   <= '1';
              DAV      <= '1';
              ADCState <= Idle_s;
            else
              ADCState <= WaitEOLC_s;
            end if;

          when RdData_s =>
            ClrDRdy <= '0';
            if (iRd = '1') then
              DAV     <= '1';
              AddrOut <= RdCntr;
              DataOut <= DataIn;
              RdCntr  <= RdCntr + 1;
              if (RdCntr = "111") then
                ADCState <= Idle_s;
              else
                ADCState <= RdData_s;
              end if;
            else
              DAV <= '0';
            end if;

            iRd <= not(iRd);

          when others =>
            ADCState <= Idle_s;
        end case;
      else
        ClrStart <= '0';
        ClrDRdy  <= '0';
        DAV      <= '0';
      end if;
    end if;
  end process;

end Behavioral;

