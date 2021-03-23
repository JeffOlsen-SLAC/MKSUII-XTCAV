restart -force

delete wave *
force -freeze p_MGTCLK 1 0, 0 {4 ns} -r 8ns
force -freeze m_MGTCLK 0 0, 1 {4 ns} -r 8ns

add wave -divider "Clock"
add wave p_MGTCLK
add wave m_MGTCLK


add wave -divider "Tester Receive Data"
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/rx_ll_data
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/rx_ll_sof
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/rx_ll_eof

add wave -divider "Tester Transmit Data"
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/tx_ll_data
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/tx_ll_sof
add wave  -radix hex sim:/hm_test_vhd/u_tester/u_intf/tx_ll_eof

-- Ethernet IO Connections
force -freeze p_MGTCLK 1 0, 0 {4 ns} -r 8ns
force -freeze m_MGTCLK 0 0, 1 {4 ns} -r 8ns

force -freeze p_MGTCLK_tstr 1 0, 0 {4 ns} -r 8ns
force -freeze m_MGTCLK_tstr 0 0, 1 {4 ns} -r 8ns



force -freeze SYSCLK60  0
#force -freeze sim:/hm_test_vhd/uut/u_glink/clk125_x 0 0, 1 {5 ns} -r 10ns
force -freeze n_BRD_RST 0

-- Hardware Manager Controls
force -freeze n_Trigger 1
force -freeze P24VFlt   0
force -freeze n_KlixonIntlk 1
force -freeze n_SpareIntlk 1
force -freeze PWM_NLimit 0
force -freeze n_Overload 1
force -freeze n_PWM_PLimit 1
force -freeze SpareLimit 0
force -freeze K1_On 0
force -freeze K2_On 0
force -freeze K3_On 0
force -freeze n_Adr 16#00000
#	En_24V     			: out std_logic;
#	En_K1     			: out std_logic;
#	En_K2     			: out std_logic;
#	En_K3     			: out std_logic;
#	GreenLED     		: out std_logic;
#	RedLED     			: out std_logic;
#	DiagFiber     		: out std_logic;


-- Gate Driver Interface
#	IGBTClk1				: out std_logic;
#	IGBTTx1				: out std_logic;
force -freeze IGBTRx1   0
force -freeze IGBTFlt1	0
#	IGBTTrg1				: out std_logic;

#	IGBTClk2				: out std_logic;
#	IGBTTx2				: out std_logic;
force -freeze IGBTRx2	0
force -freeze IGBTFlt2	0
#	IGBTTrg2				: out std_logic;

#	IGBTClk3				: out std_logic;
#	IGBTTx3				: out std_logic;
force -freeze IGBTRx3	0
force -freeze IGBTFlt3	0
#	IGBTTrg3				: out std_logic;

#	IGBTClk4				: out std_logic;
#	IGBTTx4				: out std_logic;
force -freeze IGBTRx4	0
force -freeze IGBTFlt4	0
#	IGBTTrg4				: out std_logic;

-- Group of 8 ADC Control
#	n_ADCClk1			: out std_logic;
#	ADCCs1				: out std_logic;
force -freeze ADCSd1_1	0
force -freeze ADCSd1_2	1
force -freeze ADCSd1_3	1
force -freeze ADCSd1_4	0
force -freeze ADCSd1_5	0
force -freeze ADCSd1_6	0
force -freeze ADCSd1_7	1
force -freeze ADCSd1_8	0

-- Group of 4 ADC Control
#	n_ADCClk2			: out std_logic;
#	ADCCs2				: out std_logic;
force -freeze ADCSd2_1	0
force -freeze ADCSd2_2	0
force -freeze ADCSd2_3	1
force -freeze ADCSd2_4	0

-- Ethernet Fiber Diagnostic
force -freeze 	Rx_Los	0
force -freeze 	Tx_Fault	0
#	Tx_Disable			: out std_logic;
force -freeze 	SDA		0
force -freeze 	SCL		0
force -freeze 	n_Mod_Pres	0

