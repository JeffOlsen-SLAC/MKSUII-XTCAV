-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	IonPump -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/5/2011 10:17:30 AM
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


entity IonPump is
Port (
	Clock							: in std_logic;
	Reset 	  					: in std_logic;

-- Link Interface
	Lnk_Addr		 				: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 				: in std_logic;									-- From Link Interface
	Lnk_DataIn					: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut					: out std_logic_vector(15 downto 0);

	Ion_Pump_Mon 				: in std_logic;

	Ion_Pump_Test 				: out std_logic;

	Status						: out std_logic_vector(15 downto 0)

	);

end IonPump;

architecture behaviour of IonPump is

signal TestReg						: std_logic_Vector(15 downto 0);
signal iStatus						: std_logic_Vector(15 downto 0);

begin


Ion_Pump_Test 	<= TestReg(0);

Status <= iStatus;

istatus(15 downto 1) <=	(Others => '0');
istatus(0) <=	NOT(Ion_Pump_Mon);

WrReg : process(Clock, Reset)
Begin
if (reset = '1') then
	TestReg			<= (Others => '0');
elsif (Clock'event and 	Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is

		when x"0003" => 
			TestReg(0 downto 0) <= (Lnk_DataIn(0 downto 0) or TestReg(0 downto 0));

		when x"0004" =>
			TestReg(0 downto 0) <= (not(Lnk_DataIn(0 downto 0)) and TestReg(0 downto 0));

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
