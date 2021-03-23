#wcfg new


restart

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clk1mhzen 1 -value 0 -time 10ns -value 0 -time 90ns -repeat 1us
isim force add clk10hzen 1 -value 0 -time 10ns -value 0 -time 990ns -repeat 10us

isim force add fpReset 0
isim force add localwr 0
isim force add lnk_addr 0 -radix hex
isim force add lnk_wr 0
isim force add lnk_dataIn 0 -radix hex

isim force add ram_we 0
isim force add localMode 0
isim force add localdrive 0 -radix hex
isim force add Fault3of5  0
isim force add BeamILowFault 0
isim force add FwdPwrFault  0
isim force add ReflPwrFault 0
isim force add offline 0

run 1us
isim force add DacData  40 -radix hex
isim force add lnk_addr 3 -radix hex
isim force add lnk_data 100 -radix hex
isim force add lnk_wr 1
run 20ns
isim force add lnk_wr 0
run 1us



