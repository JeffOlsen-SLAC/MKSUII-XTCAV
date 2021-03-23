restart -force

#delete wave *

force -freeze Clock			1 0, 0 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 100ns
force -freeze clk1mhzen		1 0, 0 8.4ns -r 42ns

add wave -radix hex *
run 1us

