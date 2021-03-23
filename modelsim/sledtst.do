restart -force

add wave -radix hex *

force -freeze Clock 	0 0, 1 {4.2 ns} -r 8.4ns
force -freeze Reset 			1 0, 0 100ns
force -freeze fault_Reset 0
force -freeze Modulator_On 0
force -freeze clk1khzen		1 0, 0 8.4ns -r 42ns
force -freeze SLED_U_DT 0
force -freeze SLED_U_T 0
force -freeze SLED_l_DT 0
force -freeze SLED_l_T 0
force -freeze SLED_mn_DT 0
force -freeze SLED_mn_T 0

force -freeze iEn_Sled 0
force -freeze T_Sled 0
force -freeze DT_Sled 0

run 1us
force -freeze iEn_Sled 1
run 100ns
force -freeze T_Sled 1
run 10ns
force -freeze T_Sled 0
run 1us




