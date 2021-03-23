-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
-- pon_rst.vhd -
--
--  Copyright(c) SLAC 2000
--
--  Author: Jeff Olsen
--  Created on: 9/7/2007 10:42:47 AM
--  Last change: JO 9/21/2007 8:58:35 AM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:27 08/30/2007 
-- Design Name: 
-- Module Name:    test - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Library work;
--use work.mpsnode.all;

entity pon_rst is
Port (
	Clock			: in  STD_LOGIC;
	sys_reset 	: in std_logic;
	pon_reset   : out std_logic
);
end pon_rst;

architecture Behavioral of pon_rst is

signal Counter  		: std_logic_vector(7 downto 0);
signal n_Pon_Reset 	: std_logic;

begin

pon_reset <= NOT(n_Pon_Reset);

pon_rst_p : Process(Clock, sys_reset)
begin
if (sys_reset = '1') then
counter <= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if (counter /= x"FF") then
		counter 		<= counter +1;
		n_Pon_Reset <= '0';
	else	      
		n_Pon_Reset <= '1';
	end if;	
end if;
end process; -- clk_test_p
	
end Behavioral;

