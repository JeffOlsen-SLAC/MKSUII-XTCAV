-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      alu.vhd - 
--
--      Copyright(c) SLAC National Accelerator Laboratory 2000
--
--      Author: JEFF OLSEN
--      Created on: 8/18/2011 3:21:24 PM
--      Last change: JO 1/18/2012 12:16:51 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:35:16 04/18/2011 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
use IEEE.std_logic_SIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.mksuii.all;

entity alu is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

-- 16 Bit signed integers       
    TrigDel   : in std_logic_vector(15 downto 0);
    RFDrive   : in std_logic_vector(15 downto 0);
    MicroPrev : in std_logic_vector(15 downto 0);
    BeamV     : in std_logic_vector(15 downto 0);
    BeamI     : in std_logic_vector(15 downto 0);
    FwdPwr    : in std_logic_vector(15 downto 0);
    RefPwr    : in std_logic_vector(15 downto 0);
    DeltaTemp : in std_logic_vector(15 downto 0);
    WgVac     : in std_logic_vector(15 downto 0);
    KlyVac    : in std_logic_vector(15 downto 0);

    ModRate : in std_logic_vector(15 downto 0);
    AccRate : in std_logic_vector(15 downto 0);
    ModId   : in std_logic_vector(7 downto 0);

    Clk119Pres : in std_logic;

    IP_Address : IPAddr_t;

    Assign   : in std_logic_vector(7 downto 0);  --  ACC/STBY
    HSTA     : in std_logic_vector(7 downto 0);  --  MNT/ TBR/ ARU/ OFF 
    ModState : in std_logic_vector(7 downto 0);  --  FLT/ HVR/AVAL/  ON

-- Display XY location
    X1 : out std_logic_vector(15 downto 0);
    Y1 : out std_logic_vector(15 downto 0);
    X2 : out std_logic_vector(15 downto 0);
    Y2 : out std_logic_vector(15 downto 0);

-- Control IO   7
    Refresh     : in std_logic;         -- Start Refresh Cycle
    cmd_Refresh : in std_logic;         --     Start Refresh Cycle

    NewData : out std_logic;            -- Update Display
    TxDone  : in  std_logic;            -- Display Done

-- Ascii output 8 characters
    ASCIIOut : out string(8 downto 1)
    );
end alu;

architecture Behavioral of alu is

  type aluState_t is
    (
      Idle_s,
      Wait_Refresh_s,
      Mult_s,
      Div_s,
      Offset_s,
      twoscomp_s,
      Dec2BCD_s,
      LeadingZero7_s,
      LeadingZero6_s,
      LeadingZero5_s,
      LeadingZero4_s,
      LeadingZero3_s,
      LeadingZero2_s,
      LeadingZero1_s,
      LatchData_s,
      BCD2Ascii_s
      );

  signal aluState : aluState_t;

  type DataIn_t is array(16 downto 0) of std_logic_vector(16 downto 0);
  signal Datain : DataIn_t;


  type aluConst_r is record
    Mult : integer range -32768 to 32767;
    Div  : integer range 0 to 131072;
    Offs : integer range -32768 to 32767;
    Dp   : integer range 0 to 4;
    Xval : integer range 0 to 480;
    Yval : integer range 0 to 272;
  end record aluConst_r;

  type aluConst_t is array(22 downto 0) of aluConst_r;

