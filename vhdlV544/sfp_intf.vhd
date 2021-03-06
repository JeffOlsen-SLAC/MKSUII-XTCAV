				-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	sfp_intf.vhd -
--
--	Copyright(c) SLAC 2000
--
--	Author: Jeff Olsen
--	Created on: 2/4/2008 1:32:47 PM
--	Last change: JO 9/26/2011 9:21:54 AM
--
----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:30:20 01/31/2008
-- Design Name:
-- Module Name:    atmel_2wire - Behavioral
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

Library work;
use work.mksuii.all;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- According to spec SFF-8472, 16 bit values MUST be readout using
-- two byte read sequences. 
-- This routine reads ALL data using 2 byte read sequences.
--

--
-- This module will not respond until the SFP is finished being read
-- This is to prevent reading different parts of the same 16 bit word.
--

entity sfp_intf is
Port (
	Clock 			: in std_logic;
	Reset 			: in std_logic;
-- Link Interface
	Lnk_Addr		 	: in std_logic_vector(15 downto 0);			-- From Link Interface

	Reg_DataOut		: out std_logic_vector(15 downto 0);

	Clk_En			: in std_logic;
	SDA0				: inout std_logic;
	SCL0				: out std_logic;

	SDA1				: inout std_logic;
	SCL1				: out std_logic
	);
end sfp_intf;

architecture Behavioral of sfp_intf is

constant devaddr_A0 	: std_logic_vector(6 downto 0) 	:= "1010000";
Constant devaddr_A2 	: std_logic_vector(6 downto 0) 	:= "1010001";
--constant memmax 		: std_logic_vector(7 downto 0)	:= "00000011";
constant memmax 		: std_logic_vector(7 downto 0)	:= "11111111";

signal divider 		: std_logic_vector(8 downto 0);
signal iOut_Sr 		: std_logic_vector(7 downto 0);
signal iIn_Sr_A 		: std_logic_vector(7 downto 0);
signal cntr 			: std_logic_vector(2 downto 0);
signal clk_cntr 		: std_logic_vector(1 downto 0);
signal iEn_Dout  		: std_logic;
signal ISCL  			: std_logic;
signal iSDA0  			: std_logic;
signal Mem_Addr 		: std_logic_vector(9 downto 0);
signal Mem_Wr  		: std_logic;
signal Mem_Write  	: std_logic;
signal Mem_Din 		: std_logic_vector(7 downto 0);
--signal Start      	: std_logic;
signal iStart      	: std_logic;
signal iDone      	: std_logic;
signal Fiber0Sel    	: std_logic;
signal Space 	    	: std_logic;

type seq_state_t is
(
	Idle_s,
	Start_s,
	Dev_Addr_Wr_s,
	Dev_Wr_Ack_s,
	Wrd_Addr_s,
	Wrd_Ack_s,
   Dev_Addr_Start_s,
   Dev_Addr_Rd_s,
   Dev_Rd_Ack_s,
   Read_Hi_s,
   Read_Hi_Ack_s,
   Read_Lo_s,
   Read_Lo_Ack_s,
   Stop_s,																						 
	Wait_s
);


signal seq_State 	: seq_state_t;

signal Din		 				: std_logic;
signal SDOut 		 			: std_logic;

signal iSFP_RegDataOut 		: std_logic_vector(31 downto 0);
signal Gap_Cntr 				: std_logic_vector(7 downto 0);

Begin

domux_p : process(Lnk_Addr, iSFP_RegDataOut)
begin
	if (Lnk_Addr(0) = '0') then
		Reg_DataOut <= iSFP_RegDataOut(15 downto 0);
	else
		Reg_DataOut <= iSFP_RegDataOut(31 downto 16);
	end if;
end process;

Fiber0_IO_p: process(iEn_Dout, Fiber0Sel, iout_sr)
begin
	if ((iEn_Dout = '1') and (Fiber0Sel = '1')) then
		SDA0 	<= iOut_Sr(7);
	else
		SDA0 	<= 'Z';
	end if;
end process; -- Fiber_IO_p	

Fiber1_IO_p: process(iEn_Dout, Fiber0Sel, iout_sr)
begin
	if ((iEn_Dout = '1') and (Fiber0Sel = '0')) then
		SDA1 	<= iOut_Sr(7);
	else
		SDA1 	<= 'Z';
	end if;
end process; -- Fiber_IO_p	

