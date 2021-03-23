restart -force


--add wave -radix hex *

force -freeze Clock 	0 0, 1 {5 ns} -r 10ns
force -freeze Reset 			1 0, 0 100ns

force -freeze Init 	0
force -freeze Decin	16#4500
run 1us

force -freeze Init 	1
run 10ns
force -freeze Init 	0

run 1us




