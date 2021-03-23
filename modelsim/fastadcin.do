restart -force

delete wave *

force -freeze Clock	 		1 0, 0 {8 ns} -r 16ns
force -freeze Reset 			1 0, 0 100ns

add wave -radix hex *
add wave -radix hex sim:/ad9228tb/uut/*
run 1us
