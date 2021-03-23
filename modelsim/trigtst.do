restart -force

delete wave *
add wave -radix hex *

force -freeze sim:/trigger/Clock    0 0, 1 {4.2 ns} -r 8.4ns

force -freeze sim:/trigger/reset 	1 0, 0 100ns

force -freeze sim:/trigger/ModTrigDelay 16#8
force -freeze sim:Triggeren 1
force -freeze sim:local 0

force -freeze sim:/trigger/acctrig_p 0
force -freeze sim:/trigger/acctrig_n 1

force -freeze sim:/trigger/stbytrig_p 0
force -freeze sim:/trigger/stbytrig_n 1

add wave -radix hex *
run 2us

force -freeze sim:/trigger/acctrig_p 1
force -freeze sim:/trigger/acctrig_n 0

force -freeze sim:/trigger/stbytrig_p 1
force -freeze sim:/trigger/stbytrig_n 0

run 1us
force -freeze sim:/trigger/acctrig_p 0
force -freeze sim:/trigger/acctrig_n 1

force -freeze sim:/trigger/stbytrig_p 0
force -freeze sim:/trigger/stbytrig_n 1


run 1us

