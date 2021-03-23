-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      Testcode.vhd - 
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
-- Create Date:    11:53:13 04/07/2011 
-- Design Name: 
-- Module Name:    Testcode - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testcode is
  port (RegWord  : in  std_logic_vector(15 downto 0);
        RegAddre : in  std_logic_vector(5 downto 0);
        RegOut   : out std_logic_vector(15 downto 0);
        output1  : out std_logic_vector(30 downto 0);
        Clk      : in  std_logic;
        wrt      : in  std_logic;
        Rst      : in  std_logic);
end Testcode;

architecture Behavioral of Testcode is

  --Type LatchReg is array(5 to 0) of std_logic_vector(15 downto 0);
  --Type MaskReg is array(5 to 0) of std_logic_vector(15 downto 0);
  signal LatchReg_0 : std_logic_vector(5 downto 0);
  signal LatchReg_1 : std_logic_vector(15 downto 0);
  signal LatchReg_2 : std_logic_vector(15 downto 0);
  signal LatchReg_3 : std_logic_vector(15 downto 0);
  signal LatchReg_4 : std_logic_vector(15 downto 0);
  signal LatchReg_5 : std_logic_vector(15 downto 0);



begin

  Register_p : process(Clk, rst)

  begin

    if (rst = '1') then
--             MaskReg(0) <=("1111100000000000");
--                              -- MaskReg(1) <=("1111100000000000");
--                              -- MaskReg(1) <=("1111100000000000");
--                              -- MaskReg(1) <=("1111100000000000");
--                              -- MaskReg(1) <=("1111100000000000");
--                              -- MaskReg(1) <=("1111100000000000");
      LatchReg_0 <= (others => '0');
      LatchReg_1 <= (others => '0');
      LatchReg_2 <= (others => '0');
      LatchReg_3 <= (others => '0');
      LatchReg_4 <= (others => '0');
      LatchReg_5 <= (others => '0');

    elsif (clk'event and Clk = '1') then

      if(wrt = '1') then

        case RegAddre is

          -- Reg1 is the water_flow
          when "000000" =>
            LatchReg_0 <= Regword(5 downto 0);
          -- Reg2 is the SLED
          when "000001" => LatchReg_1 <= "0000000000111111" and Regword;
          --RegOut <=  LatchReg_1;  
          when "000010" => LatchReg_2 <= "0000111111111111" and Regword;
          -- Reg4 is the MagnetSignal
          when "000011" => LatchReg_3 <= "0000000000000111" and Regword;

          -- Reg5 is theWG Signal
          when "000100" => LatchReg_4 <= "0000000000000011" and Regword;

          -- Reg5 is the Legacy  Signal
          when "000101" => LatchReg_5 <= "0000000000000111" and Regword;

          when others =>

        end case;

      end if;
    end if;

  end process;


  process(LatchReg_0, LatchReg_1, LatchReg_2, LatchReg_3, LatchReg_4, LatchReg_5, RegAddre)
  begin
    case RegAddre is

      -- Reg1 is the water_flow
      when "000000" =>
        RegOut <= "0000000000" & LatchReg_0;
      -- Reg2 is the SLED
      when "000001" => RegOut <= "0000000000111111" and LatchReg_1;
      --RegOut <=  LatchReg_1;  
      when "000010" => RegOut <= "0000111111111111" and LatchReg_2;
      -- Reg4 is the MagnetSignal
      when "000011" => RegOut <= "0000000000000111" and LatchReg_3;

      -- Reg5 is theWG Signal
      when "000100" => RegOut <= "0000000000000011" and LatchReg_4;
      -- Reg5 is the Legacy  Signal
      when "000101" => RegOut <= "0000000000000111" and LatchReg_5;

      when others => RegOut <= (others => '0');
    end case;


  end process;
--
  output1(4 downto 0) <= LatchReg_0(4 downto 0);

  output1(10 downto 5) <= LatchReg_1(5 downto 0);

  output1(22 downto 11) <= LatchReg_2(11 downto 0);

  output1(25 downto 23) <= LatchReg_3(2 downto 0);

  output1(27 downto 26) <= LatchReg_4(1 downto 0);

  output1(30 downto 28) <= LatchReg_5(2 downto 0);


end Behavioral;

--end Behavioral;

