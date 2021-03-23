----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:10 11/16/2010 
-- Design Name: 
-- Module Name:    spi_intf - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Commentslibrary IEEE;
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


--
----------------------------------------------------------------------------------

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_intf is
Port ( 
	Clock 		: in  STD_LOGIC;
	Reset 		: in  STD_LOGIC;
	Data 			: in  STD_LOGIC_VECTOR (7 downto 0);
	Wr			   	: in  STD_LOGIC;
	Tx_Done 		: out  STD_LOGIC;
	Rx_Start 	: in  STD_LOGIC;
	Rx_Done 		: out  STD_LOGIC;
	SPI_SS 		: out  STD_LOGIC;
	SPI_Clk 		: out  STD_LOGIC;
	SPI_MOSI 	: out  STD_LOGIC;
	SPI_MISO 	: in  STD_LOGIC
);
end spi_intf;

architecture Behavioral of spi_intf is

constant Clk200Kdiv : std_logic_vector := x"12C"; -- 600; 400Khz en

type State_t is
(
	Idle_s,
	Clk_s,
	Term_s
	);

signal State 			: State_t;
signal Cntr  			: std_logic_vector(11 downto 0);
signal iSS				: std_logic;
signal iClk				: std_logic;
signal iMOSI			: std_logic;
signal iMISO			: std_logic;
signal Tx_Start_Req	: std_logic;
signal Tx_Start_Clr	: std_logic;
signal Rx_Start_Req	: std_logic;
signal Rx_Start_Clr	: std_logic;
signal DataSr  		: std_logic_vector(7 downto 0);
signal BitCntr  		: std_logic_vector(2 downto 0);
signal DataLatch 		: std_logic_vector(7 downto 0);
signal Clk200Ken	: std_logic;


begin

SPI_MOSI <= iMOSI;
SPI_SS 	<= iSS;
SPI_Clk	<= iClk;

clken : process(Clock, Reset)
begin
if (Reset = '1') then
  Tx_Start_Req <= '0';

	Cntr 			<= (Others => '0');
	DataLatch	<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if (Tx_Start = '1') then
		Tx_Start_Req 	<= '1';
		Rx_Start_Req 	<= '1';
		DataLatch		<= Data;
	elsif (Tx_Start_Clr = '1') then
		Tx_Start_Req 	<= '0';
	end if;

	if (Cntr = x"000") then
		Clk200KEn 	<= '1';
		Cntr 			  <= Clk200Kdiv;
	else
		Clk200KEn 	<= '0';
		Cntr 			<= Cntr -1;
	end if;
end if;
end process;

spi_p : Process(Clock, Reset)
begin
if (Reset = '1') then
  Tx_Start_Clr <= '0';
	iSS		<= '0';
	iClk		<= '1';
	iMOSI		<= '0';
	iMISO		<= '0';
	Tx_Done 	<= '0';
	DataSr <= (Others => '0');
	BitCntr	<= (Others => '0');
	State 	<= Idle_s;
elsif (Clock'event and Clock = '1') then
	if (Clk200Ken = '1') then
		case State is
		when Idle_s =>
			BitCntr	<= "111";
			if ((Tx_Start_Req = '1') or Rx_Start_Req = '1')) then
				DataSr 			<= DataLatch;
				Tx_Start_Clr 	<= '1';
				iSS				<= '1';
				State				<= Clk_s;
			else
				iClk				<= '1';
				iSS   <= '0';
				State				<= Idle_s;
			end if;
		
		when Clk_s =>
			iClk <= Not(IClk);
			if (iClk = '1') then
				BitCntr 	<= BitCntr - 1;
				iMOSI <= DataSr(0);
				DataSr 	<= '0' & DataSr(7 downto 1) ;
				if (BitCntr = "000") then
					State <= Term_s;
				else
					State <= Clk_s;
				end if;
			end if;
			
			if (iClk = '0') then
				DataInSr <= MISO;
			end if;
				
		when Term_s =>
			if (Rx_Start_Req = '1') then
				Rx_Start_Clr 	<= '1';
				Rx_Done 			<= '1';
			end if;
		  iClk <= '1';
      State <= Idle_s;		  	
				
		when others =>
			State <= Idle_s;
			
		end case;
		
	end if;
end if;
end process;

end Behavioral;

