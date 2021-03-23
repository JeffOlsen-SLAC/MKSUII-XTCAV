----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:49:43 02/14/2012 
-- Design Name: 
-- Module Name:    FaultHistory - Behavioral 
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
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


library work;
use work.mksuii.all;

entity FaultHistory is
Port ( 
	Clock 		: in std_logic;
	Reset 		: in std_logic;

	-- Link Interface
	Lnk_Rd		: in std_logic;
	Lnk_Addr		: in std_logic_vector(15 downto 0);
	Lnk_DataOut	: out std_logic_vector(15 downto 0);

	WrEn 			: in std_logic;
	DataIn 		: in std_logic_vector(31 downto 0);
	CountIn 		: in std_logic_vector(31 downto 0)
	);
end FaultHistory;

architecture Behavioral of FaultHistory is

signal MemDin 			: std_logic_vector(63 downto 0);
signal WrAddr			: std_logic_vector(6 downto 0); 
signal RdAddr			: std_logic_vector(8 downto 0);
signal RdMemAddr		: std_logic_vector(8 downto 0);
signal Wrapped 		: std_logic;
signal Buff0DataOut 	: std_logic_vector(15 downto 0);
signal Buff1DataOut 	: std_logic_vector(15 downto 0);
signal RdCount			: std_logic; 
signal d_RdCount		: std_logic;
signal d_lnk_Rd		: std_logic; 
signal Count			: std_logic_vector(7 downto 0); 
signal RdEn0			: std_logic; 
signal WrEn0			: std_logic; 
signal Buff0Wr			: std_logic_vector(0downto 0); 
signal Buff1Wr			: std_logic_vector(0 downto 0);

begin

MemDin <= DataIn & CountIn;

out_p : process(Lnk_addr, d_RdCount, Count, RdEn0, Buff0DataOut, Buff1DataOut)
begin
if (Lnk_addr = x"0000") then
	Lnk_DataOut <= x"00" & Count;
elsif (RdEn0 = '1') then
	Lnk_DataOut <= Buff0DataOut;
else
	Lnk_DataOut <= Buff1DataOut;
end if;
end process;
	
	
write_p : process(Clock, Reset)
begin
if (reset = '1') then
	WrEn0			<= '1';
	RdCount		<= '1';
	Wrapped		<= '0';
	RdEn0			<= '0';
	d_RdCount 	<= '0';
	d_Lnk_Rd 	<= '0';
	WrAddr 		<= (Others => '0');
	RdAddr		<= (Others => '0'); 
	Count 		<= (Others => '0'); 
elsif (Clock'event and Clock = '1') then
	if ((WrEn = '1') and (Lnk_Rd = '0')) then
		WrAddr <= WrAddr +1;
		if (Count /= x"7F") then
			Count 	<= Count + 1;
			Wrapped 	<= '0';
		else
			Wrapped 	<= '1';
		end if;
	end if;
	
	if (Lnk_Rd = '1') then
			RdEn0 		<= Not(RdEn0);
			WrEn0 		<= Not(WrEn0);
			WrAddr		<=  (Others => '0');
			if (Wrapped = '1') then
				RdAddr 	<= WrAddr & "00";
			else
				RdAddr 	<= (Others => '0');
			end if;
	end if;
end if;
end process;
		
Buff0Wr(0) 	<= WrEn0 and WrEn;
Buff1Wr(0) 	<= not(WrEn0) and WrEn;
RdMemAddr 	<= RdAddr + Lnk_Addr(8 downto 0);

Buffer0 : FaultHistoryRam
PORT MAP (
	clka 		=> Clock,
	wea 		=> Buff0Wr,
	addra 	=> WrAddr,
	dina	 	=> MemDin,
	clkb 		=> Clock,
	addrb 	=> RdMemAddr,
	doutb 	=> Buff0DataOut
);

Buffer1 : FaultHistoryRam
PORT MAP (
	clka 		=> Clock,
	wea 		=> Buff1Wr,
	addra 	=> WrAddr,
	dina	 	=> MemDin,
	clkb 		=> Clock,
	addrb 	=> RdMemAddr,
	doutb 	=> Buff1DataOut
);

end Behavioral;

