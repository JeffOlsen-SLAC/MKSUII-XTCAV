-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--  mksuii_reg.vhd -
--
--  Copyright(c) SLAC 2000
--
--  Author: Jeff Olsen
--  Created on: 9/19/2007 9:57:54 AM
--  Last change: JO 5/23/2011 8:51:00 AM
--
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity mksuii_reg is
Port (
	CLOCK 				: in std_logic;
	RESET 				: in std_logic;
	Addr            	: in std_logic_vector(2 downto 0);
	Wr                : in std_logic;
	DataIn         	: in std_logic_vector(15 downto 0);
	DataOut				: in std_logic_vector(15 downto 0);
	TestOut				: out std_logic_vector(31 downto 0);
	);
end mksuii_reg;

architecture Behavioral of mksuii_reg is

type Regs_t : array(5 downto 0) of std_logic_vector(15 downto 0);
Signal Regs				: Reg_t;

begin

Write_Reg_p : process(Clock, Reset)
Begin
if (Reset = '1') then
	regs <= (others => x"0000");
elsif (Clock'event and Clock = '1') then
	if Wr = '1' then
		Regs(Conv_Integer(Addr)) <=  DataIn;
	end if;
end if;
end process; --Write_Reg_p	

Rd_p : process(Regs, iaddr)
variable iAddress : integer;
Begin
	iAddress := Conv_Integer(iAddr);
	DataOut <= Regs(iAddress);
end if;
end process; 	

Testout(30 downto 26) <= regs(5)(4 downto 0);
Testout(25 downto 20) <= regs(4)(5 downto 0);
Testout(19 downto 8) <= regs(3)(11 downto 0);
Testout(7 downto 5) <= regs(2)(2 downto 0);
Testout(4 downto 3) <= regs(1)(1 downto 0);
Testout(2 downto 0) <= regs(0)(2 downto 0);

end Behavioral;
