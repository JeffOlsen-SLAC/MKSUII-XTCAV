-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      WaveForm_Intf.vhd - 
--
--      Copyright(c) SLAC National Accelerator Laboratory 2000
--
--      Author: JEFF OLSEN
--      Created on: 5/23/2011 8:51:01 AM
--      Last change: JO  5/23/2011 8:51:01 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:51 02/14/2011 
-- Design Name: 
-- Module Name:    WaveForm_Intf - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WaveForm_Intf is
  port (
    Clock     : in std_logic;
    Reset     : in std_logic;
    Clk119Mhz : in std_logic;

    DAV     : in std_logic;                      -- From FAST ADC
    Beam_I  : in std_logic_vector(11 downto 0);  -- From FAST ADC
    Beam_V  : in std_logic_vector(11 downto 0);  -- From FAST ADC
    Kly_For : in std_logic_vector(11 downto 0);  -- From FAST ADC
    Kly_Ref : in std_logic_vector(11 downto 0);  -- From FAST ADC

    -- Link Interface
    Lnk_Ce       : in  std_logic;
    Lnk_Addr     : in  std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Wr       : in  std_logic;       -- From Link Interface
    Lnk_DataIn   : in  std_logic_vector(15 downto 0);  -- From Link Interface
    Lnk_Rd       : in  std_logic;       -- From Link Interface              
    ThresDav     : out std_logic;       -- To Link Interface
    ThresDataOut : out std_logic_vector(15 downto 0)   -- To Link Interface

    );
end WaveForm_Intf;

architecture Behavioral of WaveForm_Intf is

begin


