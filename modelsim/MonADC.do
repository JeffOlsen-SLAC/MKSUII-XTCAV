restart -force

--delete wave *

-- Ethernet IO Connections
force -freeze MGTCLK 1 0, 0 {4 ns} -r 8ns


force -freeze clk119Mhz  0 0, 1 {4.2ns} -r 8.4ns

force -freeze Reset 	1 0, 0 100ns

force -freeze sim:/testbench/uut/u_MonADC/eolc		1 0, 0 8.4ns -r 42ns
force -freeze sim:/testbench/uut/u_SlowADC/eolc		1 0, 0 8.4ns -r 42ns




force -freeze sim:/testbench/tx_Start 0
force -freeze sim:/testbench/tx_MessType  16#00
force -freeze sim:/testbench/tx_Count 16#0000
force -freeze sim:/testbench/tx_Data  16#00
force -freeze sim:/testbench/brd_id  16#05


force -freeze sim:/testbench/u_tester/u_intf/emac_addr(5) 16#08
force -freeze sim:/testbench/u_tester/u_intf/emac_addr(4) 16#00
force -freeze sim:/testbench/u_tester/u_intf/emac_addr(3) 16#56
force -freeze sim:/testbench/u_tester/u_intf/emac_addr(2) 16#00
force -freeze sim:/testbench/u_tester/u_intf/emac_addr(1) 16#06
force -freeze sim:/testbench/u_tester/u_intf/emac_addr(0) 16#05


force -freeze sim:/testbench/u_tester/u_intf/ip_addr(3) 16#C0
force -freeze sim:/testbench/u_tester/u_intf/ip_addr(2) 16#A8
force -freeze sim:/testbench/u_tester/u_intf/ip_addr(1) 16#00
force -freeze sim:/testbench/u_tester/u_intf/ip_addr(0) 16#05

# My EMAC Address Jeff's laptop
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(6) 16#00
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(7) 16#15
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(8) 16#C5
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(9) 16#58
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(10) 16#A9
#force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(11) 16#52

force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(26) 16#C0
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(27) 16#A8
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(28) 16#01
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(29) 16#00


force -freeze sim:/testbench/u_tester/u_intf/udp_dest_addr(1) 16#DD
force -freeze sim:/testbench/u_tester/u_intf/udp_dest_addr(0) 16#D5
force -freeze sim:/testbench/tx_done 0

force -freeze sim:/testbench/tx_TaskID  16#BB

force -freeze sim:/testbench/uut/u_MonADC/ADCDataIn 16#2

run 6us


