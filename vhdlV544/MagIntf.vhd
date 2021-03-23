-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	Magnet Interface -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/5/2011 10:18:28 AM
--
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library work;
use work.mksuii.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity MagIntf is
Port (
	Clock							: in std_logic;
	Reset 	  					: in std_logic;

-- Link Interface
	Lnk_Addr		 				: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 				: in std_logic;									-- From Link Interface
	Lnk_DataIn					: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut					: out std_logic_vector(15 downto 0);

	Mag_I_Intlk_Mon 			: in std_logic;
	Mag_I_Ok_MON 				: in std_logic;
	Mag_Klixon_MON 			: in std_logic;


	Mag_I_Intlk_Test 			: out std_logic;
	Mag_I_Ok_Test 				: out std_logic;
	Mag_Klixon_Test 			: out std_logic;

	Status						: out std_logic_vector(15 downto 0)

	);

end MagIntf;

architecture behaviour of MagIntf is

signal TestReg					: std_logic_Vector(15 downto 0);
signal iStatus					: std_logic_Vector(15 downto 0);

begin


Mag_I_Intlk_Test 	<= TestReg(2);
Mag_I_Ok_Test 		<= TestReg(1);
Mag_Klixon_Test 	<= TestReg(0);


Status <= iStatus;

istatus(15 downto 3) <=	(Others => '0');
istatus(2) <=	not(Mag_I_Intlk_Mon);
istatus(1) <=	not(Mag_I_Ok_MON);
istatus(0) <=	not(Mag_Klixon_MON);

WrReg : process(Clock, Reset)
Begin
if (reset = '1') then
	TestReg <= (Others => '0');
elsif (Clock'event and 	Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is
		when x"0000" =>

		when x"0003" =>
			TestReg(2 downto 0) <= (Lnk_DataIn(2 downto 0) or TestReg(2 downto 0));

		when x"0004" =>
			TestReg(2 downto 0) <= (not(Lnk_DataIn(2 downto 0)) and TestReg(2 downto 0));

		when others =>
		end case;
	end if;
end if;
end process;

Rd_Reg : Process(Lnk_Addr, TestReg, iStatus)
begin
	case Lnk_Addr(3 downto 0) is
		when x"0" => Reg_DataOut 	<= iStatus;
		when x"2" => Reg_DataOut	<= TestReg;
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;


end behaviour;
