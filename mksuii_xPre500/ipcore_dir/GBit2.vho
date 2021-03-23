
-- VHDL Instantiation Created from source file GBit2_block.vhd -- 10:33:34 03/24/2011
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
	COMPONENT GBit2_block
	PORT(
		CLK125 : IN std_logic;
		CLIENTEMAC0TXD : IN std_logic_vector(7 downto 0);
		CLIENTEMAC0TXDVLD : IN std_logic;
		CLIENTEMAC0TXFIRSTBYTE : IN std_logic;
		CLIENTEMAC0TXUNDERRUN : IN std_logic;
		CLIENTEMAC0TXIFGDELAY : IN std_logic_vector(7 downto 0);
		CLIENTEMAC0PAUSEREQ : IN std_logic;
		CLIENTEMAC0PAUSEVAL : IN std_logic_vector(15 downto 0);
		RXP_0 : IN std_logic;
		RXN_0 : IN std_logic;
		PHYAD_0 : IN std_logic_vector(4 downto 0);
		CLIENTEMAC1TXD : IN std_logic_vector(7 downto 0);
		CLIENTEMAC1TXDVLD : IN std_logic;
		CLIENTEMAC1TXFIRSTBYTE : IN std_logic;
		CLIENTEMAC1TXUNDERRUN : IN std_logic;
		CLIENTEMAC1TXIFGDELAY : IN std_logic_vector(7 downto 0);
		CLIENTEMAC1PAUSEREQ : IN std_logic;
		CLIENTEMAC1PAUSEVAL : IN std_logic_vector(15 downto 0);
		RXP_1 : IN std_logic;
		RXN_1 : IN std_logic;
		PHYAD_1 : IN std_logic_vector(4 downto 0);
		CLK_DS : IN std_logic;
		GTRESET : IN std_logic;
		RESET : IN std_logic;          
		CLK125_OUT : OUT std_logic;
		EMAC0CLIENTRXD : OUT std_logic_vector(7 downto 0);
		EMAC0CLIENTRXDVLD : OUT std_logic;
		EMAC0CLIENTRXGOODFRAME : OUT std_logic;
		EMAC0CLIENTRXBADFRAME : OUT std_logic;
		EMAC0CLIENTRXFRAMEDROP : OUT std_logic;
		EMAC0CLIENTRXSTATS : OUT std_logic_vector(6 downto 0);
		EMAC0CLIENTRXSTATSVLD : OUT std_logic;
		EMAC0CLIENTRXSTATSBYTEVLD : OUT std_logic;
		EMAC0CLIENTTXACK : OUT std_logic;
		EMAC0CLIENTTXCOLLISION : OUT std_logic;
		EMAC0CLIENTTXRETRANSMIT : OUT std_logic;
		EMAC0CLIENTTXSTATS : OUT std_logic;
		EMAC0CLIENTTXSTATSVLD : OUT std_logic;
		EMAC0CLIENTTXSTATSBYTEVLD : OUT std_logic;
		EMAC0CLIENTSYNCACQSTATUS : OUT std_logic;
		EMAC0ANINTERRUPT : OUT std_logic;
		TXP_0 : OUT std_logic;
		TXN_0 : OUT std_logic;
		RESETDONE_0 : OUT std_logic;
		EMAC1CLIENTRXD : OUT std_logic_vector(7 downto 0);
		EMAC1CLIENTRXDVLD : OUT std_logic;
		EMAC1CLIENTRXGOODFRAME : OUT std_logic;
		EMAC1CLIENTRXBADFRAME : OUT std_logic;
		EMAC1CLIENTRXFRAMEDROP : OUT std_logic;
		EMAC1CLIENTRXSTATS : OUT std_logic_vector(6 downto 0);
		EMAC1CLIENTRXSTATSVLD : OUT std_logic;
		EMAC1CLIENTRXSTATSBYTEVLD : OUT std_logic;
		EMAC1CLIENTTXACK : OUT std_logic;
		EMAC1CLIENTTXCOLLISION : OUT std_logic;
		EMAC1CLIENTTXRETRANSMIT : OUT std_logic;
		EMAC1CLIENTTXSTATS : OUT std_logic;
		EMAC1CLIENTTXSTATSVLD : OUT std_logic;
		EMAC1CLIENTTXSTATSBYTEVLD : OUT std_logic;
		EMAC1CLIENTSYNCACQSTATUS : OUT std_logic;
		EMAC1ANINTERRUPT : OUT std_logic;
		TXP_1 : OUT std_logic;
		TXN_1 : OUT std_logic;
		RESETDONE_1 : OUT std_logic
		);
	END COMPONENT;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
	Inst_GBit2_block: GBit2_block PORT MAP(
		CLK125_OUT => ,
		CLK125 => ,
		EMAC0CLIENTRXD => ,
		EMAC0CLIENTRXDVLD => ,
		EMAC0CLIENTRXGOODFRAME => ,
		EMAC0CLIENTRXBADFRAME => ,
		EMAC0CLIENTRXFRAMEDROP => ,
		EMAC0CLIENTRXSTATS => ,
		EMAC0CLIENTRXSTATSVLD => ,
		EMAC0CLIENTRXSTATSBYTEVLD => ,
		CLIENTEMAC0TXD => ,
		CLIENTEMAC0TXDVLD => ,
		EMAC0CLIENTTXACK => ,
		CLIENTEMAC0TXFIRSTBYTE => ,
		CLIENTEMAC0TXUNDERRUN => ,
		EMAC0CLIENTTXCOLLISION => ,
		EMAC0CLIENTTXRETRANSMIT => ,
		CLIENTEMAC0TXIFGDELAY => ,
		EMAC0CLIENTTXSTATS => ,
		EMAC0CLIENTTXSTATSVLD => ,
		EMAC0CLIENTTXSTATSBYTEVLD => ,
		CLIENTEMAC0PAUSEREQ => ,
		CLIENTEMAC0PAUSEVAL => ,
		EMAC0CLIENTSYNCACQSTATUS => ,
		EMAC0ANINTERRUPT => ,
		TXP_0 => ,
		TXN_0 => ,
		RXP_0 => ,
		RXN_0 => ,
		PHYAD_0 => ,
		RESETDONE_0 => ,
		EMAC1CLIENTRXD => ,
		EMAC1CLIENTRXDVLD => ,
		EMAC1CLIENTRXGOODFRAME => ,
		EMAC1CLIENTRXBADFRAME => ,
		EMAC1CLIENTRXFRAMEDROP => ,
		EMAC1CLIENTRXSTATS => ,
		EMAC1CLIENTRXSTATSVLD => ,
		EMAC1CLIENTRXSTATSBYTEVLD => ,
		CLIENTEMAC1TXD => ,
		CLIENTEMAC1TXDVLD => ,
		EMAC1CLIENTTXACK => ,
		CLIENTEMAC1TXFIRSTBYTE => ,
		CLIENTEMAC1TXUNDERRUN => ,
		EMAC1CLIENTTXCOLLISION => ,
		EMAC1CLIENTTXRETRANSMIT => ,
		CLIENTEMAC1TXIFGDELAY => ,
		EMAC1CLIENTTXSTATS => ,
		EMAC1CLIENTTXSTATSVLD => ,
		EMAC1CLIENTTXSTATSBYTEVLD => ,
		CLIENTEMAC1PAUSEREQ => ,
		CLIENTEMAC1PAUSEVAL => ,
		EMAC1CLIENTSYNCACQSTATUS => ,
		EMAC1ANINTERRUPT => ,
		TXP_1 => ,
		TXN_1 => ,
		RXP_1 => ,
		RXN_1 => ,
		PHYAD_1 => ,
		RESETDONE_1 => ,
		CLK_DS => ,
		GTRESET => ,
		RESET => 
	);



-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file GBit2_block.vhd when simulating
-- the core, GBit2_block. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".
