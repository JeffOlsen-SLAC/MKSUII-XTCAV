
restart


isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clk100Khzen 1 -value 0 -time 10ns -value 1 -time 990ns -repeat 1us

isim force add useacctrigger 1
isim force add acc_trig 0
isim force add stby_trig 0

run 1us


isim force add acc_trig 1
run 100ns
isim force add acc_trig 0
run 200ns
isim force add stby_trig 1
run 100ns
isim force add stby_trig 0
run 200ns


run 1us
