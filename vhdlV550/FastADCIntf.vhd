-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      FastADCIntf -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 6/3/2013 9:47:03 AM
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


entity FastADCIntf is
  port (
    Clock    : in std_logic;
    Reset    : in std_logic;
    Clk1HzEn : in std_logic;

-- Link Interface
    Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr      : in  std_logic;                      -- From Link Interface
    Lnk_DataIn  : in  std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_WFMRd   : in  std_logic;
    Reg_DataOut : out std_logic_vector(15 downto 0);


    Status : out std_logic_vector(15 downto 0);

--      Status                                  : out std_logic_vector(15 downto 0);

    ArmWFM   : in  std_logic;
    ArmAve   : in  std_logic;
    WFMArmed : out std_logic;
    AveArmed : out std_logic;

-- Average
    Beam_V_Average   : out std_logic_vector(15 downto 0);
    Beam_I_Average   : out std_logic_vector(15 downto 0);
    FWD_PWR_Average  : out std_logic_vector(15 downto 0);
    REFL_PWR_Average : out std_logic_vector(15 downto 0);

-- 
    Trigger : in std_logic;

    WFM_Avail : out std_logic;
    BeamILow  : out std_logic;

-- Fast ADC Input 
    FADC_CLK_P       : out std_logic;
    FADC_CLK_N       : out std_logic;
    FADC_FRAME_CLK_P : in  std_logic;
    FADC_FRAME_CLK_N : in  std_logic;
    FADC_DATA_CLK_P  : in  std_logic;
    FADC_DATA_CLK_N  : in  std_logic;
    BEAM_V_P         : in  std_logic;
    BEAM_V_N         : in  std_logic;
    BEAM_I_P         : in  std_logic;
    BEAM_I_N         : in  std_logic;
    FWD_PWR_P        : in  std_logic;
    FWD_PWR_N        : in  std_logic;
    REFL_PWR_P       : in  std_logic;
    REFL_PWR_N       : in  std_logic;

--      Frameclk                                        : out std_logic;
--      Dataclk                                 : out std_logic;
    DataclkLocked : out std_logic
    );

end FastADCIntf;

