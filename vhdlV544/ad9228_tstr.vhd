----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:14:53 12/17/2010 
-- Design Name: 
-- Module Name:    ad9228_tstr - Behavioral 
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
use IEEE.std_logic_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad9228_tstr is
Port ( 
  clock 	: in  std_logic;
  clockB : in  std_logic;
  Reset 	: in  std_logic;
  
 --Q 		: out  std_logic;
  FC 		: out  std_logic;
  FCB 	: out  std_logic;
  
  DC 		: out  std_logic; 
  DCB 	: out  std_logic;
  
  Q 		: out  std_logic_vector(3 downto 0);
  QB 		: out  std_logic_vector(3 downto 0)
  );
  
end ad9228_tstr;

architecture Behavioral of ad9228_tstr is

type adc_t is array(3 downto 0) of std_logic_vector(11 downto 0);

signal ADC_Data	:  adc_t;
signal First		: boolean;
signal tPeriod 	: time;
signal tA      	: time;
signal tB      	: time;
signal iDC      	: std_logic := '0';
signal iClk			: std_logic := '0';
signal cntr     	: std_logic_vector(7 downto 0);
signal cntr2     	: std_logic_vector(11 downto 0);
signal tmp      	: std_logic_vector(11 downto 0);
signal tmp1      	: std_logic_vector(11 downto 0);
signal tmp2      	: std_logic_vector(11 downto 0);
signal tmp3      	: std_logic_vector(11 downto 0);
signal ifc      	: std_logic;


begin
	DC		<= IDC;
	DCB	<= not(IDC);
	FC		<= ifc;
	FCB	<= not(ifc);
	
   Q(0)<=tmp(11);
   Q(1)<=tmp1(11);
   Q(2)<=tmp2(11);
   Q(3)<=tmp3(11);

   QB(0)<=not(tmp(11));
   QB(1)<=not(tmp1(11));
   QB(2)<=not(tmp2(11));
   QB(3)<=not(tmp3(11));

  
 
 
ClkPeriod_p : Process(clock, reset)
begin
if (clock'event and clock = '1') then
	tA 		<= now;
	tB			<= tA;
	tPeriod 	<= tA - tB;
end if;
end process;
  
iCLk <= Not(iCLK) after (tPeriod /24) when tPeriod > 0 ns;
 
DC_p : process(iClk, reset)
Begin
--if (Reset = '1') then
--	iDc <= '0';
if (iClk'event and iClk = '0') then
	if (cntr = x"B") then
		iDC <= '0';
	else
		iDC <= not(iDC);
	end if;
end if;
end process;
 
counter_p : process(iClk, reset)
begin
if (Reset = '1') then 
	tmp	<= "101010101010";
	tmp1	<= "011010101010";
	tmp2	<= "001010101010";
	tmp3	<= "111010101010";
	cntr	<=( others =>'0');
	cntr2	<= (others =>'0');
	ifc	<= '0';
elsif (iClk'event and iClk = '1') then
		if(cntr = x"5") then
			cntr	<= cntr	+	1;
			tmp	<= tmp(10 downto 0) & '0';
			tmp1	<= tmp1(10 downto 0) & '0';
			tmp2	<= tmp2(10 downto 0) & '0';
			tmp3	<= tmp3(10 downto 0) & '0';
			ifc 	<= '0';
		elsif (cntr = x"B") then
			cntr	<= (Others => '0');
			cntr2	<= cntr2	+	1;
			tmp 	<= cntr2;
			tmp1	<= "0100" & cntr2(7 downto 0);
			tmp2	<= "0101" & cntr2(7 downto 0);
			tmp3	<= "1100" & cntr2(7 downto 0);
			ifc 	<= '1';
		else
			cntr	<= cntr	+	1;
			tmp	<= tmp(10 downto 0) & '0';	
			tmp1	<= tmp1(10 downto 0) & '0';
			tmp2	<= tmp2(10 downto 0) & '0';
			tmp3	<= tmp3(10 downto 0) & '0';
		end if;
end if;

end process;

end Behavioral;


