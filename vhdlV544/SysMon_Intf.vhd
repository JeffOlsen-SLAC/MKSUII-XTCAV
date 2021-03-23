-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	SysMon_Intf.vhd -
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/17/2010 7:50:16 AM
--	Last change: JO 6/2/2011 2:15:00 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:54:27 03/16/2010 
-- Design Name: 
-- Module Name:    SysMon_Intf - Behavioral
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

Library work;
use work.MKSUII.all;

entity SysMon_Intf is
Port ( 
	Clock 					: in  std_logic;
	Reset 					: in  std_logic;

	Start						: in std_logic;
	
	VP_IN						: in std_logic;							 -- Dedicated Analog Input Pair
	VN_IN						: in std_logic;		

-- Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);		-- From Link Decode
	Lnk_DataOut				: out std_logic_vector(15 downto 0)		-- To Link Decode

);
end SysMon_Intf;
	
architecture Behavioral of SysMon_Intf is

type SysMon_State_t is
(
	Idle_s,
	Addr_s,
	Write_s,
	Wait_s
);


signal SysMon_State : SysMon_State_t;

signal WrdCntr 		: std_logic_vector(4 downto 0);
signal MemDataA 		: std_logic_vector(15 downto 0);

signal Drp_Addr		: std_logic_vector(6 downto 0);
signal Drp_Dout		: std_logic_vector(15 downto 0);
signal Drp_Rd			: std_logic;
signal Drp_Rdy			: std_logic;
signal WeEnA			: std_logic;

Begin


Lnk_DataOut <=  MemDataA;

process(WrdCntr)
Begin
	Case WrdCntr is
	When "00000" => Drp_Addr <= "0000000";
	When "00001" => Drp_Addr <= "0000001";
	When "00010" => Drp_Addr <= "0000010";
	When "00011" => Drp_Addr <= "0100000";
	When "00100" => Drp_Addr <= "0100001";
	When "00101" => Drp_Addr <= "0100010";
	When "00110" => Drp_Addr <= "0100100";
	When "00111" => Drp_Addr <= "0100101";
	When "01000" => Drp_Addr <= "0100110";
	when others => Drp_Addr <= "0000000";
	end case;
end process;

SysSeq : process(Clock, reset)
begin
if (reset = '1') then
	WrdCntr 			<= "00000";
	Drp_Rd			<= '0';
	WeEnA 			<= '0';
	SysMon_State 	<= Addr_s;
elsif (Clock'event and Clock = '1') then
	case SysMon_State is
	
	When Idle_s =>
		if (Start = '1') then
			WrdCntr 			<= "00000";
			SysMon_State 	<= Addr_s;
		else
			SysMon_State 	<= Idle_s;
		end if;
			
	when Addr_s =>
		Drp_Rd 			<= '1';
		SysMon_State 	<= Write_s;

	when Write_s =>
		Drp_Rd 			<= '0';
		if (Drp_Rdy = '1') then
			WeEnA 			<= '1';
			SysMon_State 	<= Wait_s;
		else
			SysMon_State 	<= Write_s;
		end if;

		when Wait_s =>
			if (WrdCntr = "01000") then
				SysMon_State 	<= Idle_s;
			else
				WrdCntr 			<= WrdCntr +1;
				SysMon_State 	<= Addr_s;
			end if;
			WeEnA 				<= '0';

		when others =>
		end case;
end if;
end process;

u_SysMon : xsysmon
port Map (
	DCLK_IN	=> Clock,								-- Clock input for the dynamic reconfiguration port
	RESET_IN	=> Reset,							 	-- Reset signal for the System Monitor control logic
	DADDR_IN	=> Drp_Addr,		 					-- Address bus for the dynamic reconfiguration port
	DI_IN		=> x"0000",	 							-- Input data bus for the dynamic reconfiguration port
	DEN_IN	=> Drp_Rd,								-- Enable Signal for the dynamic reconfiguration port
	DWE_IN	=> '0',								 	-- Write Enable for the dynamic reconfiguration port
	DO_OUT	=> Drp_Dout,	 						-- Output data bus for dynamic reconfiguration port
	DRDY_OUT	=> Drp_Rdy,								-- Data ready signal for the dynamic reconfiguration port
	VP_IN		=> VP_in,							 	-- Dedicated Analog Input Pair
	VN_IN		=> VN_in
);



u_SysMonMemA : sysmon_dpram
port map (
	clk	=> Clock,
	a		=> WrdCntr(3 downto 0),
	d		=> Drp_Dout,
	we		=> WeEnA,
	dpra	=> Lnk_Addr(3 downto 0),
	dpo	=> MemDataA
);



end Behavioral;

