restart -force


add wave -radix hex *

force -freeze Clock 1 0, 0 {4ns} -r 8ns
force -freeze Reset 1 0ns, 0 200ns
force -freeze clk200Khzen 1
force -freeze Lnk_DataIn 16#81

force -freeze Lnk_wr 0

run 1us
force -freeze Lnk_DataIn 16#81
force -freeze Lnk_wr 1
run 8ns
force -freeze Lnk_DataIn 16#03
run 8ns
force -freeze Lnk_DataIn 16#1b
run 8ns
force -freeze Lnk_DataIn 16#44
run 8ns
force -freeze Lnk_DataIn 16#4c
run 8ns
force -freeze Lnk_DataIn 16#bf
run 8ns
force -freeze Lnk_DataIn 16#55
run 8ns
force -freeze Lnk_DataIn 16#66
run 8ns
force -freeze Lnk_DataIn 16#77
run 8ns
force -freeze Lnk_wr 0


run 10us

run 1us
force -freeze Lnk_DataIn 16#81
force -freeze Lnk_wr 1
run 8ns
force -freeze Lnk_DataIn 16#03
run 8ns
force -freeze Lnk_DataIn 16#1b
run 8ns
force -freeze Lnk_DataIn 16#44
run 8ns
force -freeze Lnk_DataIn 16#4c
run 8ns
force -freeze Lnk_DataIn 16#bf
run 8ns
force -freeze Lnk_DataIn 16#55
run 8ns
force -freeze Lnk_DataIn 16#66
run 8ns
force -freeze Lnk_DataIn 16#77
run 8ns
force -freeze Lnk_wr 0

run 10us

