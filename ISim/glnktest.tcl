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
isim force add p_MGTCLK 1 0, 0 {4 ns} -r 8ns
isim force add m_MGTCLK 0 0, 1 {4 ns} -r 8ns

isim force add p_MGTCLK_tstr 1 0, 0 {4 ns} -r 8ns
isim force add m_MGTCLK_tstr 0 0, 1 {4 ns} -r 8ns



isim force add SYSCLK60  0
#isim force add sim:/hm_test_vhd/uut/u_glink/clk125_x 0 0, 1 {5 ns} -r 10ns
isim force add n_BRD_RST 0

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



