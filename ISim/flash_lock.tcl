
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add lnk_addr 0 -radix hex
isim force add lnk_datain 0 -radix hex
isim force add lnk_WriteAddr 0
isim force add lnk_ReadBlk 0
isim force add lnk_EraseBlk 0
isim force add lnk_WriteBlk 0
isim force add lnk_LockBlk 0
isim force add flash_DataIn  0  -radix hex

run 1us
isim force add lnk_datain 0 -radix hex
isim force add lnk_writeaddr 1
run 10ns
isim force add lnk_writeaddr 0
run 10ns

isim force add lnk_datain d0 -radix hex
isim force add lnk_lockBlk 1
run 10ns
isim force add lnk_datain d0 -radix hex
isim force add lnk_lockBlk 0
run 2us

isim force add flash_DataIn  0  -radix hex

run 10us

isim force add flash_DataIn  80  -radix hex

run 2us

isim force add flash_DataIn  0  -radix hex
