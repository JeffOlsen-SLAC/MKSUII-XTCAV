-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	flow_intf.vhd - 
--
--	Copyright(c) SLAC 2000
--
--	Author: JEFF OLSEN
--	Created on: 3/11/2011 12:08:09 PM
--	Last change: JO 8/5/2011 2:40:27 PM
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


entity flow_intf is
Port (
	Clock						: in std_logic;
	Reset						: in std_logic;
	FpReset					: in std_logic;
	Clk1KhzEn				: in std_logic;
	
	Lnk_Wr		 			: in std_logic;									-- From Link Interface
	Lnk_Addr		 			: in std_logic_vector(15 downto 0);			-- From Link Interface
	Lnk_DataIn				: in std_logic_vector(15 downto 0);			-- From Link Interface
	Reg_DataOut				: out std_logic_vector(15 downto 0);


	ACC2						: in std_logic;  -- High Ok, Low Fault
	ACC1						: in std_logic;
	WG2						: in std_logic;
	WG1						: in std_logic;
	KLY						: in std_logic;
	Flow_Sum_Fault			: in std_logic;
	
	ACC2_Test				: out std_logic;
	ACC1_Test				: out std_logic;
	WG2_Test					: out std_logic;
	WG1_Test					: out std_logic;
	KLY_Test					: out std_logic;


	Status					: out std_logic_vector(15 downto 0);

	Fault						: out std_logic
	
);

end flow_intf;

architecture behaviour of flow_intf is

signal iACC2 			: std_logic;
signal iACC1 			: std_logic;
signal iWG2 			: std_logic;
signal iWG1 			: std_logic;
signal iKLY 			: std_logic;
signal iFault	 		: std_logic_vector(5 downto 0);
signal FaultSum 		: std_logic;
signal iFaultLatch 	: std_logic_vector(5 downto 0);
signal TestReg		 	: std_logic_vector(15 downto 0);

begin

iFault 		<= Flow_Sum_Fault & not(iACC2 & iACC1 & iWG2 & iWG1 & iKLY);
Status		<= "00" & iFault & '0' & Faultsum & iFaultLatch;

Fault			<= FaultSum;

ACC2_Test	<= TestReg(4);
ACC1_Test	<= TestReg(3);
WG2_Test		<= TestReg(2);
WG1_Test		<= TestReg(1);
KLY_Test		<= TestReg(0);

flow_p : Process(Clock, Reset, FpReset)
begin
if ((Reset = '1') OR (FpReset = '1')) then
	FaultSum 		<= '0';
	iFaultLatch		<= (Others => '0');
	TestReg 			<= (Others => '0');
elsif (clock'event and Clock = '1') then
	if (Lnk_Wr = '1') then
		case Lnk_Addr is
			when x"0000" =>
				iFaultLatch 			<= (iFaultLatch AND NOT(Lnk_DataIn(5 downto 0))) OR iFault(5 downto 0);
			when x"0003" =>
				iFaultLatch 			<= iFaultLatch OR iFault(5 downto 0);
				TestReg(4 downto 0) 	<= Lnk_DataIn(4 downto 0) or TestReg(4 downto 0);

			when x"0004" =>
				iFaultLatch 			<= iFaultLatch OR iFault(5 downto 0);
				TestReg(4 downto 0) 	<= not(Lnk_DataIn(4 downto 0)) and TestReg(4 downto 0);

			when others =>
				iFaultLatch 			<= iFaultLatch OR iFault(5 downto 0);
		end case;
	else
		iFaultLatch <= iFaultLatch OR iFault(5 downto 0);
	end if;
	if (iFaultLatch = "000000") then
		FaultSum <= '0';
	else
		FaultSum <= '1';
	end if;
end if;
end process;

Rd_p : process(Lnk_Addr, iFaultLatch, iFault, TestReg)
begin
	Case Lnk_Addr(3 downto 0) is
		when x"0" =>
			Reg_DataOut <= "00" & iFault & "00" & iFaultLatch;
		when x"1" => 
			Reg_DataOut <= TestReg;
		when others => Reg_DataOut	<= (Others => '0');
	end case;
end process;


u_ACC2 : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> ACC2,
	Dout 		=> iACC2
	);
	
u_ACC1 : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> ACC1,
	Dout 		=> iACC1
	);
		
u_WG2 : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> WG2,
	Dout 		=> iWG2
	);
		
u_WG1 : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> WG1,
	Dout 		=> iWG1
	);
		
u_KLY : DeBounce 
Port map (
	Clock 	=> Clock,
	Reset 	=> Reset,
	ClockEn 	=> Clk1KhzEn,  -- 256ms
	Din 		=> KLY,
	Dout 		=> iKLY
	);
		
end;