InMux_P : process(Din, Fiber0Sel, SDA0, SDA1, ISCL)
begin
	if (Fiber0Sel = '1') then
		Din 	<= SDA0;
		SCL0 	<= ISCL;
		SCL1	<= '0';
	else
		Din	<= SDA1;
		SCL0 	<= '0';
		SCL1 	<= ISCL;
	end if;
end process;
	
Mem_Write 	<= (Mem_Wr AND Clk_En);

start_p: process(clock, reset)
begin
if (Reset = '1') then
   clk_cntr <= "00";
elsif (Clock'event and Clock = '1') then
   if (clk_en = '1') then
       clk_cntr 	<= clk_cntr + 1;
   end if;
end if;
end process; --start_p

Seq_p : Process(Clock, Reset)
begin
if (Reset = '1') then
	iOut_Sr 		<= (Others => '1');
	iIn_Sr_A 	<= (Others => '0');
	cntr        <= (Others => '0');
	Mem_Addr		<= (Others => '0');
	Mem_Wr    	<= '0';
	Mem_Din   	<= (Others => '0');
	Gap_Cntr   	<= (Others => '0');
	ISCL 			<= '0';
	iEn_Dout 	<= '0';
	Seq_State 	<= Idle_s;
	iDone 		<= '0';
	Fiber0Sel	<= '1';
	Space			<= '0';
elsif (Clock'event and Clock = '1') then
	Mem_Addr(9) <= not(Fiber0Sel);
	if (clk_en = '1') then
    	case Seq_State is
		when Idle_s =>
			ISCL		<= '0';
			iOut_Sr	<= (Others => '1');
			iDone 	<= '0';
			if (Gap_Cntr = x"FF") then
				if (clk_cntr = "11") then
					Gap_Cntr 	<= x"00";
					iEn_Dout 	<= '1';
					Seq_State	<= Start_s;
				else
					iEn_Dout 	<= '0';
					Seq_State 	<= Idle_s;
				end if;
			else
				Gap_Cntr <= Gap_Cntr + 1;
			end if;

		when Start_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "01" =>
				 if (Space = '1') then
					Mem_Addr(8) <= '1';
					iOut_Sr 		<= '0' & DevAddr_A0;	 
				else
					Mem_Addr(8) <= '0';
					iOut_Sr 		<= '0' & DevAddr_A2;
				end if;				   
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iOut_Sr 			<=  iOut_Sr(6 downto 0) & '0'; -- Write
				cntr				<= "111";
				Seq_State 		<= Dev_Addr_Wr_s;
			when others =>
			end case;
	
		when Dev_Addr_Wr_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "01" =>
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iOut_Sr 			<=  iOut_Sr(6 downto 0) & '0'; -- Write
				cntr 				<= cntr -1;	   
				if (cntr = "000") then
					iEn_Dout 	<= '0';		
					Seq_State	<= Dev_Wr_Ack_s;
				else
					Seq_State	<= Dev_Addr_Wr_s;
				end if;
			when others =>
			end case;
	
	
		when Dev_Wr_Ack_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				cntr				<= "111";
				iEn_Dout			<= '1';
				Seq_State 		<= Wrd_Addr_s;
			when others =>
			end case;
		  
	
		when Wrd_Addr_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "01" =>
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iOut_Sr 			<= iOut_Sr(6 downto 0) & '0'; -- Write
				cntr 				<= cntr -1;
				if (cntr = "000") then
					iEn_Dout 	<= '0';
					Seq_State 	<= Wrd_Ack_s;
				else
					iEn_Dout 	<= '1';
					Seq_State 	<= Wrd_Addr_s;
				end if;
	
			when others =>
			end case;
	
	
		when Wrd_Ack_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				cntr				<= "111";
				iEn_Dout			<= '1';
				iOut_Sr(7) 		<= '1';
				Seq_State 		<= Dev_Addr_Start_s;
			when others =>
			end case;
	
	
		when Dev_Addr_Start_s =>
		case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "01" =>
				 if (Space = '0') then
					iOut_Sr 		<= '0' & DevAddr_A0;	 
				else
					iOut_Sr 		<= '0' & DevAddr_A2;
				end if;				   
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iOut_Sr 			<=  iOut_Sr(6 downto 0) & '1'; -- Read
				cntr				<= "111";
				Seq_State 		<= Dev_Addr_Rd_s;
			when others =>
			end case;
	
		when Dev_Addr_Rd_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "01" =>
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iOut_Sr 			<=  iOut_Sr(6 downto 0) & '1'; -- Read
				cntr 				<= cntr -1;
				if (cntr = "000") then
					iEn_Dout		<= '0';
					Seq_State	<= Dev_Rd_Ack_s;
				else
					Seq_State	<= Dev_Addr_Rd_s;
				end if;
			when others =>
			end case;
	
	
		when Dev_Rd_Ack_s =>
			case clk_cntr is
			when "00" =>
				ISCL 			<= '1';
			when "10" =>
				ISCL 			<= '0';
			when "11" =>
				iEn_Dout			<= '0';
				Seq_State 		<= Read_Hi_s;
			when others =>
			end case;  
		when Read_Hi_s =>
			case clk_cntr is
			when "00" =>
				iIn_Sr_A 	<= iIn_Sr_A(6 downto 0) & Din;
				ISCL 		<= '1';
			when "01" =>
			when "10" =>
				ISCL 		<= '0';
			when "11" =>
				cntr 				<= cntr -1;
			  if (cntr = "000") then
					ien_dout 	<= '1';	
					iOut_Sr(7) 	<= '0';				
					Seq_State 	<= Read_Hi_Ack_s;
				else
					Seq_State <= Read_Hi_s;
				end if;
			when others =>
			end case;
	
		when Read_Hi_Ack_s =>
			case clk_cntr is
			when "00" =>
				ISCL 		<= '1';
				Mem_Wr		<= '1';
				Mem_Din		<= iIn_Sr_A;
			when "01" =>
				Mem_Wr 		<= '0';
			when "10" =>
				Mem_Wr 		<= '0';
				ISCL 		<= '0';
			when "11" =>
				Mem_Addr(7 downto 0) <= Mem_Addr(7 downto 0) +1;
				iEn_Dout 	<= '0';
				iOut_Sr(7) 	<= '0';
				Seq_State 	<= Read_Lo_s;
			when others =>
			end case;
	
		when Read_Lo_s =>
			case clk_cntr is
			when "00" =>
				iIn_Sr_A 	<= iIn_Sr_A(6 downto 0) & Din;
				ISCL 		<= '1';
			when "10" =>
				ISCL 		<= '0';
			when "11" =>
				cntr 			<= cntr -1;
				if (cntr = "000") then
					ien_dout 	<= '1';	
					iOut_Sr(7) 	<= '1';
					Seq_State 	<= Read_Lo_Ack_s;
				else
					Seq_State 	<= Read_Lo_s;
				end if;
			when others =>
			end case;
	
		when Read_Lo_Ack_s =>
			case clk_cntr is
			when "00" =>
				Mem_Wr		<= '1';
				Mem_Din		<= iIn_Sr_A;
				ISCL 		<= '1';
			when "01" =>
				Mem_Wr 		<= '0';
			when "10" =>
				Mem_Wr 		<= '0';
				ISCL 		<= '0';
			when "11" =>
				Seq_State 	<= Stop_s;
			when others =>
			end case;
	
		When Stop_s =>
			case clk_cntr is
			when "00" =>
				ISCL 		<= '1';
			when "01" =>
				iOut_Sr(7) 	<= '1';
			when "10" =>
				ISCL 		<= '0';
			when "11" =>
				if (Mem_Addr(7 downto 0) = memmax) then
					Mem_Addr(7 downto 0) <= (Others => '0');
					if (Space = '1') then
						Space 		<= '0';
						iDone 		<= '1';
						Fiber0Sel	<= Not(Fiber0Sel);
						Seq_State 	<= Idle_s;
					else 
						Space 		<= '1';
						cntr 			<= "001";
						Seq_State 	<= Wait_s;
					end if;
				else
					Mem_Addr(7 downto 0) <= Mem_Addr(7 downto 0) +1;
					Seq_State 				<= Dev_Addr_Start_s;
				end if;
			when others =>
				 
			end case;
						 
		When Wait_s =>
			if (Clk_Cntr = "11") then
				cntr <= cntr - 1;
				if (cntr = "000") then
					Seq_State <= Start_s;
				else
					Seq_State <= Wait_s;
				end if;
			else
				Seq_State <= Wait_s;
			end if;
		
		When Others =>
			 
		end case;
	end if; -- Clk_En
end if; -- Clock'event
End process; --Seq_p

fo_ram: dpram_fo
port map (
	clka	=> Clock,
	addra	=> Mem_Addr,
	wea	=> Mem_Wr,
	dina	=> Mem_Din,
	clkb	=> Clock,
	addrb	=> Lnk_Addr(8 downto 1),
	doutb	=> iSFP_RegDataOut
);

end Behavioral;

