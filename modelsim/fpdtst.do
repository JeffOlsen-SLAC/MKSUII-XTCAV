restart -force

--delete wave *
add wave  -radix hex \
    sim:/testbench/N_BRD_RST \
    sim:/testbench/MGTCLK_n \
    sim:/testbench/MGTCLK_p \
    sim:/testbench/TX0_p \
    sim:/testbench/TX0_n \
    sim:/testbench/RX0_n \
    sim:/testbench/RX0_p

add wave  -radix hex  \
sim:/testbench/uut/u_Glink/Lnk_DataOut \
sim:/testbench/uut/u_Glink/Lnk_DataStrb \
sim:/testbench/uut/u_Glink/Lnk_MessType \
sim:/testbench/uut/u_Glink/Lnk_TaskId \
sim:/testbench/uut/u_Glink/Lnk_MessStrb\

add wave   -radix hex \
sim:/testbench/u_tester/u_intf/RX_LL_SOF_N \
sim:/testbench/u_tester/u_intf/RX_LL_EOF_N \
sim:/testbench/u_tester/u_intf/RX_LL_DATA

add wave  -radix hex sim:/testbench/uut/u_Lnk_Decode/*


add wave  \
sim:/testbench/SPI_CLK \
sim:/testbench/N_SPI_SS \
sim:/testbench/SPI_MISO \
sim:/testbench/SPI_MOSI \
sim:/testbench/N_SPI_SBUF
add wave  -radix hex sim:/testbench/uut/u_display/u_display/*

force -freeze sim:/testbench/uut/u_display/u_display/Clk400KHzen 1

-- Ethernet IO Connections
force -freeze MGTCLK 1 0, 0 {4 ns} -r 8ns
force -freeze clk119Mhz  0 0, 1 {4.2ns} -r 8.4ns
force -freeze sim:/testbench/uut/u_MonADC/eolc		1 0, 0 8.4ns -r 42ns
force -freeze sim:/testbench/uut/u_SlowADC/eolc		1 0, 0 8.4ns -r 42ns
force -freeze sim:/testbench/uut/u_SlowADC/adcdata	16#345

force -freeze Reset 	1 0, 0 100ns

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

run 1us

force -freeze sim:/testbench/tx_Start 1
force -freeze sim:/testbench/tx_Messtype  16#20
force -freeze sim:/testbench/tx_Count 16#0008
run 8ns
force -freeze sim:/testbench/tx_Start 0
run 384ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns
force -freeze sim:/testbench/tx_Data 16#08
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#11
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#05
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#23
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#4d
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#53
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#30
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#3B
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_Data 16#44
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns

force -freeze sim:/testbench/tx_done 1
run 8ns
force -freeze sim:/testbench/tx_done 0
run 8ns

run 6us




