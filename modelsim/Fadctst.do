restart -force

delete wave *
add wave -radix hex  *
force -freeze clock	 	0 1, 1 {5 ns} -r 10ns
force -freeze adcclk	 	0 1, 1 {10 ns} -r 20ns
force -freeze Reset 			1 0, 0 100ns
force -freeze Trigger 	0
force -freeze armwfm 	0
force -freeze armave		0
force -freeze timecntr		16#000
force -freeze start			16#000
force -freeze stop			16#003


run 1us
force -freeze armave		1
run 10ns
force -freeze armave		0
run 1us
force -freeze Trigger 	1
run 20ns
force -freeze Trigger 	0
run 1us

force -freeze timecntr		16#1FF

run 1us
force -freeze Trigger 	1
run 20ns
force -freeze Trigger 	0
run 1us

force -freeze Trigger 	1
run 1us

