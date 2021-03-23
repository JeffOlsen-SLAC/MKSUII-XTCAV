----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:48:45 05/30/2013 
-- Design Name: 
-- Module Name:    clk12clk2 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk12clk2 is
Port ( 
	Clk1 	: in  std_logic;
	Reset	: in std_logic;
	Din 	: in  std_logic;
	Clk2 	: in  std_logic;
	Dout 	: out  std_logic
);
end clk12clk2;

architecture Behavioral of clk12clk2 is

signal Q 		: std_logic;
signal DOutSr 	: std_logic_vector(1 downto 0);

begin


latch_p : process(Clk1, Reset, DoutSr)
begin
	if ((Reset = '1') or ((DoutSr(1) = '1') and (Din = '0'))) then
		Q <= '0';
	elsif (Clk1'event and Clk1 = '1') then
		Q <= Din;
	end if;
end process;

Out_p : process(clk2, Reset)
begin
	if (Reset = '1') then 
		DoutSr <= "00";
	elsif (Clk2'event and Clk2 = '1') then
		DoutSr <= DoutSr(0) & Q;
		Dout <= DoutSr(1);
	end if;
end process;
end Behavioral;

