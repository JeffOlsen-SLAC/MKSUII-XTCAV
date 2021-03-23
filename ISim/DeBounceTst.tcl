

wave add  -radix hex -wcfg t.t /
isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add clocken 1
isim force add din 0

run 1us

isim force add din 1
run 3us
isim force add din 0
run 100ns
isim force add din 1
run 100ns
isim force add din 0
run 100ns
isim force add din 1
run 1us