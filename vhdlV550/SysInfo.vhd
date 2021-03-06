-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      SysInfo.vhd -
--
--      Copyright(c) SLAC 2000
--
--      Author: JEFF OLSEN
--      Created on: 3/11/2011 12:08:09 PM
--      Last change: JO 8/18/2011 3:17:47 PM
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


entity SysInfo is
  port (
    Clock : in std_logic;
    Reset : in std_logic;

    Lnk_Addr    : in  std_logic_vector(15 downto 0);  -- From Link Interface
    Reg_DataOut : out std_logic_vector(15 downto 0)

    );

end SysInfo;

architecture behaviour of SysInfo is
begin

  info_p : process(Lnk_Addr)
  begin
    case Lnk_Addr(3 downto 0) is
      when x"0" =>
        Reg_DataOut <= Character_to_StdLogicVector(MKSUII_Version(7)) & Character_to_StdLogicVector(MKSUII_Version(8));
      when x"1" =>
        Reg_DataOut <= Character_to_StdLogicVector(MKSUII_Version(5)) & Character_to_StdLogicVector(MKSUII_Version(6));
      when x"2" =>
        Reg_DataOut <= Character_to_StdLogicVector(MKSUII_Version(3)) & Character_to_StdLogicVector(MKSUII_Version(4));
      when x"3" =>
        Reg_DataOut <= Character_to_StdLogicVector(MKSUII_Version(1)) & Character_to_StdLogicVector(MKSUII_Version(2));


      when x"4" =>
        Reg_DataOut <= Character_to_StdLogicVector(System_ID(5)) & Character_to_StdLogicVector(System_ID(6));
      when x"5" =>
        Reg_DataOut <= Character_to_StdLogicVector(System_ID(3)) & Character_to_StdLogicVector(System_ID(4));
      when x"6" =>
        Reg_DataOut <= Character_to_StdLogicVector(System_ID(1)) & Character_to_StdLogicVector(System_ID(2));

      when x"7" =>
        Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(3)) & Character_to_StdLogicVector(SubType_ID(4));
      when x"8" =>
        Reg_DataOut <= Character_to_StdLogicVector(SubType_ID(1)) & Character_to_StdLogicVector(SubType_ID(2));

      when x"9" =>
        Reg_DataOut <= Character_to_StdLogicVector(Date_ID(7)) & Character_to_StdLogicVector(Date_ID(8));
      when x"A" =>
        Reg_DataOut <= Character_to_StdLogicVector(Date_ID(5)) & Character_to_StdLogicVector(Date_ID(6));
      when x"B" =>
        Reg_DataOut <= Character_to_StdLogicVector(Date_ID(3)) & Character_to_StdLogicVector(Date_ID(4));
      when x"C" =>
        Reg_DataOut <= Character_to_StdLogicVector(Date_ID(1)) & Character_to_StdLogicVector(Date_ID(2));


      when others => Reg_DataOut <= (others => '0');
    end case;
  end process;


end;

