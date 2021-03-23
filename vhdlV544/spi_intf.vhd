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

Library work;
use work.test.all;

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
	Clock 		: in  std_logic;
	Reset 		: in  std_logic;
	DataIn 		: in  std_logic_vector (7 downto 0);
	DataOut 		: out  std_logic_vector (7 downto 0);
	Wr_Fifo	 	: in  std_logic;
	Tx_Done 		: out std_logic;
	Clk200KHzen	: in std_logic;
	Rx_Start 	: in  std_logic;
	Rx_Done 		: out std_logic;
	SPI_SS 		: out std_logic;
	SPI_Clk 		: out std_logic;
	SPI_MOSI 	: out std_logic;
	SPI_MISO 	: in  std_logic;
	SBUF			: in  std_logic
);
end spi_intf;

architecture Behavioral of spi_intf is


type State_t is
(
	Idle_s,
	Clk_s,
	TermClk_s,
	TermSS_s,
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
signal DataOutSr  	: std_logic_vector(7 downto 0);
signal DataInSr  		: std_logic_vector(7 downto 0);
signal BitCntr  		: std_logic_vector(2 downto 0);
signal DataLatch 		: std_logic_vector(7 downto 0);
signal Clk200Ken		: std_logic;

signal rd_Fifo			: std_logic;
signal Fifo_Dout 		: std_logic_vector(7 downto 0);
signal full				: std_logic;
signal empty			: std_logic;
signal d_Rd_Fifo		: std_logic;
signal iRd_Fifo		: std_logic;
signal ACK_Start_Req	: std_logic;
signal ByteCntr		: std_logic_vector(8 downto 0);
signal NumBytes		: std_logic_vector(7 downto 0);
signal FF_Reset		: std_logic;
signal Reset_Fifo		: std_logic;

begin

SPI_MOSI <= iMOSI;
SPI_SS 	<= iSS;
SPI_Clk	<= iClk;

--iMISO		<= SPI_MISO;
iMISO		<= iMOSI;

FF_Reset <= Reset OR Reset_Fifo;

clken : process(Clock, Reset)
begin
if (Reset = '1') then
	Tx_Start_Req 	<= '0';
	Rx_Start_Req 	<= '0';
	Cntr 				<= (Others => '0');
	DataLatch		<= (Others => '0');
elsif (Clock'event and Clock = '1') then
	if (Empty = '0') then
		Tx_Start_Req 	<= '1';
	elsif (Tx_Start_Clr = '1') then
		Tx_Start_Req 	<= '0';
	end if;

	if (Rx_Start = '1') then
		Rx_Start_Req 	<= '1';
	elsif (Rx_Start_Clr = '1') then
		Rx_Start_Req 	<= '0';
	end if;
end if;
end process;

spi_p : Process(Clock, Reset)
begin
if (Reset = '1') then
	Tx_Start_Clr 	<= '0';
	Rx_Start_Clr 	<= '0';
	Ack_Start_Req 	<= '0';
	iSS				<= '0';
	iClk				<= '1';
	iMOSI				<= '0';
	Tx_Done 			<= '0';
	Rd_Fifo			<= '0';
	iRd_Fifo			<= '0';
	d_Rd_Fifo		<= '0';
	Reset_Fifo		<= '0';
	DataOutSr 		<= (Others => '0');
	DataInSr 		<= (Others => '0');
	BitCntr			<= (Others => '0');
	ByteCntr			<= (Others => '0');
	NumBytes			<= (Others => '1');
	State 			<= Idle_s;
elsif (Clock'event and Clock = '1') then

	d_Rd_Fifo 	<= iRd_Fifo;
	Rd_Fifo  	<= not(d_Rd_Fifo) and iRd_Fifo;
	
	if (Clk200KHzen = '1') then
		case State is
		when Idle_s =>
			Reset_Fifo		<= '0';
			Rx_Start_Clr 	<= '0';
			BitCntr			<= "111";
			if (Tx_Start_Req = '1') then
				Rd_Fifo			<= '1';
				DataOutSr 		<= Fifo_Dout(6 downto 0) & '0';
				iMOSI 			<= Fifo_Dout(7);
				iSS				<= '1';
				if (ByteCntr = "000000001") then
					NumBytes <= Fifo_Dout;
				end if;
				State				<= Clk_s;
			elsif ((Rx_Start_Req = '1') or (Ack_Start_Req = '1')) then
				DataOutSr 		<= x"FF";
				iMOSI 			<= '1';
				iSS				<= '1';
				State				<= Clk_s;
			else
				iClk				<= '0';
				iSS   			<= '0';
				State				<= Idle_s;
			end if;
		
		when Clk_s =>
			iRd_Fifo	<= '0';
			iClk 		<= Not(IClk);
			if (iClk = '1') then
				BitCntr 		<= BitCntr - 1;
				iMOSI 		<= DataOutSr(7);
				DataOutSr 	<= DataOutSr(6 downto 0) & '0' ;
				if (BitCntr = "000") then
					State <= TermClk_s;
				else
					State <= Clk_s;
				end if;
			end if;
			
			if (iClk = '1') then
				DataInSr		<= DataInSr(6 downto 0) & iMISO;
			end if;
				
		when TermClk_s =>
			DataInSr			<=  DataInSr(6 downto 0) & iMISO;
			iMOSI 			<= '0';
			iClk 				<= '0';
			State 			<= TermSS_s;		  	
				
		when TermSS_s =>
			DataOut		<= DataInSr;
			iSS			<= '0';
			if ((ByteCntr = ('0' & numBytes) + 2 ) and (Ack_Start_Req = '0')) then 
				Reset_Fifo		<= '1';
				Tx_Start_Clr 	<= '1';
				ByteCntr 		<= (Others => '0');
				Ack_Start_Req 	<= '1';
			elsif (Ack_Start_Req = '1') then
				Ack_Start_Req <= '0';
			else
				ByteCntr <= ByteCntr + 1;
			end if;
			State 	<= Term_s;

		when Term_s =>
			Reset_Fifo		<= '0';
			Tx_Start_Clr 	<= '0';
			State 			<= Idle_s;
			
		when others =>
			State <= Idle_s;
			
		end case;
		
	end if;
end if;
end process;

u_Spi_Fiofo : SPI_Fifo
port map (
	clk 		=> Clock,
	rst 		=> FF_Reset,
	din 		=> DataIn,
	wr_en 	=> Wr_Fifo,
	rd_en 	=> Rd_Fifo,
	dout 		=> Fifo_dout,
	full 		=> full,
	empty		=> empty
	);

end Behavioral;

