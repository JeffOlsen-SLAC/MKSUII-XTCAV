
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add Lnk_Addr   0 -radix hex
isim force add Clk_en 1
run 1us

