-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      FaultGen -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 6/3/2013 9:49:05 AM
--

library work;
use work.MKSUII.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- All fault inputs are latched at the source!


entity FaultGen is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

-- Link Interface
    Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr     : in std_logic;                      -- From Link Interface
    Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

    Reg_DataOut : out std_logic_vector(15 downto 0);

    SW_Fault_Reset_Le : in std_logic;

    Clk1HZEn  : in std_logic;
    Clk10HzEn : in std_logic;
    Clk1KHzEn : in std_logic;

    Trigger_In   : in std_logic;
    TriggerEn_In : in std_logic;

    Sw_Trigen : in std_logic;

    TriggerDisable : out std_logic;

-- Fault Inputs
    M24V : in std_logic;

-- Analog from Slow ADC
    KLYVACAna       : in std_logic;
    WGVACAna        : in std_logic;
    FocusCoilIAna   : in std_logic;
    FocusCoilGndAna : in std_logic;

-- Analog from FAST ADC
    BeamI   : in std_logic;
    BeamV   : in std_logic;
    FWDPWR  : in std_logic;
    REFLPWR : in std_logic;

    BeamILow : in std_logic;

-- Flow Switches
    ACC1Flow : in std_logic;
    ACC2Flow : in std_logic;
    WG1Flow  : in std_logic;
    WG2Flow  : in std_logic;
    KLYFlow  : in std_logic;

-- Temperature Monitor
    TDiff : in std_logic;

-- Legacy
    KLYVAC    : in std_logic;
    WGVACBAD  : in std_logic;
    n_WGVACOK : in std_logic;
    WGTCGauge : in std_logic;
    WGValve   : in std_logic;

-- Magnet
    MagIIntlk : in std_logic;
    MagIOK    : in std_logic;
    MagKlixon : in std_logic;

-- From SLED Interface
--      SLED_TimeOut            : in std_logic;
--      SLED_Fault                      : in std_logic;
--      SLED_OK                         : in std_logic;

-- From Tank and Pump
    Tank_Lo : in std_logic;
    Tank_Hi : in std_logic;
    PumpII  : in std_logic;


-- Outputs
    Trigger_Out   : out std_logic;
    TriggerEn_Out : out std_logic;

    HVOff        : out std_logic;
    ExtIntlk     : out std_logic;
    MagOff       : out std_logic;
    Fault3of5    : out std_logic;
    BeamILow10s  : out std_logic;
    FwdPwrFault  : out std_logic;
    ReflPwrFault : out std_logic;
-- jjo 7/8/13
    MagRfOff     : out std_logic;

    FaultBits : out std_logic_vector(31 downto 0);
    NewFault  : out std_logic;

    Status : out std_logic_vector(15 downto 0)

    );

end FaultGen;

architecture Behaviour of FaultGen is


  signal iFaultBits           : std_logic_vector(31 downto 0);
  signal FaultBitsA           : std_logic_vector(31 downto 0);
  signal iFaultCount          : std_logic_vector(15 downto 0);
  signal iStatus              : std_logic_vector(7 downto 0);
  signal iStatusLatch         : std_logic_vector(7 downto 0);
  signal iFaultCountClr       : std_logic;
  signal FaultBitsZero        : std_logic_vector(31 downto 0);
  signal ByPassReg            : std_logic_vector(31 downto 0);
  signal EnabledFaults        : std_logic_vector(31 downto 0);
  signal LatchedEnabledFaults : std_logic_vector(31 downto 0);

  signal iTrigOff     : std_logic;
  signal iHVOff       : std_logic;
  signal iExtIntlk    : std_logic;
  signal iExtIntlk1S  : std_logic;
  signal iMagOff      : std_logic;
  signal iRFOff       : std_logic;
  signal iFWDPWR      : std_logic;
  signal iMagKlixon   : std_logic;
  signal iBeamILow10s : std_logic;

  signal iFault3of5  : std_logic;
  signal Fault3of5Sr : std_logic_vector(4 downto 0);
  signal SystemFault : std_logic;
  signal BeamICntr   : std_logic_vector(3 downto 0);
  signal ClrBeamILow : std_logic;
  signal Clr3of5     : std_logic;
  signal iNewFault   : std_logic;
  signal Flag3of5    : std_logic;
  signal iFlowFault  : std_logic;
  signal iMagOffCntr : std_logic_vector(7 downto 0);
  signal iMagTrigEn  : std_logic;
  signal iMagIIntlk  : std_logic;

  signal TrigDelay_SR : std_logic_vector(10 downto 0);

