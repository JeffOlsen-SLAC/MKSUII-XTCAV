-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      atmel_2wire.vhd -
--
--      Copyright(c) SLAC 2000
--
--      Author: Jeff Olsen
--      Created on: 2/4/2008 1:32:47 PM
--      Last change: JO 5/23/2011 8:48:42 AM
--
----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:30:20 01/31/2008
-- Design Name:
-- Module Name:    atmel_2wire - Behavioral
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

library work;
use work.mpsnode.all;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- According to spec SFF-8472, 16 bit values MUST be readout using
-- two byte read sequences. 
-- This routine reads ALL data using 2 byte read sequences.
--


entity atmel_2wire is
  port (
    Clock       : in  std_logic;
    Reset       : in  std_logic;
    Start       : in  std_logic;
    Done        : out std_logic;
    Din_A       : in  std_logic;
    Din_B       : in  std_logic;
    Dout        : out std_logic;
    En_Dout     : out std_logic;
    SClk        : out std_logic;
    Rd_Mem_Addr : in  std_logic_vector(7 downto 0);
    Mem_Dout    : out std_logic_vector(31 downto 0)
    );
end atmel_2wire;

architecture Behavioral of atmel_2wire is

  constant devaddr_A0 : std_logic_vector(6 downto 0) := "1010000";
  constant devaddr_A2 : std_logic_vector(6 downto 0) := "1010001";
  constant memmax     : std_logic_vector(7 downto 0) := "11111111";

  signal divider   : std_logic_vector(8 downto 0);
  signal iOut_Sr   : std_logic_vector(7 downto 0);
  signal iIn_Sr_A  : std_logic_vector(7 downto 0);
  signal iIn_Sr_B  : std_logic_vector(7 downto 0);
  signal cntr      : std_logic_vector(2 downto 0);
  signal clk_cntr  : std_logic_vector(1 downto 0);
  signal iEn_Dout  : std_logic;
  signal Clk_en    : std_logic;
  signal iSClk     : std_logic;
  signal Mem_Addr  : std_logic_vector(9 downto 0);
  signal Mem_Wr    : std_logic;
  signal Mem_Write : std_logic;
  signal Mem_Din   : std_logic_vector(7 downto 0);
  signal Space     : std_logic;
  signal iStart    : std_logic;
  signal iDone     : std_logic;

  type seq_state_t is
    (
      Idle_s,
      Start_s,
      Dev_Addr_Wr_s,
      Dev_Wr_Ack_s,
      Wrd_Addr_s,
      Wrd_Ack_s,
      Dev_Addr_Start_s,
      Dev_Addr_Rd_s,
      Dev_Rd_Ack_s,
      Read_Hi_s,
      Read_Hi_Ack_s,
      Read_Lo_s,
      Read_Lo_Ack_s,
      Stop_s,                           
      Wait_s
      );

  signal seq_State : seq_state_t;

