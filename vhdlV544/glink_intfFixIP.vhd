-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--	glink_intf - 

--susie
--	Copyright(c) SLAC 2000
--
--	Created on: 12/14/2009 1:18:44 PM
--	Last change: JO 3/3/2014 12:24:45 PM

library IEEE;
	use IEEE.std_logic_1164.ALL;
	--use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

Library work;
use work.mksuii.all;

entity glink_intf is
Port (
	Clock						: in  std_logic;
	Reset 					: in  std_logic;
   
--  To Registers
	Active					: out std_logic;							-- Valid Link Node Message
	Lnk_Error				: out std_logic;							-- inValid Link Node Message		
	Lnk_DataOut				: out  std_logic_vector(7 downto 0);
	Lnk_DataStrb			: out  std_logic;
	Lnk_MessType			: out  std_logic_vector(7 downto 0);
	Lnk_MessStrb			: out  std_logic;
	Lnk_TaskId				: out  std_logic_vector(7 downto 0);
	
-- Tx Data	
	Tx_Start					: in std_logic;
	Tx_MessType				: in std_logic_vector(7 downto 0);	-- Transmit message type
	Tx_TaskID				: in std_logic_vector(7 downto 0);	-- Transmit message type
	Tx_Data_In	     		: in std_logic_vector(7 downto 0);	-- Data from external memory or registers
	Tx_Count					: in std_logic_vector(15 downto 0); -- 
	Tx_Done					: in std_logic;
	Tx_Rdy					: out std_logic;
	
	

-- Board ID from Dip Switches
-- Used as LSByte of the EMAC and IP Address
	Brd_ID					: in std_logic_vector(7 downto 0);		-- Dip switch board ID



-- Local Link Fifo for emac core
-- Local link Receiver Interface - EMAC0
	RX_LL_DATA				: in std_logic_vector(7 downto 0);
	RX_LL_SOF_N				: in std_logic;
	RX_LL_EOF_N				: in std_logic;
	RX_LL_SRC_RDY_N		: in std_logic;--flag
	RX_LL_DST_RDY_N		: out	std_logic;--flag

-- Local link Transmitter Interface - EMAC0
	TX_LL_DATA				: out std_logic_vector(7 downto 0);
	TX_LL_SOF_N				: out std_logic;
	TX_LL_EOF_N				: out std_logic;
	TX_LL_SRC_RDY_N		: out std_logic;--flag
	TX_LL_DST_RDY_N		: in std_logic  --flag
	
);
end glink_intf;

architecture Behavioral of glink_intf is

signal cntr 				: std_logic_vector(7 downto 0);
signal txcntr 				: std_logic_vector(15 downto 0);

signal RX_LL_SOF			: std_logic;
signal RX_LL_EOF 			: std_logic;
signal RX_LL_SRC_RDY 	: std_logic;
signal RX_LL_DST_RDY 	: std_logic;

signal TX_LL_SOF			: std_logic;
signal TX_LL_EOF 			: std_logic;
signal TX_LL_SRC_RDY 	: std_logic;
signal TX_LL_DST_RDY 	: std_logic;


signal EMAC_Dest_Addr 	: MACAddr_t;
signal IP_Dest_Addr  	: IPAddr_t;
signal UDP_Dest_Addr 	: UDPAddr_t;
signal IP_Header 			: IPHeader_t;
signal EMAC_Addr			: MACAddr_t;
signal IP_Addr				: IPAddr_t;

signal IP_Protocol 		: std_logic_vector(7 downto 0);
signal Ether_Type_b 		: ether_type_t;
signal EMAC_BC 			: std_logic;
signal EMAC_ME 			: std_logic;
signal IP_ME 				: std_logic;
signal IP_BC 				: std_logic;
signal UDP_Err				: std_logic;
signal Tx_Busy				: std_logic;


signal HM_Version_Err 	: std_logic;
signal Message_Err 		: std_logic;

signal TxARP_Start   	: std_logic;
signal d_iTx_Start 		: std_logic;
signal dd_iTx_Start 		: std_logic;
signal d_TxARP_Start   	: std_logic;

signal Tx_Data				: Common_Data_t;
signal Tx_Common			: Common_Data_t;

signal iTX_LL_Data		: std_logic_vector(7 downto 0);
signal iARP_Reply			: Common_Data_t;
signal iARP_Data			: Common_Data_t;

signal ARP_TPA				: IPAddr_t;
signal MyIP      			: IPAddr_t;

signal ARP_Start 			: std_logic;
signal iTx_Start 			: std_logic;