--signal NoFaultRst                                     : std_logic;
--signal dNoFaultRst                            : std_logic;
--signal NoFaultReset                           : std_logic;


-- simTrigEn is for simulation
-- for checking 

  signal simTrigEn : std_logic;

  type MagState_t is
    (Idle_s,
     Delay_s,
     Wait_Mag_Status_s,
     Wait_Fault_Status_s
     );

  signal MagState : MagState_t;

begin

  TriggerDisable <= iTrigOff;

-- jjo 05/01/13
-- Added iMagOff to trigger_out
--

  simTrigEn <= not(iTrigOff) and not(iMagOff) and iMagTrigEn and Sw_TrigEn;

-- jjo 07/02/13
-- Delay trigen by 1Sec

  TrigenDelay_p : process(clock)
  begin
    if (SimTrigEn = '0') then
      TrigDelay_Sr <= (others => '0');
    elsif (clk10HzEn = '1') then
      TrigDelay_Sr <= TrigDelay_Sr(9 downto 0) & SimTrigEn;
    end if;
  end process;

  Trigger_Out   <= Trigger_In and TrigDelay_Sr(10);
  TriggerEn_Out <= TriggerEn_In and TrigDelay_Sr(10);


  ExtIntlk <= iExtIntlk1S;

  HVOff       <= iHVOff;
  MagOff      <= iMagOff;
  Fault3of5   <= iFault3of5;
  BeamILow10s <= iBeamILow10s;
  Status      <= iStatus & iStatusLatch;
  NewFault    <= iNewFault;

  FwdPwrFault  <= EnabledFaults(17);
  ReflPwrFault <= EnabledFaults(16);

  FaultBits <= EnabledFaults;

  wr_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      ClrBeamILow          <= '0';
      Clr3of5              <= '0';
      iStatusLatch         <= (others => '0');
      iFaultCountClr       <= '0';
      ByPassReg            <= (others => '0');
      LatchedEnabledFaults <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      ClrBeamILow <= '0';
      Clr3of5     <= '0';
      if (Lnk_Wr = '1') then
        case Lnk_Addr is
          when x"0000" =>
            iStatusLatch         <= iStatus;
            LatchedEnabledFaults <= LatchedEnabledFaults or EnabledFaults;
          when x"0001" =>
            iFaultCountClr       <= '1';
            iStatusLatch         <= iStatusLatch or iStatus;
            LatchedEnabledFaults <= LatchedEnabledFaults or EnabledFaults;
          when x"0002" =>
            ByPassReg(15 downto 0) <= Lnk_DataIn or ByPassReg(15 downto 0);
            iStatusLatch           <= iStatusLatch or iStatus;
            LatchedEnabledFaults   <= LatchedEnabledFaults or EnabledFaults;
          when x"0003" =>
            ByPassReg(31 downto 16) <= Lnk_DataIn or ByPassReg(31 downto 16);
            iStatusLatch            <= iStatusLatch or iStatus;
            LatchedEnabledFaults    <= LatchedEnabledFaults or EnabledFaults;
          when x"0004" =>
            ByPassReg(15 downto 0) <= not(Lnk_DataIn) and ByPassReg(15 downto 0);
            iStatusLatch           <= iStatusLatch or iStatus;
            LatchedEnabledFaults   <= LatchedEnabledFaults or EnabledFaults;
          when x"0005" =>
            ByPassReg(31 downto 16) <= not(Lnk_DataIn) and ByPassReg(31 downto 16);
            iStatusLatch            <= iStatusLatch or iStatus;
            LatchedEnabledFaults    <= LatchedEnabledFaults or EnabledFaults;
          when x"0006" =>
            iStatusLatch <= iStatus;
