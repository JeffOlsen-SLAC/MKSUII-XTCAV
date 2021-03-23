-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	ThresComp.vhd - 
--
--	Copyright(c) SLAC National Accelerator Laboratory 2000
--
--	Author: JEFF OLSEN
--	Created on: 5/23/2011 8:51:01 AM
--	Last change: JO  5/23/2011 8:51:01 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:08:02 02/11/2011 
-- Design Name: 
-- Module Name:    ThresComp - Behavioral 
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
use ieee.std_logic_signed.all; 
 

entity ThresComp is
Port ( 
	a 			: in  std_logic_vector(11 downto 0);
	b 			: in  std_logic_vector(11 downto 0);
	LessThan : out  std_logic;
	GrtrThan : out  std_logic;
	Equal		: out  std_logic
	);
end ThresComp;

architecture Behavioral of ThresComp is

begin
comp_p : process(a,b)
begin
	if (a > b) then 
		GrtrThan <= '1';
	else
		GrtrThan <= '0';
	end if;

	if (a < b) then
		LessThan <= '1';
	else
		LessThan <= '0';
	end if;

	if (a = b) then
		Equal <= '1';
	else
		Equal <= '0';
	end if;
end process;
end Behavioral;

