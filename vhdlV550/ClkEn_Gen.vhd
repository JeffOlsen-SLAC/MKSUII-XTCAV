-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      ClkEn_Gen.vhd - 
--
--      Copyright(c) SLAC National Accelerator Laboratory 2000
--
--      Author: JEFF OLSEN
--      Created on: 6/8/2011 1:29:35 PM
--      Last change: JO 6/3/2013 9:42:17 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:01:44 11/18/2010 
-- Design Name: 
-- Module Name:    ClkEn_Gen - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library work;
use work.mksuii.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClkEn_Gen is
  port (
    Clock       : in  std_logic;
    Reset       : in  std_logic;
    Clk30MhzEn  : out std_logic;
    Clk1MhzEn   : out std_logic;
    clk400KhzEn : out std_logic;
    Clk100KhzEn : out std_logic;
    Clk10KhzEn  : out std_logic;
    Clk1KhzEn   : out std_logic;
    Clk100hzEn  : out std_logic;
    Clk10hzEn   : out std_logic;
    Clk2hzEn    : out std_logic;
    Clk1hzEn    : out std_logic
    );
end ClkEn_Gen;

architecture Behavioral of ClkEn_Gen is

  signal Clk30MhzCntr  : std_logic_vector(1 downto 0);
  signal Clk1MhzCntr   : std_logic_vector(6 downto 0);
  signal clk400KhzCntr : std_logic_vector(9 downto 0);
  signal iclk400KhzEn  : std_logic;
  signal Clk100KhzCntr : std_logic_vector(3 downto 0);
  signal iClk100KhzEn  : std_logic;
  signal Clk10khzCntr  : std_logic_vector(15 downto 0);
  signal iClk10KhzEn   : std_logic;
  signal Clk1khzCntr   : std_logic_vector(3 downto 0);
  signal iClk1KhzEn    : std_logic;
  signal Clk100hzCntr  : std_logic_vector(3 downto 0);
  signal iClk100hzEn   : std_logic;
  signal Clk10hzCntr   : std_logic_vector(3 downto 0);
  signal iClk10hzEn    : std_logic;
  signal Clk2hzCntr    : std_logic_vector(3 downto 0);
  signal iClk2hzEn     : std_logic;
  signal CLk1HzCntr    : std_logic;
  signal iClk1hzEn     : std_logic;

begin

  clk400KhzEn <= iclk400KhzEn;
  Clk100KhzEn <= iClk100KhzEn;
  Clk10KhzEn  <= iClk10KhzEn;
  Clk1KHzEn   <= iClk1KHzEn;
  Clk100hzEn  <= iClk100hzEn;
  Clk10hzEn   <= iClk10hzEn;
  Clk2HzEn    <= iClk2HzEn;
  Clk1HzEn    <= iClk1HzEn;


  ClkGen : process(Clock, Reset)
  begin
    if (Reset = '1') then
      clk30MhzCntr  <= (others => '0');
      Clk30MhzEn    <= '0';
      clk1MhzCntr   <= (others => '0');
      Clk1MhzEn     <= '0';
      clk400KhzCntr <= (others => '0');
      iclk400KhzEn  <= '0';
      clk100khzCntr <= (others => '0');
      iClk100khzEn  <= '0';
      clk10khzCntr  <= (others => '0');
      iClk10khzEn   <= '0';
      clk1khzCntr   <= (others => '0');
      iClk1khzEn    <= '0';
      clk100hzCntr  <= (others => '0');
      iClk100hzEn   <= '0';
      clk10hzCntr   <= (others => '0');
      iClk10hzEn    <= '0';
      clk2hzCntr    <= (others => '0');
      iClk2hzEn     <= '0';
      clk1hzCntr    <= '0';
      iClk1hzEn     <= '0';
    elsif (Clock'event and Clock = '1') then
      clk30MhzCntr <= clk30MhzCntr + 1;
      if (clk30MhzCntr = "00") then
        Clk30MhzEn <= '1';
      else
        Clk30MhzEn <= '0';
      end if;

      if (clk1MhzCntr = "0000000") then
        clk1MhzCntr <= "1110110";       -- 0x76 = 118
        Clk1MhzEn   <= '1';
      else
        clk1MhzCntr <= clk1MhzCntr - 1;
        Clk1MhzEn   <= '0';
      end if;

      if (clk400KhzCntr = "0000000") then
        clk400KhzCntr <= "0100101001";  -- 0x129 = 297
        iclk400KhzEn  <= '1';
      else
        clk400KhzCntr <= clk400KhzCntr - 1;
        iclk400KhzEn  <= '0';
      end if;

      if (iClk400KhzEn = '1') then
        if (CLk100KhzCntr = x"0") then
          Clk100KhzCntr <= x"3";
          iClk100KhzEn  <= '1';
        else
          Clk100KhzCntr <= Clk100KhzCntr - 1;
          iClk100KhzEn  <= '0';
        end if;
      else
        iClk100KhzEn <= '0';
      end if;


      if (Clk10KhzCntr = x"0000") then
        Clk10KhzCntr <= x"2E76";        --  0x2E76 = 11900 -1
        iClk10KhzEn  <= '1';
      else
        Clk10KhzCntr <= Clk10KhzCntr - 1;
        iClk10KhzEn  <= '0';
      end if;

      if (iClk10KhzEn = '1') then
        if (CLk1KhzCntr = x"0") then
          Clk1KhzCntr <= x"9";
          iClk1KhzEn  <= '1';
        else
          Clk1KhzCntr <= Clk1KhzCntr - 1;
          iClk1KhzEn  <= '0';
        end if;
      else
        iClk1KhzEn <= '0';
      end if;

      if (iClk1KhzEn = '1') then
        if (Clk100HzCntr = x"0") then
          Clk100HzCntr <= x"9";
          iClk100HzEn  <= '1';
        else
          Clk100HzCntr <= Clk100HzCntr - 1;
          iClk100HzEn  <= '0';
        end if;
      else
        iClk100HzEn <= '0';
      end if;

      if (iClk100hzEn = '1') then
        if (Clk10hzCntr = x"0") then
          Clk10hzCntr <= x"9";          -- 1000 -1
          iClk10hzEn  <= '1';
        else
          Clk10hzCntr <= Clk10hzCntr - 1;
          iClk10hzEn  <= '0';
        end if;
      else
        iClk10hzEn <= '0';
      end if;

      if (iClk10HzEn = '1') then
        if (Clk2hzCntr = x"0") then
          Clk2hzCntr <= x"4";           -- 5000 -1
          iClk2hzEn  <= '1';
        else
          Clk2hzCntr <= Clk2hzCntr - 1;
          iClk2hzEn  <= '0';
        end if;
      else
        iClk2hzEn <= '0';
      end if;

      if (iClk2HzEn = '1') then
        CLk1HzCntr <= not(Clk1HzCntr);
        if (Clk1HzCntr = '1') then
          iClk1hzEn <= '1';
        end if;
      else
        iClk1HzEn <= '0';
      end if;

    end if;
  end process;

end Behavioral;

