restart -force

delete wave *

force -freeze Clock	 		1 0, 0 {4 ns} -r 8ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk1khzen    0
force -freeze  acc2 0
force -freeze  acc1 0
force -freeze  wg2 0
force -freeze  wg1 0
force -freeze  kly 0
force -freeze  fpreset 0

force -freeze lnk_addr	16#0000
force -freeze lnk_wr	0
force -freeze lnk_datain	16#0000

add wave -radix hex *

run 1us
force -freeze clk1khzen			1 0, 0 8.4ns -r 42ns
run 1us


run 1us

force -freeze lnk_datain	16#6
force -freeze lnk_wr	1
run 20ns
force -freeze lnk_wr	0

run 200ns


force -freeze lnk_datain	16#2
force -freeze lnk_wr	1
run 20ns
force -freeze lnk_wr	0

run 1us


