
restart

isim force add clock 0 -value 1 -time 4ns -repeat 8ns
isim force add clocken 0 -value 1 -time 8ns -value 0 -time 16ns -repeat 104ns
isim force add Reset 1 -value 0 -time 100ns

isim force add start 0
isim force add retrigen 1
isim force add level 1
isim force add os_time f -radix hex

run 1.152us

isim force add start 1
run 10ns
isim force add start 0

run 300ns
isim force add start 0
run 8ns
isim force add start 0

run 2us