begin

  Dout    <= iOut_Sr(7);
  SClk    <= iSClk;
  En_Dout <= iEn_Dout;

  Done <= iDone;

  Mem_Write <= (Mem_Wr and Clk_En);

  clk_en_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      divider <= (others => '0');
      clk_en  <= '0';
    elsif (Clock'event and Clock = '1') then
      divider <= divider +1;
      if (divider = "000100111") then
        divider <= (others => '0');
        clk_en  <= '1';
      else
        divider <= divider +1;
        clk_en  <= '0';
      end if;
    end if;
  end process;  -- clk_en

  start_p : process(clock, reset)
  begin
    if (Reset = '1') then
      iStart   <= '0';
      clk_cntr <= "00";
    elsif (Clock'event and Clock = '1') then
      if (Start = '1') then
        iStart <= '1';
      end if;
      if ((istart = '1') and (clk_en = '1')) then
        clk_cntr <= "00";
        iStart   <= '0';
      elsif (clk_en = '1') then
        clk_cntr <= clk_cntr + 1;
      end if;
    end if;
  end process;  --start_p


  Seq_p : process(Clock, Reset)
  begin
    if (Reset = '1') then
      iOut_Sr   <= (others => '1');
      iIn_Sr_A  <= (others => '0');
      iIn_Sr_B  <= (others => '0');
      cntr      <= (others => '0');
      Mem_Addr  <= (others => '0');
      Mem_Wr    <= '0';
      Mem_Din   <= (others => '0');
      iSClk     <= '0';
      iEn_Dout  <= '0';
      Seq_State <= Idle_s;
      space     <= '0';
      iDone     <= '0';
    elsif (Clock'event and Clock = '1') then
      if (iDone = '1') then
        iDone <= '0';
      end if;
      if (clk_en = '1') then
        case Seq_State is
          when Idle_s =>
            iSClk   <= '0';
            iOut_Sr <= (others => '1');
            iDone   <= '0';
            if (iStart = '1') then
              iEn_Dout  <= '1';
              Seq_State <= Start_s;
            else
              iEn_Dout  <= '0';
              Seq_State <= Idle_s;
            end if;

          when Start_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
                if (Space = '0') then
                  Mem_Addr(8) <= '0';
                  iOut_Sr     <= '0' & DevAddr_A0;
                else
                  Mem_Addr(8) <= '1';
                  iOut_Sr     <= '0' & DevAddr_A2;
                end if;
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iOut_Sr   <= iOut_Sr(6 downto 0) & '0';  -- Write
                cntr      <= "111";
                Seq_State <= Dev_Addr_Wr_s;
              when others =>
            end case;

          when Dev_Addr_Wr_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iOut_Sr <= iOut_Sr(6 downto 0) & '0';  -- Write
                cntr    <= cntr -1;
                if (cntr = "000") then
                  iEn_Dout  <= '0';
                  Seq_State <= Dev_Wr_Ack_s;
                else
                  Seq_State <= Dev_Addr_Wr_s;
                end if;
              when others =>
            end case;


          when Dev_Wr_Ack_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "10" =>
                iSClk <= '0';
              when "11" =>
                cntr      <= "111";
                iEn_Dout  <= '1';
                Seq_State <= Wrd_Addr_s;
              when others =>
            end case;


          when Wrd_Addr_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iOut_Sr <= iOut_Sr(6 downto 0) & '0';  -- Write
                cntr    <= cntr -1;
                if (cntr = "000") then
                  iEn_Dout  <= '0';
                  Seq_State <= Wrd_Ack_s;
                else
                  iEn_Dout  <= '1';
                  Seq_State <= Wrd_Addr_s;
                end if;

              when others =>
            end case;


          when Wrd_Ack_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "10" =>
                iSClk <= '0';
              when "11" =>
                cntr       <= "111";
                iEn_Dout   <= '1';
                iOut_Sr(7) <= '1';
                Seq_State  <= Dev_Addr_Start_s;
              when others =>
            end case;


          when Dev_Addr_Start_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
                if (Space = '0') then
                  iOut_Sr <= '0' & DevAddr_A0;
                else
                  iOut_Sr <= '0' & DevAddr_A2;
                end if;
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iOut_Sr   <= iOut_Sr(6 downto 0) & '1';  -- Read
                cntr      <= "111";
                Seq_State <= Dev_Addr_Rd_s;
              when others =>
            end case;

          when Dev_Addr_Rd_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iOut_Sr <= iOut_Sr(6 downto 0) & '1';  -- Read
                cntr    <= cntr -1;
                if (cntr = "000") then
                  iEn_Dout  <= '0';
                  Seq_State <= Dev_Rd_Ack_s;
                else
                  Seq_State <= Dev_Addr_Rd_s;
                end if;
              when others =>
            end case;


          when Dev_Rd_Ack_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "10" =>
                iSClk <= '0';
              when "11" =>
                iEn_Dout  <= '0';
                Seq_State <= Read_Hi_s;
              when others =>
            end case;
          when Read_Hi_s =>
            case clk_cntr is
              when "00" =>
                iIn_Sr_A <= iIn_Sr_A(6 downto 0) & Din_A;
                iIn_Sr_B <= iIn_Sr_B(6 downto 0) & Din_B;
                iSClk    <= '1';
              when "01" =>
              when "10" =>
                iSClk <= '0';
              when "11" =>
                cntr <= cntr -1;
                if (cntr = "000") then
                  ien_dout   <= '1';
                  iOut_Sr(7) <= '0';
                  Seq_State  <= Read_Hi_Ack_s;
                else
                  Seq_State <= Read_Hi_s;
                end if;
              when others =>
            end case;

          when Read_Hi_Ack_s =>
            case clk_cntr is
              when "00" =>
                Mem_Wr      <= '1';
                Mem_Addr(9) <= '0';
                Mem_Din     <= iIn_Sr_A;
                iSClk       <= '1';
              when "01" =>
                Mem_Wr      <= '1';
                Mem_Addr(9) <= '1';
                Mem_Din     <= iIn_Sr_B;
              when "10" =>
                Mem_Wr <= '0';
                iSClk  <= '0';
              when "11" =>
                Mem_Addr(7 downto 0) <= Mem_Addr(7 downto 0) +1;
                iEn_Dout             <= '0';
                iOut_Sr(7)           <= '0';
                Seq_State            <= Read_Lo_s;
              when others =>
            end case;

          when Read_Lo_s =>
            case clk_cntr is
              when "00" =>
                iIn_Sr_A <= iIn_Sr_A(6 downto 0) & Din_A;
                iIn_Sr_B <= iIn_Sr_B(6 downto 0) & Din_B;
                iSClk    <= '1';
              when "01" =>
              when "10" =>
                iSClk <= '0';
              when "11" =>
                cntr <= cntr -1;
                if (cntr = "000") then
                  ien_dout   <= '1';
                  iOut_Sr(7) <= '1';
                  Seq_State  <= Read_Lo_Ack_s;
                else
                  Seq_State <= Read_Lo_s;
                end if;
              when others =>
            end case;

          when Read_Lo_Ack_s =>
            case clk_cntr is
              when "00" =>
                Mem_Wr      <= '1';
                Mem_Addr(9) <= '0';
                Mem_Din     <= iIn_Sr_A;
                iSClk       <= '1';
              when "01" =>
                Mem_Wr      <= '1';
                Mem_Addr(9) <= '1';
                Mem_Din     <= iIn_Sr_B;
              when "10" =>
                Mem_Wr <= '0';
                iSClk  <= '0';
              when "11" =>
                Seq_State <= Stop_s;
              when others =>
            end case;

          when Stop_s =>
            case clk_cntr is
              when "00" =>
                iSClk <= '1';
              when "01" =>
                iOut_Sr(7) <= '1';
              when "10" =>
                iSClk <= '0';
              when "11" =>
                Mem_Addr(7 downto 0) <= Mem_Addr(7 downto 0) +1;
                if (Mem_Addr(7 downto 0) = memmax) then
                  if (space = '1') then
                    space     <= '0';
                    iDone     <= '1';
                    Seq_State <= Idle_s;
                  else
                    Space                <= '1';
                    Mem_Addr(7 downto 0) <= (others => '0');
                    cntr                 <= "001";
                    Seq_State            <= Wait_s;
                  end if;
                else
                  Seq_State <= Dev_Addr_Start_s;
                end if;
              when others =>

            end case;

          when Wait_s =>
            if (Clk_Cntr = "11") then
              cntr <= cntr -1;
              if (cntr = "000") then
                Seq_State <= Start_s;
              else
                Seq_State <= Wait_s;
              end if;
            else
              Seq_State <= Wait_s;
            end if;

          when others =>

        end case;
      end if;  -- Clk_En
    end if;  -- Clock'event
  end process;  --Seq_p

  fo_ram : dpram_fo
    port map (
      addra => Mem_Addr,
      addrb => Rd_Mem_Addr,
      clka  => Clock,
      clkb  => Clock,
      dina  => Mem_Din,
      doutb => Mem_Dout,
      wea   => Mem_Wr
      );

end Behavioral;

