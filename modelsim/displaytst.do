restart -force

delete wave *

add wave -radix hex  sim:/displayintf/*
add wave -radix hex  sim:/u_alu/*
add wave -radix hex  sim:/u_display/*

force -freeze Clock 	0 0, 1 {5 ns} -r 10ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk400khzen 	1 0, 0 10ns -r 100ns


force -freeze TrigDel   16#0001
force -freeze RFDrive   16#0002
force -freeze MicroPrev 16#0003
force -freeze BeamV     16#0004
force -freeze BeamI     16#0005
force -freeze FwdPwr    16#0006
force -freeze RefPwr    16#0007
force -freeze DeltaTemp 16#0008
force -freeze WgVac     16#0009
force -freeze KlyVac    16#000A
force -freeze ModRate  	16#0115
force -freeze AccRate   16#7FFF
force -freeze modid    16#55

force -freeze assign 	16#0000
force -freeze hsta   	16#0000
force -freeze modstate  16#0000

force -freeze lnk_addr   16#0100
force -freeze lnk_datain   16#0000
force -freeze lnk_wr 0
force -freeze spi_miso 0

force -freeze refresh 0
force -freeze cmd_refresh 0

run 1us


force -freeze cmd_refresh 1
run 10ns
force -freeze cmd_refresh 0


run 500us

