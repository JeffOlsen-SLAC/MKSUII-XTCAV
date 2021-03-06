restart -force

delete wave *

force -freeze Clock 	0 0, 1 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk1hzen	   0
force -freeze Faultbits    16#000000

add wave -radix hex *

run 1us
--force -freeze clk10Khzen		1 0, 0 8.4ns -r 100.7916us
force -freeze clk1hzen			1 0, 0 8.4ns -r 100.7916ns
run 10us

force -freeze Faultbits    16#000001
run 10ns
force -freeze Faultbits    16#000000
run 1us





