restart -force

#delete wave *
-- Ethernet IO Connections
force -freeze MGTCLK 1 0, 0 {4 ns} -r 8ns

force -freeze Clk119Mhz_in_n	 	1 0, 0 {4.2 ns} -r 8.4ns
force -freeze Clk119Mhz_in_p	 	0 1, 1 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 200ns
force -freeze tstrreset 	1 0, 0 100ns

#force -freeze sim:/testbench/uut/u_FastADC/u_BeamV/start 16#100
#force -freeze sim:/testbench/uut/u_FastADC/u_BeamV/stop 16#102
#force -freeze sim:/testbench/uut/u_FastADC/u_BeamV/DataIn 16#EA2
#force -freeze sim:/testbench/uut/u_FastADC/u_BeamV/trigger 0

#add wave  -radix hex sim:/testbench/uut/u_clkDet/*

add wave sim:/testbench/uut/Clk119MhzOk
add wave sim:/testbench/uut/lnk_clk
add wave sim:/testbench/uut/sysclk

#add wave -radix hex sim:/testbench/u_fadc/*
#add wave -radix hex clk119mhz_in_p clk119mhz_in_n
#add wave -radix hex fadc*
#add wave beam*
#add wave fwd*
#add wave refl*
#add wave -radix hex  sim:/testbench/uut/u_FastADC/u_ad9228/*

#add wave  -radix hex sim:/testbench/uut/u_FastADC/u_beamv/*
#add wave fadc_SDIO fadc_sclk n_fadc_cs

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

add wave -radix hex sim:/testbench/uut/u_Lnk_Decode/*
add wave -radix hex sim:/testbench/uut/u_RfDrive/*
add wave -radix hex sim:/testbench/rfattn*
add wave -radix hex sim:/testbench/n_rfattn*


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


force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(26) 16#C0
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(27) 16#A8
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(28) 16#01
force -freeze sim:/testbench/u_tester/u_intf/Tx_Common(29) 16#00


force -freeze sim:/testbench/u_tester/u_intf/udp_dest_addr(1) 16#DD
force -freeze sim:/testbench/u_tester/u_intf/udp_dest_addr(0) 16#D5
force -freeze sim:/testbench/tx_done 0

force -freeze sim:/testbench/tx_TaskID  16#BB

run 2us
#force -freeze sim:/testbench/uut/u_FastADC/u_REFLPWR/trigger 1
#run 100ns
#force -freeze sim:/testbench/uut/u_FastADC/u_REFLPWR/trigger 0


#run 9us

force -freeze sim:/testbench/tx_Start 1
force -freeze sim:/testbench/tx_Messtype  16#06
force -freeze sim:/testbench/tx_Count 16#0000
run 8ns
force -freeze sim:/testbench/tx_Start 0
run 384ns
force -freeze sim:/testbench/tx_Data 16#02
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns
force -freeze sim:/testbench/tx_Data 16#01
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns
force -freeze sim:/testbench/tx_Data 16#64
run 8ns
force -freeze sim:/testbench/tx_Data 16#00
run 8ns
force -freeze sim:/testbench/tx_done 1
run 8ns
force -freeze sim:/testbench/tx_done 0
run 8ns

run 6us

