-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      eDipTFT43_Intf.vhd - 
--
--      Copyright(c) SLAC National Accelerator Laboratory 2000
--
--      Author: JEFF OLSEN
--      Created on: 8/19/2011 8:28:28 AM
--      Last change: JO 8/19/2011 9:22:55 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:10 11/16/2010 
-- Design Name: 
-- Module Name:    eDipTFT43_intf - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Commentslibrary IEEE;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library work;
use work.mksuii.all;

--
----------------------------------------------------------------------------------

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eDipTFT43_intf is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

-- Link
    Lnk_Addr    : in  std_logic_vector(15 downto 0);
    Lnk_Wr      : in  std_logic;
    Lnk_DataIn  : in  std_logic_vector(15 downto 0);
    Reg_DataOut : out std_logic_vector(15 downto 0);

    clk400KhzEn : in std_logic;

    cmd_Refresh : out std_logic;

-- Display update
    NewData : in  std_logic;
    Tx_Done : out std_logic;
    x1      : in  std_logic_vector(15 downto 0);
    y1      : in  std_logic_vector(15 downto 0);
    x2      : in  std_logic_vector(15 downto 0);
    y2      : in  std_logic_vector(15 downto 0);
    ASCIIIn : in  string(8 downto 1);

    SPI_SS    : out std_logic;
    SPI_Clk   : out std_logic;
    SPI_MOSI  : out std_logic;
    SPI_MISO  : in  std_logic;
    SBUF      : in  std_logic;
    FPD_Reset : out std_logic;
    FPD_DPOM  : out std_logic

    );
end eDipTFT43_intf;

architecture Behavioral of eDipTFT43_intf is


  type State_t is
    (
      Idle_s,
      Clk_s,
      TermClk_s,
      TermSS_s,
      Ack_Del1_s,
      Ack_Del2_s,
      Term_s
      );

  type Display_t is
    (
      Wait_NewData_s,
      Write_Fifo_s
      );


  signal State        : State_t;
  signal DisplayState : Display_t;
  signal iSS          : std_logic;
  signal iClk         : std_logic;
  signal iMOSI        : std_logic;
  signal iMISO        : std_logic;
  signal Tx_Start_Req : std_logic;
  signal Tx_Start_Clr : std_logic;
  signal DataOutSr    : std_logic_vector(7 downto 0);
  signal DataInSr     : std_logic_vector(7 downto 0);
  signal BitCntr      : std_logic_vector(2 downto 0);

  signal rd_Fifo       : std_logic;
  signal Fifo_Din      : std_logic_vector(7 downto 0);
  signal Fifo_Dout     : std_logic_vector(7 downto 0);
  signal Display_Cnt   : std_logic_vector(7 downto 0);
  signal empty         : std_logic;
  signal ACK_Start_Req : std_logic;
  signal ByteCntr      : std_logic_vector(15 downto 0);
  signal NumBytes      : std_logic_vector(15 downto 0);
  signal DisplayChksum : std_logic_vector(15 downto 0);
  signal FF_Reset      : std_logic;
  signal Reset_Fifo    : std_logic;
  signal cmd_Reset     : std_logic;
  signal cmd_DnLdReq   : std_logic;
  signal RdyDnLd       : std_logic;
  signal Mem_Wr        : std_logic;
  signal Display_Wr    : std_logic;
  signal iStatus       : std_logic_vector(7 downto 0);
  signal StatusLatch   : std_logic_vector(7 downto 0);
  signal CntlReg       : std_logic_vector(15 downto 0);
  signal d_RdyDnLd     : std_logic;
  signal iTx_Done      : std_logic;
  signal iiTx_Done     : std_logic;
  signal Busy          : std_logic;

begin

  SPI_MOSI <= iMOSI;
  SPI_SS   <= iSS;
  SPI_Clk  <= iClk;

  FPD_Reset <= CntlReg(0);
  FPD_DPOM  <= CntlReg(1);

  iMISO <= SPI_MISO;
--iMISO         <= iMOSI;

  FF_Reset <= Reset or Reset_Fifo or cmd_Reset;

  cmd_DnLdReq <= cntlReg(2);

