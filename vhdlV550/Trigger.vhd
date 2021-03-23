-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      Trigger -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 6/3/2013 9:18:53 AM
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;

library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity Trigger is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

    AccTrig_p  : in std_logic;
    AccTrig_n  : in std_logic;
    StbyTrig_p : in std_logic;
    StbyTrig_n : in std_logic;

    UseAccTrigger : in std_logic;

    SelfTriggerEn : in std_logic;

-- Link Interface
    Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr     : in std_logic;                      -- From Link Interface
    Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

    Reg_DataOut : out std_logic_vector(15 downto 0);

    Clk100KHzEn    : in  std_logic;
    Local          : in  std_logic;
    LocalTrigDelay : in  std_logic_vector(15 downto 0);
    LocalRateDiv   : in  std_logic_vector(2 downto 0);
    TriggerEn      : in  std_logic;     -- From EPIC's enable
    TriggerDisable : in  std_logic;     -- From Fault Gen Trigger Disable
    Mode_Maint     : in  std_logic;
    Gt120Hz        : out std_logic;

    WFMTrigger   : out std_logic;
    ModTrigger   : out std_logic;
    RearTrigger  : out std_logic;
    FrontTrigger : out std_logic;

    DisplayTrigDelay : out std_logic_vector(15 downto 0);

    InputRate  : out std_logic_vector(15 downto 0);
    OutputRate : out std_logic_vector(15 downto 0);

    EventCounter : out std_logic_vector(31 downto 0)

    );

end Trigger;

architecture behaviour of Trigger is

  signal WFMTrigDelay   : std_logic_vector(15 downto 0);
  signal ModTrigDelay   : std_logic_vector(15 downto 0);
  signal RearTrigDelay  : std_logic_vector(15 downto 0);
  signal FrontTrigDelay : std_logic_vector(15 downto 0);
  signal TriggerDelay   : std_logic_vector(15 downto 0);
  signal RearTrigWidth  : std_logic_vector(15 downto 0);
  signal FrontTrigWidth : std_logic_vector(15 downto 0);

  signal InRateCntr     : std_logic_vector(15 downto 0);
  signal OutRateCntr    : std_logic_vector(15 downto 0);
  signal OutRateDivCntr : std_logic_vector(3 downto 0);
  signal OutRateDiv     : std_logic_vector(3 downto 0);
  signal iInputRate     : std_logic_vector(15 downto 0);
  signal iOutputRate    : std_logic_vector(15 downto 0);
  signal SelfTrigDel    : std_logic_vector(15 downto 0);
  signal SelfTrigCntr   : std_logic_vector(15 downto 0);
  signal SelfTrigger    : std_logic;
  signal SelfTrigSR     : std_logic_vector(1 downto 0);

  signal iTrig         : std_logic;
  signal TrigLe        : std_logic;
  signal DivTrig       : std_logic;
  signal iWFMTrigger   : std_logic;
  signal iModTrigger   : std_logic;
  signal iRearTrigger  : std_logic;
  signal iFrontTrigger : std_logic;
  signal ModTrig       : std_logic;
  signal ACC_Trig      : std_logic;
  signal Stby_Trig     : std_logic;
  signal AccSyncSR     : std_logic_vector(2 downto 0);
  signal StndbySyncSr  : std_logic_vector(2 downto 0);
  signal ModTrigSyncSr : std_logic_vector(2 downto 0);
  signal iWFMTriggerSr : std_logic_vector(2 downto 0);
  signal ModTrigSyncFE : std_logic;
  signal RearTrigSr : std_logic_vector(2 downto 0);
  signal RearTrigLe : std_logic;
 
  signal RemoteRateDiv    : std_logic_vector(2 downto 0);
  signal iEventCounter    : std_logic_vector(31 downto 0);
  signal ModulatorTrigger : std_logic;
  signal iiRearTrigger : std_logic;

  signal iTrigSync  : std_logic;
  signal TrigLeSync : std_logic;
  signal StndbyMask : std_logic;
  signal Msk120Hz   : std_logic;


