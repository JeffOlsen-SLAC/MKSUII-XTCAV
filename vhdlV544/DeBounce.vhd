----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:36:24 11/03/2010 
-- Design Name: 
-- Module Name:    DeBounce - Behavioral 
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
use IEEE.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DeBounce is
Port ( 
	Clock 	: in  std_logic;
	Reset 	: in  std_logic;
	ClockEn 	: in  std_logic;
	Din 		: in  std_logic;
	Dout 		: out  std_logic
	);
end DeBounce;

architecture Behavioral of DeBounce is

signal Sync_InSr 	: std_logic_vector(2 downto 0);
signal Cntr			: std_logic_vector(7 downto 0);

begin

process(Clock, Reset)
begin
if (Reset = '1') then
	Dout 			<= '0';
	Cntr 			<= (Others => '0');
	Sync_InSr	<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	Sync_InSr	<= Sync_InSr(1 downto 0) & Din;
	if (ClockEn = '1') then
		if (Sync_InSr(2 downto 1) = "00") then
			if (Cntr /= x"00") then
				Cntr 	<= Cntr - 1;
			end if;
		elsif (Sync_InSr(2 downto 1) = "11") then
			if (Cntr /= x"FF") then
				Cntr 	<= Cntr + 1;
			end if;
		end if;
		if (Cntr = x"FF") then
			Dout	<= '1';
		elsif (Cntr = x"00") then
			Dout 	<= '0';
		end if;
	end if;
end if;
end process;


end Behavioral;