-- Delay from block to block (640us)
  u_DoneDelay : prog_strobe16
    port map (
      Clock     => Clock,
      Reset     => Reset,
      TriggerIn => iiTx_Done,
      Delay     => x"000F",
      width     => x"0001",
      Pulse     => Tx_Done
      );


  Mux_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      Fifo_Din <= (others => '0');
      Mem_Wr   <= '0';
    elsif (Clock'event and Clock = '1') then
      if (RdyDnLd = '1') then
        if Lnk_Addr(8) = '1' then
          Fifo_Din <= Lnk_DataIn(7 downto 0);
          Mem_Wr   <= Lnk_Wr;
        else
          Fifo_Din <= (others => '0');
          Mem_Wr   <= '0';
        end if;
      else
        Mem_Wr <= Display_Wr;
        case Display_Cnt is
          when x"00"  => Fifo_Din <= x"11";  -- DC1 Character
          when x"01"  => Fifo_Din <= x"15";  -- Len always 21
          when x"02"  => Fifo_Din <= x"1B";  -- Esc 
          when x"03"  => Fifo_Din <= Character_to_StdLogicVector('Z');
          when x"04"  => Fifo_Din <= Character_to_StdLogicVector('B');
          when x"05"  => Fifo_Din <= x1(7 downto 0);
          when x"06"  => Fifo_Din <= x1(15 downto 8);
          when x"07"  => Fifo_Din <= y1(7 downto 0);
          when x"08"  => Fifo_Din <= y1(15 downto 8);
          when x"09"  => Fifo_Din <= x2(7 downto 0);
          when x"0A"  => Fifo_Din <= x2(15 downto 8);
          when x"0B"  => Fifo_Din <= y2(7 downto 0);
          when x"0C"  => Fifo_Din <= y2(15 downto 8);
          when x"0D"  => Fifo_Din <= x"07";  -- 7, Bottom Left orientation
          when x"0E"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(8));
          when x"0F"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(7));
          when x"10"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(6));
          when x"11"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(5));
          when x"12"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(4));
          when x"13"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(3));
          when x"14"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(2));
          when x"15"  => Fifo_Din <= Character_to_StdLogicVector(ASCIIIn(1));
          when x"16"  => Fifo_Din <= x"00";  -- Null Termination
          when x"17"  => Fifo_Din <= DisplayChksum(7 downto 0);
          when others => Fifo_Din <= (others => '0');
        end case;
      end if;
    end if;
  end process;

  Cntl_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      cmd_Reset   <= '0';
      cmd_Refresh <= '0';
      CntlReg     <= (others => '0');
      StatusLatch <= x"00";
    elsif (Clock'event and Clock = '1') then
      if (Lnk_Wr = '1') then
        case Lnk_Addr is
          when x"0000" =>
            StatusLatch <= (others => '0');
          when x"0001" =>
            Statuslatch <= StatusLatch or iStatus;
            if (Lnk_DataIn(0) = '1') then
              cmd_Reset <= '1';
            end if;
            if (Lnk_DataIn(3) = '1') then
              cmd_Refresh <= '1';
            end if;
            CntlReg <= Lnk_DataIn or CntlReg;
          when x"0002" =>
            Statuslatch <= StatusLatch or iStatus;
            CntlReg     <= not(Lnk_DataIn) and CntlReg;
          when others =>
        end case;
      else
        Statuslatch <= StatusLatch or iStatus;
        cmd_Reset   <= '0';
        cmd_Refresh <= '0';
      end if;
    end if;
  end process;

  Rd_Reg : process(Lnk_Addr, StatusLatch, CntlReg, RdyDnLd)
  begin
    case Lnk_Addr(3 downto 0) is
      when x"0"   => Reg_DataOut <= "0000000" & RdyDnLd & StatusLatch;
      when x"1"   => Reg_DataOut <= x"000" & '0' & CntlReg(2 downto 0);
      when others => Reg_DataOut <= (others => '0');
    end case;
  end process;

  DisplayWr_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      Display_Wr    <= '0';
      Display_Cnt   <= x"00";
      DisplayChksum <= (others => '0');
      DisplayState  <= Wait_NewData_s;
    elsif (Clock'event and Clock = '1') then
      case DisplayState is
        when Wait_NewData_s =>
          Display_Cnt <= (others => '0');
          if (NewData = '1') then
            Display_Wr    <= '1';
            DisplayChksum <= x"0000";
            DisplayState  <= Write_Fifo_s;
          else
            DisplayState <= Wait_NewData_s;
          end if;

        when Write_Fifo_s =>
          if (Display_Cnt < x"17") then
            if (Mem_Wr = '1') then
              DisplayChkSum <= DisplayChkSum + Fifo_Din;
            end if;
            Display_Cnt  <= Display_Cnt + 1;
            DisplayState <= Write_Fifo_s;
          else
            Display_Wr   <= '0';
            DisplayState <= Wait_NewData_s;
          end if;

        when others =>
          DisplayState <= Wait_NewData_s;
      end case;
    end if;
  end process;

  clken : process(Clock, Reset)
  begin
    if (Reset = '1') then
      Tx_Start_Req <= '0';
    elsif (Clock'event and Clock = '1') then
      if (Empty = '0') then
        Tx_Start_Req <= '1';
      elsif (Tx_Start_Clr = '1') then
        Tx_Start_Req <= '0';
      end if;

    end if;
  end process;

  txdone_p : process(clock, Reset)
  begin
    if (Reset = '1') then
      iiTx_Done <= '0';
      RdyDnLd   <= '0';
      d_RdyDnLd <= '0';

    elsif (Clock'event and Clock = '1') then
      d_RdyDnLd <= RdyDnLd;
      if (busy = '0') then
        if (cmd_DnLdReq = '1') then
          RdyDnLd <= '1';
        elsif ((d_RdyDnLd = '1') and (RdyDnLd = '0')) then  -- Restart normal refresh after dropping enable
          iiTx_Done <= '1';
        else
          iiTx_Done <= iTx_Done;
        end if;
      else
        iiTx_Done <= iTx_Done;
      end if;

      if (cmd_DnLdReq = '0') then
        RdyDnLd <= '0';
      end if;
    end if;
  end process;

  spi_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      Tx_Start_Clr  <= '0';
      Ack_Start_Req <= '0';
      iSS           <= '0';
      iClk          <= '1';
      iMOSI         <= '0';
      iTx_Done      <= '0';
      Rd_Fifo       <= '0';
      Reset_Fifo    <= '0';
      Busy          <= '0';
      DataOutSr     <= (others => '0');
      DataInSr      <= (others => '0');
      BitCntr       <= (others => '0');
      ByteCntr      <= (others => '0');
      NumBytes      <= (others => '0');
      iStatus       <= (others => '0');
      State         <= Idle_s;
    elsif (Clock'event and Clock = '1') then
      Rd_Fifo    <= '0';
      iTx_Done   <= '0';
      Reset_Fifo <= '0';
      iStatus    <= (others => '0');
      if (clk400KhzEn = '1') then
        case State is
          when Idle_s =>
            iStatus    <= (others => '0');
            Reset_Fifo <= '0';
            BitCntr    <= "111";
            if (Tx_Start_Req = '1') then
              Tx_Start_Clr <= '1';
              Busy         <= '1';
              Rd_Fifo      <= '1';
              DataOutSr    <= Fifo_Dout(6 downto 0) & '0';
              iMOSI        <= Fifo_Dout(7);
              iSS          <= '1';
              if (ByteCntr = x"0001") then
                NumBytes <= x"00" & Fifo_Dout + 2;
              end if;
              State <= Clk_s;
            else
              Busy  <= '0';
              iClk  <= '0';
              iSS   <= '0';
              State <= Idle_s;
            end if;

          when Clk_s =>
            Rd_Fifo      <= '0';
            Tx_Start_Clr <= '0';
            iClk         <= not(IClk);
            if (iClk = '1') then
              BitCntr   <= BitCntr - 1;
              iMOSI     <= DataOutSr(7);
              DataOutSr <= DataOutSr(6 downto 0) & '0';
              if (BitCntr = "000") then
                State <= TermClk_s;
              else
                State <= Clk_s;
              end if;
            end if;

            if (iClk = '1') then
              DataInSr <= DataInSr(6 downto 0) & iMISO;
            end if;

          when TermClk_s =>
            --DataInSr                  <=  DataInSr(6 downto 0) & iMISO;
            iMOSI <= '0';
            iClk  <= '0';
            iSS   <= '0';
            State <= TermSS_s;

          when TermSS_s =>
            iSS <= '0';
            if ((ByteCntr > x"0002") and (ByteCntr = NumBytes) and (Ack_Start_Req = '0')) then
              Reset_Fifo    <= '1';
              Tx_Start_Clr  <= '1';
              BitCntr       <= "111";
              DataOutSr     <= x"FF";
              iMOSI         <= '1';
              ByteCntr      <= (others => '0');
              numBytes      <= (others => '0');
              Ack_Start_Req <= '1';
              State         <= Ack_Del1_s;
            elsif (Ack_Start_Req = '1') then
              Ack_Start_Req       <= '0';
              iTx_Done            <= '1';
              iStatus(7 downto 0) <= DataInSr;
              State               <= Term_s;
            else
              ByteCntr <= ByteCntr + 1;
              State    <= Term_s;
            end if;

          when Ack_Del1_s =>
            State <= Ack_Del2_s;

          when Ack_Del2_s =>
            iSS   <= '1';
            State <= Clk_s;

          when Term_s =>
            iTx_Done     <= '0';
            Reset_Fifo   <= '0';
            Tx_Start_Clr <= '0';
            State        <= Idle_s;

          when others =>
            State <= Idle_s;

        end case;

      end if;
    end if;
  end process;

  u_Spi_Fiofo : SPI_Fifo
    port map (
      clk   => Clock,
      rst   => FF_Reset,
      din   => Fifo_Din,
      wr_en => Mem_Wr,
      rd_en => Rd_Fifo,
      dout  => Fifo_dout,
      full  => open,
      empty => empty
      );

end Behavioral;