signal IP_Chksum			: std_logic_vector(15 downto 0);
signal Comp_IP_ChkSuma	: std_logic_vector(31 downto 0);
signal Comp_IP_ChkSumb	: std_logic_vector(31 downto 0);
signal Comp_IP_ChkSumc	: std_logic_vector(31 downto 0);
signal Comp_IP_ChkSumd	: std_logic_vector(31 downto 0);
signal Comp_IP_ChkSume	: std_logic_vector(31 downto 0);

signal UDP_Count			: std_logic_Vector(15 downto 0);
signal IPV4_Count			: std_logic_Vector(15 downto 0);
signal ChkSum_Count		: std_logic_Vector(15 downto 0);
signal PayLoadLength		: std_logic_Vector(15 downto 0);


--signal iGate_Driver_ID_s_s  : std_logic_vector(7 downto 0);

type EMAC_State_t is
(
	Idle_s,
	EMAC_SA_s,
	EMAC_DA_s,
	EMAC_Type_s,
	Do_ARP_s,
		--ARP_Comp_s,
	Do_IPV4_s,
		IP_SA_s,
		IP_DA_s,
		UDP_SA_s,
		UDP_DA_s,
		UDP_Len_s,
		UDP_ChkSum_s,
			HM_Ver_s,--changed from MPS_Ver_s; HM_UDP_Type
			Lnk_MessType_s,--changed from MPS_Type_s
			Lnk_TaskId_s,
				HM_ID_s,
				HM_ReadData_S,
	Drain_Fifo_s
	);

signal EMAC_State : EMAC_State_t;


type tx_p is 
(
  tx_Idle_s,
  tx_DoARP_s,
  Tx_Common_s,
  tx_Data_s
);
	
signal Tx_State : tx_p;


--attribute signal_encoding : string;
--attribute signal_encoding of TxStatus_state : signal is "user";
--attribute signal_encoding of EMAC_state : signal is "user";

-- Try to preseve this signals for ChipScope
attribute keep : string;
attribute keep of Clock 				: signal is "true";
attribute keep of RX_LL_DATA 			: signal is "true";
attribute keep of RX_LL_SOF	 		: signal is "true";
attribute keep of RX_LL_EOF	 		: signal is "true";
attribute keep of RX_LL_SRC_RDY 		: signal is "true";
attribute keep of RX_LL_DST_RDY		: signal is "true";
attribute keep of Emac_State			: signal is "true";
attribute keep of lnk_error			: signal is "true";
--
attribute keep of TX_LL_DATA			: signal is "true";
attribute keep of TX_LL_SOF			: signal is "true";
attribute keep of TX_LL_EOF			: signal is "true";
attribute keep of TX_LL_SRC_RDY		: signal is "true";
attribute keep of TX_LL_DST_RDY		: signal is "true";
attribute keep of iTx_LL_Data			: signal is "true";
attribute keep of Tx_Busy				: signal is "true";

--
--attribute keep of LNK_WR				: signal is "true";
--
--attribute keep of FIFO_IN_Data  	: signal is "true";

Begin


TX_LL_Data 		<= iTX_LL_Data  ;

Lnk_Error 		<=  UDP_Err or HM_Version_Err or  Message_Err;

-- Index Counter counts down,
-- Header indexs start at 11    
IP_Protocol 		<= IP_Header(2);--commented out
--IP_Protocol <= x"11";

RX_LL_SOF 			<= not(RX_LL_SOF_N);
RX_LL_EOF 			<= not(RX_LL_EOF_N);
RX_LL_SRC_RDY 		<= not(RX_LL_SRC_RDY_N);
RX_LL_DST_RDY_N	<= not(RX_LL_DST_RDY);

TX_LL_SOF_N			<= not(TX_LL_SOF);
TX_LL_EOF_N			<= not(TX_LL_EOF);
TX_LL_SRC_RDY_N	<= not(TX_LL_SRC_RDY);
TX_LL_DST_RDY 		<= not(TX_LL_DST_RDY_N);

MyIp(3) <= MyIP_Addr(3);
MyIp(2) <= MyIP_Addr(2);
MyIp(1) <= MyIP_Addr(1);
MyIp(0) <= MyIP_Addr(0);


--ipsel_p : process (Brd_ID)
--begin
--	case BRD_ID is
--	when x"00" =>
--		MyIp(3) <= MyIP_Addr0(3);
--		MyIp(2) <= MyIP_Addr0(2);
--		MyIp(1) <= MyIP_Addr0(1);
--		MyIp(0) <= MyIP_Addr0(0);
--	when x"01" => 
--		MyIp(3) <= MyIP_Addr1(3);
--		MyIp(2) <= MyIP_Addr1(2);
--		MyIp(1) <= MyIP_Addr1(1);
--		MyIp(0) <= MyIP_Addr1(0);
--	when x"02" =>
--		MyIp(3) <= MyIP_Addr2(3);
--		MyIp(2) <= MyIP_Addr2(2);
--		MyIp(1) <= MyIP_Addr2(1);
--		MyIp(0) <= MyIP_Addr2(0);
--	when others =>
--		MyIp(3) <= MyIP_Addr0(3);
--		MyIp(2) <= MyIP_Addr0(2);
--		MyIp(1) <= MyIP_Addr0(1);
--		MyIp(0) <= MyIP_Addr0(0);
--	end case;
--end process;
--	