architecture behaviour of FastADCIntf is


  type Regs_t is array(25 downto 0) of std_logic_vector(15 downto 0);
  signal Regs : Regs_t;

  type Sample_t is
    (
      Idle_s,
      Wfm_s
      );

  signal Sample_s : Sample_t;

  signal Beam_V_Data   : std_logic_vector(15 downto 0);
  signal Beam_I_Data   : std_logic_vector(15 downto 0);
  signal FWD_PWR_Data  : std_logic_vector(15 downto 0);
  signal REFL_PWR_Data : std_logic_vector(15 downto 0);


  signal Beam_V_Lo_Thres : std_logic_vector(11 downto 0);
  signal Beam_V_Hi_Thres : std_logic_vector(11 downto 0);
  signal Beam_V_Start    : std_logic_vector(8 downto 0);
  signal Beam_V_Stop     : std_logic_vector(8 downto 0);
  signal Beam_V_WFM_DOut : std_logic_vector(15 downto 0);
  signal Beam_V_Status   : std_logic_vector(1 downto 0);

  signal Beam_I_Lo_Thres : std_logic_vector(11 downto 0);
  signal Beam_I_Hi_Thres : std_logic_vector(11 downto 0);
  signal Beam_I_Start    : std_logic_vector(8 downto 0);
  signal Beam_I_Stop     : std_logic_vector(8 downto 0);
  signal Beam_I_WFM_DOut : std_logic_vector(15 downto 0);
  signal Beam_I_Status   : std_logic_vector(1 downto 0);

  signal FWD_PWR_Lo_Thres : std_logic_vector(11 downto 0);
  signal FWD_PWR_Hi_Thres : std_logic_vector(11 downto 0);
  signal FWD_PWR_Start    : std_logic_vector(8 downto 0);
  signal FWD_PWR_Stop     : std_logic_vector(8 downto 0);
  signal FWD_PWR_WFM_DOut : std_logic_vector(15 downto 0);
  signal FWD_PWR_Status   : std_logic_vector(1 downto 0);

  signal REFL_PWR_Lo_Thres : std_logic_vector(11 downto 0);
  signal REFL_PWR_Hi_Thres : std_logic_vector(11 downto 0);
  signal REFL_PWR_Start    : std_logic_vector(8 downto 0);
  signal REFL_PWR_Stop     : std_logic_vector(8 downto 0);
  signal REFL_PWR_WFM_DOut : std_logic_vector(15 downto 0);
  signal REFL_PWR_Status   : std_logic_vector(1 downto 0);

  signal TimeCntr : std_logic_vector(8 downto 0);

  signal ADC_Clk : std_logic;

  signal REFL_PWR_Done : std_logic;
  signal FWD_PWR_Done  : std_logic;
  signal Beam_V_Done   : std_logic;
  signal Beam_I_Done   : std_logic;


  signal iBeam_V_Average   : std_logic_vector(15 downto 0);
  signal iBeam_I_Average   : std_logic_vector(15 downto 0);
  signal iFwd_Pwr_Average  : std_logic_vector(15 downto 0);
  signal iRefl_Pwr_Average : std_logic_vector(15 downto 0);

  signal iBeam_V_Data   : std_logic_vector(11 downto 0);
  signal iBeam_I_Data   : std_logic_vector(11 downto 0);
  signal iFWD_PWR_Data  : std_logic_vector(11 downto 0);
  signal iREFL_PWR_Data : std_logic_vector(11 downto 0);

  signal StatusLatch : std_logic_vector(15 downto 0);
  signal iStatus     : std_logic_vector(15 downto 0);
  signal SyncTrigger : std_logic;
  signal iTrigger    : std_logic;
  signal ClrTrigger  : std_logic;

  signal Beam_V_WFMArmed   : std_logic;
  signal Beam_V_AveArmed   : std_logic;
  signal Beam_I_WFMArmed   : std_logic;
  signal Beam_I_AveArmed   : std_logic;
  signal FWD_PWR_WFMArmed  : std_logic;
  signal FWD_PWR_AveArmed  : std_logic;
  signal Refl_PWR_WFMArmed : std_logic;
  signal Refl_PWR_AveArmed : std_logic;

  signal Beam_V_Ave_DOut   : std_logic_vector(15 downto 0);
  signal Beam_I_Ave_DOut   : std_logic_vector(15 downto 0);
  signal FWD_PWR_Ave_DOut  : std_logic_vector(15 downto 0);
  signal REFL_PWR_Ave_DOut : std_logic_vector(15 downto 0);

  signal Num_AveSamples : std_logic_vector(8 downto 0);
  signal BeamICntr      : std_logic_vector(3 downto 0);

begin

-- jjo 05/09/13
-- Changed Status to unlatched version