--

  constant RateDiv5 : std_logic_vector(3 downto 0) := x"C";
  constant RateDiv4 : std_logic_vector(3 downto 0) := x"6";
  constant RateDiv3 : std_logic_vector(3 downto 0) := x"4";
  constant RateDiv2 : std_logic_vector(3 downto 0) := x"3";
  constant RateDiv1 : std_logic_vector(3 downto 0) := x"2";
  constant RateDiv0 : std_logic_vector(3 downto 0) := x"1";


begin

  DisplayTrigDelay <= TriggerDelay;
  EventCounter     <= iEventCounter;

  InputRate  <= iInputRate;
  OutputRate <= iOutputRate;

  u_AccTrig : IBUFDS
    port map (
      I  => AccTrig_p,
      IB => AccTrig_n,
      O  => ACC_Trig
      );

  u_StdbyTrig : IBUFDS
    port map (
      I  => StbyTrig_p,
      IB => StbyTrig_n,
      O  => STBY_Trig
      );

-- jjo
-- 4/23/13

  iRearTrigger  <= (ACC_Trig or (STBY_Trig and not(StndbyMask))) when UseAccTrigger = '1' else STBY_Trig;
  iFrontTrigger <= (ACC_Trig or (STBY_Trig and not(StndbyMask))) when UseAccTrigger = '1' else STBY_Trig;

  iiRearTrigger  <= iRearTrigger and TriggerEn and not(Msk120Hz);
  RearTrigger <= iiRearTrigger;
  FrontTrigger <= iFrontTrigger and TriggerEn and not(Msk120Hz);


