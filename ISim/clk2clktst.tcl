
restart

isim force add clk1 0 -value 1 -time 4ns -repeat 8ns
isim force add clk2 0 -value 1 -time 4.2ns -repeat 8.4ns
isim force add Reset 1 -value 0 -time 100ns

isim force add din 0

run 1.1us

isim force add din 1
run 8ns
isim force add din 0

run 300ns