--Status                                <= StatusLatch;
  Status <= iStatus;

  iStatus <= "00000000" & REFL_PWR_Status & FWD_PWR_Status & Beam_I_Status & Beam_V_Status;

  Beam_V_Average   <= iBeam_V_Average;
  Beam_I_Average   <= iBeam_I_Average;
  Fwd_Pwr_Average  <= iFwd_Pwr_Average;
  Refl_Pwr_Average <= iRefl_Pwr_Average;

  Beam_V_Data   <= iBeam_V_Data(11) & iBeam_V_Data(11) & iBeam_V_Data(11) & iBeam_V_Data(11) & iBeam_V_Data;
  Beam_I_Data   <= iBeam_I_Data(11) & iBeam_I_Data(11) & iBeam_I_Data(11) & iBeam_I_Data(11) & iBeam_I_Data;
  FWD_PWR_Data  <= iFWD_PWR_Data(11) & iFWD_PWR_Data(11) & iFWD_PWR_Data(11) & iFWD_PWR_Data(11) & iFWD_PWR_Data;
  REFL_PWR_Data <= iREFL_PWR_Data(11) & iREFL_PWR_Data(11) & iREFL_PWR_Data(11) & iREFL_PWR_Data(11) & iREFL_PWR_Data;

  AveArmed <= Beam_V_AveArmed or Beam_I_AveArmed or FWD_PWR_AveArmed or Refl_PWR_AveArmed;
  WFMArmed <= Beam_V_WFMArmed or Beam_I_WFMArmed or FWD_PWR_WFMArmed or Refl_PWR_WFMArmed;

  Beam_V_Lo_Thres <= Regs(1)(11 downto 0);
  Beam_V_Hi_Thres <= Regs(2)(11 downto 0);
  Beam_V_Start    <= Regs(3)(8 downto 0);
  Beam_V_Stop     <= Regs(4)(8 downto 0);

  Beam_I_Lo_Thres <= Regs(5)(11 downto 0);
  Beam_I_Hi_Thres <= Regs(6)(11 downto 0);
  Beam_I_Start    <= Regs(7)(8 downto 0);
  Beam_I_Stop     <= Regs(8)(8 downto 0);

  FWD_PWR_Lo_Thres <= Regs(9)(11 downto 0);
  FWD_PWR_Hi_Thres <= Regs(10)(11 downto 0);
  FWD_PWR_Start    <= Regs(11)(8 downto 0);
  FWD_PWR_Stop     <= Regs(12)(8 downto 0);

  REFL_PWR_Lo_Thres <= Regs(13)(11 downto 0);
  REFL_PWR_Hi_Thres <= Regs(14)(11 downto 0);
  REFL_PWR_Start    <= Regs(15)(8 downto 0);
  REFL_PWR_Stop     <= Regs(16)(8 downto 0);
  Num_AveSamples    <= Regs(17)(8 downto 0);

-- jjo 6/19/13
-- Changed status in FastChannel so I don't need
-- Beam_I_Done
--

