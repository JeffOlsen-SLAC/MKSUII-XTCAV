#wcfg new
#wave add clock reset clk1mhzen
#wave add tempsclk tempsdout tempsdin temp_out_cs temp_in_cs tempstate
#wave add intemp outtemp


restart
isim force add /tempadc/cmdreset 0

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clk1mhzen 1 -value 0 -time 10ns -value 0 -time 90ns -repeat 1us

isim force add tempsdin 1

# Wait for power on wait
run 1000us

# wait for 40 clock reset and 512us delay

run 800us

# FS Cal
isim force add tempsdin 0
run 2us
isim force add tempsdin 1
run 200us

#Zero Cal
isim force add tempsdin 0
run 2us
isim force add tempsdin 1
run 200us

run 1100us

# FS Cal
isim force add tempsdin 0
run 2us
isim force add tempsdin 1
run 200us

#Zero Cal
isim force add tempsdin 0
run 2us
isim force add tempsdin 1
run 200us



