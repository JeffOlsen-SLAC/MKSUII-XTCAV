#wcfg new

restart

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clk10hzen 1 -value 0 -time 10ns -value 0 -time 990ns -repeat 10us

isim force add iextintlk 0
run 1us

isim force add iextintlk 1
run 100ns
isim force add iextintlk 0
run 75us
isim force add iextintlk 1
run 100ns
isim force add iextintlk 0


run 200us

isim force add iextintlk 1
run 200us

