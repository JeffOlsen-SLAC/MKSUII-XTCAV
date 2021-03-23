-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      RFDrive -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/9/2011 2:32:34 PM
--      Last change: JO 6/3/2013 10:02:08 AM
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


entity RFDrive is
  port (
    Clock   : in std_logic;
    Reset   : in std_logic;
    FpReset : in std_logic;


-- Link Interface
    Lnk_Addr   : in std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr     : in std_logic;                      -- From Link Interface
    Lnk_DataIn : in std_logic_vector(15 downto 0);  -- From Link Interface

    Reg_DataOut  : out std_logic_vector(15 downto 0);
    LkUp_DataOut : out std_logic_vector(15 downto 0);
    Ram_We       : in  std_logic;       -- From Link Interface

    Clk1hzEn      : in std_logic;
    Clk10hzEn     : in std_logic;
    Clk10KhzEn    : in std_logic;
    Clk1MhzEn     : in std_logic;
    LocalMode     : in std_logic;
    LocalDrive    : in std_logic_vector(7 downto 0);
    LocalWr       : in std_logic;
    Fault3of5     : in std_logic;
    BeamILowFault : in std_logic;
    FwdPwrFault   : in std_logic;
    ReflPwrFault  : in std_logic;

--jjo 05/06/13
--add offline to ForceZero
    OFFLine : in std_logic;

-- jjo 7/8/13
-- Add mag off
    MagRfOff : in std_logic;

    Ramping : out std_logic;
    Status  : out std_logic_vector(15 downto 0);

    DisplayRFDrive : out std_logic_vector(15 downto 0);

    RFAttnClk   : out std_logic;
    RFAttnSync  : out std_logic;
    RFAttnSDOut : out std_logic
    );

end RFDrive;

architecture behaviour of RFDrive is

  signal ModeReg        : std_logic_vector(15 downto 0);
  signal iRamping       : std_logic;
  signal RemoteDrive    : std_logic_vector(13 downto 0);
  signal ActualDrive    : std_logic_vector(15 downto 0);
  signal RequestedDrive : std_logic_vector(7 downto 0);
  signal CurrentDrive   : std_logic_vector(7 downto 0);
  signal DeltaDrive     : std_logic_vector(7 downto 0);
  signal IncCounter     : std_logic_vector(7 downto 0);
  signal TxDrive        : std_logic_vector(15 downto 0);
  signal IncVal         : std_logic_vector(15 downto 0);
  signal IncRate        : std_logic;
  signal IncRateCntr    : std_logic_vector(4 downto 0);
  signal NewDrive       : std_logic;
  signal ClrNewDrive    : std_logic;
  signal RemoteReq      : std_logic;
  signal NormalMode     : std_logic;
  signal ForceZero      : std_logic;
  signal BitCntr        : std_logic_vector(3 downto 0);
  signal iRFAttnClk     : std_logic;
  signal DacSr          : std_logic_vector(15 downto 0);
  signal DacData        : std_logic_vector(15 downto 0);
  signal iStatus        : std_logic_vector(15 downto 0);
  signal LocalSr        : std_logic_vector(1 downto 0);
  signal LocalLe        : std_logic;
  signal RemoteLe       : std_logic;
  signal ByPass         : std_logic;
  signal Ram_Dout       : std_logic_vector(15 downto 0);
  signal ForceZeroSr    : std_logic_vector(1 downto 0);
  signal AutoReload     : std_logic;

  type RampState_t is
    (
      Idle_s,
      Calc_s,
      Inc_s,
      Tx_Sync_s,
      Tx_Data_s,
      Term_s
      );

  signal RampState : RampState_t;

