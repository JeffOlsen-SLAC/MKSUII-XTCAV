
wave add /  -radix hex

isim force add clock 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 100ns

isim force add beamv 400 -radix dec
run 500ns

isim force add datapointer 3
isim force add refresh 1
run 10ns
isim force add refresh 1

run 1us


