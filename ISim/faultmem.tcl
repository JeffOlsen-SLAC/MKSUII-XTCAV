restart

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns
isim force add lnk_rd  0
isim force add WrEn  0
isim force add DataIn  0
isim force add CountIn  0

run 1us
run 6ns

isim force add WrEn  1
isim force add DataIn  0abcdef0 -radix hex
isim force add CountIn 5555aaaa -radix hex
run 10ns
isim force add WrEn  0
run 100ns

isim force add WrEn  1
isim force add DataIn  12345678 -radix hex
isim force add CountIn    1 -radix hex
run 10ns
isim force add WrEn  0
run 100ns

isim force add WrEn  1
isim force add DataIn  5555 -radix hex
isim force add CountIn    5 -radix hex
run 10ns
isim force add WrEn  0
run 100ns

isim force add lnk_rd  1

