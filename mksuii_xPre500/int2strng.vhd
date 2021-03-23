----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:36:07 04/15/2011 
-- Design Name: 
-- Module Name:    int2strng - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_textio.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity int2strng is
    Port ( din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (19 downto 0));
end int2strng;

architecture Behavioral of int2strng is


begin
variable mystring : string(19 downto 0);
mystring := int_to_string(30000);


end Behavioral;

