restart -force

--delete wave *

force -freeze Clock  0 0, 1 {4.2ns} -r 8.4ns

force -freeze Reset 	1 0, 0 100ns

add wave *

