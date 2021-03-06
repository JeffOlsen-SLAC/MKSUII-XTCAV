restart -force


force -freeze Clock	 	1 0, 0 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 100ns

force -freeze lnk_wr 	0
force -freeze lnk_addr 	16#0
force -freeze lnk_Datain 	16#0


force -freeze clk1mhzen 1

add wave -radix hex *

run 1us
force -freeze lnk_wr 	0
force -freeze lnk_addr 	16#0
force -freeze lnk_Datain 	16#8B5
run 10ns
force -freeze lnk_wr 1
run 10ns
force -freeze lnk_wr 	0

run 1us
force -freeze lnk_wr 	0
force -freeze lnk_addr 	16#0
force -freeze lnk_Datain 	16#555
run 10ns
force -freeze lnk_wr 1
run 10ns
force -freeze lnk_wr 	0
run 11us



