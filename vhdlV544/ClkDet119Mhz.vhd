----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:39 06/20/2011 
-- Design Name: 
-- Module Name:    ClkDet119Mhz - Behavioral 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClkDet119Mhz is
Port ( 
	Clk125Mhz	: in  STD_LOGIC;
	Reset 		: in  STD_LOGIC;
	Clk119Mhz 	: in  STD_LOGIC;
	Clk119MhzOK : out  STD_LOGIC
	);
end ClkDet119Mhz;

architecture Behavioral of ClkDet119Mhz is

signal clk125Window 		: std_logic;
signal clk125Count		: std_logic_vector(7 downto 0);
signal clk119Window		: std_logic;
signal clk119WindowSr	: std_logic_vector(2 downto 0);
signal clk119Count		: std_logic_vector(7 downto 0);
signal Clk119MhzRst		: std_logic;

begin

clk125w_p : process(Clk125Mhz, Reset)
begin
if (Reset = '1') then
	Clk125Window 	<= '0';
	Clk119MhzOk 	<= '0';
	Clk125Count  	<= x"00";
	Clk119MhzRst 	<= '0';
elsif (Clk125Mhz'event and Clk125Mhz = '1') then
	if (Clk125Count = x"00") then
		Clk125Window <= '1';
	end if;
	if (Clk125Count = x"00") then
		Clk119MhzRst <= '1';
	else
		Clk119MhzRst <= '0';
	end if;
	if (Clk125Count = x"7C") then  -- 124
		Clk125Window 	<= '0';
	end if;
	if (Clk125Count = x"80") then 
		if ((Clk119Count > x"82") OR (Clk119Count < x"6E")) then -- 110 to 130 
			Clk119MhzOk <= '0';
		else
			Clk119MhzOk	<= '1';
		end if;
	end if;
	Clk125Count <= Clk125Count + 1;
end if;
end process;

clk118w_p : process(Clk119Mhz, Reset, Clk119MhzRst)
begin
if ((Reset = '1') or (Clk119MhzRst = '1')) then
	Clk119Window 		<= '0';
	Clk119Count  		<= x"00";
	Clk119WindowSr 	<= "000";
elsif (Clk119Mhz'event and Clk119Mhz = '1') then
	Clk119WindowSr <= Clk119WindowSr(1 downto 0) & Clk125Window;
	if (Clk119WindowSr(2 downto 1) = "01") then
		Clk119Window <= '1';
	end if;
	if (Clk119WindowSr(2 downto 1) = "10") then
		Clk119Window <= '0';
	end if;
	if (Clk119Window = '1') then
		Clk119Count <= Clk119Count + 1;
	end if;
	
end if;
end process;

	
end Behavioral;

