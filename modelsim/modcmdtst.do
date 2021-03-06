restart -force

delete wave *

force -freeze Clock	 		1 0, 0 {4 ns} -r 8ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk10hzen    0


force -freeze reg_addr	16#0000
force -freeze reg_wr	0
force -freeze reg_datain	16#0000

add wave -radix hex *

run 1us
force -freeze clk10hzen			1 0, 0 8.4ns -r 42ns
run 1us


run 1us

force -freeze reg_datain	16#6
force -freeze reg_wr	1
run 20ns
force -freeze reg_wr	0

run 200ns


force -freeze reg_datain	16#2
force -freeze reg_wr	1
run 20ns
force -freeze reg_wr	0

run 1us