-- 3/22/21 jjo
-- Changed ModTrig from iModTrigger to iRearTrigger
--
--  ModTrigger <= iModTrigger;
--RearTrigger           <= iRearTrigger;
--FrontTrigger          <= iFrontTrigger;
  -- ModTrig    <= iTrig and TriggerEn;


  WFMTrigger <= iWFMTrigger;

  TrigCntr_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iEventCounter <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (TrigLe = '1') then
        iEventCounter <= iEventCounter + 1;
      end if;
    end if;
  end process;

  Sync : process(Clock, Reset)
  begin
    if (reset = '1') then
      StndbySyncSr  <= (others => '0');
      AccSyncSr     <= (others => '0');
      ModTrigSyncSr <= (others => '0');
      ModTrigSyncFE <= '0';
    elsif (Clock'event and Clock = '1') then
      StndBySyncSr  <= StndBySyncSr(1 downto 0) & STBY_Trig;
      AccSyncSr     <= AccSyncSr(1 downto 0) & Acc_Trig;
      ModTrigSyncSr <= ModTrigSyncSr(1 downto 0) & iRearTrigger;
      if ModTrigSyncSr(2 downto 1) = "10" then
        ModTrigSyncFE <= '1';
      else
        ModTrigSyncFE <= '0';
      end if;
    end if;
  end process;

  WrReg : process(Clock, Reset)
  begin
    if (reset = '1') then
      WFMTrigDelay   <= (others => '0');
      ModTrigDelay   <= (others => '0');
      RearTrigDelay  <= (others => '0');
      RearTrigWidth  <= (others => '0');
      FrontTrigDelay <= (others => '0');
      FrontTrigWidth <= (others => '0');
      SelfTrigDel    <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        case Lnk_Addr is
          when x"0000" =>
            WFMTrigDelay <= Lnk_DataIn;
          when x"0001" =>
            ModTrigDelay <= Lnk_DataIn;
--                      when x"0002" =>
--                              RearTrigDelay           <= Lnk_DataIn;
--                      when x"0003" =>
--                              RearTrigWidth           <= Lnk_DataIn;
--                      when x"0004" =>
--                              FrontTrigDelay          <= Lnk_DataIn;
--                      when x"0005" =>
--                              FrontTrigWidth  <= Lnk_DataIn;
          when x"000A" =>
            RemoteRateDiv <= Lnk_DataIn(2 downto 0);
          when x"000D" =>
            SelfTrigDel <= Lnk_DataIn;
          when others =>
        end case;
      end if;
    end if;
  end process;

  TriggerDelay <= LocalTrigDelay when (Local = '1')      else ModTrigDelay;
  iTrig        <= DivTrig        when (Mode_Maint = '1') else TrigLe;

  ReadReg_p : process (Lnk_Addr, Local, WFMTrigDelay, ModTrigDelay, RearTrigDelay,
                       RearTrigWidth, FrontTrigDelay, FrontTrigWidth, LocalTrigDelay,
                       TriggerDelay, iInputRate, iOutputRate, RemoteRateDiv,
                       LocalRateDiv, OutRateDiv, SelfTrigDel)
  begin
    case Lnk_Addr(3 downto 0) is
      when x"0" =>
        Reg_DataOut <= WFMTrigDelay;
      when x"1" =>
        Reg_DataOut <= ModTrigDelay;
      when x"2" =>
        Reg_DataOut <= RearTrigDelay;
      when x"3" =>
        Reg_DataOut <= RearTrigWidth;
      when x"4" =>
        Reg_DataOut <= FrontTrigDelay;
      when x"5" =>
        Reg_DataOut <= FrontTrigWidth;
      when x"6" =>
        Reg_DataOut <= LocalTrigDelay;
      when x"7" =>
        Reg_DataOut <= TriggerDelay;
      when x"8" =>
        Reg_DataOut <= iInputRate;
      when x"9" =>
        Reg_DataOut <= iOutputRate;
      when x"A" =>
        Reg_DataOut <= "0000000000000" & RemoteRateDiv;
      when x"B" =>
        Reg_DataOut <= "0000000000000" & LocalRateDiv;
      when x"C" =>
        Reg_DataOut <= x"000" & OutRateDiv;
      when x"D" =>
        Reg_DataOut <= SelfTrigDel;
      when others =>
        Reg_DataOut <= (others => '0');
    end case;
  end process;

  RateMux_p : process(LocalRateDiv, RemoteRateDiv, Local)
  begin
    if (Local = '1') then
      case LocalRateDiv is
        when "000"  => OutRateDiv <= RateDiv0;
        when "001"  => OutRateDiv <= RateDiv1;
        when "010"  => OutRateDiv <= RateDiv2;
        when "011"  => OutRateDiv <= RateDiv3;
        when "100"  => OutRateDiv <= RateDiv4;
        when "101"  => OutRateDiv <= RateDiv5;
        when others => OutRateDiv <= RateDiv0;
      end case;
    else
      case RemoteRateDiv is
        when "000"  => OutRateDiv <= RateDiv0;
        when "001"  => OutRateDiv <= RateDiv1;
        when "010"  => OutRateDiv <= RateDiv2;
        when "011"  => OutRateDiv <= RateDiv3;
        when "100"  => OutRateDiv <= RateDiv4;
        when "101"  => OutRateDiv <= RateDiv5;
        when others => OutRateDiv <= RateDiv0;
      end case;
    end if;
  end process;


  u_120mask : oneshotCEn
    generic map (
      N => 12
      )
    port map(
      Clock    => Clock,
      Reset    => Reset,
      ClockEn  => Clk100KHzEn,
      Start    => ModTrigSyncFE,
      RetrigEn => '1',
      Level    => '1',
      OS_Time  => X"334",               -- 8.2ms
      OS_Out   => Msk120Hz
      );


  Gt120 : process(Clock, Reset)
  begin
    if (reset = '1') then
      Gt120Hz <= '0';
    elsif (clock'event and Clock = '1') then
      if (Msk120Hz = '1') and (TrigLe = '1') then
        Gt120Hz <= '1';
      else
        Gt120Hz <= '0';
      end if;
    end if;
  end process;

-- jjo 05/30/13
-- Removed Self Trigger 

  TrigLe_p : process(Clock, Reset)
  begin
    if (reset = '1') then
      TrigLe     <= '0';
      StndbyMask <= '0';
    elsif (Clock'event and Clock = '1') then
      if (UseAccTrigger = '1') then
        -- Use Accelerate Trigger if available, mask off subsequent Standby
        if (AccSyncSr(2 downto 1) = "01") then
          TrigLe     <= '1';
          StndbyMask <= '1';

        -- Use Standby if it was NOT preceeded by an Accelerate Trigger
        elsif ((StndBySyncSr(2 downto 1) = "01") and (StndbyMask = '0'))then
          TrigLe <= '1';
        else
          TrigLe <= '0';
        end if;

        -- Clear the mask at the falling edge of Standby        
        if (StndBySyncSr(2 downto 1) = "10")then
          StndbyMask <= '0';
        end if;

      else
        StndbyMask <= '0';
        if (StndBySyncSr(2 downto 1) = "01") then
          TrigLe <= '1';
        else
          TrigLe <= '0';
        end if;
      end if;
    end if;
  end process;

  OutTrig_p : process(Clock, Reset)
  begin
    if (reset = '1') then
      DivTrig        <= '0';
      OutRateDivCntr <= x"0";
    elsif (Clock'event and Clock = '1') then
      if (TrigLe = '1') then
        if (OutRateDivCntr = OutRateDiv) then
          DivTrig        <= '1';
          OutRateDivCntr <= x"1";
        else
          OutRateDivCntr <= OutRateDivCntr + 1;
        end if;
      else
        DivTrig <= '0';
      end if;
    end if;
  end process;

  InRate_p : process(Clock, Reset)
  begin
    if (reset = '1') then
      InRateCntr <= (others => '0');
      iInputRate <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (TrigLe = '1') then
        iInputRate <= InRateCntr;
        InRateCntr <= (others => '0');
      elsif (Clk100KHzEn = '1') then
        if (InRateCntr /= x"FFFF") then
          InRateCntr <= InRateCntr + 1;
        end if;
      end if;
    end if;
  end process;

  RearTrig_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      RearTrigSr <= "000";
      RearTrigLe <= '0';
    elsif (Clock'event and Clock = '1') then
      RearTrigSr <= RearTrigSr(1 downto 0) & iiRearTrigger;
      if (RearTrigSr(2 downto 1) = "01") then
        RearTrigLe <= '1';
      else
        RearTrigLe <= '0';
      end if;
    end if;
  end process;
  
  
  OutRate_p : process(Clock, Reset)
  begin
    if (reset = '1') then
      OutRateCntr <= (others => '0');
      iOutputRate <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (RearTrigLe = '1') then
        iOutputRate <= OutRateCntr;
        OutRateCntr <= (others => '0');
      elsif (Clk100KHzEn = '1') then
        if (OutRateCntr /= x"FFFF") then
          OutRateCntr <= OutRateCntr +1;
        end if;
      end if;
    end if;
  end process;

  u_wfmTrig : prog_strobe16
    port map (
      Clock     => Clock,
      Reset     => Reset,
      TriggerIn => iTrig,
      Delay     => WFMTrigDelay,
      Width     => x"0004",
      Pulse     => iWFMTrigger
      );

--u_ModTrig : pulse_delay16
--Port map (
--      Clock                   => Clock,
--      Reset                   => Reset,
--      TriggerIn               => ModTrigEnable,
--      Delay                   => TriggerDelay,
--      Pulse                   => iModTrigger
--      );

  ModulatorTrigger <= ModTrig and not(TriggerDisable);


-- jjo 05/30/13
-- Changed width back to 1us
-- Maybe went to 100us to test pulser, I don't remeber

  u_ModTrig : prog_strobe16
    port map (
      Clock     => Clock,
      Reset     => Reset,
      TriggerIn => ModulatorTrigger,
      Delay     => TriggerDelay,
      Width     => x"0076",             -- 1us at 119Mhz
--      Width                   => x"2e7c",   -- 100us at 119Mhz
      Pulse     => iModTrigger
      );

--u_RearTrig : prog_strobe16
--Port map (
--      Clock                   => Clock,
--      Reset                   => Reset,
--      TriggerIn               => ModTrig,
--      Delay                   => RearTrigDelay,
--      Width                   => RearTrigWidth,
--      Pulse                   => iRearTrigger
--      );
--
--u_FronTrig : prog_strobe16
--Port map (
--      Clock                   => Clock,
--      Reset                   => Reset,
--      TriggerIn               => ModTrig,
--      Delay                   => FrontTrigDelay,
--      Width                   => FrontTrigWidth,
--      Pulse                   => iFrontTrigger
--      );

end behaviour;
