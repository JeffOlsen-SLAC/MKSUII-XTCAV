restart -force

--delete wave *

force -freeze Clock  0 0, 1 {4.2ns} -r 8.4ns


force -freeze Reset 	1 0, 0 100ns
force -freeze iintemp 		10#3000
force -freeze iouttemp 		10#3100
force -freeze tempoffset   10#0
force -freeze itempsr 16#0000
add wave -radix decimal clock iiintemp iiouttemp ominusi
add wave -radix decimal tempoffset deltatemp
add wave -radix decimal itempsr temperature

add wave  \
sim:/tempadc/InputOutofRange \
sim:/tempadc/OutputOutofRange \
sim:/tempadc/OverTemp

run 200ns
force -freeze iintemp 10#3100
force -freeze iouttemp 10#3000
run 200ns
force -freeze iintemp 10#4000
force -freeze iouttemp 10#3000
run 200ns
force -freeze iintemp 10#3000
force -freeze iouttemp 10#4100
run 200ns
force -freeze tempoffset   10#1100
run 200ns

force -freeze iintemp 10#4400
force -freeze iouttemp 10#4100
force -freeze tempoffset  -10#600
run 200ns

force -freeze iouttemp 10#4
force -freeze iintemp 10#2
force -freeze tempoffset  -10#0
run 200ns

force -freeze itempsr 16#CB52
run 200ns
force -freeze itempsr 16#65A9
run 200ns

