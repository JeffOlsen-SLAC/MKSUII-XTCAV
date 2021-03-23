-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	bcdconv.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 4/19/2011 12:12:40 PM
--	Last change: JO 8/18/2011 3:37:43 PM
--
--
-- Copyright (C) Doulos Ltd 2001
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library work;
use work.mksuii.all;

entity BCDConv is
port (
  Clock  	: in std_logic;
  Reset  	: in std_logic;
  Init   	: in std_logic;  -- initialise conversion
  DecIn  	: in std_logic_vector(19 downto 0);
  ModOut 	: out std_logic; -- carry out 
  Done	  	: out std_logic;
  BCDOut 	: out std_logic_vector(31 downto 0) -- BCD result
       );
end;

architecture RTL of BCDConv is

signal Counter 	: std_logic_vector(4 downto 0);
signal ModVec 		: std_logic_vector(1 to 9);
signal DecInSr 	: std_logic_vector(19 downto 0);
signal iInit	 	: std_logic;
signal Q 			: std_logic_vector(31 downto 0); 

begin

sr_p : Process(Clock, Reset)
begin
if (Reset = '1') then
	DecInSr 	<= (Others => '0');
	Counter 	<= (Others => '0');
	BCDOut 	<= (Others => '0');
	iInit 	<= '0';
	Done		<= '0';
elsif (Clock'event and Clock = '1') then
	if (Init = '1') then
		iInit 	<= '1';
		Counter 	<= "10101";
		DecInSr 	<= DecIn;
	else
		if (Counter = "0001") then
			Counter 	<= Counter - 1;
			Done		<= '1';
			BCDOut 	<= Q;
		elsif (Counter /= "00000") then
			Counter 	<= Counter - 1;
		else
			Done		<= '0';
		end if;
		iInit 	<= '0';
		DecInSr 	<=  DecInSr(18 downto 0) & '0';
	end if;
end if;
end process;

ModVec(9) <= DecInSr(19);

-- The magic of generate!  
g1 : for i in 1 to 8 generate
  c1: Digit
        port map (
        Clock 	=> Clock,
        Reset 	=> Reset,
        Init 	=> iInit,
        ModIn 	=> ModVec(I+1),
        ModOut => ModVec(I),
        Q      => Q(35-(I*4) downto 32-(I*4))
--        Q      => Q(I*4-1 downto I*4-4)
		  );
  end generate;
  
  ModOut 	<= ModVec(1);

end;
 
