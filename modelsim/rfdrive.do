restart -force


force -freeze Clock	 	1 0, 0 {4.2 ns} -r 8.4ns
force -freeze Reset 		1 0, 0 100ns

force -freeze lnk_wr 	0
force -freeze lnk_addr 	16#0
force -freeze lnk_Datain 	16#0


force -freeze clk1hzen 1
force -freeze clk10hzen 1
force -freeze clk10khzen 1
force -freeze clk1mhzen 1
force -freeze localsw 0
force -freeze localwr 0
force -freeze BeamILowThres 0


add wave -radix hex *

run 1us
force -freeze lnk_wr 	0
force -freeze lnk_addr 	16#2
force -freeze lnk_Datain 	16#FF
run 10ns
force -freeze lnk_wr 1
run 10ns
force -freeze lnk_wr 	0
run 11us

force -freeze lnk_Datain 	16#00
run 10ns
force -freeze lnk_wr 1
run 10ns
force -freeze lnk_wr 	0
run 11us

force -freeze lnk_Datain 	16#ff
run 10ns
force -freeze lnk_wr 1
run 10ns
force -freeze lnk_wr 	0
run 11us