-- Board ID Switch
force -freeze 	n_Mod_ID	16#FA

-- General purpose IO
#	Diag					: out std_logic_vector(7 downto 0);

-- Hardware Mananager Power Supply
force -freeze P3D3VGOOD		0
force -freeze P2D5VGOOD		0
force -freeze P1D2VGOOD		0
force -freeze P1D0VGOOD		0



-- Flash and Memmory IO
#	Data					: inout std_logic_vector(31 downto 0);

-- Flash and Memmory Address
#	Address				: out std_logic_vector(24 downto 0);

-- Boot Revision
#	RS						: out std_logic_vector(1 downto 0);

-- Flash Memory Control
#	n_FWE					: out std_logic;
#	n_FOE					: out std_logic;
#	n_FCS					: out std_logic;
force -freeze FWAIT	0
#	VPP					: out std_logic;
#	FCLK					: out std_logic;
#	n_FADV				: out std_logic;

-- RAM Control
#	P						: inout std_logic_vector(4 downto 1); -- Unused Parity Bits
#	ADV_LD				: out std_logic;
#	R_W					: out std_logic;
#	n_CEN					: out std_logic;
#	n_BW					: out std_logic_vector(4 downto 1);

#	MEM_CLK				: out std_logic;
#	n_LBO					: out std_logic;
#	n_OE					: out std_logic



force -freeze sim:/hm_test_vhd/tx_Start 0
force -freeze sim:/hm_test_vhd/tx_Mess  16#00
force -freeze sim:/hm_test_vhd/tx_Count 16#0000
force -freeze sim:/hm_test_vhd/tx_Din   16#00
force -freeze sim:/hm_test_vhd/brdid  16#03


force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(5) 16#08
force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(4) 16#00
force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(3) 16#56
force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(2) 16#00
force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(1) 16#03
force -freeze sim:/hm_test_vhd/u_tester/u_intf/emac_addr(0) 16#05


force -freeze sim:/hm_test_vhd/u_tester/u_intf/ip_addr(3) 16#C0
force -freeze sim:/hm_test_vhd/u_tester/u_intf/ip_addr(2) 16#A8
force -freeze sim:/hm_test_vhd/u_tester/u_intf/ip_addr(1) 16#00
force -freeze sim:/hm_test_vhd/u_tester/u_intf/ip_addr(0) 16#05

# My EMAC Address Jeff's laptop
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(6) 16#00
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(7) 16#15
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(8) 16#C5
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(9) 16#58
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(10) 16#A9
#force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(11) 16#52

# Susie's Laptop
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(6) 16#00
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(7) 16#24
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(8) 16#E8
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(9) 16#95
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(10) 16#18
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(11) 16#A1

force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(26) 16#C0
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(27) 16#A8
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(28) 16#01
force -freeze sim:/hm_test_vhd/u_tester/u_intf/Tx_Common(29) 16#00


force -freeze sim:/hm_test_vhd/u_tester/u_intf/udp_dest_addr(1) 16#DD
force -freeze sim:/hm_test_vhd/u_tester/u_intf/udp_dest_addr(0) 16#D5
force -freeze sim:/hm_test_vhd/tx_done 0


run 100ns
force -freeze n_BRD_RST 1


run 7us
noforce  sim:/hm_test_vhd/u_tester/u_intf/rx_ll_data
force -freeze sim:/hm_test_vhd/tx_Start 1
force -freeze sim:/hm_test_vhd/tx_Mess  16#48
force -freeze sim:/hm_test_vhd/tx_Count 16#0000
run 10ns
force -freeze sim:/hm_test_vhd/tx_Start 0
run 374ns

force -freeze sim:/hm_test_vhd/tx_done 1
run 8ns
force -freeze sim:/hm_test_vhd/tx_done 0
run 5us