--                              LatchedEnabledFaults(15 downto 0)       <= ((LatchedEnabledFaults(15 downto 0) and not(Lnk_DataIn(15 downto 0))) or EnabledFaults(15 downto 0));
--                              LatchedEnabledFaults(31 downto 16)      <= LatchedEnabledFaults(31 downto 16) OR EnabledFaults(31 downto 16);

            LatchedEnabledFaults <= EnabledFaults;

          when x"0007" =>
            iStatusLatch <= iStatus;
--                              LatchedEnabledFaults(15 downto 0)       <= LatchedEnabledFaults(15 downto 0) OR EnabledFaults(15 downto 0);
--                              LatchedEnabledFaults(31 downto 16)      <= ((LatchedEnabledFaults(31 downto 16) and not(Lnk_DataIn(15 downto 0))) or EnabledFaults(31 downto 16));

            LatchedEnabledFaults <= EnabledFaults;

          when others =>
            iStatusLatch         <= iStatusLatch or iStatus;
            LatchedEnabledFaults <= LatchedEnabledFaults or EnabledFaults;
        end case;

-- jjo 05/06/13
--      added switch reset
--

      elsif (SW_Fault_Reset_Le = '1') then
        iStatusLatch         <= iStatus;
        LatchedEnabledFaults <= EnabledFaults;

      else
        iStatusLatch         <= iStatusLatch or iStatus;
        LatchedEnabledFaults <= LatchedEnabledFaults or EnabledFaults;
        iFaultCountClr       <= '0';
      end if;
    end if;
  end process;

  rd_p : process(Lnk_Addr, iFaultCount, iStatus, iStatusLatch, iFaultBits, ByPassReg, LatchedEnabledFaults)
  begin
    case Lnk_Addr(3 downto 0) is
      when x"0"   => Reg_DataOut <= iStatus & iStatusLatch;
      when x"1"   => Reg_DataOut <= iFaultCount;
      when x"2"   => Reg_DataOut <= ByPassReg(15 downto 0);
      when x"3"   => Reg_DataOut <= ByPassReg(31 downto 16);
      when x"4"   => Reg_DataOut <= LatchedEnabledFaults(15 downto 0);
      when x"5"   => Reg_DataOut <= LatchedEnabledFaults(31 downto 16);
      when x"6"   => Reg_DataOut <= iFaultBits(15 downto 0);
      when x"7"   => Reg_DataOut <= iFaultBits(31 downto 16);
      when others => Reg_DataOut <= (others => '0');
    end case;
  end process;

  iStatus <= '0' & iBeamILow10S & Sw_TrigEn & iTrigOff & iHVOFF & iExtIntlk1S & iMagOff & iFault3of5;

-- 04/16/13 jjo
-- Registered all inputs just to be sure 
-- they are syncd

  input_reg_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iFaultBits    <= (others => '0');
      EnabledFaults <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      iFaultBits(31 downto 27) <= "00000";
      --iFaultBits(27) <= iFault3of5;
      iFaultBits(26)           <= iMagoff;
      iFaultBits(25)           <= M24V;
      iFaultBits(24)           <= TDiff;
      iFaultBits(23)           <= KLYVACAna;
      iFaultBits(22)           <= WGVACAna;

-- jjo 05/06/13
-- FocusCoil measurements NOT used.

--      iFaultBits(21) <= FocusCoilIAna;
--      iFaultBits(20) <= FocusCoilGndAna;
      iFaultBits(21) <= '0';
      iFaultBits(20) <= '0';

      iFaultBits(19) <= BeamI;
      iFaultBits(18) <= BeamV;
      iFaultBits(17) <= FWDPWR;
      iFaultBits(16) <= REFLPWR;

      iFaultBits(15) <= ACC1Flow;
      iFaultBits(14) <= ACC2Flow;
      iFaultBits(13) <= WG1Flow;
      iFaultBits(12) <= WG2Flow;
      iFaultBits(11) <= KLYFlow;

