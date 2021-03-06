restart -force

delete wave *

force -freeze RegClk	 		1 0, 0 {4 ns} -r 8ns
force -freeze TimingClk 	0 0, 1 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk1mhzen    0
force -freeze tempsdin    1


force -freeze reg_addr	16#0000
force -freeze reg_wr	0
force -freeze reg_datain	16#0000
add wave -radix hex *

run 1us
--force -freeze clk10Khzen		1 0, 0 8.4ns -r 100.7916us
force -freeze clk1Mhzen			1 0, 0 8.4ns -r 42ns
force -freeze tempsdin			0 0, 1 300ns   -r 10us
run 1us