begin

  DisplayRFDrive <= x"00" & CurrentDrive;

  Status      <= iStatus;
  iStatus     <= "000000000000" & ByPass & iRamping & "00";
  Ramping     <= iRamping;
  RFAttnClk   <= iRFAttnclk;
  RFAttnSDOut <= DacSr(15);

  NormalMode   <= not(ModeReg(0));
  ByPass       <= ModeReg(1) and not(LocalMode);
  LkUp_DataOut <= Ram_Dout;

  te_p : process(clock, Reset)
  begin
    if (reset = '1') then
      ForceZeroSr <= "00";
    elsif (Clock'event and Clock = '1') then
      ForceZeroSr <= ForceZeroSr(0) & ForceZero;
      if (ForceZeroSR = "10") then
        AutoReLoad <= '1';
      else
        AutoReLoad <= '0';
      end if;
    end if;
  end process;

  le_p : process(clock, Reset)
  begin
    if (reset = '1') then
      LocalSr  <= "00";
      LocalLe  <= '0';
      RemoteLe <= '0';
    elsif (Clock'event and Clock = '1') then
      LocalSr  <= LocalSr(0) & LocalMode;
      LocalLe  <= not(LocalSr(1)) and LocalSr(0);
      RemoteLe <= LocalSr(1) and not(LocalSr(0));
    end if;
  end process;

  newdrive_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      NewDrive       <= '0';
      RequestedDrive <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (LocalMode = '1') then
        if ((LocalWr = '1') or (LocalLe = '1')) then
          RequestedDrive <= LocalDrive;
          NewDrive       <= '1';
        end if;
      elsif ((RemoteReq = '1') or (RemoteLe = '1') or (AutoReLoad = '1')) then
        RequestedDrive <= RemoteDrive(7 downto 0);
        NewDrive       <= '1';
      elsif (ClrNewDrive = '1') then
        NewDrive <= '0';
      end if;
    end if;
  end process;

  WrReg : process(Clock, Reset)
  begin
    if (reset = '1') then
      ModeReg     <= (others => '0');
      RemoteDrive <= (others => '0');
      RemoteReq   <= '0';
    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        case Lnk_Addr is
          when x"0000" =>

          when x"0001" =>
            ModeReg <= Lnk_DataIN or ModeReg;
          when x"0002" =>
            ModeReg <= not(Lnk_DataIN) and ModeReg;
          when x"0003" =>
            RemoteDrive <= Lnk_DataIN(13 downto 0);
            RemoteReq   <= '1';
          when others =>
        end case;
      else
        RemoteReq <= '0';
      end if;
    end if;
  end process;

  RdREg : process(Lnk_Addr, RemoteDrive, LocalDrive, ModeReg, iRamping, CurrentDrive, ActualDrive, iStatus, bypass, RAM_Dout)
  begin
    case Lnk_Addr is
      when x"0000" => Reg_DataOut <= iStatus;
      when x"0001" => Reg_DataOut <= "00000000000000" & ByPass & ModeReg(0);
      when x"0002" => Reg_DataOut <= "00" & RemoteDrive;
      when x"0003" => Reg_DataOut <= x"00" & LocalDrive;
      when x"0004" => Reg_DataOut <= x"00" & CurrentDrive;
      when x"0005" => Reg_DataOut <= ActualDrive;
      when others  => Reg_DataOut <= (others => '0');
    end case;
  end process;

  IncRate_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      IncRate     <= '0';
      IncRateCntr <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (NormalMode = '1') then
        IncRate <= Clk10HzEn;
      else
        if (Clk10HzEn = '1') then
          if (IncRateCntr = "00000") then
            IncRateCntr <= "10111";     -- 0x17, 24
            IncRate     <= '1';
          else
            IncRateCntr <= IncRateCntr - 1;
            IncRate     <= '0';
          end if;
        else
-- jjo 05/30/13
-- Added else statement to lower increament
          IncRate <= '0';
        end if;
      end if;
    end if;
  end process;

  ForceZero <= BeamILowFault or Fault3of5 or FwdPwrFault or ReflPwrFault or OFFLine or MagRfOff;

  Ramp_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iRamping     <= '0';
      DeltaDrive   <= (others => '0');
      TxDrive      <= (others => '0');
      IncCounter   <= (others => '0');
      IncVal       <= (others => '0');
      CurrentDrive <= (others => '0');
      BitCntr      <= (others => '0');
      DacSr        <= (others => '0');
      ActualDrive  <= (others => '0');
      ClrNewDrive  <= '0';
      RFAttnSync   <= '0';
      iRFAttnClk   <= '0';
      RampState    <= Idle_s;
    elsif (Clock'event and Clock = '1') then
      case RampState is
        when Idle_s =>
          RFAttnSync <= '0';
          iRFAttnClk <= '1';
          if (ForceZero = '1') then
            iRamping   <= '0';
            TxDrive    <= (others => '0');
            IncCounter <= (others => '0');
            BitCntr    <= x"F";
            RampState  <= Tx_Sync_s;
          elsif (NewDrive = '1') then
            iRamping    <= '1';
            ClrNewDrive <= '1';
            DeltaDrive  <= RequestedDrive - CurrentDrive;
            if (ByPass = '0') then
              RampState <= Calc_s;
            else
              IncCounter <= x"00";
              BitCntr    <= x"F";
              RampState  <= Tx_Sync_s;
            end if;
          else
            iRamping  <= '0';
            RampState <= Idle_s;
          end if;

        when Calc_s =>
          ClrNewDrive        <= '0';
          if (RequestedDrive <= Currentdrive) then
            TxDrive    <= "000" & RequestedDrive & "00000";
            IncCounter <= x"00";
            BitCntr    <= x"F";
            RampState  <= Tx_Sync_s;
          elsif (ForceZero = '1') then
            RampState <= Idle_s;
          elsif (DeltaDrive <= x"01") then
            IncVal     <= x"0020";
            IncCounter <= x"00";
            TxDrive    <= (("000" & CurrentDrive & "00000") + x"0020");
            RampState  <= Inc_s;
          elsif (DeltaDrive < x"20") then
            IncVal     <= x"0020";
            IncCounter <= DeltaDrive - 1;
            TxDrive    <= (("000" & CurrentDrive & "00000") + x"0020");
            RampState  <= Inc_s;
          else
            IncVal     <= x"00" & DeltaDrive;
            IncCounter <= x"1F";
            TxDrive    <= (("000" & CurrentDrive & "00000") + (x"00" & DeltaDrive));
            RampState  <= Inc_s;
          end if;

        when Inc_s =>
          if (IncRate = '1') then
            if (IncCounter = x"00") then
              TxDrive <= "000" & RequestedDrive & "00000";
            else
              TxDrive <= TxDrive + IncVal;
            end if;
            BitCntr   <= x"F";
            RampState <= Tx_Sync_s;
          else
            RampState <= Inc_s;
          end if;

        when Tx_Sync_s =>
          if (Clk1MhzEn = '1') then
            RFAttnSync <= '1';
            if (ByPass = '0') then
              DacSr       <= "00" & DacData(15 downto 2);
              ActualDrive <= "00" & DacData(15 downto 2);
            elsif (ForceZero = '1') then
              DacSr       <= x"0000";
              ActualDrive <= x"0000";
            else
              DacSr       <= "00" & RemoteDrive;
              ActualDrive <= "00" & RemoteDrive;
            end if;
            RampState <= Tx_Data_s;
          else
            RampState <= Tx_Sync_s;
          end if;

        when Tx_Data_s =>
          if (Clk1MhzEn = '1') then
            iRFAttnClk <= not(iRFAttnClk);
            if (iRFAttnClk = '0') then
              if (BitCntr = x"0") then
                RampState <= Term_s;
              else
                DacSr     <= DacSr(14 downto 0) & '0';
                BitCntr   <= BitCntr - 1;
                RampState <= Tx_Data_s;
              end if;
            end if;
          else
            RampState <= Tx_Data_s;
          end if;

        when Term_s =>
          if (Clk1MhzEn = '1') then
            DacSr        <= (others => '0');
            iRFAttnClk   <= '1';
            RFAttnSync   <= '0';
            CurrentDrive <= TxDrive(12 downto 5);
            if (NewDrive = '1') then
              RampState <= Idle_s;
-- Added ForceZero Condition
-- jjo 04/04/13
            elsif (ForceZero = '1') then
              RampState <= Idle_s;
            elsif (IncCounter = x"00") then
              RampState <= Idle_s;
            else
              IncCounter <= IncCounter -1;
              RampState  <= Inc_s;
            end if;
          else
            RampState <= Term_s;
          end if;
      end case;
    end if;
  end process;

  u_DriveLkUp : RFDriveDPMem
    port map(
      clk  => Clock,
      a    => Lnk_Addr(7 downto 0),
      d    => Lnk_DataIn,
      we   => Ram_We,
      spo  => Ram_Dout,
      dpra => TxDrive(12 downto 5),
      dpo  => DacData
      );



--u_DriveLkUp : Drive_Lkup
--port map (
--      clka            => Clock,
--      addra   => TxDrive(12 downto 5),
--      douta   => DacData
--);

end behaviour;