--Constant aluConst : aluConst_t :=
--(
----         Mult      Div    Offset  Dp   Xval   Yval
--      17 => (0,                       0,     0,      0,  340,   10),  -- ModState
--      16 => (0,                       0,     0,      0,  340,   10),  -- ModState
--      15 => (0,                       0,     0,      0,  340,   113), -- HSTA
--      14 => (0,                       0,     0,      0,  340,   90),  -- Assign
--      13 => (0,                       0,     0,      0,  130,   93),  -- Date
--      12 => (0,                       0,     0,      0,  130,   73),  -- Version
--      11 => (0,                       0,     0,      0,  130,  133),  -- AccRate
--      10 => (0,                       0,     0,      0,  130,  113),  -- ModRate
--      
--       9 => (5000,    4096,     0,      0,  340,   263),  -- Kly Vac
--       8 => (5000,    4096,     0,      0,  340,   233),      -- Wg Vac
--       7 => (-1213,   16384, 5923,      2,  340,   213),      -- Delta T
--       6 => (1000,    4096,     0,      0,  340,   193),      -- Ref Pwr
--       5 => (1000,    4096,     0,      0,  340,   173),      -- Fwd Pwr
--       4 => (1000,    4096,     0,      2,  340,   153),      -- BeamI
--       3 => (1000,    4096,     0,      2,  340,   133),      -- BeamV
--       2 => (1000,    4096,     0,      0,  130,   193),      -- Micro Prev
--       1 => (1000,    4096,     0,      2,  130,   173),      -- RFDrive
--       0 => (8400,     100,     0,      1,  130,   153)       -- TrigDelay
--
--
  constant aluConst : aluConst_t :=
    (
--         Mult      Div    Offset  Dp   Xval   Yval
      22 => (0, 0, 0, 0, 340, 10),      -- Dummy
      21 => (0, 0, 0, 0, 340, 113),     -- ModState
      20 => (0, 0, 0, 0, 340, 73),      -- HSTA
      19 => (0, 0, 0, 0, 340, 93),      -- Assign
      18 => (0, 0, 0, 0, 130, 93),      -- Date
      17 => (0, 0, 0, 0, 130, 73),      -- Version

      16 => (1, 1, 0, 0, 160, 253),        -- IPAddr0
      15 => (1, 1, 0, 0, 110, 253),        -- IPAddr1
      14 => (1, 1, 0, 0, 60, 253),         -- IPAddr2
      13 => (1, 1, 0, 0, 10, 253),         -- IPAddr3
      12 => (1, 1, 0, 0, 70, 53),          -- ID
      11 => (1, 100000, 0, 0, 130, 133),   -- ModRate
      10 => (1, 100000, 0, 0, 130, 113),   -- AccRate    
      9  => (1, 1, 0, 2, 340, 253),        -- Kly Vac
      8  => (1, 1, 0, 2, 340, 233),        -- Wg Vac
      7  => (1, 1, 0, 2, 340, 213),        -- Delta T
      6  => (2000, 4096, 0, 3, 340, 193),  -- Ref Pwr
      5  => (2000, 4096, 0, 3, 340, 173),  -- Fwd Pwr
      4  => (2000, 4096, 0, 3, 340, 153),  -- BeamI
      3  => (2000, 4096, 0, 3, 340, 133),  -- BeamV
      2  => (1, 1, 0, 2, 130, 193),        -- Micro Prev
      1  => (1, 1, 0, 2, 130, 173),        -- RFDrive
      0  => (84, 10, 0, 0, 130, 153)       -- TrigDelay
      );

--constant xoffset : std_logic_vector(15 downto 0) := x"0064";  -- 100
  constant xoffset : std_logic_vector(15 downto 0) := x"0050";  -- 80
  constant yoffset : std_logic_vector(15 downto 0) := x"000B";  -- 11

  signal DecimalPoint : integer range 0 to 4;

  signal DataPointer : std_logic_vector(5 downto 0);
  signal Counter     : std_logic_vector(5 downto 0);

  signal MultA     : std_logic_vector(15 downto 0);
  signal MultB     : std_logic_vector(16 downto 0);
  signal Prod      : std_logic_vector(54 downto 0);
  signal Divisor   : std_logic_vector(16 downto 0);
  signal iProd     : std_logic_vector(54 downto 0);
  signal iDivisor  : std_logic_vector(16 downto 0);
  signal Quotient  : std_logic_vector(53 downto 0);
  signal iQuotient : std_logic_vector(19 downto 0);

  signal iDecimal   : std_logic_vector(15 downto 0);
  signal NewDecimal : std_logic_vector(19 downto 0);
  signal Offset     : std_logic_vector(15 downto 0);
  signal NewDiv     : std_logic;
  signal DivDone    : std_logic;
  signal NewBCD     : std_logic;
  signal BCDDone    : std_logic;
  signal XLoc       : std_logic_vector(15 downto 0);
  signal YLoc       : std_logic_vector(15 downto 0);
  signal iNewData   : std_logic;
  signal iiNewData  : std_logic;

  signal iBCD      : std_logic_vector(31 downto 0);
  signal iASCIIOut : string(8 downto 1);
  signal Sign      : string(1 downto 1);

  constant MultCnt : integer := 4;
  constant DecCnt  : integer := 16;


begin


  XLoc <= CONV_std_logic_VECTOR(aluConst(Conv_Integer(DataPointer)).Xval, 16);
  YLoc <= CONV_std_logic_VECTOR(aluConst(Conv_Integer(DataPointer)).Yval, 16);

  process(clock, Reset)
  begin
    if (Reset = '1') then
      ASCIIOut <= (others => '0');
    elsif (Clock'event and Clock = '0') then
      case DataPointer is
        when "010001" => ASCIIOut <= MKSUII_Version;
        when "010010" => ASCIIOut <= Date_ID;
        when "010011" => ASCIIOut <= "Assign  ";
        when "010100" => ASCIIOut <= " HASTA  ";
        when "010101" => ASCIIOut <= "ModState";
        when others   => ASCIIOut <= iAsciiOut;
      end case;
    end if;
  end process;

  q_p : process(Clock, reset)
  begin
    if (Reset = '1') then
      iQuotient <= (others => '0');
    elsif (Clock'event and Clock = '1') then
      if (DivDone = '1') then
        iQuotient <= Quotient(19 downto 0);
      end if;
    end if;
  end process;

  alu_p : process(Clock, Reset)
    variable iAddress : integer;
  begin
    iAddress := Conv_Integer(DataPointer);
    if (Reset = '1') then
      iASCIIOut   <= (others => '0');
      DataPointer <= (others => '0');
      Counter     <= (others => '0');
      MultA       <= (others => '0');
      MultB       <= (others => '0');
      Divisor     <= (others => '0');
      Offset      <= (others => '0');
      X1          <= (others => '0');
      Y1          <= (others => '0');
      X2          <= (others => '0');
      Y2          <= (others => '0');

      NewBCD    <= '0';
      NewDiv    <= '0';
      NewData   <= '0';
      iNewData  <= '0';
      iiNewData <= '0';

      aluState <= Idle_s;
    elsif (Clock'event and Clock = '1') then
      iiNewData <= iNewData;
      NewData   <= iiNewData;
      case aluState is
        when Idle_s =>
--              DataPointer <= "01010";
          DataPointer <= "000000";

-- Sign extend to 17 bits
          Datain(16) <= "000000000" & IP_Address(0);
          Datain(15) <= "000000000" & IP_Address(1);
          Datain(14) <= "000000000" & IP_Address(2);
          Datain(13) <= "000000000" & IP_Address(3);
          Datain(12) <= "000000000" & ModId;
          Datain(11) <= ModRate(15) & ModRate;
          Datain(10) <= AccRate(15) & AccRate;
          Datain(9)  <= KlyVac(15) & KlyVac;
          Datain(8)  <= WgVac(15) & WgVac;
          Datain(7)  <= DeltaTemp(15) & DeltaTemp;
          Datain(6)  <= RefPwr(15) & RefPwr;
          Datain(5)  <= FwdPwr(15) & FwdPwr;
          Datain(4)  <= BeamI(15) & BeamI;
          Datain(3)  <= BeamV(15) & BeamV;
          Datain(2)  <= MicroPrev(15) & MicroPrev;
          Datain(1)  <= RFDrive(15) & RFDrive;
          Datain(0)  <= '0' & TrigDel;  -- unsigned 16 bits

          if ((Refresh = '1') or (cmd_Refresh = '1'))then
            aluState <= LatchData_s;
          else
            aluState <= Idle_s;
          end if;

        when Wait_Refresh_s =>
          iNewData <= '0';
          if (TxDone = '1') then
            DataPointer <= DataPointer +1;
            if (DataPointer = "010101") then
              aluState <= Idle_s;
            else
              aluState <= LatchData_s;
            end if;
          else
            aluState <= Wait_Refresh_s;
          end if;

        when LatchData_s =>
          X1 <= XLoc;
          Y1 <= YLoc;
          X2 <= XLoc + XOffset;
          Y2 <= YLoc - YOffset;
          if ((Clk119Pres = '0') and (DataPointer = "000000")) then
            MultA <= CONV_std_logic_VECTOR(80, 16);  -- 125Mhz operation
          else
            MultA <= CONV_std_logic_VECTOR(aluConst(iAddress).Mult, 16);
          end if;

          if (DataPointer > "010000") then
            iNewData <= '1';
            aluState <= Wait_Refresh_s;
          else
            MultB        <= DataIn(iAddress);
            iDivisor     <= CONV_std_logic_VECTOR(aluConst(iAddress).Div, 17);
            Offset       <= CONV_std_logic_VECTOR(aluConst(iAddress).Offs, 16);
            Counter      <= CONV_std_logic_VECTOR(MultCnt, 6);
            DecimalPoint <= aluConst(iAddress).dp;
            aluState     <= mult_s;
          end if;

        when Mult_s =>
          Counter <= Counter -1;
          if (Counter = "000000") then
            if ((DataPointer = "001010") or (DataPointer = "001011")) then
              if (Clk119Pres = '1') then
                Prod <= x"000000000" & "00" & iDivisor;
              else
                Prod <= x"000000000" & "00" & CONV_std_logic_VECTOR(105000, 17);
              end if;
              Divisor <= iProd(16 downto 0);
            else
              Prod    <= iProd;
              Divisor <= iDivisor;
            end if;

            NewDiv   <= '1';
            aluState <= Div_s;
          else
            aluState <= Mult_s;
          end if;

        when Div_s =>
          NewDiv <= '0';
          if (DivDone = '1') then
            aluState <= Offset_s;
          else
            aluState <= Div_s;
          end if;

        when Offset_s =>
          aluState <= twoscomp_s;

        when twoscomp_s =>
          NewBCD <= '1';
          if (DataPointer /= "000000") then
            if (iDecimal < 0) then
              NewDecimal <= x"0" & (not(iDecimal) + 1);
              Sign       <= "-";
            else
              NewDecimal <= x"0" & iDecimal;
              Sign       <= " ";
            end if;
          else
            NewDecimal <= iQuotient;
            Sign       <= " ";
          end if;

          aluState <= Dec2BCD_s;

        when Dec2BCD_s =>
          NewBcd <= '0';
          if (BCDDone = '1') then
            aluState <= BCD2Ascii_s;
          else
            aluState <= Dec2Bcd_s;
          end if;

        when BCD2Ascii_s =>
          case DecimalPoint is
            when 0 =>
              iASCIIOut(1) <= StdLogicVector_to_Character(iBCD(3 downto 0));
              iASCIIOut(2) <= StdLogicVector_to_Character(iBCD(7 downto 4));
              iASCIIOut(3) <= StdLogicVector_to_Character(iBCD(11 downto 8));
              iASCIIOut(4) <= StdLogicVector_to_Character(iBCD(15 downto 12));
              iASCIIOut(5) <= StdLogicVector_to_Character(iBCD(19 downto 16));
              iASCIIOut(6) <= StdLogicVector_to_Character(iBCD(23 downto 20));
              iASCIIOut(7) <= StdLogicVector_to_Character(iBCD(27 downto 24));
              iASCIIOut(8) <= '0';
            when 1 =>
              iASCIIOut(1) <= StdLogicVector_to_Character(iBCD(3 downto 0));
              iASCIIOut(2) <= '.';
              iASCIIOut(3) <= StdLogicVector_to_Character(iBCD(7 downto 4));
              iASCIIOut(4) <= StdLogicVector_to_Character(iBCD(11 downto 8));
              iASCIIOut(5) <= StdLogicVector_to_Character(iBCD(15 downto 12));
              iASCIIOut(6) <= StdLogicVector_to_Character(iBCD(19 downto 16));
              iASCIIOut(7) <= StdLogicVector_to_Character(iBCD(23 downto 20));
              iASCIIOut(8) <= '0';
            when 2 =>
              iASCIIOut(1) <= StdLogicVector_to_Character(iBCD(3 downto 0));
              iASCIIOut(2) <= StdLogicVector_to_Character(iBCD(7 downto 4));
              iASCIIOut(3) <= '.';
              iASCIIOut(4) <= StdLogicVector_to_Character(iBCD(11 downto 8));
              iASCIIOut(5) <= StdLogicVector_to_Character(iBCD(15 downto 12));
              iASCIIOut(6) <= StdLogicVector_to_Character(iBCD(19 downto 16));
              iASCIIOut(7) <= StdLogicVector_to_Character(iBCD(23 downto 20));
              iASCIIOut(8) <= '0';
            when 3 =>
              iASCIIOut(1) <= StdLogicVector_to_Character(iBCD(3 downto 0));
              iASCIIOut(2) <= StdLogicVector_to_Character(iBCD(7 downto 4));
              iASCIIOut(3) <= StdLogicVector_to_Character(iBCD(11 downto 8));
              iASCIIOut(4) <= '.';
              iASCIIOut(5) <= StdLogicVector_to_Character(iBCD(15 downto 12));
              iASCIIOut(6) <= StdLogicVector_to_Character(iBCD(19 downto 16));
              iASCIIOut(7) <= StdLogicVector_to_Character(iBCD(23 downto 20));
              iASCIIOut(8) <= '0';
            when 4 =>
              iASCIIOut(1) <= StdLogicVector_to_Character(iBCD(3 downto 0));
              iASCIIOut(2) <= StdLogicVector_to_Character(iBCD(7 downto 4));
              iASCIIOut(3) <= StdLogicVector_to_Character(iBCD(11 downto 8));
              iASCIIOut(4) <= StdLogicVector_to_Character(iBCD(15 downto 12));
              iASCIIOut(5) <= '.';
              iASCIIOut(6) <= StdLogicVector_to_Character(iBCD(19 downto 16));
              iASCIIOut(7) <= StdLogicVector_to_Character(iBCD(23 downto 20));
              iASCIIOut(8) <= '0';
          end case;

          aluState <= LeadingZero7_s;

        when LeadingZero7_s =>
          if ((iASCIIOut(8) = '0') and (iASCIIOut(7) /= '.')) then
            iASCIIOut(8) <= ' ';
            aluState     <= LeadingZero6_s;
          else
            iNewData <= '1';
            aluState <= Wait_Refresh_s;
          end if;

        when LeadingZero6_s =>
          if ((iASCIIOut(7) = '0') and (iASCIIOut(6) /= '.')) then
            iASCIIOut(7) <= ' ';
            aluState     <= LeadingZero5_s;
          else
            iASCIIOut(8) <= Sign(1);
            iNewData     <= '1';
            aluState     <= Wait_Refresh_s;
          end if;

        when LeadingZero5_s =>
          if ((iASCIIOut(6) = '0') and (iASCIIOut(5) /= '.')) then
            iASCIIOut(6) <= ' ';
            aluState     <= LeadingZero4_s;
          else
            iASCIIOut(7) <= Sign(1);
            iNewData     <= '1';
            aluState     <= Wait_Refresh_s;
          end if;

        when LeadingZero4_s =>
          if ((iASCIIOut(5) = '0') and (iASCIIOut(4) /= '.')) then
            iASCIIOut(5) <= ' ';
            aluState     <= LeadingZero3_s;
          else
            iASCIIOut(6) <= Sign(1);
            iNewData     <= '1';
            aluState     <= Wait_Refresh_s;
          end if;

        when LeadingZero3_s =>
          if ((iASCIIOut(4) = '0') and (iASCIIOut(3) /= '.')) then
            iASCIIOut(4) <= ' ';
            aluState     <= LeadingZero2_s;
          else
            iASCIIOut(5) <= Sign(1);
            iNewData     <= '1';
            aluState     <= Wait_Refresh_s;
          end if;

        when LeadingZero2_s =>
          if ((iASCIIOut(3) = '0') and (iASCIIOut(2) /= '.')) then
            iASCIIOut(3) <= ' ';
            aluState     <= LeadingZero1_s;
          else
            iASCIIOut(4) <= Sign(1);
            iNewData     <= '1';
            aluState     <= Wait_Refresh_s;
          end if;

        when LeadingZero1_s =>
          if ((iASCIIOut(2) = '0') and (iASCIIOut(1) /= '.')) then
            iASCIIOut(2) <= ' ';
          end if;
          iASCIIOut(3) <= Sign(1);
          iNewData     <= '1';
          aluState     <= Wait_Refresh_s;


      end case;
    end if;
  end process;


--alu_mult : sign16xsign16
--port map (
--      clk     => Clock,
--      a               => MultA,
--      b               => MultB,
--      p               => Prod
--);

  alu_mult : mults16s16x54
    port map (
      clk => Clock,
      a   => MultA,
      b   => MultB,
      p   => iProd
      );

--alu_div : sign32div16
--port map (
--      clk             => Clock,
--      nd              => NewDiv,
--      rdy             => DivDone,
--      rfd             => open,
--      dividend => Prod,
--      divisor         => Divisor,
--      quotient => Quotient
--);
--

  alu_div : div54x16x32
    port map (
      clk      => Clock,
      nd       => NewDiv,
      rdy      => DivDone,
      rfd      => open,
      dividend => Prod(53 downto 0),
      divisor  => Divisor,
      quotient => Quotient
      );


  alu_off : sign16plussign16
    port map (
      clk => Clock,
      a   => iQuotient(15 downto 0),
      b   => Offset,
      s   => iDecimal
      );


  alu_bcd : BCDConv
    port map (
      Clock  => Clock,
      Reset  => Reset,
      Init   => NewBCD,
      DecIn  => NewDecimal,
      ModOut => open,
      Done   => BCDDone,
      BCDOut => iBCD                    -- BCD result
      );

end Behavioral;