--BeamILow_p : process(Clock, Reset)
--Begin
--if (Reset = '1') then
--      BeamILow <= '0';
--elsif (Clock'event and Clock = '1') then
--      if (Beam_I_Done = '1') then
--              BeamILow <= Beam_I_Status(0);
--      end if;
--end if;
--end process;
--

  BeamILow <= Beam_I_Status(0);

  Write_Reg_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      regs <= (others => x"0000");
    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        if (Lnk_Addr = x"0000") then
          StatusLatch <= (iStatus and not(Lnk_DataIn)) or iStatus;
        elsif (Conv_Integer(Lnk_Addr) < 18) then
          StatusLatch                  <= StatusLatch or iStatus;
          Regs(Conv_Integer(Lnk_Addr)) <= Lnk_DataIn;
        end if;
      else
        StatusLatch <= StatusLatch or iStatus;
        Regs(0)     <= StatusLatch or iStatus;
      end if;

      Regs(18) <= iBeam_V_Average;
      Regs(19) <= iBeam_I_Average;
      Regs(20) <= iFwd_Pwr_Average;
      Regs(21) <= iRefl_Pwr_Average;

      Regs(22) <= Beam_V_Data;
      Regs(23) <= Beam_I_Data;
      Regs(24) <= FWD_PWR_Data;
      Regs(25) <= REFL_PWR_Data;

    end if;
  end process;  --Write_Reg_p   

  Rd_p : process(Regs, Lnk_Addr, Lnk_WFMRd, Beam_V_Lo_Thres, Beam_V_Hi_Thres,
                 Beam_V_Start, Beam_V_Stop, Beam_I_Lo_Thres, Beam_I_Hi_Thres,
                 Beam_I_Start, Beam_I_Stop, FWD_PWR_Lo_Thres, FWD_PWR_Hi_Thres,
                 FWD_PWR_Start, FWD_PWR_Stop, REFL_PWR_Lo_Thres, REFL_PWR_Hi_Thres,
                 REFL_PWR_Start, REFL_PWR_Stop, iBeam_V_Average, iBeam_I_Average,
                 iFwd_Pwr_Average, iRefl_Pwr_Average, Beam_V_Data, Beam_I_Data,
                 FWD_PWR_Data, REFL_PWR_Data, Beam_V_WFM_DOut, Beam_I_WFM_DOut,
                 FWD_PWR_WFM_DOut, REFL_PWR_WFM_DOut,
                 Beam_V_Ave_DOut, Beam_I_Ave_DOut, FWD_PWR_Ave_DOut, REFL_PWR_Ave_DOut, Num_AveSamples)

    variable iAddress : integer;
  begin
    iAddress := Conv_Integer(Lnk_Addr);
    if (Lnk_WFMRd = '0') then
      case Lnk_Addr is
        when x"0000" => Reg_DataOut <= Regs(0);

        when x"0001" => Reg_DataOut <= Beam_V_Lo_Thres(11) & Beam_V_Lo_Thres(11) & Beam_V_Lo_Thres(11) & Beam_V_Lo_Thres(11) & Beam_V_Lo_Thres;
        when x"0002" => Reg_DataOut <= Beam_V_Hi_Thres(11) & Beam_V_Hi_Thres(11) & Beam_V_Hi_Thres(11) & Beam_V_Hi_Thres(11) & Beam_V_Hi_Thres;
        when x"0003" => Reg_DataOut <= "0000000" & Beam_V_Start;
        when x"0004" => Reg_DataOut <= "0000000" & Beam_V_Stop;

        when x"0005" => Reg_DataOut <= Beam_I_Lo_Thres(11) & Beam_I_Lo_Thres(11) & Beam_I_Lo_Thres(11) & Beam_I_Lo_Thres(11) & Beam_I_Lo_Thres;
        when x"0006" => Reg_DataOut <= Beam_I_Hi_Thres(11) & Beam_I_Hi_Thres(11) & Beam_I_Hi_Thres(11) & Beam_I_Hi_Thres(11) & Beam_I_Hi_Thres;
        when x"0007" => Reg_DataOut <= "0000000" & Beam_I_Start;
        when x"0008" => Reg_DataOut <= "0000000" & Beam_I_Stop;

        when x"0009" => Reg_DataOut <= FWD_PWR_Lo_Thres(11) & FWD_PWR_Lo_Thres(11) & FWD_PWR_Lo_Thres(11) & FWD_PWR_Lo_Thres(11) & FWD_PWR_Lo_Thres;
        when x"000A" => Reg_DataOut <= FWD_PWR_Hi_Thres(11) & FWD_PWR_Hi_Thres(11) & FWD_PWR_Hi_Thres(11) & FWD_PWR_Hi_Thres(11) & FWD_PWR_Hi_Thres;
        when x"000B" => Reg_DataOut <= "0000000" & FWD_PWR_Start;
        when x"000C" => Reg_DataOut <= "0000000" & FWD_PWR_Stop;

        when x"000D" => Reg_DataOut <= REFL_PWR_Lo_Thres(11) & REFL_PWR_Lo_Thres(11) & REFL_PWR_Lo_Thres(11) & REFL_PWR_Lo_Thres(11) & REFL_PWR_Lo_Thres;
        when x"000E" => Reg_DataOut <= REFL_PWR_Hi_Thres(11) & REFL_PWR_Hi_Thres(11) & REFL_PWR_Hi_Thres(11) & REFL_PWR_Hi_Thres(11) & REFL_PWR_Hi_Thres;
        when x"000F" => Reg_DataOut <= "0000000" & REFL_PWR_Start;
        when x"0010" => Reg_DataOut <= "0000000" & REFL_PWR_Stop;

        when x"0011" => Reg_DataOut <= "0000000" & Num_AveSamples;

        when x"0012" => Reg_DataOut <= iBeam_V_Average;
        when x"0013" => Reg_DataOut <= iBeam_I_Average;
        when x"0014" => Reg_DataOut <= iFwd_Pwr_Average;
        when x"0015" => Reg_DataOut <= iRefl_Pwr_Average;

        when x"0016" => Reg_DataOut <= Beam_V_Data;
        when x"0017" => Reg_DataOut <= Beam_I_Data;
        when x"0018" => Reg_DataOut <= FWD_PWR_Data;
        when x"0019" => Reg_DataOut <= REFL_PWR_Data;

        when others => Reg_DataOut <= (others => '0');
      end case;
    else
      case Lnk_Addr(11 downto 9) is
        when "000" => Reg_DataOut <= Beam_V_WFM_DOut;
        when "001" => Reg_DataOut <= Beam_I_WFM_DOut;
        when "010" => Reg_DataOut <= FWD_PWR_WFM_DOut;
        when "011" => Reg_DataOut <= REFL_PWR_WFM_DOut;
        when "100" => Reg_DataOut <= Beam_V_Ave_DOut;
        when "101" => Reg_DataOut <= Beam_I_Ave_DOut;
        when "110" => Reg_DataOut <= FWD_PWR_Ave_DOut;
        when "111" => Reg_DataOut <= REFL_PWR_Ave_DOut;

        when others =>
      end case;
    end if;
  end process;

  SyncTrigg_p : process(Clock, Reset)
  begin
    if (reset = '1') then
      SyncTrigger <= '0';
      iTrigger    <= '0';
    elsif (Clock'event and Clock = '1') then
      if (Trigger = '1') then
        iTrigger <= '1';
      elsif (ClrTrigger = '1') then
        iTrigger <= '0';
      end if;
      if (ADC_Clk = '1') then
        if (iTrigger = '1') then
          SyncTrigger <= '1';
        else
          SyncTrigger <= '0';
        end if;
      end if;
    end if;
  end process;

  Sample_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      ADC_Clk    <= '0';
      ClrTrigger <= '0';
      TimeCntr   <= (others => '0');
      Sample_s   <= Idle_s;
    elsif (Clock'event and Clock = '1') then
      ADC_Clk <= not(ADC_Clk);
      if (ADC_Clk = '1') then
        case Sample_s is
          when Idle_s =>
            TimeCntr <= (others => '0');
            if (SyncTrigger = '1') then
              ClrTrigger <= '1';
              Sample_s   <= WFM_s;
            else
              Sample_s <= Idle_s;
            end if;

          when WFM_s =>
            ClrTrigger <= '0';
            TimeCntr   <= TimeCntr + 1;
            if (TimeCntr = x"1FF") then
              Sample_s <= Idle_s;
            else
              Sample_s <= WFM_s;
            end if;

          when others =>
            Sample_s <= WFM_s;

        end case;
      end if;
    end if;
  end process;

  u_ad9228 : ad9228Input
    port map (
      Clock => ADC_Clk,
      Reset => Reset,

      FADC_CLK_P       => FADC_CLK_P,
      FADC_CLK_N       => FADC_CLK_N,
      FADC_FRAME_CLK_P => FADC_FRAME_CLK_P,
      FADC_FRAME_CLK_N => FADC_FRAME_CLK_N,
      FADC_DATA_CLK_P  => FADC_DATA_CLK_P,
      FADC_DATA_CLK_N  => FADC_DATA_CLK_N,
      BEAM_V_P         => BEAM_V_P,
      BEAM_V_N         => BEAM_V_N,
      BEAM_I_P         => BEAM_I_P,
      BEAM_I_N         => BEAM_I_N,
      FWD_PWR_P        => FWD_PWR_P,
      FWD_PWR_N        => FWD_PWR_N,
      REFL_PWR_P       => REFL_PWR_P,
      REFL_PWR_N       => REFL_PWR_N,
      Beam_V_Data      => iBeam_V_Data,
      Beam_I_Data      => iBeam_I_Data,
      FWD_PWR_Data     => iFWD_PWR_Data,
      REFL_PWR_Data    => iREFL_PWR_Data,

--      FrameClk                                        => FrameClk,
--      DataClk                                 => DataClk,
      DataClkLocked => DataClkLocked
      );

  u_BeamV : FastChannel
    port map (
      Clock  => Clock,
      Reset  => Reset,
      ADCClk => ADC_Clk,

      DataIn         => iBeam_V_Data,
      Trigger        => SyncTrigger,
      TimeCntr       => TimeCntr,
      Lo_Thres       => Beam_V_Lo_Thres,
      Hi_Thres       => Beam_V_Hi_Thres,
      Start          => Beam_V_Start,
      Stop           => Beam_V_Stop,
      Num_AveSamples => Num_AveSamples,

      ArmWFM   => ArmWFM,
      ArmAve   => ArmAve,
      WFMArmed => Beam_V_WFMArmed,
      AveArmed => Beam_V_AveArmed,

      WFM_RAddr => Lnk_Addr(8 downto 0),
      WFM_DOut  => Beam_V_WFM_DOut,
      AVE_DOut  => Beam_V_Ave_DOut,
      Average   => iBeam_V_Average,
      Status    => Beam_V_Status,
      Done      => Beam_V_Done
      );

  u_BeamI : FastChannel
    port map (
      Clock  => Clock,
      Reset  => Reset,
      ADCClk => ADC_Clk,

      DataIn         => iBeam_I_Data,
      Trigger        => SyncTrigger,
      TimeCntr       => TimeCntr,
      Lo_Thres       => Beam_I_Lo_Thres,
      Hi_Thres       => Beam_I_Hi_Thres,
      Start          => Beam_I_Start,
      Stop           => Beam_I_Stop,
      Num_AveSamples => Num_AveSamples,

      ArmWFM   => ArmWFM,
      ArmAve   => ArmAve,
      WFMArmed => Beam_I_WFMArmed,
      AveArmed => Beam_I_AveArmed,

      WFM_RAddr => Lnk_Addr(8 downto 0),
      WFM_DOut  => Beam_I_WFM_DOut,
      AVE_DOut  => Beam_I_Ave_DOut,
      Average   => iBeam_I_Average,
      Status    => Beam_I_Status,
      Done      => Beam_I_Done
      );

  u_FWDPWR : FastChannel
    port map (
      Clock  => Clock,
      Reset  => Reset,
      ADCClk => ADC_Clk,

      DataIn         => iFWD_PWR_Data,
      Trigger        => SyncTrigger,
      TimeCntr       => TimeCntr,
      Lo_Thres       => FWD_PWR_Lo_Thres,
      Hi_Thres       => FWD_PWR_Hi_Thres,
      Start          => FWD_PWR_Start,
      Stop           => FWD_PWR_Stop,
      Num_AveSamples => Num_AveSamples,

      ArmWFM   => ArmWFM,
      ArmAve   => ArmAve,
      WFMArmed => FWD_PWR_WFMArmed,
      AveArmed => FWD_PWR_AveArmed,

      WFM_RAddr => Lnk_Addr(8 downto 0),
      WFM_DOut  => FWD_PWR_WFM_DOut,
      AVE_DOut  => FWD_PWR_Ave_DOut,
      Average   => iFWD_PWR_Average,
      Status    => FWD_PWR_Status,
      Done      => FWD_PWR_Done
      );

  u_REFLPWR : FastChannel
    port map (
      Clock  => Clock,
      Reset  => Reset,
      ADCClk => ADC_Clk,

      DataIn         => iREFL_PWR_Data,
      Trigger        => SyncTrigger,
      TimeCntr       => TimeCntr,
      Lo_Thres       => REFL_PWR_Lo_Thres,
      Hi_Thres       => REFL_PWR_Hi_Thres,
      Start          => REFL_PWR_Start,
      Stop           => REFL_PWR_Stop,
      Num_AveSamples => Num_AveSamples,

      ArmWFM   => ArmWFM,
      ArmAve   => ArmAve,
      WFMArmed => REFL_PWR_WFMArmed,
      AveArmed => REFL_PWR_AveArmed,

      WFM_RAddr => Lnk_Addr(8 downto 0),
      WFM_DOut  => REFL_PWR_WFM_DOut,
      AVE_DOut  => REFL_PWR_Ave_DOut,
      Average   => iREFL_PWR_Average,
      Status    => REFL_PWR_Status,
      Done      => REFL_PWR_Done
      );
end behaviour;
