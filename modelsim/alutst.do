restart -force

--delete wave *

--add wave -radix hex *

force -freeze Clock 	0 0, 1 {5 ns} -r 10ns
force -freeze Reset 			1 0, 0 100ns

force -freeze UpdateDisplay  0
force -freeze txdone  0

force -freeze TrigDel   16#0002
force -freeze RFDrive   16#0000
force -freeze MicroPrev 16#0000
force -freeze BeamV     16#0000
force -freeze BeamI     16#0000
force -freeze FwdPwr    16#0000
force -freeze RefPwr    16#0000
force -freeze DeltaTemp 16#4D14
force -freeze WgVac     16#0000
force -freeze KlyVac    16#0000
force -freeze ModRate   16#0115
force -freeze AccRate   16#0019




run 1us

force -freeze UpdateDisplay  1
run 10ns
force -freeze UpdateDisplay  0

run 1us
force -freeze txdone			1 0, 0 10ns -r 1us

run 2us




