restart -force

force -freeze Clock 	0 0, 1 {5 ns} -r 10ns
force -freeze Reset 			1 0, 0 100ns

force -freeze clk400khzen 1
force -freeze lnk_Addr 16#0
force -freeze lnk_Datain 16#0
force -freeze lnk_wr 0
force -freeze newData 0
force -freeze x1 16#0082
force -freeze y1 16#0046
force -freeze x2 16#00b6
force -freeze y2 16#003b
force -freeze ASCIIIn(8) 0
force -freeze ASCIIIn(7) 0
force -freeze ASCIIIn(6) 0
force -freeze ASCIIIn(5) 0
force -freeze ASCIIIn(4) 0
force -freeze ASCIIIn(3) 0
force -freeze ASCIIIn(2) 0
force -freeze ASCIIIn(1) 1

add wave  -radix hex *

run 1us
force -freeze newData 1
run 20ns
force -freeze newData 0
run 1us