CheckSum_p : process(clock, reset)
begin
if (Reset = '1') then
	IP_ChkSum <= (others => '0');
	Comp_IP_ChkSuma 	<= (others => '0'); 
	Comp_IP_ChkSumb 	<= (others => '0'); 
	Comp_IP_ChkSumc 	<= (others => '0'); 
	UDP_Count			<= (others => '0'); 
	IPV4_Count			<= (others => '0'); 
elsif (clock'event and clock = '1') then
	Comp_IP_ChkSuma <= (Constant_Ip_Chksum + (x"0000" & MyIp_Addr(3) & MyIP_Addr(2)));
	Comp_IP_ChkSumb <= (Comp_IP_ChkSuma + (x"0000" & MyIp_Addr(1) & MyIp_Addr(0))); 	
	Comp_IP_ChkSumc <= (Comp_IP_ChkSumb + (x"0000" & IP_Addr(3) & IP_Addr(2))); 
	Comp_IP_ChkSumd <= (Comp_IP_ChkSumc + (x"0000" & IP_Addr(1) & IP_Addr(0)));
	Comp_IP_ChkSume <= (Comp_IP_ChkSumd + (x"0000" & IPV4_Count)); -- Length
	
	IP_ChkSum	<= Not(Comp_IP_ChkSume(15 downto 0) + 
	                  Comp_IP_ChkSume(31 downto 16));
							

-- UDP Count = 8 Byte UDP Header +	 8 Byte MKSUii ProtoCol header + TxCount
--           = TxCount + 16						
	UDP_Count		<= Tx_Count + x"0010";
	
-- IPV4 Count = 20 Byte IPV4 Header + UDP Length
--	           = TxCount + 36
	IPV4_Count		<= Tx_Count + x"0024";
	
end if;
end Process; --CheckSum_p

Status_Latch_p : process(clock, reset)
begin
if (Reset = '1') then
	Tx_Data 				<= (Others => "00000000");
	iTx_Start 			<= '0';
	d_iTx_Start 		<= '0';
	dd_iTx_Start 		<= '0';
	d_TxARP_Start 		<= '0';
	ARP_Start 			<= '0';

elsif (clock'event and clock = '1') then
	iTx_Start 			<= Tx_Start;		
	ARP_Start    		<= TxARP_Start;
	d_iTx_Start 		<= iTx_Start;
	dd_iTx_Start 		<= d_iTx_Start;
	d_TxARP_Start 		<= ARP_Start;
	if ((d_iTx_Start = '1') )then
		Tx_Data <= Tx_Common;
	elsif (ARP_Start = '1') then
		Tx_Data <= iARP_Reply;
	end if;
end if;
end process;

-- EMAC Destination Address

	EMAC_Addr		<= EMAC_Dest_Addr;
	ip_Addr			<= IP_Dest_Addr;
   
	Tx_Common(0) 	<= EMAC_Addr(5);
	Tx_Common(1) 	<= EMAC_Addr(4);
	Tx_Common(2) 	<= EMAC_Addr(3);
	Tx_Common(3) 	<= EMAC_Addr(2);
	Tx_Common(4) 	<= EMAC_Addr(1);
	Tx_Common(5) 	<= EMAC_Addr(0);
	
-- EMAC Source Address
	Tx_Common(6) 	<= myEMAC_addr(5);
	Tx_Common(7) 	<= myEMAC_addr(4);
	Tx_Common(8) 	<= myEMAC_addr(3);
	Tx_Common(9) 	<= myEMAC_addr(2);
	Tx_Common(10) 	<= myEMAC_addr(1);
	Tx_Common(11) 	<= Brd_ID;
	
	Tx_Common(12) 	<= Ether_Type_IPV4(15 downto 8);
	Tx_Common(13) 	<= Ether_Type_IPV4(7 downto 0);
-- Header length 5,  IPVersion 4
	Tx_Common(14) 	<= x"45";
-- Type of service
	Tx_Common(15) 	<= x"00";
	
-- Total Length
-- IPV4 Header = 20
-- UDP  Header =  8
--              ----

	Tx_Common(16) 	<= IPV4_Count(15 downto 8);
	Tx_Common(17) 	<= IPV4_Count(7 downto 0);
	
-- Id, flags, frag
	Tx_Common(18) 	<= x"00";
	Tx_Common(19) 	<= x"00";
	Tx_Common(20) 	<= x"00";
	Tx_Common(21) 	<= x"00";
	
-- Time to Live
-- 12/21/09 Changed from 0 to 6
	Tx_Common(22) 	<= x"06";

-- Protocol
	Tx_Common(23) 	<= UDP_Protocol;
	
-- CheckSum 
	Tx_Common(24) 	<= IP_ChkSum(15 downto 8);
	Tx_Common(25) 	<= IP_ChkSum(7 downto 0);
-- IP Source Address

	Tx_Common(26) 	<= myIP_Addr(3);
	Tx_Common(27) 	<= myIP_Addr(2);
	Tx_Common(28) 	<= myIP_Addr(1);
	Tx_Common(29) 	<= myIP_Addr(0);
	
-- IP Destination Address

	Tx_Common(30) 	<= IP_Addr(3);
	Tx_Common(31) 	<= IP_Addr(2);
	Tx_Common(32) 	<= IP_Addr(1);
	Tx_Common(33) 	<= IP_Addr(0);

-- UDP Source Header
 	Tx_Common(34) 	<= myUDP_Addr(1);
 	Tx_Common(35) 	<= myUDP_Addr(0);
-- UDP Destination Header
 	Tx_Common(36) 	<= UDP_Dest_Addr(1);
 	Tx_Common(37) 	<= UDP_Dest_Addr(0);
	
-- Length
-- Header   8
-- Version  1
-- Type     1
--       ----
--         40

   Tx_Common(38) 	<=  UDP_Count(15 downto 8);
   Tx_Common(39) 	<=  UDP_Count(7 downto 0);


-- Checksum unused
	Tx_Common(40) 	<= x"00";
	Tx_Common(41) 	<= x"00";

-- HM Protocol Version
	Tx_Common(42) 	<= MKSUII_ProtoCol_Version;
-- HM Message Type Status

	Tx_Common(43) 	<= Brd_ID;
	Tx_Common(44) 	<= Tx_MessType;
	Tx_Common(45)	<= Tx_TaskID;


-- ARP Reply
-- EMAC Destination Address
	iARP_Reply(0) 	<= EMAC_Dest_Addr(5);
	iARP_Reply(1) 	<= EMAC_Dest_Addr(4);
	iARP_Reply(2) 	<= EMAC_Dest_Addr(3);
	iARP_Reply(3) 	<= EMAC_Dest_Addr(2);
	iARP_Reply(4) 	<= EMAC_Dest_Addr(1);
	iARP_Reply(5) 	<= EMAC_Dest_Addr(0);

-- EMAC Source Address
	iARP_Reply(6) 	<= myEMAC_addr(5);
	iARP_Reply(7) 	<= myEMAC_addr(4);
	iARP_Reply(8) 	<= myEMAC_addr(3);
	iARP_Reply(9) 	<= myEMAC_addr(2);
	iARP_Reply(10) <= myEMAC_addr(1);
	iARP_Reply(11) <= Brd_ID;
	
	iARP_Reply(12) <= Ether_Type_ARP(15 downto 8);
	iARP_Reply(13) <= Ether_Type_ARP(7 downto 0);

-- Hardware Type
	iARP_Reply(14) <=	x"00";
	iARP_Reply(15) <=	x"01";

-- Protocol Type
	iARP_Reply(16) <= Ether_Type_IPV4(15 downto 8);
	iARP_Reply(17) <= Ether_Type_IPV4(7 downto 0);
-- Hardware Length
	iARP_Reply(18) <= x"06";
-- Protocol Length
	iARP_Reply(19) <= x"04";
-- Operation 2, ARP Reply
	iARP_Reply(20) <= x"00";
	iARP_Reply(21) <= x"02";

-- Sender Hardware address <= SHA
	iARP_Reply(22)	<= myEMAC_addr(5);
	iARP_Reply(23) <= myEMAC_addr(4);
	iARP_Reply(24) <= myEMAC_addr(3);
	iARP_Reply(25) <= myEMAC_addr(2);
	iARP_Reply(26) <= myEMAC_addr(1);
	iARP_Reply(27) <= Brd_ID;

-- Sender Protocal address <= SPA
	iARP_Reply(28) <= myIP_Addr(3);
	iARP_Reply(29) <= myIP_Addr(2);
	iARP_Reply(30) <= myIP_Addr(1);
	iARP_Reply(31) <=  myIP_Addr(0);


-- Target Hardware address <= SHA
	iARP_Reply(32)	<= iARP_Data(19);
	iARP_Reply(33) <= iARP_Data(18);
	iARP_Reply(34) <= iARP_Data(17);
	iARP_Reply(35) <= iARP_Data(16);
	iARP_Reply(36) <= iARP_Data(15);
	iARP_Reply(37) <= iARP_Data(14);

-- Target Protocal address <= SPA
	iARP_Reply(38) <= iARP_Data(13);
	iARP_Reply(39) <= iARP_Data(12);
	iARP_Reply(40) <= iARP_Data(11);
	iARP_Reply(41) <= iARP_Data(10);

-- 18 filler zeros to make packet 46 bytes
   iARP_Reply(42) <= x"00";
   iARP_Reply(43) <= x"00";
   iARP_Reply(44) <= x"00";
   iARP_Reply(45) <= x"00";
   iARP_Reply(46) <= x"00";
   iARP_Reply(47) <= x"00";
   iARP_Reply(48) <= x"00";
   iARP_Reply(49) <= x"00";
   iARP_Reply(50) <= x"00";
   iARP_Reply(51) <= x"00";
   iARP_Reply(52) <= x"00";
   iARP_Reply(53) <= x"00";
   iARP_Reply(54) <= x"00";
   iARP_Reply(55) <= x"00";
   iARP_Reply(56) <= x"00";
   iARP_Reply(57) <= x"00";
   iARP_Reply(58) <= x"00";
   iARP_Reply(59) <= x"00";


	ARP_TPA(3)  <= iARP_Data(3);
	ARP_TPA(2)  <= iARP_Data(2);
	ARP_TPA(1)  <= iARP_Data(1);
	ARP_TPA(0)  <= iARP_Data(0);

-- Decode Command received by Ethernet Link
EMAC_Decode_p : process(clock, reset)
Begin
if (Reset = '1') then
	cntr 						<= (others => '0');
	EMAC_State 				<= Idle_s;
	EMAC_BC 					<= '0';
	EMAC_ME 					<= '0';
	IP_ME 					<= '0';
	IP_BC 					<= '0';
	UDP_Err					<= '0';
	
	HM_Version_Err 		<= '0';
	Message_Err 			<= '0';
	Ether_type_b			<= (Others => x"00");
	TxARP_Start 			<= '0';
	Active       			<= '0';
	Lnk_MessType 			<= (Others => '0');
	Lnk_MessStrb			<= '0';
	Lnk_DataStrb			<= '0';
	IP_Header 				<= (Others => "00000000");
	Lnk_DataOut 			<= (Others => '0');
	RX_LL_DST_RDY 			<= '0';
	Lnk_TaskId				<= x"00";
	PayLoadLength			<= x"0000";
elsif (Clock'event and Clock = '1') then
	CASE EMAC_State is	
	When Idle_s =>
		Lnk_Dataout 		<= (Others => '0');
		Lnk_DataStrb 		<= '0';
		IP_ME 				<= '0';
		IP_BC 				<= '0';
		UDP_Err				<= '0';
		HM_Version_Err 	<= '0';
		TxARP_Start 		<= '0';
		Active   			<= '0';
		Message_Err	  		<= '0';
		PayLoadLength		<= x"0000";
		
		if (tx_busy = '0') then
			RX_LL_DST_RDY 		<= '1';
		
	--		If ((RX_LL_SOF = '1') and (Tx_Busy = '0')) then
			If ((RX_LL_SOF = '1') and (RX_LL_DST_RDY = '1')) then
				if (RX_LL_Data /= x"FF") then
					EMAC_BC <= '0';
				else
					EMAC_BC <= '1';
				end if;

				if (RX_LL_Data /= MyEMAC_Addr(5)) then
					EMAC_Me <= '0';
				else
					EMAC_ME <= '1';
				end if;
		  
				Message_Err 		<= '0';
				Cntr					<= x"04";
				EMAC_State			<= EMAC_DA_s;
			else
				EMAC_BC				<= '0';
				EMAC_ME				<= '0';
				EMAC_State			<= Idle_s;
			end if;
		else		
			RX_LL_DST_RDY 		<= '0';
			EMAC_BC				<= '0';
			EMAC_ME				<= '0';
			EMAC_State 			<= Idle_s;
		end if;
				
	When EMAC_DA_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				if (cntr = 0) then
					if (RX_LL_Data /= Brd_ID) then
						EMAC_Me <= '0';
					end if;
					if (RX_LL_Data /= x"FF") then
						EMAC_BC <= '0';
					end if;
				
					if (((RX_LL_Data = Brd_ID) AND (EMAC_Me = '1')) OR
					((RX_LL_Data = x"FF") AND (EMAC_BC = '1'))) then
						cntr 			<= x"05";
						EMAC_State 	<= EMAC_SA_s;
					else
						EMAC_State <= drain_fifo_s;
					end if;
				else
					if (RX_LL_Data /= MyEMAC_Addr(Conv_Integer(cntr))) then
						EMAC_Me <= '0';
					end if;
					if (RX_LL_Data /= x"FF") then
						EMAC_BC <= '0';
					end if;
		
					Cntr			<= cntr -1;
					EMAC_State	<= EMAC_DA_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State <= EMAC_DA_s;
		end if;

	When EMAC_SA_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				EMAC_Dest_Addr(Conv_Integer(Cntr)) <= RX_LL_Data;
				if (cntr = 0) then
					Cntr 			<= x"01";
					EMAC_State 	<= EMAC_Type_s;
				else
					Cntr 			<= cntr -1;
					EMAC_State 	<= EMAC_SA_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State <= EMAC_SA_s;
		end if;

-- Respond to either ARP or IPV4 packets
	When EMAC_Type_s =>	
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF ='0') then
				Ether_Type_b(Conv_Integer(Cntr)) <= RX_LL_Data;
				If (Cntr = x"00") then
					if ((Ether_Type_b(1) & RX_LL_Data) = Ether_Type_ARP) then
-- jjo
-- added EMAC_ME since the switch does an ARP to my MAC
--
						if ((EMAC_BC = '1') OR (EMAC_ME = '1')) then
							cntr 			<= x"1B";
							EMAC_State 	<= Do_ARP_s;
						else
							EMAC_State 	<= Drain_Fifo_s;
						end if;					 
					elsif ((Ether_Type_b(1) & RX_LL_Data) = Ether_Type_IPV4) then
						if ((EMAC_Me = '1') or (EMAC_BC = '1')) then
							cntr 			<= x"0B";
							IP_Me			<= '1';
							IP_BC			<= '1';	
							EMAC_State  <= Do_IPV4_s;
						else
							EMAC_State 	<= Drain_Fifo_s;
						end if;				  
					else
						IP_Me 		<= '0';
						Message_Err <= '1';
						EMAC_State 	<= Drain_Fifo_s;
					end if;
				else
					cntr 			<= cntr -1;
					EMAC_State 	<= EMAC_Type_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State <= EMAC_Type_s;
		end if;

	When Do_IPV4_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				IP_Header(Conv_Integer(cntr)) <= RX_LL_Data;
				If (cntr = x"00") then
					cntr <= x"03";
					If (IP_Protocol /= UDP_Protocol) then
						IP_Me 		<= '0';
						UDP_Err		<= '1';
						Message_Err <= '1';
						--EMAC_State 	<= IP_SA_s;
						EMAC_State 	<= Drain_Fifo_s;
					else
						EMAC_State 	<= IP_SA_s;
					end if;
				else
					cntr 			<= cntr -1;
					EMAC_State 	<= Do_IPV4_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State 		<= Do_IPV4_s;
		end if;

	When IP_SA_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				IP_Dest_Addr(Conv_Integer(Cntr)) <= RX_LL_Data;
				if (cntr = 0) then
					Cntr 			<= x"03";
					EMAC_State 	<= IP_DA_s;
				else
					Cntr 			<= cntr -1;
					EMAC_State 	<= IP_SA_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State 		<= IP_SA_s;
		end if;


	When IP_DA_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				if (cntr = 0) then
					if (RX_LL_Data /= MyIP_Addr(0)) then
						IP_Me 		<= '0';
					end if;
					if (RX_LL_Data /= x"FF") then
						IP_BC 		<= '0';
					end if;
					if (((RX_LL_Data = MyIP_Addr(0)) AND (IP_Me = '1')) OR
						 ((RX_LL_Data = x"FF") AND (IP_Me = '1')) OR
						 ((RX_LL_Data = x"FF") AND (IP_BC = '1'))) then
						cntr 			<= x"01";
						EMAC_State	<= UDP_SA_s;
					else
						EMAC_State 	<= Drain_Fifo_s;			
					end if;
				else
					if (RX_LL_Data /= MyIP_Addr(Conv_Integer(Cntr))) then
						IP_Me 		<= '0';
					end if;
					if (RX_LL_Data /= x"FF") then
						IP_BC			<= '0';
					end if;

					if ((RX_LL_Data = MyIP_Addr(Conv_Integer(Cntr))) OR
						 (RX_LL_Data = x"FF")) then
						Cntr 			<= cntr -1;
						EMAC_State 	<= IP_DA_s;
					else
						EMAC_State 	<= Drain_Fifo_s;
	
					end if;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State 		<= IP_DA_s;
		end if;

	When UDP_SA_s =>
		If (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				UDP_Dest_Addr(Conv_Integer(Cntr)) <= RX_LL_Data;
				if (Cntr = x"00") then
					cntr			<= x"01";
					EMAC_State	<= UDP_DA_s;
				else
					cntr 			<= cntr -1;
					EMAC_State 	<= UDP_SA_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State 		<= UDP_SA_s;
		end if;

	When UDP_DA_s =>
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
			  --MyUDP_Addr(Conv_Integer(Cntr)) <= RX_LL_Data;
				if (RX_LL_Data /= MyUDP_Addr(Conv_Integer(Cntr))) then
					EMAC_State 	<= drain_fifo_s;
				else
					if (Cntr = x"00") then
						Cntr			<= x"01";
						EMAC_State	<= UDP_Len_s ;
					else
						cntr 			<= cntr -1;
						EMAC_State	<= UDP_DA_s;
					end if;
				end if; 
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State 		<= UDP_DA_s;
		end if;
--udp length
	When UDP_Len_s =>
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				PayLoadLength <= PayLoadLength(7 downto 0) & RX_LL_Data;
				if (cntr = x"00") then
					cntr 			<= x"01";
					EMAC_State 	<= UDP_ChkSum_s;
				else
					cntr 			<= cntr -1;
					EMAC_State 	<= UDP_Len_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
						
		else
			EMAC_State 		<= UDP_Len_s;
		end if;

--udp checksum
	When UDP_ChkSum_s =>
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				if (cntr = x"00") then
					cntr 			<= x"00";
					EMAC_State 	<= HM_Ver_s;
				else
					cntr 			<= cntr -1;
					EMAC_State 	<= UDP_ChkSum_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
						
		else
			EMAC_State 		<= UDP_ChkSum_s;
		end if;

	When HM_Ver_s =>
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				if (RX_LL_Data /= MKSUII_ProtoCol_Version) then
					Message_Err			<= '1';
					HM_Version_Err 	<= '1';
					EMAC_State 			<= drain_fifo_s;
				else
					EMAC_State 			<= HM_Id_s;
				end if;
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State <= HM_Ver_s;
		end if;
		
	When HM_Id_s =>
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				EMAC_State 	<= Lnk_MessType_s;				
			else
				Message_Err <= '1';
				EMAC_State 	<= Idle_s;
			end if;
		else
			EMAC_State <= HM_ID_s;
		end if;

	When Lnk_MessType_s =>
		Active 	<= '1';
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '0') then
				Lnk_MessType 	<= RX_LL_Data;
				Lnk_MessStrb	<= '1';
				EMAC_State 		<= Lnk_TaskId_s;
			else	
				Message_Err 	<= '1';
				EMAC_State 		<= Idle_s;
			end if;
		else
			EMAC_State 		<= Lnk_MessType_s;
		end if;

	When Lnk_TaskId_s =>
		Lnk_MessStrb	<= '0';
		if (RX_LL_SRC_RDY = '1') then
			Lnk_TaskId	 	<= RX_LL_Data;
			if (RX_LL_EOF = '0') then
				EMAC_State 		<= HM_ReadData_S;
			else	
				Message_Err 	<= '1';
				EMAC_State 		<= Idle_s;
			end if;
		else
			EMAC_State 		<= Lnk_TaskId_s;
		end if;
		
	when HM_ReadData_S=>
		Active 			<= '0';
		Lnk_MessStrb	<= '0';
		if (RX_LL_SRC_RDY = '1') then
			Lnk_Dataout 	<= RX_LL_Data;
			if (RX_LL_EOF = '0') then
				Lnk_DataStrb 	<= '1';
				EMAC_State 		<= HM_ReadData_S;
			else	
			   Lnk_DataStrb 	<= '1';
				EMAC_State 		<= Idle_s;
			end if;
		else
			EMAC_State 	<= HM_ReadData_S;
		end if;

	when Do_ARP_s =>
		if (RX_LL_SRC_RDY = '1') then
--		if ((RX_LL_SRC_RDY = '1') and (Tx_Busy = '0')) then
--			RX_LL_DST_RDY	<= '1';
			iARP_Data(Conv_Integer(Cntr)) <= RX_LL_Data;
			if (cntr = 0) then
				if (RX_LL_EOF = '1') then
					Message_Err <= '1';
					EMAC_State 	<= Idle_s;
				else
					if ((myIp = ARP_TPA(3 downto 1) & RX_LL_Data) OR
						( (myIp(3 downto 1) = ARP_TPA(3 downto 1)) and (RX_LL_Data =  x"FF") ) ) then   -- Broadcast
						TxARP_Start <= '1';
						Active 		<= '1';
						EMAC_State 	<= drain_fifo_s;
					else
						TxARP_Start <= '0';
						Active 		<= '0';
						Emac_State  <= drain_fifo_s;
					end if;
				end if;
			else
					if (RX_LL_EOF = '1') then
						Message_Err <= '1';
						EMAC_State 	<= Idle_s;
					else	
						cntr 			<= cntr -1;
						EMAC_State 	<= Do_ARP_s;
					end if;
			end if;
		else
--			RX_LL_DST_RDY	<= '0';
			EMAC_State 		<= Do_ARP_s;
		end if;

	when drain_fifo_s =>
		TxARP_Start 	<= '0';
		if (RX_LL_SRC_RDY = '1') then
			if (RX_LL_EOF = '1') then
				EMAC_State 	<= Idle_s;
			else
				EMAC_State 	<= drain_fifo_s;
			end if;
		else
			EMAC_State 		<= drain_fifo_s;
		end if;
		
   end case;
end if;
end process;

--	Transmit MPS
tx_process : process(clock, reset)
Begin
if (Reset = '1') then
	txcntr 			<= (others => '0');
	iTX_LL_Data 	<= (others => '0');
	TX_LL_Sof		<= '0';
	TX_LL_EOF		<= '0';
	TX_LL_SRC_RDY	<= '0';
	Tx_Rdy 			<= '0';
	Tx_State 		<= tx_Idle_s;
elsif (Clock'event and Clock = '1') then
	CASE Tx_State is
	When tx_Idle_s =>
		TX_LL_EOF			<= '0';
		Tx_Rdy 				<= '0';
  		if (dd_iTx_Start = '1') then
			Tx_Busy				<= '1';
			TX_LL_Src_Rdy 		<= '1';
			TX_LL_Sof			<= '1';
			txcntr 				<= x"0001";
			iTX_LL_Data 		<= Tx_Data(0);
			Tx_State 			<= Tx_Common_s;
  		elsif (d_TxARP_Start = '1') then
			Tx_Busy				<= '1';
			TX_LL_Src_Rdy 		<= '1';
			TX_LL_Sof			<= '1';
			txcntr 				<= x"0001";
			iTX_LL_Data 		<= Tx_Data(0);
			Tx_State 			<= Tx_DoARP_s;
		else
			Tx_Busy				<= '0';
			TX_LL_SRC_RDY		<= '0';
			TX_LL_Sof			<= '0';
			iTX_LL_Data 		<= (Others => '0');
			Tx_State 			<= Tx_Idle_s;
		end if;

	When tx_DoARP_s =>
		if (TX_LL_DST_RDY = '1') then
			iTX_LL_Data 		<= Tx_Data(Conv_Integer(txcntr));
			TX_LL_Sof 			<= '0';
			if (txcntr = 44) then
				TX_LL_Eof 		<= '1';
				Tx_State 		<= Tx_Idle_s;
			else
				txcntr 			<= txcntr + 1;
				Tx_State 		<= tx_DoARP_s;
			end if;
		else
			Tx_State 			<= tx_DoARP_s;
		end if;

	When Tx_Common_s =>
		TX_LL_Sof 	<= '0';
		if (TX_LL_DST_RDY = '1') then
			if (txcntr = 45) then
				iTX_LL_Data 	<= Tx_Data(Conv_Integer(txcntr));
				if (Tx_Done = '1') then
					Tx_ll_Eof		<= '1';
					Tx_Rdy			<= '1';
					Tx_State 		<= Tx_Idle_s;
				else
					Tx_Rdy 			<= '1';
					txcntr 			<= txcntr + 1;
					Tx_State 		<= Tx_Common_s;
				end if;
			elsif (txcntr = 46) then
				txCntr 			<= Tx_Count;
				iTX_LL_Data 	<= Tx_Data_In;
					if (Tx_Done = '1') then
						Tx_Rdy			<= '1';
						Tx_ll_Eof		<= '1';
						Tx_State 		<= Tx_Idle_s;
					else
						Tx_Rdy			<= '1';
						Tx_State			<= tx_Data_s;
					end if;
			else
				iTX_LL_Data 	<= Tx_Data(Conv_Integer(txcntr));
				txcntr 			<= txcntr + 1;
				Tx_State 		<= Tx_Common_s;
			end if;
		else
			Tx_State 			<= Tx_Common_s;
		end if;
		
	When tx_Data_s =>
		Tx_Rdy <= TX_LL_DST_RDY;
		TX_LL_Sof 			<= '0';
		if (TX_LL_DST_RDY = '1') then
			iTx_LL_Data		<= Tx_Data_In;
			if (Tx_Done = '1') then
				Tx_ll_Eof		<= '1';
--				TX_LL_SRC_RDY	<= '0';
				Tx_Rdy			<= '0';
				Tx_State 		<= Tx_Idle_s;
			else
				Tx_Rdy 			<= '1';
				Tx_State 		<= tx_Data_s;
			end if;
		else
		   Tx_Rdy 			<= '0';
			Tx_State			<= tx_Data_s;
		end if;
			
		
   End Case;
end if;
end process;
end Behavioral;