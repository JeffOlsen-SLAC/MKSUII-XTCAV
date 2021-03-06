
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add lnk_addr 0 -radix hex
isim force add lnk_datain 0 -radix hex
isim force add lnk_ReadBlk 0
isim force add lnk_EraseBlk 0
isim force add lnk_WriteBlk 0
isim force add flash_DataIn  0  -radix hex

run 1us

isim force add lnk_WriteBlk 1
isim force add lnk_datain 1 -radix hex
run 10ns
isim force add lnk_datain 2 -radix hex
run 10ns
isim force add lnk_datain 3 -radix hex
run 10ns
isim force add lnk_datain 4 -radix hex
run 10ns
isim force add lnk_datain 5 -radix hex
run 10ns
isim force add lnk_datain 6 -radix hex
run 10ns
isim force add lnk_datain 7 -radix hex
run 10ns
isim force add lnk_datain 8 -radix hex
run 10ns
isim force add lnk_datain 11 -radix hex
run 10ns
isim force add lnk_datain 12 -radix hex
run 10ns
isim force add lnk_datain 13 -radix hex
run 10ns
isim force add lnk_datain 14 -radix hex
run 10ns
isim force add lnk_datain 15 -radix hex
run 10ns
isim force add lnk_datain 16 -radix hex
run 10ns
isim force add lnk_datain 17 -radix hex
run 10ns
isim force add lnk_datain 18 -radix hex
run 10ns
isim force add lnk_datain 21 -radix hex
run 10ns
isim force add lnk_datain 22 -radix hex
run 10ns
isim force add lnk_datain 23 -radix hex
run 10ns
isim force add lnk_datain 24 -radix hex
run 10ns
isim force add lnk_datain 25 -radix hex
run 10ns
isim force add lnk_datain 26 -radix hex
run 10ns
isim force add lnk_datain 27 -radix hex
run 10ns
isim force add lnk_datain 28 -radix hex
run 10ns
isim force add lnk_datain 31 -radix hex
run 10ns
isim force add lnk_datain 32 -radix hex
run 10ns
isim force add lnk_datain 33 -radix hex
run 10ns
isim force add lnk_datain 34 -radix hex
run 10ns
isim force add lnk_datain 35 -radix hex
run 10ns
isim force add lnk_datain 36 -radix hex
run 10ns
isim force add lnk_datain 37 -radix hex
run 10ns
isim force add lnk_datain 38 -radix hex
run 10ns
isim force add lnk_WriteBlk 0

isim force add flash_DataIn  0  -radix hex
run 1us
isim force add flash_DataIn  80  -radix hex
run 2us

isim force add flash_DataIn  0  -radix hex
run 20us
isim force add flash_DataIn  80  -radix hex
run 2us
