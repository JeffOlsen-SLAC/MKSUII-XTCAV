restart -force

delete wave *

force -freeze clock     0 0, 1 {5 ns} -r 10ns
force -freeze Reset 1 0, 0 100ns
force -freeze Delay 16#05
force -freeze TriggerIn 0

add wave -radix hex *
run 1us
force -freeze TriggerIn 1
run 100ns
force -freeze TriggerIn 0


run 1us

