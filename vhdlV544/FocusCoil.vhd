-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	FocusCoil -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/9/2011 2:32:34 PM
--	Last change: JO 8/5/2011 1:17:28 PM
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


entity FocusCoil is
Port (
	Clock						: in std_logic;
	Reset 	  				: in std_logic;

-- Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_DataIn				: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut				: out std_logic_vector(15 downto 0);

	Clk1MhzEn				: in std_logic;
	FocusClk					: out std_logic;
	FocusSync				: out std_logic;
	FocusSDOut				: out std_logic
	);

end FocusCoil;

architecture behaviour of FocusCoil is

signal BitCntr				: std_logic_vector(3 downto 0);
signal iFocusClk			: std_logic;
signal DacSr				: std_logic_vector(15 downto 0);
signal DacData				: std_logic_vector(15 downto 0);
signal NewDrive			: std_logic;
signal ClrNewDrive		: std_logic;

type FocusState_t is
(
	Idle_s,
	Tx_Sync_s,
	Tx_Data_s,
	Term_s
);

signal FocusState : FocusState_t;

begin

FocusClk		<= iFocusclk;
FocusSDOut 	<= DacSr(15);


WrReg : process(Clock, Reset, ClrNewDrive)
Begin
if (reset = '1') then
	DACData 	<= (Others => '0');
	NewDrive <= '0';
elsif ( ClrNewDrive = '1') then
	NewDrive <= '0';
elsif (Clock'event and 	Clock = '1') then
	if (Lnk_Wr = '1') then
		If (Lnk_Addr =  x"0000") then
			DacData	<= Lnk_DataIn;
			NewDrive <= '1';
		end if;
	end if;
end if;
end process;

RdREg : process(Lnk_Addr, DacData)
Begin
	if (Lnk_Addr(3 downto 0) = x"0") then
		Reg_DataOut <= DacData;
	else
		Reg_DataOut <= (Others => '0');	
	end if;
end process;

focus_p : process(Clock, Reset)
begin
if (Reset = '1') then
	BitCntr			<= (Others => '0');
	DacSr				<= (Others => '0');
	FocusSync		<= '0';
	iFocusClk		<= '0';
	ClrNewDrive 	<= '0';
	FocusState 		<= Idle_s;
elsif (Clock'event and Clock = '1') then
case FocusState is
	when Idle_s =>
		FocusSync		<= '0';
		iFocusClk		<= '1';
		if (NewDrive = '1') then
			ClrNewDrive <= '1';
			BitCntr		<= x"F";
			FocusState 	<= Tx_Sync_s;
		else
			FocusState 	<= Idle_s;
		end if;
		
	when Tx_Sync_s =>
		ClrNewDrive <= '0';
		if (Clk1MhzEn = '1') then
			FocusSync 	<= '1';
			DacSr			<= "00" & DacData(11 downto 0) & "00";
			FocusState 	<= Tx_Data_s;
		else
			FocusState 	<= Tx_Sync_s;
		end if;
		
	when Tx_Data_s =>
		if (Clk1MhzEn = '1') then
			iFocusClk <= NOT(iFocusClk);
			if (iFocusClk = '0') then
				DacSr <= DacSr(14 downto 0) & '0';
				if (BitCntr = x"0") then
					FocusState <= Term_s;
				else
					BitCntr 		<= BitCntr - 1;
					FocusState 	<= Tx_Data_s;
				end if;
			end if;
		else
			FocusState <= Tx_Data_s;
		end if;

	when Term_s =>
		if (Clk1MhzEn = '1') then
			FocusSync 		<= '0';
			FocusState 		<= Idle_s;
		else
			FocusState 		<= Term_s;
		end if;
	end case;
end if;
end process;

end behaviour;
