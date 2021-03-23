restart

isim force add clock 0 -value 1 -time 4.2ns -repeat 8.4ns
isim force add Reset 1 -value 0 -time 100ns

isim force add eolc 1 -value 0 -time 8.4ns -repeat 2us

isim force add adcdata c59   -radix hex

isim force add slowclken 1
isim force add startcycle 1

run 100us


isim force add data16 fc59 -radix hex
run 100us

isim force add data16 fd00 -radix hex
run 100us

isim force add data16 fc59 -radix hex
run 100us

isim force add data16 fb00 -radix hex
run 100us

isim force add data16 fc59 -radix hex
run 100us
