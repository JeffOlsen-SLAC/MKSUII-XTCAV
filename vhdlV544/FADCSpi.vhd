		-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	TempADC -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/4/2011 3:03:14 PM
--
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_SIGNED.ALL;

library work;
use work.mksuii.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity FADCSpi is
Port (
	Clock						: in std_logic;
	Reset 	  				: in std_logic;
	Clk1MhzEn				: in std_logic;
	FADCSClk					: out std_logic;
	FADCSIO					: inout std_logic;
	FADCCs					: out std_logic
	);
end FADCSpi;

architecture behaviour of FADCSpi is

--constant SPIData 			: std_logic_vector(23 downto 0) := x"000D4C"; -- write 1 byte, Addr 0D, Testio, MixedFrequency
constant SPIData 			: std_logic_vector(23 downto 0) := x"001401"; -- write 1 byte, Addr 14, twos comp
constant TransData		: std_logic_vector(23 downto 0) := x"00FF01"; -- write 1 byte, Addr ff, tsw trans

signal BitCntr				: std_logic_vector(5 downto 0);
signal iFADCSClk			: std_logic;
signal iFADCCs				: std_logic;
signal ADCOutSr			: std_logic_vector(23 downto 0);
signal SPIOutEn			: std_logic;
signal TxTrans				: std_logic;

type FADCSpiState_t is
(
	Power_On_s,			
	Tx_IO_s,
	Tx_Sync_s,
	Tx_Data_s,
	Tx_Term_s
);

signal FADCSpiState	: FADCSpiState_t;

begin

FADCSClk			<= iFADCSClk;
FADCCS			<= iFADCCs;

io_p : process(ADCOutSr, SPIOutEn)
begin
if (SPIOutEn = '1') then
	FADCSIO		<= ADCOutSr(23);
else
	FADCSIO	 	<= 'Z';
end if;
end process;

adc_p : process(Clock, Reset)
begin
if (Reset = '1') then
	SPIOutEn			<= '0';
	IFADCCs			<= '0';
	iFADCSClk 		<= '0';
	TxTrans			<= '0';
	BitCntr			<= (Others => '0');
	ADCOutSr			<= (Others => '0');
	FADCSpiState 	<= Power_On_s;
elsif (Clock'event and Clock = '1') then
	if (Clk1MhzEn = '1') then
		case FADCSpiState is
		when Power_On_s =>
			iFADCSClk 		<= '1';
			if (BitCntr = "111111") then
				SPIOutEn			<= '1';
				IFADCCs			<= '1';
				ADCOutSr(19)	<= '0';
				BitCntr 			<= "000000";
				if (TxTrans = '0') then
					ADCOutSr		<= SPIData;
				else
					ADCOutSr		<= TransData;
				end if;
				FADCSpiState 	<= TX_IO_s;
			else
				BitCntr 			<= BitCntr +1;
				FADCSpiState 	<= Power_On_s;
			end if;
			
		when Tx_IO_s =>
			BitCntr 			<= "010111";
			FADCSpiState 	<= Tx_Sync_s;
		
		when Tx_Sync_s =>
			iFADCSClk 		<= not(iFADCSClk);
			FADCSpiState	<= Tx_Data_s;
			
		when Tx_Data_s =>
			iFADCSClk <= NOT(iFADCSClk);
			if (iFADCSClk = '1') then
				ADCOutSr <= ADCOutSr(22 downto 0) & '0';
				if (BitCntr = x"0") then
					SPIOutEn			<= '0';
					IFADCCs			<= '0';
					FADCSpiState	<=	Tx_Term_s;
				else
					BitCntr			<= BitCntr - 1;
					FADCSpiState	<= Tx_Data_s;
				end if;
			end if;
			
		when Tx_Term_s =>
			ADCOutSr(23)		<= '1';
			if (Clk1MhzEn = '1') then
				iFADCSClk 		<= '1';
				if (TxTrans = '1') then
					FADCSpiState	<= Tx_Term_s;
				else
					TxTrans 			<= '1';
					FADCSpiState	<= Power_On_s;
				end if;
			end if;
			
		when others =>
			FADCSpiState <= Power_On_s;
		end case;
	end if;
end if;
end process;

end behaviour;