-- jjo 05/06/13
-- WGTC and WGV not used

--      iFaultBits(10) <= WGTCGauge;
--      iFaultBits(9) <= WGValve;

      iFaultBits(10) <= '0';
      iFaultBits(9)  <= '0';
      iFaultBits(8)  <= KLYVAC;
      iFaultBits(7)  <= n_WGVACOK;
      iFaultBits(6)  <= WGVACBAD;
      iFaultBits(5)  <= MagIIntlk;

-- jjo 05/06/12
-- MagIOK and MagKlixon not used

--      iFaultBits(4) <= MagIOK;
--      iFaultBits(3) <= MagKlixon;

      iFaultBits(4) <= '0';
      iFaultBits(3) <= '0';

      iFaultBits(2) <= TANK_Lo;
      iFaultBits(1) <= TANK_Hi;
      iFaultBits(0) <= PUMPII;

      EnabledFaults <= iFaultBits and not(ByPassReg);
    end if;
  end process;

-- 04/01/13 jjo
-- Changed iFwdpwr and MagKlixon to latched versions
-- added iFlowFault to IMagOff
-- 06/22/13 jjo
-- Changed to unlatched Versions for autoreset

--iFWDPWR               <= LatchedEnabledFaults(17);
--iMagIIntlk    <= LatchedEnabledFaults(5);
--
--iFlowFault    <= LatchedEnabledFaults(11) OR LatchedEnabledFaults(12) OR
--                                      LatchedEnabledFaults(13) OR LatchedEnabledFaults(14) OR
--                                      LatchedEnabledFaults(15);

  iFWDPWR    <= EnabledFaults(17);
  iMagIIntlk <= EnabledFaults(5);

  iFlowFault <= EnabledFaults(11) or EnabledFaults(12) or
                EnabledFaults(13) or EnabledFaults(14) or
                EnabledFaults(15);


  u_Beami10s : process(Clock, Reset)
  begin
    if (Reset = '1') then
      BeamIcntr    <= (others => '0');
      iBeamILow10s <= '0';
    elsif (Clock'event and Clock = '1') then
      if (BeamILow = '0')then
        BeamICntr    <= (others => '0');
        iBeamILow10s <= '0';
      elsif (Clk1hzEn = '1') then
        BeamICntr <= BeamICntr + 1;
      end if;
      if (BeamICntr = "1001") then
        iBeamILow10s <= '1';
      end if;
    end if;
  end process;

  Trigoff_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iTrigOff <= '0';
    elsif (Clock'event and Clock = '1') then
-- jjo 06/22/13
--      if (LatchedEnabledFaults /= FaultBitsZero) then
      if (EnabledFaults /= FaultBitsZero) then
        iTrigOff <= '1';
      else
        iTrigOff <= '0';
      end if;
    end if;
  end process;

  HVOFF_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iHVOff <= '0';
    elsif (Clock'event and Clock = '1') then
      if (iFWDPWR = '1') then
        iHVOff <= '1';
      else
        iHVOff <= '0';
      end if;
    end if;
  end process;


-- jjo 05/02/13
-- Dont use iMagKlixon to cause a fault
--

  MagOff_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iMagOff     <= '0';
      iMagTrigEn  <= '0';
      MagRfOff    <= '0';
      iMagOffCntr <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      case MagState is
        when Idle_s =>
          iMagOffCntr <= (others => '0');
          if (iFlowFault = '1') then
            MagRfOff   <= '1';
            iMagTrigEn <= '0';
            MagState   <= Delay_s;
          else
            MagRfOff   <= '0';
            iMagTrigEn <= '1';
            MagState   <= Idle_s;
          end if;

-- Turn off triggers, iMagTrigen <0
-- Wait 250Ms and then turn off the supply

        when Delay_s =>
          iMagTrigEn <= '0';
          if (Clk1KhzEn = '1') then
            if (iMagOffCntr = x"ff") then
              iMagOff  <= '1';
              MagState <= Wait_Mag_Status_s;
            else
              iMagOffCntr <= iMagOffCntr + 1;
              MagState    <= Delay_s;
            end if;
          end if;

-- Wait for Supplies to turn off!
-- MagIntlk Status should fault when the supply is
-- off

        when Wait_Mag_Status_s =>
          if (iMagIIntlk = '1') then
            MagState <= Wait_Fault_Status_s;
          else
            MagState <= Wait_Mag_Status_s;
          end if;

        when Wait_Fault_Status_s =>
          if (iFlowFault = '1') then
            MagState <= Wait_Fault_Status_s;
          else
            iMagOff  <= '0';
            MagState <= Idle_s;
          end if;
      end case;

    end if;

  end process;

  SysFault_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      SystemFault <= '0';
    elsif (Clock'event and Clock = '1') then
      if (EnabledFaults /= FaultBitsZero) then
        SystemFault <= '1';
      else
        SystemFault <= '0';
      end if;
    end if;
  end process;


  ExtIntlk_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iExtIntlk <= '0';
    elsif (Clock'event and Clock = '1') then
-- jjo 06/22/13
--      if (LatchedEnabledFaults /= FaultBitsZero) then
      if (EnabledFaults /= FaultBitsZero) then
        iExtIntlk <= '1';
      else
        iExtIntlk <= '0';
      end if;
    end if;
  end process;

  Fault_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      FaultBitsA    <= (others => '0');
      FaultBitsZero <= (others => '0');
      iFaultCount   <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      FaultBitsA <= EnabledFaults;
      iNewFault  <= '0';
      if (iFaultCountClr = '1') then
        iFaultCount <= (others => '0');
      elsif ((not(FaultBitsA) and EnabledFaults) /= FaultBitsZero) then
        if (iFaultCount /= x"FFFF") then
          iFaultCount <= iFaultCount + 1;
          iNewFault   <= '1';
        end if;
      end if;
    end if;
  end process;


  Fault3of5_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iFault3of5  <= '0';
      Flag3of5    <= '0';
      Fault3of5Sr <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (SystemFault = '1') then
        Flag3of5 <= '1';
      elsif (Clk1hzEn = '1') then
        Flag3of5 <= '0';
      end if;

      if (clk1HzEn = '1') then
        Fault3of5Sr <= Fault3of5Sr(3 downto 0) & Flag3of5;
      end if;
      case Fault3of5Sr is
        when "00111" => iFault3of5 <= '1';
        when "01011" => iFault3of5 <= '1';
        when "01101" => iFault3of5 <= '1';
        when "01110" => iFault3of5 <= '1';
        when "01111" => iFault3of5 <= '1';
        when "10011" => iFault3of5 <= '1';
        when "10101" => iFault3of5 <= '1';
        when "10110" => iFault3of5 <= '1';
        when "10111" => iFault3of5 <= '1';
        when "11001" => iFault3of5 <= '1';
        when "11010" => iFault3of5 <= '1';
        when "11011" => iFault3of5 <= '1';
        when "11100" => iFault3of5 <= '1';
        when "11101" => iFault3of5 <= '1';
        when "11110" => iFault3of5 <= '1';
        when "11111" => iFault3of5 <= '1';
        when others =>
          iFault3of5 <= '0';
      end case;
    end if;
  end process;


-- jjo
-- 6/18/13 Replaced oneshotcen with oneshotcen4bit
-- onshotcen does not do level correctly

-- jjo
-- 11/12/13 V5.44
-- Changed time from A to F
-- A is < 1s
--u_extintlk : oneshotCen
--generic map(
--      N => 4
--)
  u_extintlk : oneshotCEn4Bit
    port map (
      Clock    => Clock,
      Reset    => Reset,
      ClockEn  => Clk10hzEn,
      Start    => iExtIntlk,
      RetrigEn => '1',
      Level    => '1',
      OS_Time  => X"F",
      OS_Out   => iExtIntlk1S
      );

end behaviour;
